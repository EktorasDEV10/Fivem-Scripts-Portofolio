fx_version 'adamant'
game 'gta5'
lua54 'yes'

escrow_ignore {
  'ek_config.lua',
}

description 'Advanced Report System coded by Ektoras#4021'

ui_page 'html/report.html'

shared_script 'ek_config.lua'

server_scripts {
  'server/*.lua'
}

client_scripts {
  'client/ek_c.lua'
}

files {
  'html/report.html',
  'html/css/index.css',
  'html/js/index.js'
}