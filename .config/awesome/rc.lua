-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain    = require("lain")
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("connman-ui-gtk")
run_once("compton")
-- }}}

-- {{{ Variable definitions
-- Default modkey
modkey      = "Mod4"
altkey      = "Mod1"

-- User defined
terminal    = "konsole"
editor      = os.getenv("EDITOR") or "nano"
editor_cmd  = terminal .. " -e " .. editor
vol         = terminal .. " -g 95x20-5+20 -e alsamixer -c 0"
htop        = terminal .. " -g 95x20-5+20 -e htop"
-- fm_cli      = terminal .. " -name 'ranger' -e ranger"
-- ncm         = terminal .. " -name 'ncmpcpp' -e ncmpcpp"

base01 = "#586e75"
base02 = "#073642"
-- naughty.config.defaults.border_color = base01

home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
themes = confdir .. "/themes"

-- Load the theme
active_theme = themes .. "/solarized-powerarrow"
beautiful.init(active_theme .. "/theme.lua")

-- Load layouts
local layouts = {
    awful.layout.suit.floating,
    lain.layout.uselesstile,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tag list
tags = {
    -- names = { "Ƅ", "ƀ", "Ɵ", "ƈ", "Ɗ" },
    names = { "1", "2", "3", "4", "5" },
    layout = { layouts[2], layouts[6], layouts[2], layouts[7], layouts[1] }
}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Switch windows
local titlin = function()
        clients = client.get()
        dmenu_in = ""
        for i, line in ipairs(clients) do
                dmenu_in = dmenu_in ..i ..", ".. line.name
                if (i ~= #clients) then
                        dmenu_in = dmenu_in .. "\n"
                end
        end
        selected = awful.util.pread("echo '" .. dmenu_in .. "'|dmenu -i -y 14 -l 5 -w 800 -h 15 -nb '" .. beautiful.menu_bg_normal ..
        "' -fn '" .. beautiful.font_alt ..
        "' -nf '" .. beautiful.menu_fg_normal ..
        "' -sb '" .. beautiful.menu_bg_focus .. "' ")
        if selected ~= "" then
                _,_,n = string.find(selected, "(%d+),")
                awful.client.jumpto(clients[tonumber(n)])
        end
end
-- }}}

-- {{{ Menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon } -- ,
--                                    { "ncmpcpp", ncm },
--                                    { "ranger", fm_cli }
                                  }
})

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
markup = lain.util.markup
space2 = markup.font("Tamsyn 2", " ")
white   = "#93A1A1"
yellow  = "#F0C674"
red     = "#FF6C5C"
green   = "#B7CE42"

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(markup("#6c71c4", "%I:%M %p" .. space2))

-- Calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 8 })

-- Volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(vol) end )))
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            widget:set_markup(markup("#268bd2", volume_now.level .. "M "))
            volicon:set_image(beautiful.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            widget:set_markup(markup("#268bd2", volume_now.level .. "% "))
            volicon:set_image(beautifu.widget_vol_no)
        elseif tonumber(volume_now.level) <= 30 then
            widget:set_markup(markup("#268bd2", volume_now.level .. "% "))
            volicon:set_image(beautiful.widget_vol_low)
        elseif tonumber(volume_now.level) <= 60 then
            widget:set_markup(markup("#268bd2", volume_now.level .. "% "))
            volicon:set_image(beautiful.widget_vol_med)
        else
            volicon:set_image(beautiful.widget_vol)
            widget:set_markup(markup("#268bd2", volume_now.level .. "% "))
        end
    end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = wibox.widget.background(lain.widgets.bat({
    battery = "BAT1",
    settings = function()
        if bat_now.watt == "N/A" then
            widget:set_markup(markup("#eee8d5", "AC "))
            baticon:set_image(beautiful.widget_ac)
            return
        elseif bat_now.status == "Charging" then
            bat_now.perc = bat_now.perc .. " CHR "
            baticon:set_image(beautiful.widget_ac)
        elseif tonumber(bat_now.perc) <= 30 then
            bat_now.perc = bat_now.perc .. "% "
            baticon:set_image(beautiful.widget_bat_low)
        elseif tonumber(bat_now.perc) <= 50 then
            bat_now.perc = bat_now.perc .. "% "
            baticon:set_image(beautiful.widget_bat_half)
        elseif tonumber(bat_now.perc) <= 90 then
            bat_now.perc = bat_now.perc .. "% "
            baticon:set_image(beautiful.widget_bat_med)
        else
            bat_now.perc = bat_now.perc .. "% "
            baticon:set_image(beautiful.widget_bat)
        end
        widget:set_markup(markup("#eee8d5", bat_now.perc))
    end
}), base02)

-- Memory
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = wibox.widget.background(lain.widgets.mem({
    settings = function()
        widget:set_markup(markup("#b58900", mem_now.used .. "M "))
    end
}), base02)

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup("#cb4b16", coretemp_now .. "°C "))
    end
})

-- CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(htop) end )))
cpuwidget = wibox.widget.background(lain.widgets.cpu({
    settings = function()
        widget:set_markup(markup("#dc322f", cpu_now.usage .. "% "))
    end
}), base02)

