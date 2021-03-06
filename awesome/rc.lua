-- {{{ License
--
--  This config file has been taken from someone awesome,
--  then modified to the extent that
--  the person which created it in the first place 
--  cannot say I couldn't create it on my own. 
--  
--  Use as please, don't complain, 
--  copy and paste, 
--  maintain,
--  use with taste,
--  Enjoy!
--  
-- Kirø
-- }}}

-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
-- User libraries
local vicious = require("vicious")
local scratch = require("scratch")
-- }}}

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
local altkey = "Mod1"
local modkey = "Mod4"

local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local scount = screen.count()

-- Sound Settings
-- # Make some devices default in pulse. use pacmd, and:
--   set-default-sink <name_of_sink>
--   set-default-source <name_of_source>
-- # when using a USB sound card, such as logitech wireless headset.
--local sound_settings = { device = "PCM", card = 1 }
-- # when using the standard laptop sound card..
local sound_settings = { device = "Master", card = 1 } 

-- Beautiful theme
beautiful.init(home .. "/.config/awesome/zenburn.lua")

terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Window management layouts
layouts = {
    awful.layout.suit.tile,        -- 1
    awful.layout.suit.tile.bottom, -- 2
    awful.layout.suit.fair,        -- 3
    awful.layout.suit.max,         -- 4
    awful.layout.suit.magnifier,   -- 5
    awful.layout.suit.floating     -- 6
}
-- }}}


-- {{{ Tags
tags = {
    names  = { "bash/slack", "web-info", "web-work", "pdf/docs", "vim/tex", "git/bash", "ide/code", "sql/db", "spotify" },
    layout = {
        layouts[3], layouts[3], layouts[3], layouts[3], layouts[1],
        layouts[1], layouts[4], layouts[4], layouts[4]
    }
}

for s = 1, scount do
    tags[s] = awful.tag(tags.names, s, tags.layout)
    for i, t in ipairs(tags[s]) do
        awful.tag.setproperty(t, "mwfact", 0.5)
        --      awful.tag.setproperty(t, "mwfact", i==5 and 0.13  or  0.5)
        --      awful.tag.setproperty(t, "hide",  (i==6 or  i==7) and true)
    end
end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}

mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "Debian", debian.menu.Debian_menu.Debian },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({
    image = image(beautiful.awesome_icon),
    menu = mymainmenu
})
-- }}}


-- {{{ Wibox
-- {{{ Widgets configuration
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })
-- Graph properties
cpugraph:set_width(30):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
    beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
}) -- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")
vicious.register(tzswidget, vicious.widgets.thermal, " $1C", 19, "thermal_zone0")
-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_vertical(true):set_ticks(true)
membar:set_height(12):set_width(8):set_ticks_size(2)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_gradient_colors({
    beautiful.fg_widget,
    beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
-- Initialize widgets
fs = {
    b = awful.widget.progressbar(), r = awful.widget.progressbar(),
    h = awful.widget.progressbar(), s = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
    w:set_vertical(true):set_ticks(true)
    w:set_height(14):set_width(5):set_ticks_size(2)
    w:set_border_color(beautiful.border_widget)
    w:set_background_color(beautiful.fg_off_widget)
    w:set_gradient_colors({
        beautiful.fg_widget,
        beautiful.fg_center_widget, beautiful.fg_end_widget
    }) -- Register buttons
    w.widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function () exec("rox", false) end)
    ))
end -- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
vicious.register(fs.b, vicious.widgets.fs, "${/boot used_p}", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",     599)
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)
vicious.register(fs.s, vicious.widgets.fs, "${/mnt/storage used_p}", 599)
-- }}}

-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(
    netwidget,
    vicious.widgets.net,
    '<span color="' ..
            beautiful.fg_netdn_widget ..'">${eth1 down_kb}</span> 1span color="' ..
            beautiful.fg_netup_widget ..'">${eth1 up_kb}</span>',
    1
)
-- }}}

