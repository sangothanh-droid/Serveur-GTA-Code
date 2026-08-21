fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Serveur-GTA-Code'
description "Écran de règlement à l'arrivée + logs Discord (join/leave)"
version '1.0.0'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
