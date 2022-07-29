-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local CoordenadaZ = 14.93
local CoordenadaX = -1208.75
local CoordenadaY = -2700.11
local servico = false
local location = 1 
local idEmp = 0
local blips = false

local iniciar = {
	[1] = { ['x'] = -1208.75, ['y'] = -2700.11, ['z'] = 14.93 },
}
local departamentos = {
	[1] = { ['x'] = 1687.86, ['y'] = 3755.57, ['z'] = 34.57 },
	[2] = {['x'] = 245.09, ['y'] = -41.33, ['z'] = 69.9 },
	[3] = {['x'] = 847.84, ['y'] = -1020.36, ['z'] = 27.89 },
	[4] = {['x'] = -342.63, ['y'] =  6097.54, ['z'] = 31.31 },
	[5] = {['x'] = -655.51, ['y'] = -932.35, ['z'] = 22.71 },
}

vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_tbl_chest",cnVRP)
vSERVER = Tunnel.getInterface("vrp_tbl_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
Citizen.CreateThread(function()	
	idEmp = vSERVER.checkJobActive()
	while true do
		local skips = 1000
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)
			if distance <= 10.0 then
			skips = 1
			DrawMarker(25,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,60,0,0,0,1)
				if distance <= 1.2 then
					if idEmp > 0 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then							
							RemoveBlip(blips)	
							servico = true
							vSERVER.checkPackeg()					
							location = math.random(1,5)
							CriandoBlip(departamentos,location)

						end
					end 
				end
			end
		end
		Citizen.Wait(skips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- randomicamente locais de entrega 
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
	    local timedistance = 1000
		local ped = PlayerPedId()
		if servico then
		    timedistance = 5
				local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),departamentos[location].x,departamentos[location].y,departamentos[location].z,true)
				if distance <= 50 then
				    timedistance = 5
					DrawMarker(0,departamentos[location].x,departamentos[location].y,departamentos[location].z-0.6,0,0,0,0,0,130.0,2.0,2.0,1.5,255,255,255,150,1,1,0,0)
					if distance <= 4 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							if vSERVER.checkItem() then
								RemoveBlip(blips)
								servico = false
								vSERVER.checkPayment()
								vSERVER.removeEmprego(idEmp)
							end
					    end
				    end
			    end
		end
		Citizen.Wait(timedistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPassport",function(data,cb)
	local passport = vSERVER.getPass(data.user_id)
	if passport then
		cb({ passport = passport})
	end
end)

RegisterNUICallback("requestPassportSemOrg",function(data,cb)
	local passport = vSERVER.getPassSemOrg(data.user_id)
	if passport then
		cb({ passport = passport})
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local inventario2 = vSERVER.openChest(data.homes)
	if inventario2 then
		cb({  inventario2 = inventario2 })
	end
	
end)

RegisterNUICallback("getCars",function(data,cb)
	local inventario2 = vSERVER.getCar()
	if inventario2 then
		cb({  cars = inventario2 })
	end
	
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTHOUSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestHouse",function(data,cb)
	local houses = vSERVER.getHouse()
	if houses then
		cb({ houses = houses})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--  GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestGroup",function(data,cb)
	local group = vSERVER.getGroup()
	if group then
		cb({ group = group})
	end
end)

RegisterNUICallback("requestGroupUsers",function(data,cb)
	local group = vSERVER.getGroupUser(data.idGroup)
	if group then
		cb({ group = group})
	end
end)

RegisterNUICallback("postGroup",function(data,cb)
	local group = vSERVER.postGroup(data.name, data.radio)
	if group then
		cb({ group = group})
	else 
		cb({})
	end
end)

RegisterNUICallback("postGroupUser",function(data,cb)
	local group = vSERVER.postGroupUser(data.user_id, data.id_grupo)
	if group then
		cb({ group = group})
	else 
		cb({})
	end
end)

RegisterNUICallback("delGroupUser",function(data,cb)
	local group = vSERVER.delGroupUser(data.user_id, data.id_grupo)
	if group then
		cb({ group = group})
	else 
		cb({})
	end
end)

RegisterNUICallback("delGroup",function(data,cb)
	local group = vSERVER.delGroup( data.id_grupo)
	if group then
		cb({ group = group})
	else 
		cb({})
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--  Orgs
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestOrgsLider",function(data,cb)
	local orgs = vSERVER.getLideranca()
	if orgs then
		cb({ orgs = orgs})
	end
end)

RegisterNUICallback("requestOrgsPes",function(data,cb)
	local orgs = vSERVER.getPesOrg(data.orgs)
	if orgs then
		cb({ orgs = orgs})
	end
end)

RegisterNUICallback("requestChestOrgs",function(data,cb)
	local inventario2 = vSERVER.openChestOrgs(data.orgs)
	if inventario2 then
		cb({  inventario2 = inventario2 })
	end
	
end)

RegisterNUICallback("postOrgs",function(data,cb)
	TriggerServerEvent("AddGrupo", data.org, data.user_id)
	cb({  })
end)

RegisterNUICallback("removeUserOrgs",function(data,cb)
	TriggerServerEvent("removeUserOrgs", data.org, data.user_id)
	cb({  })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--  empregos User
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getUserAtivo", function(data, cb)
    local empUser = vSERVER.empAtivo()
	idEmp = vSERVER.checkJobActive()
	if empUser then 
		cb({empAtivo = empUser})
	end 	
end)

RegisterNUICallback("postRemoveEmprego", function ( data, cb)
	local empUser = vSERVER.removeEmprego(  data.id)
	cb({ })
end)

RegisterNUICallback("postAceitaEmprego", function ( data, cb)
	local empUser = vSERVER.aceitaEmprego(  data.id, data.empUserId)
	idEmp = vSERVER.checkJobActive()
	CriandoBlip(iniciar,1)
	cb({ })
end)

RegisterNUICallback("getEmpJobs", function(data, cb)
    local empDiarios = vSERVER.empJobDiario(data.empUserId)
	if empDiarios then 
		cb({empDiarios = empDiarios})
	end 	
end)

RegisterNUICallback("postEmpUser", function ( data, cb)
	local empUser = vSERVER.atualizaEmpAivo(  data.id, data.ativo)
	cb({ })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v.x << 8) | v.y
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
local chestCoords = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION ADD IN TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.insertTable(chestname,coords)
	local x,y,z = table.unpack(coords)
	table.insert(chestCoords,{ chestname = chestname, x = x, y = y, z = z })
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Encomenda")
	EndTextCommandSetBlipName(blips)
end
