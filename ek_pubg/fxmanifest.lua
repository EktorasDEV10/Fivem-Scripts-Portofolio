fx_version 'adamant'
game 'gta5'

description 'PUBG EVENT by Ektoras#4021'

shared_script 'config/ek_config.lua'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/ek_s.lua'
}

client_scripts {
  'client/*.lua'
}

server_exports {
	"isPubg"
}