-- {{{ Wifi usage
wifiicon = widget({ type = "imagebox" })
wifiicon.image = image(beautiful.widget_wifi)
-- Initialize widget
wifiwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(wifiwidget, vicious.widgets.wifi,
    -- name of network / data transmission rate / link quality percentage
    '\'${ssid}\' ${rate}Mb/s ${linp}%', 3, "wlan0")
-- }}}

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({
    beautiful.fg_widget,
    beautiful.fg_center_widget,
    beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register( volbar, vicious.widgets.volume, "$1", 2, sound_settings["device"] .. " -c " .. sound_settings["card"] ) -- register the right sound card
--vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "PCM -c 1") -- example, register the right sound card
vicious.register(
    volwidget,
    vicious.widgets.volume,
    function(widget, args)
        local label = { ["♫"] = "O", ["♩"] = "M" } -- mute label.
        return args[1] .. "%" .. label[args[2]] -- args[1] is the vol level, args[2] is the mute state(1=mute)
    end,
    2,
    sound_settings["device"] .. " -c " .. sound_settings["card"] -- set the correct sound device.
)
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("amixer") end),
    awful.button({ }, 2, function () exec("amixer -D pulse set ".. sound_settings["device"] .." toggle")   end),
    awful.button({ }, 4, function () exec("amixer -q set ".. sound_settings["device"] .." 2%+", false) end),
    awful.button({ }, 5, function () exec("amixer -q set ".. sound_settings["device"] .." 2%-", false) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())
-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
-- %B / %b = month(September) / short form (Sept)
-- %D / %d = date(09/19/13 mm/dd/yy) / day of month (19 dd) 
-- %R / %r = time now: 24h / 12h(am/pm)+seconds (01:10:16 not much usefull when the update rate of the widget is 30ish seconds.)
vicious.register(datewidget, vicious.widgets.date, "%b %d, %R", 60)
-- Register buttons
datewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("pylendar.py") end)
))
-- }}}

-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
    ))

tasklist = {}
tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))

for s = 1, scount do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
    tasklist[s] = awful.widget.tasklist(function(c)
        return awful.widget.tasklist.label.currenttags(c, s)
    end, tasklist.buttons)

    -- Create the wibox
    wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 12,
        bg = beautiful.bg_normal, position = "top",
        border_color = beautiful.border_focus,
        border_width = beautiful.border_width
    })
    -- Add widgets to the wibox
    wibox[s].widgets = {
        {   taglist[s], layoutbox[s], separator, promptbox[s],
            ["layout"] = awful.widget.layout.horizontal.leftright
        },
        s == 1 and systray or nil,
        separator, datewidget, dateicon,
        separator, wifiwidget, wifiicon,
        separator, upicon, netwidget, dnicon,
        separator, fs.s.widget, fs.h.widget, fs.r.widget, fs.b.widget, fsicon,
        separator, membar.widget, memicon,
        separator, volwidget,  volbar.widget, volicon,
        separator, batwidget, baticon,
        separator, tzswidget, cpugraph.widget, cpuicon,
        separator, ["layout"] = awful.widget.layout.horizontal.rightleft,
        tasklist[s]
    }
