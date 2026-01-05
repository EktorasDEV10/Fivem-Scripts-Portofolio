resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'ADVANCED CRATE EVENT by Ektoras#4021'

shared_script 'config/ek_config.lua'

client_scripts {
    "client/ek_c.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/ek_s.lua"
}
