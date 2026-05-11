import catppuccin
config.load_autoconfig()
c.fonts.default_family = ['JetBrainsMono Nerd Font', 'JetBrains Mono', 'monospace']
c.fonts.default_size = '14px'

c.fonts.completion.entry = '14pt JetBrainsMono Nerd Font'
c.fonts.completion.category = 'bold 14pt JetBrainsMono Nerd Font'
c.fonts.debug_console = '14pt JetBrainsMono Nerd Font'
c.fonts.downloads = '14pt JetBrainsMono Nerd Font'
c.fonts.hints = 'bold 14pt JetBrainsMono Nerd Font'
c.fonts.keyhint = '14pt JetBrainsMono Nerd Font'
c.fonts.messages.error = '14pt JetBrainsMono Nerd Font'
c.fonts.messages.info = '14pt JetBrainsMono Nerd Font'
c.fonts.messages.warning = '14pt JetBrainsMono Nerd Font'
c.fonts.prompts = '14pt JetBrainsMono Nerd Font'
c.fonts.statusbar = '14pt JetBrainsMono Nerd Font'
c.fonts.tabs.selected = '14pt JetBrainsMono Nerd Font'
c.fonts.tabs.unselected = '14pt JetBrainsMono Nerd Font'

c.fonts.web.family.standard = 'JetBrainsMono Nerd Font'
c.fonts.web.family.fixed = 'JetBrainsMono Nerd Font'
c.fonts.web.family.serif = 'JetBrainsMono Nerd Font'
c.fonts.web.family.sans_serif = 'JetBrainsMono Nerd Font'
c.fonts.web.family.cursive = 'JetBrainsMono Nerd Font'
c.fonts.web.family.fantasy = 'JetBrainsMono Nerd Font'
c.fonts.web.size.default = 14
c.fonts.web.size.default_fixed = 14
c.fonts.web.size.minimum = 12
c.fonts.web.size.minimum_logical = 10
catppuccin.setup(c, 'mocha', True)

c.colors.hints.fg = '#282828'  # черный текст
c.colors.hints.bg = '#ebdbb2'  # розовый фон (Catppuccin Mocha pink)
c.colors.hints.match.fg = '#282828'  # черный текст для совпадающих хинтов
c.hints.radius = 10

c.scrolling.smooth = True

c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts",
    "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt",
    "https://filters.adtidy.org/extension/ublock/filters/224.txt"
]