end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
-- {{{ Global keys
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),
    awful.key({ modkey }, "w", function () mymainmenu:show({keygrabber=true}) end),
    awful.key({ modkey }, "l", function () exec("xscreensaver-command -lock") end),

    -- {{{ Applications
    awful.key({ modkey }, "e",      function () exec("emacsclient -n -c") end),
    awful.key({ altkey }, "F1",     function () exec("urxvt") end),
    awful.key({ altkey }, "#49",    function () scratch.drop("urxvt", "bottom", nil, nil, 0.30) end),
    awful.key({ modkey }, "a",      function () exec("urxvt -T Alpine -e alpine.exp") end),
    awful.key({ modkey }, "g",      function () sexec("GTK2_RC_FILES=~/.gtkrc-gajim gajim") end),
    awful.key({ modkey }, "q",      function () exec("emacsclient --eval '(make-remember-frame)'") end),
    awful.key({ altkey }, "#51",    function ()
        if boosk then osk(nil, mouse.screen)
        else boosk, osk = pcall(require, "osk") end
    end),
    -- printscreen
    awful.key({ }, "Print", function () awful.util.spawn("gnome-screenshot") end),
    -- }}}

    -- {{{ Multimedia keys
    awful.key({}, "#160", function () exec("xscreensaver-command -lock") end),

    -- {{{START sound commands
    -- Mute sound.  
    awful.key({ modkey }, "m", function ()
        exec("amixer -q sset " .. sound_settings["device"] .. " toggle")
    end),
    -- increase sound 
    awful.key({ modkey }, "Down", function ()
        exec("amixer -q sset " .. sound_settings["device"] .. " 2%- umute")
    end),
    -- decrease sound
    awful.key({ modkey }, "Up", function ()
        exec("amixer -q sset " .. sound_settings["device"] .. " 2%+ umute")
    end),
    -- Media keys on laptop.
    awful.key({}, "#121", function () exec("amixer -q sset " .. sound_settings["device"] .. " toggle") end), -- Mute sound.  
    awful.key({}, "#122", function () exec("amixer -q sset " .. sound_settings["device"] .. " 2%- umute") end), -- increase sound 
    awful.key({}, "#123", function () exec("amixer -q sset " .. sound_settings["device"] .. " 2%+ umute") end), -- decrease sound
    -- }}}END sound commands

    awful.key({}, "#232", function () exec("plight.py -s") end),
    awful.key({}, "#233", function () exec("plight.py -s") end),
    --awful.key({}, "#150", function () exec("sudo /usr/sbin/pm-suspend")   end),
    awful.key({}, "#213", function () exec("sudo /usr/sbin/pm-hibernate") end),
    --awful.key({}, "#235", function () exec("xset dpms force off") end),
    awful.key({}, "#235", function () exec("pypres.py") end),
    awful.key({}, "#244", function () sexec("acpitool -b | xmessage -timeout 10 -file -")   end),
    -- }}}

    -- {{{ Prompt menus
    -- Run program 
    awful.key({ modkey }, "F2", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = exec(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    awful.key({ altkey }, "F2", function () -- alt+f2 is standard linux run-program promt.
    awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
        function (...) promptbox[mouse.screen].text = exec(unpack(arg), false) end,
        awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    awful.key({ modkey }, "r", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = exec(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    -- Search dictionary
    -- TODO make it work. Use duckduckgo with '!d word' as params
    awful.key({ modkey }, "F3", function ()
        awful.prompt.run({ prompt = "Dictionary: " }, promptbox[mouse.screen].widget,
            function (words)
                sexec("crodict "..words.." | ".."xmessage -timeout 10 -file -")
            end)
    end),
    -- Open chromium with spesific search.
    awful.key({ modkey }, "F4", function ()
        awful.prompt.run({ prompt = "Web: " }, promptbox[mouse.screen].widget,
            function (command)
                sexec("chromium '"..command.."'")
                awful.tag.viewonly(tags[scount][2])
            end)
    end),
    -- Run Lua code.
    awful.key({ altkey }, "F5", function ()
        awful.prompt.run({ prompt = "Lua: " }, promptbox[mouse.screen].widget,
            awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
    end),
    awful.key({ modkey }, "x", function ()
        awful.prompt.run({ prompt = "Run Lua code: " }, promptbox[mouse.screen].widget,
            awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
    end),
    -- }}}

    -- {{{ Awesome controls
    -- Open terminal 
    awful.key({ modkey }, "Return", function ()
        awful.util.spawn(terminal)
    end),
    -- hide awesome systray line / task line at the top of screen
    awful.key({ modkey }, "b", function ()
        wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),
    awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, "Control" }, "r", awesome.restart), -- restart awesome.
    -- }}}

    -- {{{ Tag browsing
    awful.key({ altkey }, "n",   awful.tag.viewnext), -- next desktop / workspace / awesoem window / tag
    awful.key({ modkey }, "n",   awful.tag.viewnext), -- next desktop / workspace / awesoem window / tag
    awful.key({ altkey }, "p",   awful.tag.viewprev), -- previous desktop / workspace / awesoem window / tag
    awful.key({ modkey }, "p",   awful.tag.viewprev), -- previous desktop / workspace / awesoem window / tag

    awful.key({ modkey }, "Tab", awful.tag.history.restore), -- switch to previous desktop. 
    -- }}}

    -- {{{ Layout manipulation
    --    awful.key({ modkey }, "l",          function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact( 0.05) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end), -- choose previous awesome window layout
    awful.key({ modkey },          "space", function () awful.layout.inc(layouts,  1) end), -- choose next awesome window layout
    -- }}}

    -- {{{ Focus controls
    --    awful.key({ modkey }, "p", function () awful.screen.focus_relative(1) end),
    --    awful.key({ modkey }, "s", function () scratch.pad.toggle() end),
    --    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey }, "j", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    -- {{{ alt + tab functionality
    awful.key({ altkey,           }, "Tab",
        function ()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "Tab",
        function ()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus:raise()
            end
        end),
    -- }}} end alt + tab functionality.
    -- {{{show a list of all open programs.
    -- use arrowkeys and enter to select program to navigate to.
    awful.key({ altkey }, "Escape", function ()
        awful.menu.menu_keys.down = { "Down", "Alt_L" }
        local cmenu = awful.menu.clients({width=530}, { keygrabber=true, coords={x=525, y=330} })
    end),
    -- }}}
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1)  end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end)
-- }}}
)
-- }}}

