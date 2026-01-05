fx_version 'adamant'
game 'gta5'
lua54 'yes'

escrow_ignore {
  'config/ek_config.lua',
}

description 'GUNGAME by Ektoras#4021'

ui_page "html/index.html"

shared_scripts {
  'config/*.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/ek_s.lua'
}

client_scripts {
  'client/*.lua'
}

files {
    'html/index.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/images/*.png',
    'html/images/*.jpg',
    'html/images/weapons/*.png',
    'html/images/weapons/*.jpg',
    'html/images/peds/**',
    'html/sounds/*.mp3',
    'html/sounds/*.ogg'
}