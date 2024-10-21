fx_version "adamant"
games { "gta5" }
lua54 'yes'
author 'HG Store'
description 'HG-VehRental'
version '1.0.0'

shared_scripts { 
    '@ox_lib/init.lua',
	'config.lua'
}

server_scripts {
    "server.lua"
}

client_scripts {
    "client.lua"
}
