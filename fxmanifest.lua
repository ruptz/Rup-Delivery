fx_version 'cerulean'
game 'gta5'

author 'Ruptz'
description 'Delivery script made to look like GTA Online'

version '1.0.0'

repository 'https://github.com/ruptz/Rup-Delivery'

client_scripts {
    'client/cl_*.lua',
}

shared_scripts {
    'config.lua',
    --'@es_extended/imports.lua' --[[ Uncomment if using ESX ]]
}

server_scripts {
    'server/sv_*.lua',
}