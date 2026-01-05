fx_version 'adamant'

game 'gta5'

description 'CAPTURE THE AREA by Ektoras#4021'

ui_page "html/index.html"

shared_script 'config/ek_config.lua'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/ek_s.lua'
}

client_scripts {
  'client/*.lua'
}

files {
  'html/index.html',
  'html/index.js',
  'html/index.css'
}
client_script "@Greek_ac/client/injections.lua"