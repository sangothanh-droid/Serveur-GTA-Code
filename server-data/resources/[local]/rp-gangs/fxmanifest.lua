fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Serveur-GTA-Code'
description 'Réputation de gang avec conséquences (police, économie)'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
    'shared/gangs.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