-- {{{ Client manipulation
clientkeys = awful.util.table.join(
-- kill program in focus.
    awful.key({ modkey }, "c", function (c) c:kill() end),
    awful.key({ altkey }, "F4", function (c) c:kill() end),

    -- non fullscreen, centered default size.
    awful.key({ modkey }, "d", function (c) scratch.pad.set(c, 0.60, 0.60, true) end),
    -- fullscreen
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end),
    -- no idea, yet.
    awful.key({ modkey, altkey }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    -- toggle floating mode
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle ),
    -- move program/window to next screen
    awful.key({ modkey }, "o",     awful.client.movetoscreen),
    awful.key({ modkey, altkey }, "2", function (c) awful.client.movetoscreen(c, 1) end),
    awful.key({ modkey, altkey }, "1", function (c) awful.client.movetoscreen(c, 2) end),
    awful.key({ modkey, altkey }, "3", function (c) awful.client.movetoscreen(c, 3) end),

    awful.key({ modkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey, "Shift" }, "0", function (c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end),
    --    awful.key({ modkey, "Shift" }, "c", function (c) exec("kill -CONT " .. c.pid) end),
    --    awful.key({ modkey, "Shift" }, "s", function (c) exec("kill -STOP " .. c.pid) end),
    -- toggel title bar for programs/windows
    awful.key({ modkey, }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey, "Shift" }, "f", function (c)
        if awful.client.floating.get(c) then
            awful.client.floating.delete(c)
            awful.titlebar.remove(c)
        else
            awful.client.floating.set(c, true)
            awful.titlebar.add(c)
        end
    end)
)
-- }}}

-- {{{ Keyboard digits
local keynumber = 0
for s = 1, scount do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- }}}

