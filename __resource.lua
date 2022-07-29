shared_script "@ThnAC/natives.lua"
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "nui/index.html"

files {
	"nui/*"
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*",
	"client.lua",
	"config.lua"
	
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server-side/*",
	"server.lua"
}

