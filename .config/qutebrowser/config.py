config.load_autoconfig()

# https://github.com/qutebrowser/qutebrowser/blob/master/doc/help/configuring.asciidoc#binding-chained-commands
def bind_chained(key, *commands):
    config.bind(key, ' ;; '.join(commands))

bind_chained('<Escape>', 'clear-keychain', 'search')

c.qt.force_platform = 'wayland'

# Enable JS
bind_chained("xjs", "set content.javascript.enabled true",
        "set colors.statusbar.normal.bg red")

# Disable JS
bind_chained("xJS", "set content.javascript.enabled false",
        "set colors.statusbar.normal.bg black")

# editor
c.editor.command = ["foot", "-e", "vim", "{}"]

# The page(s) to open at the start.
c.url.start_pages = "https://home.brub.ca"

c.content.javascript.enabled = False
js_whitelist = [
    "*://localhost/*",
    "*://127.0.0.1/*",
    "*://brub.ca/*",
    "*://*.brub.ca/*",
    "*://chromic.org/*",
    "*://*.chromic.org/*",
    "*://github.com/*",
    "*://news.ycombinator.com/*",
    "*://duckduckgo.com/*"
]

for site in js_whitelist:
    with config.pattern(site) as p:
        p.content.javascript.enabled = True

config.source('pyconfig/redirectors.py')

