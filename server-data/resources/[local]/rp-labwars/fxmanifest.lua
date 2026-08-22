fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Serveur-GTA-Code'
description 'Contrôle des labos (armes/drogue) : occuper seul un labo en prend le monopole'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
