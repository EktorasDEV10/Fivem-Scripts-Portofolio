fx_version 'adamant'
game 'gta5'
lua54 'yes'

escrow_ignore {
  'config/ek_config.lua',
}

description 'MARKETS by Ektoras#4021'

ui_page "html/index.html"

shared_scripts {
  'config/*.lua'
}

server_scripts {
  'server/ek_s.lua'
}

client_scripts {
  'client/ek_c.lua'
}

files {
    'html/index.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/images/**.png',
    'html/images/**.jpg'
}