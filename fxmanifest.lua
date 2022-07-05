fx_version 'cerulean'
game 'gta5'

author 'ALEN TL'
version '1.0'

client_scripts {
    'client/main.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua',
    'config.lua',
    '@oxmysql/lib/MySQL.lua'
}