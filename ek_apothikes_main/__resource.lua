resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'WAREHOUSES-APOTHIKES by Ektoras#4021'

ui_page 'html/kwdikos.html'

shared_script 'config/ek_config.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/ek_s.lua'
}

client_scripts {
    'client/ek_c.lua'
}

files {
    'html/kwdikos.css',
    'html/kwdikos.js',
    'html/kwdikos.mp3',
    'html/kwdikos.png',
    'html/kwdikos.html'
}