-- {{{ Tag controls
for i = 1, keynumber do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewonly(tags[screen][i]) end
        end),
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewtoggle(tags[screen][i]) end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end)
    )
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Signals
-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    if awful.client.floating.get(c) or awful.layout.get(c.screen) == awful.layout.suit.floating then
        if c.titlebar then
            awful.titlebar.remove(c)
        else
            awful.titlebar.add(c, {modkey = modkey})
        end
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)
        if not c.size_hints.program_position and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, scount do
    screen[s]:add_signal(
        "arrange",
        function ()
            local clients = awful.client.visible(s)
            local layout = awful.layout.getname(awful.layout.get(s))

            -- Floaters are always on top
            for _, c in pairs(clients) do
                if awful.client.floating.get(c) or layout == "floating" then
                    if not c.fullscreen then
                        c.above = true
                    end
                else
                    c.above = false
                end
            end
        end
    )
end
-- }}}
-- }}} end Signals

--{{{ Mouse movement
-- Simple function to move the mouse to the coordinates set above.
local function move_mouse(x_co, y_co)
    mouse.coords({ x=x_co, y=y_co })
end

-- if there are two or more screens enable infinite screen array loop illusion.
-- (isali)
if screen.count() >=2 then
    -- get the dimensions of the total screen resolution. ex: 3200x1080
    local screen_dimension = io.popen("xdpyinfo | grep \"dimensions:\" | grep -oP \"\\d+x\\d+\"")

    local dimensions = {} -- list containing: nil, x, y
    -- first line is pixels, second line is mm.
    for l in screen_dimension:lines() do
        for dim in string.gmatch(l, "%d+") do
            table.insert(dimensions,dim)
        end
        break -- we only want the first line.
    end

    --local width=3360 -- =2 screens with 1680 width
    --local width=5760 -- =3 screens with 1920 width
    -- start isali timer.
    local mouse_timer = timer({timeout = 0.1})
    -- add signal listening for isali timer.
    mouse_timer:add_signal("timeout", function()
        -- if mouse cursor hits right screen edge
        if mouse.coords()["x"] >= dimensions[1]-1 then
            -- move cursor to left screen edge
            move_mouse( 1, mouse.coords()["y"]  )
            -- if mouse cursor hits left screen edge
        elseif mouse.coords()["x"] <= 0 then
            -- move cursor to right screen edge.
            move_mouse( dimensions[1]-2, mouse.coords()["y"]  )
        end
    end)
    -- start timer to check for isali event.
    mouse_timer:start()
end
--}}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { }, properties = {
        focus = true,      size_hints_honor = false,
        keys = clientkeys, buttons = clientbuttons,
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal }
    },

    { rule = { class = "Spotify" },
        properties = { tag = tags[1][9], switchtotag = true }
    },

    { rule = { class = "Skype",  instance = "im" },
        properties = { tag = tags[1][8] }
    },

    { rule = { name = "irc", instance = "irc"},
        properties = { tag = tags[1][8] }
    },

    { rule = { class = "Chromium" },
        properties = { tag = tags[1][2], switchtotag = true }
    },

    { rule = { class = "owncloud" },
        properties = { tag= tags[1][1], switchtotag = true }
    },

    { rule = { instance = "plugin-container" },
        properties = { floating = true }, callback = awful.titlebar.add  },
    --{ rule = { class = "Akregator" },   properties = { tag = tags[scount][8]}},
    --{ rule = { name  = "Alpine" },      properties = { tag = tags[1][4]} },
    --{ rule = { class = "Gajim" },       properties = { tag = tags[1][5]} },
    --{ rule = { class = "Ark" },         properties = { floating = true } },
    --{ rule = { class = "Geeqie" },      properties = { floating = true } },
    --{ rule = { class = "ROX-Filer" },   properties = { floating = true } },
    --{ rule = { class = "Pinentry.*" },  properties = { floating = true } },
}
-- }}}

-- Starting applications.
os.execute("~/repos/scripts/run_once x-terminal-emulator &")
os.execute("~/repos/scripts/run_once nm-applet &")
os.execute("~/repos/scripts/run_once chromium &")
os.execute("~/repos/scripts/run_once xscreensaver &")
os.execute("~/repos/scripts/run_once slack &")
os.execute("~/repos/scripts/run_once spotify &")