-- Net
--netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)
netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_net_down)
netdowninfo = wibox.widget.textbox()

-- netupicon = wibox.widget.imagebox(beautiful.widget_netup)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_net_up)
netupinfo = lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#dc322f", net_now.sent .. " "))
        netdowninfo:set_markup(markup("#859900", net_now.received .. " "))
    end
})

-- MPD notification
--mpdwidget = lain.widgets.mpd({
--    settings = function()
--        mpd_notification_preset = {
--            title = "Now playing",
--            timeout = 6,
--            text = string.format("%s - %s\n%s", mpd_now.artist,
--                   mpd_now.album, mpd_now.title)
--        }
--    end
--})

-- Separators
spr = wibox.widget.textbox('<span font="Tamsyn 4"> </span>')
arr0 = wibox.widget.imagebox()
arr0:set_image(beautiful.arr0)
arr01= wibox.widget.imagebox()
arr01:set_image(beautiful.arr01)
arr1 = wibox.widget.imagebox()
arr1:set_image(beautiful.arr1)
arr2 = wibox.widget.imagebox()
arr2:set_image(beautiful.arr2)
arr3 = wibox.widget.imagebox()
arr3:set_image(beautiful.arr3)
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
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
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    -- mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "16", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    -- left_layout:add(mypromptbox[s])
    left_layout:add(arr2)
    left_layout:add(mylayoutbox[s])
    left_layout:add(arr3)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(arrl)
    right_layout:add(netupicon)
    right_layout:add(netupinfo)
    right_layout:add(netdownicon)
    right_layout:add(netdowninfo)
    right_layout:add(arr1)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(arr0)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(arr1)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(arr0)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(arr1)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(arr01)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- Tag browsing
    awful.key({ modkey }, "bracketleft", awful.tag.viewprev),
    awful.key({ modkey }, "bracketright", awful.tag.viewnext),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Client focus
    awful.key({ modkey }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Client reorder
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

    -- Jump to urgent client
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Switch mouse screen
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),

    -- Layout manipulation
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

    -- Resize floaters
    awful.key({ modkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),

    -- Move floaters
    awful.key({ modkey,           }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey,           }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey,           }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey,           }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),

    -- Show menu
    awful.key({ modkey }, "w",
        function () mymainmenu:show() end),

    -- Toggle wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- Change usesless gap
    awful.key({ modkey }, "=", function () lain.util.useless_gaps_resize(1) end),
    awful.key({ modkey }, "-", function () lain.util.useless_gaps_resize(-1) end),

    -- dmenu2
    awful.key({ modkey }, "p", function ()
    awful.util.spawn( "dmenu_run -i -y 16 -q -l 5 -w 250 -h 15 -nb '" .. beautiful.menu_bg_normal ..
            "' -fn '" .. beautiful.font_alt ..
            "' -nf '" .. beautiful.menu_fg_normal ..
            "' -sb '" .. beautiful.menu_bg_focus ..
            "' -p 'Run:' ")
    end),

    -- passmenu
    awful.key({ modkey, "Shift" }, "p", function ()
    awful.util.spawn( "passmenu -i -y 16 -q -l 5 -w 350 -h 15 -nb '" .. beautiful.menu_bg_normal ..
            "' -fn '" .. beautiful.font_alt ..
            "' -nf '" .. beautiful.menu_fg_normal ..
            "' -sb '" .. beautiful.menu_bg_focus ..
            "' -p 'Passmenu:' ")
    end),

    -- Tag/client switching
    awful.key({ altkey, }, "Tab", titlin),

    -- Volume keyboard control
    awful.key({ }, "XF86AudioRaiseVolume",
    function ()
        awful.util.spawn("amixer -D pulse sset Master '2%+'")
        volumewidget.update()
    end),
    awful.key({ }, "XF86AudioLowerVolume",
    function ()
        awful.util.spawn("amixer -D pulse sset Master '2%-'")
        volumewidget.update()
    end),
    awful.key({ }, "XF86AudioMute",
    function ()
        awful.util.spawn("amixer set Master playback toggle")
        volumewidget.update()
    end),

    -- Printscreens
    awful.key({ }, "Print",
    function ()
        awful.util.spawn("scrot -d 1 -e 'mv $f ~/screenshots/ 2>/dev/null'")
    end)
)


clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false } },
    -- urxvt gaps fixes
    -- { rule = { name = "urxvt" }, properties = { size_hints_honor = false } },
    -- floating apps
    { rule_any = { class = {"MPlayer", "mpv", "pinentry", "feh", "Vlc"} },
      properties = { floating = true } },
    -- { rule_any = { name = {"alsamixer", "htop",
    --                        "Firefox Preferences", "Library", "Reset Firefox",
    --                        "Classic Theme Restorer", "NoScript Options"} },
    --  properties = { floating = true } },
    -- apps tags
    --{ rule = { class = "Firefox" },
    --  properties = { tag = tags[1][2] } },
    { rule = { class = "Thunar" },
      properties = { tag = tags[1][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- vim: ft=lua:
