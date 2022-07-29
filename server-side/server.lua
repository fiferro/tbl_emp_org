-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local cfg = module("cfg/groups")
local groups = cfg.groups
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_tbl_chest",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_tbl_chest")
config = {};
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chestOpen = {}
local antichestdump = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- Busca
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("queryPassport",
             "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")	
vRP.prepare("queryPassportSemOrg",
             "SELECT vui.* FROM vrp_user_identities vui, vw_org_user vou WHERE vui.user_id = @user_id  and vui.user_id = vou.user_id AND vou.NAME = '' ")	
vRP._prepare("queryHouses",
             "SELECT home FROM vrp_homes_permissions WHERE user_id = @user_id")
vRP.prepare("queryChest",
             "SELECT dvalue FROM vrp_srv_data WHERE dkey = @dKey")			 
vRP.prepare("queryCars",
             "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")		
vRP.prepare("queryGrupo",
             "SELECT g.id, g.nome, g.user_id, g.radio FROM grupo g WHERE user_id = @user_id UNION SELECT g.id, g.nome, g.user_id, g.radio FROM grupo g , grupo_user gu WHERE g.id = gu.id_grupo AND gu.user_id = @user_id" )	
vRP.prepare("queryGrupoUser",
             "SELECT  gu.user_id, vud.name, vud.phone,vud.registration, gu.id_grupo, vud.foto, gu.lider FROM grupo_user gu, vrp_user_identities vud WHERE vud.user_id = gu.user_id and gu.id_grupo =  @id_group AND gu.user_id = @user_id UNION	 SELECT  gu.user_id, vud.name, vud.phone,vud.registration, gu.id_grupo, vud.foto, gu.lider FROM grupo_user gu, vrp_user_identities vud WHERE vud.user_id = gu.user_id and gu.id_grupo =  @id_group")
vRP.prepare("queryLideranca", 
			  "SELECT NAME FROM vw_org_user WHERE user_id = @user_id")			 
vRP.prepare("queryPesOrg", 
				"SELECT * FROM vw_identif_org WHERE org = @orgs")
vRP._prepare("queryEmpUser",
             "SELECT id, ativo from emp_user where user_id = @user_id ")
vRP._prepare("queryEmpJobUser",
             "SELECT * from emp_diario where emp_user_id = @emp_user_id")
vRP._prepare("queryEmployer",
             " SELECT ed.id FROM emp_user eu INNER JOIN emp_diario ed ON ed.emp_user_id = eu.id WHERE user_id = @user_id ")			 
			
-----------------------------------------------------------------------------------------------------------------------------------------
-- inserção 
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("InsertGroup",
			"INSERT INTO grupo(nome,user_id,radio) VALUES(@nome,@user_id,@radio); SELECT LAST_INSERT_ID() AS id")	
vRP._prepare("InsertEmpUser",
             "INSERT INTO emp_user (user_id,ativo, dataInicio) VALUES (@user_id, @ativo, DATE_FORMAT(NOW() ,'%Y-%m-%d'))")
vRP.prepare("InsertGroupUser",
			"INSERT INTO grupo_user(user_id, lider, id_grupo) VALUES(@user_id, @lider, @id_grupo);")
vRP._prepare("updateEmpUser",
			"UPDATE emp_user SET ativo = @ativo where id = @id")		
vRP._prepare("updateEmpDiario",
			"UPDATE emp_diario SET emp_user_id = @emp_user_id where id = @id")					
-----------------------------------------------------------------------------------------------------------------------------------------
-- exclusão 
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("deleteUserGroup",
			"DELETE FROM grupo_user WHERE user_id = @user_id and id_grupo = @id_grupo")		
vRP.prepare("deleteGroup",
	 		"DELETE FROM grupo_user WHERE id_grupo = @id_grupo")		
vRP.prepare("deleteGroupMaster",
	        "DELETE FROM grupo WHERE id = @id_grupo")	
vRP.prepare("deleteEmpDiario",
	        "DELETE FROM emp_diario WHERE id = @id")		
-----------------------------------------------------------------------------------------------------------------------------------------
-- getPassport
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getPass(user_id)
	return vRP.query("queryPassport", {user_id = user_id})
end	
-----------------------------------------------------------------------------------------------------------------------------------------
-- getPassportSemFac
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getPassSemOrg(user_id)
	return vRP.query("queryPassportSemOrg", {user_id = user_id})
end			 
-----------------------------------------------------------------------------------------------------------------------------------------
-- getLideranca
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getLideranca(user_id)
	local source = source
	local user_id = vRP.getUserId(source)
	local org =  vRP.query("queryLideranca", {user_id = user_id})
	return vRP.query("queryPesOrg", {orgs = org[1].NAME})
end			

function cnVRP.getPesOrg(orgs)
	return vRP.query("queryPesOrg", {orgs = orgs})
end			

-----------------------------------------------------------------------------------------------------------------------------------------
-- getHouse
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getHouse(k)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.query("queryHouses", {user_id = user_id})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getGrupo
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getGroup()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.query("queryGrupo", {user_id = user_id})
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getGrupoUser
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getGroupUser(id_group)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.query("queryGrupoUser", {id_group = id_group, user_id = user_id})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- insGrupo
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.postGroup(name, radio)	
	local source = source
	local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("InsertGroup",{nome = name, user_id = user_id, radio = radio })
	if #rows > 0 then
		local group_id = rows[1].id
		vRP.execute("InsertGroupUser",{ user_id = user_id, lider = true, id_grupo = group_id })
	end
	return
end

function cnVRP.postGroupUser(user_id, id_grupo)	
    vRP.execute("InsertGroupUser",{ user_id = user_id, lider = false, id_grupo = id_grupo })
	return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- delGrupo
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.delGroupUser(user_id, id_grupo)	
    vRP.execute("deleteUserGroup",{ user_id = user_id, id_grupo = id_grupo })
	return
end

function cnVRP.delGroup(id_grupo)	
    vRP.execute("deleteGroup",{id_grupo = id_grupo })
    vRP.execute("deleteGroupMaster",{id_grupo = id_grupo })
	return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getCars
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getCar()
	local source = source
    local user_id = vRP.getUserId(source)
    local vehicles = vRP.query("queryCars", {user_id = user_id})
	for i in pairs(vehicles) do 
        vehicles[i].name = config.getVehicleModel(vehicles[i].vehicle)
        vehicles[i].ipva = parseInt(vehicles[i].ipva)
        if not vehicles[i].detido then
            vehicles[i].detido = vehicles[i].arrest
        end
    end
    return vehicles
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------

function cnVRP.openChestOrgs(orgs)
	local mychestopen = {}
	if orgs then
		local dkey = 'chest:'..orgs
		local rows = vRP.query("queryChest", {dKey = dkey})
		local data = rows[1].dvalue
		local sdata = json.decode(rows[1].dvalue) or {}
		if data then
			for k,v in pairs(sdata) do
				table.insert(mychestopen,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end
		end
		return mychestopen
	end
	return false
end

function cnVRP.openChest(mychestname)
	local mychestopen = {}
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if mychestname ~= nil then
			local dkey = 'homesVault:'..user_id..':'..mychestname
			local rows = vRP.query("queryChest", {dKey = dkey})
			local data = rows[1].dvalue
			local sdata = json.decode(rows[1].dvalue) or {}
			if data then
				for k,v in pairs(sdata) do
					table.insert(mychestopen,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
			return mychestopen
		end
	end
	return false
end

function checkWeaponByAmmo(ammo, weapon)
	local is_w = config.weapon_ammos[ammo]
	if is_w then
		for k, v in pairs(is_w) do
			if v == weapon then
				return true
			end
		end
	end
	return false
end

function getAmmoTypeByWeapon(wea)
	for ammo, weapons in pairs(config.weapon_ammos) do
		for _, weapon in pairs(weapons) do
			if weapon  == wea then
				return ammo
			end
		end
	end
	return ""
end

RegisterNetEvent('AddGrupo')
AddEventHandler('AddGrupo',function(grupos, playerId)
	local user_id = tonumber(playerId)
    vRP.addUserGroup(user_id,grupos)
	return true
end)

RegisterNetEvent('removeUserOrgs')
AddEventHandler('removeUserOrgs',function(grupos, playerId)
	local user_id = tonumber(playerId)
	vRP.removeUserGroup(user_id, grupos)
	return true
end)


----- emprego emp ------ 

function cnVRP.empAtivo()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.query("queryEmpUser", {user_id = user_id})
end

function cnVRP.empJobDiario(empUserId)
    return vRP.query("queryEmpJobUser", {emp_user_id = empUserId})
end

function cnVRP.aceitaEmprego(id,empUserID)   
	vRP.execute("updateEmpDiario",
	{emp_user_id = empUserID, id = id})
return
end

function cnVRP.removeEmprego(id)   
	vRP.execute("deleteEmpDiario",
	{id = id})
return
end



function cnVRP.atualizaEmpAivo(id,ativo)
    if id == 0 then 		
		local source = source
		local user_id = vRP.getUserId(source)
        vRP.execute("InsertEmpUser",
        {user_id = user_id, ativo = ativo})
    else
        vRP.execute("updateEmpUser",
        {ativo = ativo, id = id})
    end 
   return
end

-----------------------------------
--------- dados para veiculos --------
-------- lembrar de ajustar isso --------

config.vehList = {

	{ hash = 1897985918, name = 'imola', price = 900000, banido = false, modelo = 'Imola', capacidade = 30, tipo = 'carros' },
	{ hash = -2049278303, name = 'ben17', price = 900000, banido = false, modelo = 'Ben 17', capacidade = 30, tipo = 'carros' },
	{ hash = -905399718, name = 'a80', price = 900000, banido = false, modelo = 'Supra A80', capacidade = 30, tipo = 'carros' },
	{ hash = 1920158251, name = '500gtrlam', price = 900000, banido = false, modelo = '500GTR Lam', capacidade = 30, tipo = 'carros' },
	{ hash = 872704284, name = 'sultan2', price = 900000, banido = false, modelo = 'Sultan 2', capacidade = 30, tipo = 'carros' },
	{ hash = -2049278303, name = 'cullinan', price = 900000, banido = false, modelo = 'Cullinan', capacidade = 30, tipo = 'carros' },
	{ hash = 1044193113, name = 'thrax', price = 700000, banido = false, modelo = 'Thrax', capacidade = 30, tipo = 'carros' },
	{ hash = -1193912403, name = 'calico', price = 410000, banido = false, modelo = 'Karin Calico GTF', capacidade = 30, tipo = 'carros' },
	{ hash = -631322662, name = 'penumbra2', price = 310000, banido = false, modelo = 'Penumbra2', capacidade = 30, tipo = 'carros' },
	{ hash = 1118611807, name = 'asbo', price = 110000, banido = false, modelo = 'Asbo', capacidade = 30, tipo = 'carros' },
	{ hash = -447711397, name = 'paragon', price = 400000, banido = false, modelo = 'Paragon', capacidade = 30, tipo = 'carros' },
	{ hash = -1620126302, name = 'neo', price = 620000, banido = false, modelo = 'NEO', capacidade = 30, tipo = 'carros' },
	{ hash = -834353991, name = 'komoda', price = 470000, banido = false, modelo = 'Komoda', capacidade = 50, tipo = 'carros' },
	{ hash = -208911803, name = 'jugular', price = 320000, banido = false, modelo = 'Jugular', capacidade = 50, tipo = 'carros' },
	{ hash = -1132721664, name = 'imorgon', price = 170000, banido = false, modelo = 'IMorgon', capacidade = 30, tipo = 'carros' },
	{ hash = -14495224, name = 'regina', price = 50000, banido = false, modelo = 'Regina', capacidade = 65, tipo = 'sedan' },
	{ hash = 83136452, name = 'rebla', price = 210000, banido = false, modelo = 'Rebla', capacidade = 60, tipo = 'suv' },
	{ hash = 1131912276, name = 'bmx', price = 0, banido = true, modelo = 'bmx', capacidade = 0, tipo = 'work' },
	{ hash = 448402357, name = 'cruiser', price = 0, banido = true, modelo = 'cruiser', capacidade = 0, tipo = 'work' },
	{ hash = -836512833, name = 'fixter', price = 0, banido = true, modelo = 'fixter', capacidade = 0, tipo = 'work' },
	{ hash = -186537451, name = 'scorcher', price = 0, banido = true, modelo = 'scorcher', capacidade = 0, tipo = 'work' },
	{ hash = 1127861609, name = 'tribike', price = 0, banido = true, modelo = 'tribike', capacidade = 0, tipo = 'work' },
	{ hash = -1233807380, name = 'tribike2', price = 0, banido = true, modelo = 'tribike2', capacidade = 0, tipo = 'work' },
	{ hash = 850991848, name = 'biff', price = 0, banido = true, modelo = 'Mineradora', capacidade = 500, tipo = 'work' },
	{ hash = -1829436850, name = 'novak', price = 220000, banido = false, modelo = 'Novak', capacidade = 60, tipo = 'suv' },
	{ hash = -344943009, name = 'blista', price = 30000, banido = false, modelo = 'Blista', capacidade = 40, tipo = 'carros' },
	{ hash = 1549126457, name = 'brioso', price = 35000, banido = false, modelo = 'Brioso', capacidade = 30, tipo = 'carros' },
	{ hash = -1130810103, name = 'dilettante', price = 60000, banido = false, modelo = 'Dilettante', capacidade = 30, tipo = 'carros' },
	{ hash = -1177863319, name = 'issi2', price = 90000, banido = false, modelo = 'Issi2', capacidade = 20, tipo = 'carros' },
	{ hash = -1450650718, name = 'prairie', price = 10000, banido = false, modelo = 'Prairie', capacidade = 25, tipo = 'carros' },
	{ hash = 841808271, name = 'rhapsody', price = 10000, banido = false, modelo = 'Rhapsody', capacidade = 30, tipo = 'carros' },
	{ hash = 330661258, name = 'cogcabrio', price = 130000, banido = false, modelo = 'Cogcabrio', capacidade = 60, tipo = 'carros' },
	{ hash = -685276541, name = 'emperor', price = 50000, banido = false, modelo = 'Emperor', capacidade = 60, tipo = 'carros' },
	{ hash = -1883002148, name = 'emperor2', price = 50000, banido = false, modelo = 'Emperor 2', capacidade = 60, tipo = 'carros' },
	{ hash = -2095439403, name = 'phoenix', price = 250000, banido = false, modelo = 'Phoenix', capacidade = 40, tipo = 'carros' },
    { hash = -1883869285, name = 'premier', price = 35000, banido = false, modelo = 'Premier', capacidade = 50, tipo = 'carros' },
	{ hash = 75131841, name = 'glendale', price = 70000, banido = false, modelo = 'Glendale', capacidade = 50, tipo = 'carros' },
	{ hash = 886934177, name = 'intruder', price = 60000, banido = false, modelo = 'Intruder', capacidade = 50, tipo = 'carros' },
	{ hash = -5153954, name = 'exemplar', price = 80000, banido = false, modelo = 'Exemplar', capacidade = 20, tipo = 'carros' },
	{ hash = -591610296, name = 'f620', price = 55000, banido = false, modelo = 'F620', capacidade = 30, tipo = 'carros' },
	{ hash = -391594584, name = 'felon', price = 70000, banido = false, modelo = 'Felon', capacidade = 50, tipo = 'carros' },
	{ hash = -1289722222, name = 'ingot', price = 160000, banido = false, modelo = 'Ingot', capacidade = 60, tipo = 'carros' },
	{ hash = -89291282, name = 'felon2', price = 1000, banido = false, modelo = 'Felon2', capacidade = 40, tipo = 'work' },
	{ hash = -624529134, name = 'jackal', price = 100000, banido = false, modelo = 'Jackal', capacidade = 50, tipo = 'carros' },
	{ hash = 1348744438, name = 'oracle', price = 60000, banido = false, modelo = 'Oracle', capacidade = 50, tipo = 'carros' },
	{ hash = -511601230, name = 'oracle2', price = 80000, banido = false, modelo = 'Oracle2', capacidade = 60, tipo = 'carros' },
	{ hash = 1349725314, name = 'sentinel', price = 50000, banido = false, modelo = 'Sentinel', capacidade = 50, tipo = 'carros' },
	{ hash = 873639469, name = 'sentinel2', price = 60000, banido = false, modelo = 'Sentinel2', capacidade = 40, tipo = 'carros' },
	{ hash = 1581459400, name = 'windsor', price = 150000, banido = false, modelo = 'Windsor', capacidade = 20, tipo = 'carros' },
	{ hash = -1930048799, name = 'windsor2', price = 170000, banido = false, modelo = 'Windsor2', capacidade = 40, tipo = 'carros' },
	{ hash = -1122289213, name = 'zion', price = 50000, banido = false, modelo = 'Zion', capacidade = 50, tipo = 'carros' },
	{ hash = -1193103848, name = 'zion2', price = 60000, banido = false, modelo = 'Zion2', capacidade = 40, tipo = 'carros' },
	{ hash = -1205801634, name = 'blade', price = 110000, banido = false, modelo = 'Blade', capacidade = 40, tipo = 'carros' },
	{ hash = -682211828, name = 'buccaneer', price = 130000, banido = false, modelo = 'Buccaneer', capacidade = 50, tipo = 'carros' },
	{ hash = -1013450936, name = 'buccaneer2', price = 260000, banido = false, modelo = 'Buccaneer2', capacidade = 60, tipo = 'carros' },
	{ hash = -1150599089, name = 'primo', price = 130000, banido = false, modelo = 'Primo', capacidade = 50, tipo = 'carros' },
	{ hash = -2040426790, name = 'primo2', price = 200000, banido = false, modelo = 'Primo2', capacidade = 60, tipo = 'work' },
	{ hash = 349605904, name = 'chino', price = 130000, banido = false, modelo = 'Chino', capacidade = 50, tipo = 'carros' },
	{ hash = -1361687965, name = 'chino2', price = 200000, banido = false, modelo = 'Chino2', capacidade = 60, tipo = 'work' },
	{ hash = 784565758, name = 'coquette3', price = 150000, banido = false, modelo = 'Coquette3', capacidade = 40, tipo = 'carros' },
	{ hash = 80636076, name = 'dominator', price = 230000, banido = false, modelo = 'Dominator', capacidade = 50, tipo = 'carros' },
	{ hash = 915704871, name = 'dominator2', price = 230000, banido = false, modelo = 'Dominator2', capacidade = 50, tipo = 'carros' },
	{ hash = 723973206, name = 'dukes', price = 150000, banido = false, modelo = 'Dukes', capacidade = 40, tipo = 'carros' },
	{ hash = -2119578145, name = 'faction', price = 150000, banido = false, modelo = 'Faction', capacidade = 50, tipo = 'carros' },
	{ hash = -1790546981, name = 'faction2', price = 200000, banido = false, modelo = 'Faction2', capacidade = 40, tipo = 'work' },
	{ hash = -2039755226, name = 'faction3', price = 350000, banido = false, modelo = 'Faction3', capacidade = 60, tipo = 'carros' },
	{ hash = -1800170043, name = 'gauntlet', price = 165000, banido = false, modelo = 'Gauntlet', capacidade = 40, tipo = 'carros' },
	{ hash = 349315417, name = 'gauntlet2', price = 165000, banido = false, modelo = 'Gauntlet2', capacidade = 40, tipo = 'carros' },
	{ hash = 15219735, name = 'hermes', price = 280000, banido = false, modelo = 'Hermes', capacidade = 50, tipo = 'carros' },
	{ hash = 37348240, name = 'hotknife', price = 180000, banido = false, modelo = 'Hotknife', capacidade = 30, tipo = 'carros' },
	{ hash = 525509695, name = 'moonbeam', price = 220000, banido = false, modelo = 'Moonbeam', capacidade = 80, tipo = 'carros' },
	{ hash = 1896491931, name = 'moonbeam2', price = 250000, banido = false, modelo = 'Moonbeam2', capacidade = 70, tipo = 'carros' },
	{ hash = -1943285540, name = 'nightshade', price = 270000, banido = false, modelo = 'Nightshade', capacidade = 30, tipo = 'carros' },
	{ hash = 1507916787, name = 'picador', price = 150000, banido = false, modelo = 'Picador', capacidade = 90, tipo = 'carros' },
	{ hash = -227741703, name = 'ruiner', price = 150000, banido = false, modelo = 'Ruiner', capacidade = 50, tipo = 'carros' },
	{ hash = -1685021548, name = 'sabregt', price = 260000, banido = false, modelo = 'Sabregt', capacidade = 60, tipo = 'carros' },
	{ hash = 223258115, name = 'sabregt2', price = 150000, banido = false, modelo = 'Sabregt2', capacidade = 60, tipo = 'carros' },
	{ hash = -1745203402, name = 'gburrito', price = 200000, banido = false, modelo = 'GBurrito', capacidade = 100, tipo = 'work' },
	{ hash = 729783779, name = 'slamvan', price = 180000, banido = false, modelo = 'Slamvan', capacidade = 80, tipo = 'carros' },
	{ hash = 833469436, name = 'slamvan2', price = 200000, banido = false, modelo = 'Slamvan2', capacidade = 50, tipo = 'work' },
	{ hash = 1119641113, name = 'slamvan3', price = 230000, banido = false, modelo = 'Slamvan3', capacidade = 80, tipo = 'carros' },
	{ hash = 1923400478, name = 'stalion', price = 150000, banido = false, modelo = 'Stalion', capacidade = 30, tipo = 'carros' },
	{ hash = -401643538, name = 'stalion2', price = 150000, banido = false, modelo = 'Stalion2', capacidade = 20, tipo = 'carros' },
	{ hash = 972671128, name = 'tampa', price = 170000, banido = false, modelo = 'Tampa', capacidade = 40, tipo = 'carros' },
	{ hash = -825837129, name = 'vigero', price = 170000, banido = false, modelo = 'Vigero', capacidade = 30, tipo = 'carros' },
	{ hash = -498054846, name = 'virgo', price = 150000, banido = false, modelo = 'Virgo', capacidade = 60, tipo = 'carros' },
	{ hash = -899509638, name = 'virgo2', price = 250000, banido = false, modelo = 'Virgo2', capacidade = 50, tipo = 'carros' },
	{ hash = 16646064, name = 'virgo3', price = 180000, banido = false, modelo = 'Virgo3', capacidade = 60, tipo = 'carros' },
	{ hash = 2006667053, name = 'voodoo', price = 220000, banido = false, modelo = 'Voodoo', capacidade = 60, tipo = 'carros' },
	{ hash = 523724515, name = 'voodoo2', price = 220000, banido = false, modelo = 'Voodoo2', capacidade = 60, tipo = 'carros' },
	{ hash = 1871995513, name = 'yosemite', price = 350000, banido = false, modelo = 'Yosemite', capacidade = 130, tipo = 'carros' },
	{ hash = 1126868326, name = 'bfinjection', price = 200000, banido = false, modelo = 'Bfinjection', capacidade = 20, tipo = 'carros' },
	{ hash = -349601129, name = 'bifta', price = 190000, banido = false, modelo = 'Bifta', capacidade = 20, tipo = 'carros' },
	{ hash = -1435919434, name = 'bodhi2', price = 170000, banido = false, modelo = 'Bodhi2', capacidade = 90, tipo = 'carros' },
	{ hash = -1479664699, name = 'brawler', price = 250000, banido = false, modelo = 'Brawler', capacidade = 50, tipo = 'carros' },
	{ hash = 101905590, name = 'trophytruck', price = 400000, banido = false, modelo = 'Trophytruck', capacidade = 15, tipo = 'carros' },
	{ hash = -663299102, name = 'trophytruck2', price = 400000, banido = false, modelo = 'Trophytruck2', capacidade = 15, tipo = 'carros' },
	{ hash = -1237253773, name = 'dubsta3', price = 300000, banido = false, modelo = 'Dubsta3', capacidade = 90, tipo = 'carros' },
	{ hash = -2064372143, name = 'mesa3', price = 200000, banido = false, modelo = 'Mesa3', capacidade = 60, tipo = 'carros' },
	{ hash = 1645267888, name = 'rancherxl', price = 220000, banido = false, modelo = 'Rancherxl', capacidade = 70, tipo = 'carros' },
	{ hash = -1207771834, name = 'rebel', price = 1000, banido = false, modelo = 'Rebel', capacidade = 80, tipo = 'work' },
	{ hash = -2045594037, name = 'rebel2', price = 250000, banido = false, modelo = 'Rebel2', capacidade = 100, tipo = 'carros' },
	{ hash = -1532697517, name = 'riata', price = 250000, banido = false, modelo = 'Riata', capacidade = 80, tipo = 'carros' },
	{ hash = 1770332643, name = 'dloader', price = 150000, banido = false, modelo = 'Dloader', capacidade = 80, tipo = 'carros' },
	{ hash = -667151410, name = 'ratloader', price = 1000, banido = false, modelo = 'Caminhão', capacidade = 80, tipo = 'work' },
	{ hash = -1189015600, name = 'sandking', price = 400000, banido = false, modelo = 'Sandking', capacidade = 120, tipo = 'carros' },
	{ hash = 989381445, name = 'sandking2', price = 370000, banido = false, modelo = 'Sandking2', capacidade = 120, tipo = 'carros' },
	{ hash = -808831384, name = 'baller', price = 120000, banido = false, modelo = 'Baller', capacidade = 50, tipo = 'carros' },
	{ hash = 142944341, name = 'baller2', price = 230000, banido = false, modelo = 'Baller', capacidade = 50, tipo = 'carros' },
	{ hash = 1878062887, name = 'baller3', price = 175000, banido = false, modelo = 'Baller3', capacidade = 50, tipo = 'carros' },
	{ hash = 634118882, name = 'baller4', price = 280000, banido = false, modelo = 'Baller2', capacidade = 50, tipo = 'carros' },
	{ hash = 470404958, name = 'baller5', price = 270000, banido = false, modelo = 'Baller5', capacidade = 50, tipo = 'carros' },
	{ hash = 666166960, name = 'baller6', price = 280000, banido = false, modelo = 'Baller6', capacidade = 50, tipo = 'carros' },
	{ hash = 850565707, name = 'bjxl', price = 250000, banido = false, modelo = 'Bjxl', capacidade = 50, tipo = 'carros' },
	{ hash = 2006918058, name = 'cavalcade', price = 300000, banido = false, modelo = 'Cavalcade', capacidade = 60, tipo = 'carros' },
	{ hash = -789894171, name = 'cavalcade2', price = 130000, banido = false, modelo = 'Cavalcade2', capacidade = 60, tipo = 'carros' },
	{ hash = 683047626, name = 'contender', price = 300000, banido = false, modelo = 'Contender', capacidade = 80, tipo = 'carros' },
	{ hash = 1177543287, name = 'dubsta', price = 210000, banido = false, modelo = 'Dubsta', capacidade = 70, tipo = 'carros' },
	{ hash = -394074634, name = 'dubsta2', price = 340000, banido = false, modelo = 'Dubsta2', capacidade = 70, tipo = 'carros' },
	{ hash = -1137532101, name = 'fq2', price = 250000, banido = false, modelo = 'Fq2', capacidade = 50, tipo = 'carros' },
	{ hash = -1775728740, name = 'granger', price = 345000, banido = false, modelo = 'Granger', capacidade = 70, tipo = 'carros' },
	{ hash = -1543762099, name = 'gresley', price = 150000, banido = false, modelo = 'Gresley', capacidade = 50, tipo = 'carros' },
	{ hash = 884422927, name = 'habanero', price = 110000, banido = false, modelo = 'Habanero', capacidade = 50, tipo = 'carros' },
	{ hash = 1221512915, name = 'seminole', price = 110000, banido = false, modelo = 'Seminole', capacidade = 60, tipo = 'carros' },
	{ hash = 1337041428, name = 'serrano', price = 150000, banido = false, modelo = 'Serrano', capacidade = 50, tipo = 'carros' },
	{ hash = 1203490606, name = 'xls', price = 150000, banido = false, modelo = 'Xls', capacidade = 50, tipo = 'carros' },
	{ hash = -432008408, name = 'xls2', price = 350000, banido = false, modelo = 'Xls2', capacidade = 50, tipo = 'carros' },
	{ hash = -1809822327, name = 'asea', price = 55000, banido = false, modelo = 'Asea', capacidade = 30, tipo = 'carros' },
	{ hash = -1903012613, name = 'asterope', price = 100000, banido = false, modelo = 'Asterope', capacidade = 30, tipo = 'carros' },
	{ hash = 906642318, name = 'cog55', price = 200000, banido = false, modelo = 'Cog55', capacidade = 50, tipo = 'work' },
	{ hash = 704435172, name = 'cog552', price = 400000, banido = false, modelo = 'Cog552', capacidade = 50, tipo = 'carros' },
	{ hash = -2030171296, name = 'cognoscenti', price = 280000, banido = false, modelo = 'Cognoscenti', capacidade = 50, tipo = 'carros' },
	{ hash = -604842630, name = 'cognoscenti2', price = 400000, banido = false, modelo = 'Cognoscenti2', capacidade = 50, tipo = 'carros' },
	{ hash = -1477580979, name = 'stanier', price = 60000, banido = false, modelo = 'Stanier', capacidade = 60, tipo = 'carros' },
	{ hash = 1723137093, name = 'stratum', price = 90000, banido = false, modelo = 'Stratum', capacidade = 70, tipo = 'carros' },
	{ hash = 1123216662, name = 'superd', price = 200000, banido = false, modelo = 'Superd', capacidade = 50, tipo = 'work' },
	{ hash = -1894894188, name = 'surge', price = 110000, banido = false, modelo = 'Surge', capacidade = 60, tipo = 'carros' },
	{ hash = -1008861746, name = 'tailgater', price = 110000, banido = false, modelo = 'Tailgater', capacidade = 50, tipo = 'carros' },
	{ hash = 1373123368, name = 'warrener', price = 90000, banido = false, modelo = 'Warrener', capacidade = 40, tipo = 'carros' },
	{ hash = 1777363799, name = 'washington', price = 130000, banido = false, modelo = 'Washington', capacidade = 60, tipo = 'carros' },
	{ hash = 767087018, name = 'alpha', price = 230000, banido = false, modelo = 'Alpha', capacidade = 40, tipo = 'carros' },
	{ hash = -1041692462, name = 'banshee', price = 300000, banido = false, modelo = 'Banshee', capacidade = 30, tipo = 'carros' },
	{ hash = 1274868363, name = 'bestiagts', price = 290000, banido = false, modelo = 'Bestiagts', capacidade = 60, tipo = 'carros' },
	{ hash = 1039032026, name = 'blista2', price = 55000, banido = false, modelo = 'Blista2', capacidade = 40, tipo = 'carros' },
	{ hash = -591651781, name = 'blista3', price = 80000, banido = false, modelo = 'Blista3', capacidade = 40, tipo = 'carros' },
	{ hash = -304802106, name = 'buffalo', price = 300000, banido = false, modelo = 'Buffalo', capacidade = 50, tipo = 'carros' },
	{ hash = 736902334, name = 'buffalo2', price = 300000, banido = false, modelo = 'Buffalo2', capacidade = 50, tipo = 'carros' },
	{ hash = 237764926, name = 'buffalo3', price = 300000, banido = false, modelo = 'Buffalo2', capacidade = 50, tipo = 'carros' },
	{ hash = 2072687711, name = 'carbonizzare', price = 290000, banido = false, modelo = 'Carbonizzare', capacidade = 30, tipo = 'carros' },
	{ hash = -1045541610, name = 'comet2', price = 250000, banido = false, modelo = 'Comet2', capacidade = 40, tipo = 'carros' },
	{ hash = -2022483795, name = 'comet3', price = 290000, banido = false, modelo = 'Comet3', capacidade = 40, tipo = 'carros' },
	{ hash = 661493923, name = 'comet5', price = 300000, banido = false, modelo = 'Comet4', capacidade = 40, tipo = 'carros' },
	{ hash = 108773431, name = 'coquette', price = 250000, banido = false, modelo = 'Coquette', capacidade = 30, tipo = 'carros' },
	{ hash = 196747873, name = 'elegy', price = 350000, banido = false, modelo = 'Elegy', capacidade = 30, tipo = 'carros' },
	{ hash = -566387422, name = 'elegy2', price = 355000, banido = false, modelo = 'Elegy2', capacidade = 30, tipo = 'carros' },
	{ hash = -1995326987, name = 'feltzer2', price = 255000, banido = false, modelo = 'Feltzer2', capacidade = 40, tipo = 'carros' },
	{ hash = -1089039904, name = 'furoregt', price = 290000, banido = false, modelo = 'Furoregt', capacidade = 30, tipo = 'carros' },
	{ hash = 499169875, name = 'fusilade', price = 210000, banido = false, modelo = 'Fusilade', capacidade = 40, tipo = 'carros' },
    { hash = 2016857647, name = 'futo', price = 170000, banido = false, modelo = 'Futo', capacidade = 40, tipo = 'carros' },
	{ hash = -1297672541, name = 'jester', price = 150000, banido = false, modelo = 'Jester', capacidade = 30, tipo = 'carros' },
	{ hash = 544021352, name = 'khamelion', price = 210000, banido = false, modelo = 'Khamelion', capacidade = 50, tipo = 'carros' },
	{ hash = -1372848492, name = 'kuruma', price = 330000, banido = false, modelo = 'Kuruma', capacidade = 50, tipo = 'carros' },
	{ hash = -142942670, name = 'massacro', price = 330000, banido = false, modelo = 'Massacro', capacidade = 40, tipo = 'carros' },
	{ hash = -631760477, name = 'massacro2', price = 330000, banido = false, modelo = 'Massacro2', capacidade = 40, tipo = 'carros' },
	{ hash = 1032823388, name = 'ninef', price = 290000, banido = false, modelo = 'Ninef', capacidade = 40, tipo = 'carros' },
	{ hash = -1461482751, name = 'ninef2', price = 290000, banido = false, modelo = 'Ninef2', capacidade = 40, tipo = 'carros' },
	{ hash = -777172681, name = 'omnis', price = 240000, banido = false, modelo = 'Omnis', capacidade = 20, tipo = 'carros' },
	{ hash = 867799010, name = 'pariah', price = 500000, banido = false, modelo = 'Pariah', capacidade = 30, tipo = 'carros' },
	{ hash = -377465520, name = 'penumbra', price = 150000, banido = false, modelo = 'Penumbra', capacidade = 40, tipo = 'carros' },
	{ hash = -1529242755, name = 'raiden', price = 240000, banido = false, modelo = 'Raiden', capacidade = 50, tipo = 'carros' },
	{ hash = -1934452204, name = 'rapidgt', price = 250000, banido = false, modelo = 'Rapidgt', capacidade = 20, tipo = 'carros' },
	{ hash = 1737773231, name = 'rapidgt2', price = 300000, banido = false, modelo = 'Rapidgt2', capacidade = 20, tipo = 'carros' },
	{ hash = 719660200, name = 'ruston', price = 370000, banido = false, modelo = 'Ruston', capacidade = 20, tipo = 'carros' },
	{ hash = -1485523546, name = 'schafter3', price = 275000, banido = false, modelo = 'Schafter3', capacidade = 50, tipo = 'carros' },
	{ hash = 1489967196, name = 'schafter4', price = 160000, banido = false, modelo = 'Schafter4', capacidade = 40, tipo = 'carros' },
	{ hash = 1922255844, name = 'schafter6', price = 160000, banido = false, modelo = 'Schafter6', capacidade = 40, tipo = 'carros' },
	{ hash = -888242983, name = 'schafter5', price = 275000, banido = false, modelo = 'Schafter5', capacidade = 50, tipo = 'carros' },
	{ hash = -746882698, name = 'schwarzer', price = 170000, banido = false, modelo = 'Schwarzer', capacidade = 50, tipo = 'carros' },
	{ hash = 1104234922, name = 'sentinel3', price = 170000, banido = false, modelo = 'Sentinel3', capacidade = 30, tipo = 'carros' },
	{ hash = -1757836725, name = 'seven70', price = 370000, banido = false, modelo = 'Seven70', capacidade = 20, tipo = 'carros' },
	{ hash = 1886268224, name = 'specter', price = 320000, banido = false, modelo = 'Specter', capacidade = 20, tipo = 'carros' },
	{ hash = 1074745671, name = 'specter2', price = 355000, banido = false, modelo = 'Specter2', capacidade = 20, tipo = 'carros' },
	{ hash = 1741861769, name = 'streiter', price = 250000, banido = false, modelo = 'Streiter', capacidade = 70, tipo = 'carros' },
	{ hash = 970598228, name = 'sultan', price = 210000, banido = false, modelo = 'Sultan', capacidade = 50, tipo = 'carros' },
	{ hash = 384071873, name = 'surano', price = 310000, banido = false, modelo = 'Surano', capacidade = 30, tipo = 'carros' },
	{ hash = -1071380347, name = 'tampa2', price = 200000, banido = false, modelo = 'Tampa2', capacidade = 20, tipo = 'carros' },
	{ hash = 1887331236, name = 'tropos', price = 170000, banido = false, modelo = 'Tropos', capacidade = 20, tipo = 'carros' },
	{ hash = 1102544804, name = 'verlierer2', price = 380000, banido = false, modelo = 'Verlierer2', capacidade = 20, tipo = 'carros' },
	{ hash = 117401876, name = 'btype', price = 200000, banido = false, modelo = 'Btype', capacidade = 40, tipo = 'work' },
	{ hash = -831834716, name = 'btype2', price = 460000, banido = false, modelo = 'Btype2', capacidade = 20, tipo = 'carros' },
	{ hash = -602287871, name = 'btype3', price = 390000, banido = false, modelo = 'Btype3', capacidade = 40, tipo = 'carros' },
	{ hash = 941800958, name = 'casco', price = 355000, banido = false, modelo = 'Casco', capacidade = 50, tipo = 'carros' },
	{ hash = -1311154784, name = 'cheetah', price = 425000, banido = false, modelo = 'Cheetah', capacidade = 20, tipo = 'carros' },
	{ hash = 1011753235, name = 'coquette2', price = 285000, banido = false, modelo = 'Coquette2', capacidade = 40, tipo = 'carros' },
	{ hash = -1566741232, name = 'feltzer3', price = 220000, banido = false, modelo = 'Feltzer3', capacidade = 40, tipo = 'carros' },
	{ hash = -2079788230, name = 'gt500', price = 250000, banido = false, modelo = 'Gt500', capacidade = 40, tipo = 'carros' },
	{ hash = -1405937764, name = 'infernus2', price = 250000, banido = false, modelo = 'Infernus2', capacidade = 20, tipo = 'carros' },
	{ hash = 1051415893, name = 'jb700', price = 220000, banido = false, modelo = 'Jb700', capacidade = 30, tipo = 'carros' },
	{ hash = -1660945322, name = 'mamba', price = 300000, banido = false, modelo = 'Mamba', capacidade = 50, tipo = 'carros' },
	{ hash = -2124201592, name = 'manana', price = 130000, banido = false, modelo = 'Manana', capacidade = 60, tipo = 'carros' },
	{ hash = -433375717, name = 'monroe', price = 260000, banido = false, modelo = 'Monroe', capacidade = 20, tipo = 'carros' },
	{ hash = 1830407356, name = 'peyote', price = 150000, banido = false, modelo = 'Peyote', capacidade = 50, tipo = 'carros' },
	{ hash = 1078682497, name = 'pigalle', price = 250000, banido = false, modelo = 'Pigalle', capacidade = 60, tipo = 'carros' },
	{ hash = 2049897956, name = 'rapidgt3', price = 220000, banido = false, modelo = 'Rapidgt3', capacidade = 40, tipo = 'carros' },
	{ hash = 1841130506, name = 'retinue', price = 150000, banido = false, modelo = 'Retinue', capacidade = 40, tipo = 'carros' },
	{ hash = 1545842587, name = 'stinger', price = 220000, banido = false, modelo = 'Stinger', capacidade = 20, tipo = 'carros' },
	{ hash = -2098947590, name = 'stingergt', price = 230000, banido = false, modelo = 'Stingergt', capacidade = 20, tipo = 'carros' },
	{ hash = 1504306544, name = 'torero', price = 160000, banido = false, modelo = 'Torero', capacidade = 30, tipo = 'carros' },
	{ hash = 464687292, name = 'tornado', price = 150000, banido = false, modelo = 'Tornado', capacidade = 70, tipo = 'carros' },
	{ hash = 1531094468, name = 'tornado2', price = 160000, banido = false, modelo = 'Tornado2', capacidade = 60, tipo = 'carros' },
	{ hash = -1797613329, name = 'tornado5', price = 200000, banido = false, modelo = 'Tornado5', capacidade = 60, tipo = 'work' },
	{ hash = -1558399629, name = 'tornado6', price = 250000, banido = false, modelo = 'Tornado6', capacidade = 50, tipo = 'carros' },
	{ hash = -982130927, name = 'turismo2', price = 250000, banido = false, modelo = 'Turismo2', capacidade = 30, tipo = 'carros' },
	{ hash = 758895617, name = 'ztype', price = 400000, banido = false, modelo = 'Ztype', capacidade = 20, tipo = 'carros' },
	{ hash = -1216765807, name = 'adder', price = 560000, banido = false, modelo = 'Adder', capacidade = 20, tipo = 'carros' },
	{ hash = -313185164, name = 'autarch', price = 760000, banido = false, modelo = 'Autarch', capacidade = 20, tipo = 'carros' },
	{ hash = 633712403, name = 'banshee2', price = 370000, banido = false, modelo = 'Banshee2', capacidade = 20, tipo = 'carros' },
	{ hash = -1696146015, name = 'bullet', price = 400000, banido = false, modelo = 'Bullet', capacidade = 20, tipo = 'carros' },
	{ hash = 223240013, name = 'cheetah2', price = 240000, banido = false, modelo = 'Cheetah2', capacidade = 20, tipo = 'carros' },
	{ hash = -1291952903, name = 'entityxf', price = 460000, banido = false, modelo = 'Entityxf', capacidade = 20, tipo = 'carros' },
	{ hash = 1426219628, name = 'fmj', price = 610000, banido = false, modelo = 'Fmj', capacidade = 20, tipo = 'carros' },
	{ hash = 1234311532, name = 'gp1', price = 495000, banido = false, modelo = 'Gp1', capacidade = 20, tipo = 'carros' },
	{ hash = 418536135, name = 'infernus', price = 470000, banido = false, modelo = 'Infernus', capacidade = 20, tipo = 'carros' },
	{ hash = 1034187331, name = 'nero', price = 450000, banido = false, modelo = 'Nero', capacidade = 20, tipo = 'carros' },
	{ hash = 1093792632, name = 'nero2', price = 480000, banido = false, modelo = 'Nero2', capacidade = 20, tipo = 'carros' },
	{ hash = 1987142870, name = 'osiris', price = 1400000, banido = false, modelo = 'Osiris', capacidade = 20, tipo = 'carros' },
	{ hash = -1758137366, name = 'penetrator', price = 480000, banido = false, modelo = 'Penetrator', capacidade = 20, tipo = 'carros' },
	{ hash = -1829802492, name = 'pfister811', price = 530000, banido = false, modelo = 'Pfister811', capacidade = 20, tipo = 'carros' },
	{ hash = 234062309, name = 'reaper', price = 620000, banido = false, modelo = 'Reaper', capacidade = 20, tipo = 'carros' },
	{ hash = 1352136073, name = 'sc1', price = 495000, banido = false, modelo = 'Sc1', capacidade = 20, tipo = 'carros' },
	{ hash = -295689028, name = 'sultanrs', price = 450000, banido = false, modelo = 'Sultan RS', capacidade = 30, tipo = 'carros' },
	{ hash = 1663218586, name = 't20', price = 1200000, banido = false, modelo = 'T20', capacidade = 20, tipo = 'carros' },
	{ hash = 272929391, name = 'tempesta', price = 600000, banido = false, modelo = 'Tempesta', capacidade = 20, tipo = 'carros' },
	{ hash = 408192225, name = 'turismor', price = 620000, banido = false, modelo = 'Turismor', capacidade = 20, tipo = 'carros' },
	{ hash = 2067820283, name = 'tyrus', price = 620000, banido = false, modelo = 'Tyrus', capacidade = 20, tipo = 'carros' },
	{ hash = 338562499, name = 'vacca', price = 620000, banido = false, modelo = 'Vacca', capacidade = 30, tipo = 'carros' },
	{ hash = -998177792, name = 'visione', price = 690000, banido = false, modelo = 'Visione', capacidade = 20, tipo = 'carros' },
	{ hash = -1622444098, name = 'voltic', price = 440000, banido = false, modelo = 'Voltic', capacidade = 20, tipo = 'carros' },
	{ hash = -1403128555, name = 'zentorno', price = 920000, banido = false, modelo = 'Zentorno', capacidade = 20, tipo = 'carros' },
	{ hash = -599568815, name = 'sadler', price = 180000, banido = false, modelo = 'Sadler', capacidade = 70, tipo = 'carros' },
	{ hash = -16948145, name = 'bison', price = 220000, banido = false, modelo = 'Bison', capacidade = 70, tipo = 'carros' },
	{ hash = 2072156101, name = 'bison2', price = 180000, banido = false, modelo = 'Bison2', capacidade = 70, tipo = 'carros' },
	{ hash = 1069929536, name = 'bobcatxl', price = 260000, banido = false, modelo = 'Bobcatxl', capacidade = 100, tipo = 'carros' },
	{ hash = -1346687836, name = 'burrito', price = 260000, banido = false, modelo = 'Burrito', capacidade = 120, tipo = 'carros' },
	{ hash = -907477130, name = 'burrito2', price = 260000, banido = false, modelo = 'Burrito2', capacidade = 120, tipo = 'carros' },
	{ hash = -1743316013, name = 'burrito3', price = 260000, banido = false, modelo = 'Burrito3', capacidade = 120, tipo = 'carros' },
	{ hash = 893081117, name = 'burrito4', price = 260000, banido = false, modelo = 'Burrito4', capacidade = 120, tipo = 'carros' },
	{ hash = -310465116, name = 'minivan', price = 110000, banido = false, modelo = 'Minivan', capacidade = 70, tipo = 'carros' },
	{ hash = -1126264336, name = 'minivan2', price = 220000, banido = false, modelo = 'Minivan2', capacidade = 60, tipo = 'carros' },
	{ hash = 1488164764, name = 'paradise', price = 260000, banido = false, modelo = 'Paradise', capacidade = 120, tipo = 'carros' },
	{ hash = -119658072, name = 'pony', price = 260000, banido = false, modelo = 'Pony', capacidade = 120, tipo = 'carros' },
	{ hash = 943752001, name = 'pony2', price = 260000, banido = false, modelo = 'Pony2', capacidade = 120, tipo = 'carros' },
	{ hash = 1162065741, name = 'rumpo', price = 260000, banido = false, modelo = 'Rumpo', capacidade = 120, tipo = 'carros' },
	{ hash = -1776615689, name = 'rumpo2', price = 260000, banido = false, modelo = 'Rumpo2', capacidade = 120, tipo = 'carros' },
	{ hash = 1475773103, name = 'rumpo3', price = 350000, banido = false, modelo = 'Rumpo3', capacidade = 120, tipo = 'carros' },
	{ hash = -810318068, name = 'speedo', price = 200000, banido = false, modelo = 'Speedo', capacidade = 120, tipo = 'work' },
	{ hash = 699456151, name = 'surfer', price = 180000, banido = false, modelo = 'Surfer', capacidade = 80, tipo = 'carros' },
	{ hash = 65402552, name = 'youga', price = 260000, banido = false, modelo = 'Youga', capacidade = 120, tipo = 'carros' },
	{ hash = 1026149675, name = 'youga2', price = 1000, banido = false, modelo = 'Youga2', capacidade = 80, tipo = 'work' },
	{ hash = -1207771834, name = 'rebel', price = 1000, banido = false, modelo = 'Rebel', capacidade = 80, tipo = 'work' },
	{ hash = -2076478498, name = 'tractor2', price = 1000, banido = false, modelo = 'Tractor2', capacidade = 80, tipo = 'work' },
	{ hash = 486987393, name = 'huntley', price = 200000, banido = false, modelo = 'Huntley', capacidade = 60, tipo = 'carros' },
	{ hash = 1269098716, name = 'landstalker', price = 130000, banido = false, modelo = 'Landstalker', capacidade = 70, tipo = 'carros' },
	{ hash = 914654722, name = 'mesa', price = 90000, banido = false, modelo = 'Mesa', capacidade = 50, tipo = 'carros' },
	{ hash = -808457413, name = 'patriot', price = 250000, banido = false, modelo = 'Patriot', capacidade = 70, tipo = 'carros' },
	{ hash = -1651067813, name = 'radi', price = 110000, banido = false, modelo = 'Radi', capacidade = 50, tipo = 'carros' },
	{ hash = 2136773105, name = 'rocoto', price = 110000, banido = false, modelo = 'Rocoto', capacidade = 60, tipo = 'carros' },
	{ hash = -376434238, name = 'tyrant', price = 690000, banido = false, modelo = 'Tyrant', capacidade = 30, tipo = 'carros' },
	{ hash = -2120700196, name = 'entity2', price = 850000, banido = false, modelo = 'Entity2', capacidade = 20, tipo = 'carros' },
	{ hash = -988501280, name = 'cheburek', price = 170000, banido = false, modelo = 'Cheburek', capacidade = 50, tipo = 'carros' },
	{ hash = 1115909093, name = 'hotring', price = 300000, banido = false, modelo = 'Hotring', capacidade = 60, tipo = 'carros' },
	{ hash = -214906006, name = 'jester3', price = 345000, banido = false, modelo = 'Jester3', capacidade = 30, tipo = 'carros' },
	{ hash = -1259134696, name = 'flashgt', price = 370000, banido = false, modelo = 'Flashgt', capacidade = 30, tipo = 'carros' },
	{ hash = -1267543371, name = 'ellie', price = 320000, banido = false, modelo = 'Ellie', capacidade = 50, tipo = 'carros' },
	{ hash = 1046206681, name = 'michelli', price = 160000, banido = false, modelo = 'Michelli', capacidade = 40, tipo = 'carros' },
	{ hash = 1617472902, name = 'fagaloa', price = 320000, banido = false, modelo = 'Fagaloa', capacidade = 80, tipo = 'carros' },
	{ hash = -915704871, name = 'dominator2', price = 230000, banido = false, modelo = 'Dominator2', capacidade = 50, tipo = 'carros' },
	{ hash = -986944621, name = 'dominator3', price = 370000, banido = false, modelo = 'Dominator3', capacidade = 30, tipo = 'carros' },
	{ hash = 931280609, name = 'issi3', price = 190000, banido = false, modelo = 'Issi3', capacidade = 20, tipo = 'carros' },
	{ hash = -1134706562, name = 'taipan', price = 620000, banido = false, modelo = 'Taipan', capacidade = 20, tipo = 'carros' },
	{ hash = 1909189272, name = 'gb200', price = 195000, banido = false, modelo = 'Gb200', capacidade = 20, tipo = 'carros' },
	{ hash = -1961627517, name = 'stretch', price = 600000, banido = false, modelo = 'Stretch', capacidade = 60, tipo = 'carros' },
	{ hash = -2107990196, name = 'guardian', price = 540000, banido = false, modelo = 'Guardian', capacidade = 150, tipo = 'carros' },
	{ hash = -121446169, name = 'kamacho', price = 460000, banido = false, modelo = 'Kamacho', capacidade = 90, tipo = 'carros' },
	{ hash = -1848994066, name = 'neon', price = 370000, banido = false, modelo = 'Neon', capacidade = 30, tipo = 'carros' },
	{ hash = 1392481335, name = 'cyclone', price = 920000, banido = false, modelo = 'Cyclone', capacidade = 20, tipo = 'carros' },
	{ hash = -2048333973, name = 'italigtb', price = 600000, banido = false, modelo = 'Italigtb', capacidade = 20, tipo = 'carros' },
	{ hash = -482719877, name = 'italigtb2', price = 610000, banido = false, modelo = 'Italigtb2', capacidade = 20, tipo = 'carros' },
	{ hash = 1939284556, name = 'vagner', price = 680000, banido = false, modelo = 'Vagner', capacidade = 20, tipo = 'carros' },
	{ hash = 917809321, name = 'xa21', price = 630000, banido = false, modelo = 'Xa21', capacidade = 20, tipo = 'carros' },
	{ hash = 1031562256, name = 'tezeract', price = 1000000, banido = false, modelo = 'Tezeract', capacidade = 20, tipo = 'carros' },
	{ hash = 2123327359, name = 'prototipo', price = 1500000, banido = false, modelo = 'Prototipo', capacidade = 20, tipo = 'carros' },
	{ hash = -420911112, name = 'patriot2', price = 550000, banido = false, modelo = 'Patriot2', capacidade = 60, tipo = 'carros' },
	{ hash = 321186144, name = 'stafford', price = 300000, banido = false, modelo = 'Stafford', capacidade = 40, tipo = 'work' },
	{ hash = 500482303, name = 'swinger', price = 250000, banido = false, modelo = 'Swinger', capacidade = 20, tipo = 'carros' },
	{ hash = -1566607184, name = 'clique', price = 360000, banido = false, modelo = 'Clique', capacidade = 40, tipo = 'carros' },
	{ hash = 1591739866, name = 'deveste', price = 900000, banido = false, modelo = 'Deveste', capacidade = 20, tipo = 'carros' },
	{ hash = 1279262537, name = 'deviant', price = 370000, banido = false, modelo = 'Deviant', capacidade = 50, tipo = 'carros' },
	{ hash = -2096690334, name = 'impaler', price = 320000, banido = false, modelo = 'Impaler', capacidade = 60, tipo = 'carros' },
	{ hash = -331467772, name = 'italigto', price = 800000, banido = false, modelo = 'Italigto', capacidade = 30, tipo = 'carros' },
	{ hash = -507495760, name = 'schlagen', price = 690000, banido = false, modelo = 'Schlagen', capacidade = 30, tipo = 'carros' },
	{ hash = -1168952148, name = 'toros', price = 520000, banido = false, modelo = 'Toros', capacidade = 50, tipo = 'carros' },
	{ hash = 1456744817, name = 'tulip', price = 320000, banido = false, modelo = 'Tulip', capacidade = 60, tipo = 'carros' },
	{ hash = -49115651, name = 'vamos', price = 320000, banido = false, modelo = 'Vamos', capacidade = 60, tipo = 'carros' },
	{ hash = -54332285, name = 'freecrawler', price = 350000, banido = false, modelo = 'Freecrawler', capacidade = 50, tipo = 'carros' },
	{ hash = 1909141499, name = 'fugitive', price = 120000, banido = false, modelo = 'Fugitive', capacidade = 50, tipo = 'carros' },
	{ hash = -1232836011, name = 'le7b', price = 700000, banido = false, modelo = 'Le7b', capacidade = 20, tipo = 'carros' },
	{ hash = 2068293287, name = 'lurcher', price = 150000, banido = false, modelo = 'Lurcher', capacidade = 60, tipo = 'carros' },
	{ hash = 482197771, name = 'lynx', price = 370000, banido = false, modelo = 'Lynx', capacidade = 30, tipo = 'carros' },
	{ hash = -674927303, name = 'raptor', price = 300000, banido = false, modelo = 'Raptor', capacidade = 20, tipo = 'carros' },
	{ hash = 819197656, name = 'sheava', price = 700000, banido = false, modelo = 'Sheava', capacidade = 20, tipo = 'carros' },
	{ hash = 838982985, name = 'z190', price = 350000, banido = false, modelo = 'Z190', capacidade = 40, tipo = 'carros' },
	{ hash = 1672195559, name = 'akuma', price = 500000, banido = false, modelo = 'Akuma', capacidade = 15, tipo = 'motos' },
	{ hash = -2115793025, name = 'avarus', price = 440000, banido = false, modelo = 'Avarus', capacidade = 15, tipo = 'motos' },
	{ hash = -2115793025, name = 'bros', price = 40000, banido = false, modelo = 'BROS 160', capacidade = 15, tipo = 'motos' }, 
	{ hash = -2115793025, name = 'xj6', price = 440000, banido = false, modelo = 'XJ6 RENATOG.', capacidade = 15, tipo = 'motos' }, 
	{ hash = -2115793025, name = 'hornet', price = 90000, banido = false, modelo = 'HORNET', capacidade = 15, tipo = 'motos' }, 
	{ hash = -2140431165, name = 'bagger', price = 300000, banido = false, modelo = 'Bagger', capacidade = 40, tipo = 'motos' },
	{ hash = -114291515, name = 'bati', price = 370000, banido = false, modelo = 'Bati', capacidade = 15, tipo = 'motos' },
	{ hash = -891462355, name = 'bati2', price = 300000, banido = false, modelo = 'Bati2', capacidade = 15, tipo = 'motos' },
	{ hash = 86520421, name = 'bf400', price = 320000, banido = false, modelo = 'Bf400', capacidade = 15, tipo = 'motos' },
	{ hash = 11251904, name = 'carbonrs', price = 370000, banido = false, modelo = 'Carbonrs', capacidade = 15, tipo = 'motos' },
	{ hash = 6774487, name = 'chimera', price = 345000, banido = false, modelo = 'Chimera', capacidade = 15, tipo = 'motos' },
	{ hash = 390201602, name = 'cliffhanger', price = 310000, banido = false, modelo = 'Cliffhanger', capacidade = 15, tipo = 'motos' },
	{ hash = 2006142190, name = 'daemon', price = 200000, banido = false, modelo = 'Daemon', capacidade = 15, tipo = 'work' },
	{ hash = -1404136503, name = 'daemon2', price = 240000, banido = false, modelo = 'Daemon2', capacidade = 15, tipo = 'motos' },
	{ hash = 822018448, name = 'defiler', price = 460000, banido = false, modelo = 'Defiler', capacidade = 15, tipo = 'motos' },
    { hash = -239841468, name = 'diablous', price = 430000, banido = false, modelo = 'Diablous', capacidade = 15, tipo = 'motos' },
	{ hash = -1987109409, name = '150', price = 400000, banido = false, modelo = 'CG 150', capacidade = 15, tipo = 'motos' }, 
	{ hash = 1790834270, name = 'diablous2', price = 460000, banido = false, modelo = 'Diablous2', capacidade = 15, tipo = 'motos' },
	{ hash = -1670998136, name = 'double', price = 370000, banido = false, modelo = 'Double', capacidade = 15, tipo = 'motos' },
	{ hash = 1753414259, name = 'enduro', price = 195000, banido = false, modelo = 'Enduro', capacidade = 15, tipo = 'motos' },
	{ hash = 2035069708, name = 'esskey', price = 320000, banido = false, modelo = 'Esskey', capacidade = 15, tipo = 'motos' },
	{ hash = -1842748181, name = 'faggio', price = 20000, banido = false, modelo = 'Faggio', capacidade = 30, tipo = 'motos' },
	{ hash = 55628203, name = 'faggio2', price = 5000, banido = false, modelo = 'Faggio2', capacidade = 30, tipo = 'motos' },
	{ hash = -1289178744, name = 'faggio3', price = 5000, banido = false, modelo = 'Faggio3', capacidade = 30, tipo = 'motos' },
	{ hash = 627535535, name = 'fcr', price = 390000, banido = false, modelo = 'Fcr', capacidade = 15, tipo = 'motos' },
	{ hash = -757735410, name = 'fcr2', price = 390000, banido = false, modelo = 'Fcr2', capacidade = 15, tipo = 'motos' },
	{ hash = 741090084, name = 'gargoyle', price = 345000, banido = false, modelo = 'Gargoyle', capacidade = 15, tipo = 'motos' },
	{ hash = 1265391242, name = 'hakuchou', price = 380000, banido = false, modelo = 'Hakuchou', capacidade = 15, tipo = 'motos' },
	{ hash = 1265391242, name = 'falcon', price = 100000, banido = false, modelo = 'Falcon', capacidade = 15, tipo = 'motos' }, 
	{ hash = -255678177, name = 'hakuchou2', price = 550000, banido = false, modelo = 'Hakuchou2', capacidade = 15, tipo = 'motos' },
	{ hash = 301427732, name = 'hexer', price = 250000, banido = false, modelo = 'Hexer', capacidade = 15, tipo = 'motos' },
	{ hash = -159126838, name = 'innovation', price = 250000, banido = false, modelo = 'Innovation', capacidade = 15, tipo = 'motos' },
	{ hash = 640818791, name = 'lectro', price = 380000, banido = false, modelo = 'Lectro', capacidade = 15, tipo = 'motos' },
	{ hash = -1523428744, name = 'manchez', price = 355000, banido = false, modelo = 'Manchez', capacidade = 15, tipo = 'motos' },
	{ hash = -634879114, name = 'nemesis', price = 345000, banido = false, modelo = 'Nemesis', capacidade = 15, tipo = 'motos' },
	{ hash = -1606187161, name = 'nightblade', price = 415000, banido = false, modelo = 'Nightblade', capacidade = 15, tipo = 'motos' },
	{ hash = -909201658, name = 'pcj', price = 230000, banido = false, modelo = 'Pcj', capacidade = 15, tipo = 'motos' },
	{ hash = -893578776, name = 'ruffian', price = 345000, banido = false, modelo = 'Ruffian', capacidade = 15, tipo = 'motos' },
	{ hash = 788045382, name = 'sanchez', price = 185000, banido = false, modelo = 'Sanchez', capacidade = 15, tipo = 'motos' },
	{ hash = -1453280962, name = 'sanchez2', price = 185000, banido = false, modelo = 'Sanchez2', capacidade = 15, tipo = 'motos' },
	{ hash = -1453280962, name = '25anos', price = 550000, banido = false, modelo = 'Titan 160', capacidade = 15, tipo = 'motos' }, 
	{ hash = 1491277511, name = 'sanctus', price = 200000, banido = false, modelo = 'Sanctus', capacidade = 15, tipo = 'work' },
	{ hash = 743478836, name = 'sovereign', price = 285000, banido = false, modelo = 'Sovereign', capacidade = 50, tipo = 'motos' },
	{ hash = 1836027715, name = 'thrust', price = 375000, banido = false, modelo = 'Thrust', capacidade = 15, tipo = 'motos' },
	{ hash = -140902153, name = 'vader', price = 345000, banido = false, modelo = 'Vader', capacidade = 15, tipo = 'motos' },
	{ hash = -1353081087, name = 'vindicator', price = 340000, banido = false, modelo = 'Vindicator', capacidade = 15, tipo = 'motos' },
	{ hash = -609625092, name = 'vortex', price = 375000, banido = false, modelo = 'Vortex', capacidade = 15, tipo = 'motos' },
	{ hash = -618617997, name = 'wolfsbane', price = 290000, banido = false, modelo = 'Wolfsbane', capacidade = 15, tipo = 'motos' },
	{ hash = -1009268949, name = 'zombiea', price = 290000, banido = false, modelo = 'Zombiea', capacidade = 15, tipo = 'motos' },
	{ hash = -570033273, name = 'zombieb', price = 300000, banido = false, modelo = 'Zombieb', capacidade = 15, tipo = 'motos' },
	{ hash = -2128233223, name = 'blazer', price = 230000, banido = true, modelo = 'Blazer', capacidade = 15, tipo = 'motos' },
	{ hash = -440768424, name = 'blazer4', price = 370000, banido = true, modelo = 'Blazer4', capacidade = 15, tipo = 'motos' },
	{ hash = -405626514, name = 'shotaro', price = 500000, banido = false, modelo = 'Shotaro', capacidade = 15, tipo = 'motos' },
	{ hash = 1873600305, name = 'ratbike', price = 230000, banido = false, modelo = 'Ratbike', capacidade = 15, tipo = 'motos' },
	{ hash = 1743739647, name = 'policiacharger2018', price = 1000, banido = true, modelo = 'Dodge Charger 2018', capacidade = 0, tipo = 'work' },
	{ hash = 796154746, name = 'policiamustanggt', price = 1000, banido = true, modelo = 'Mustang GT', capacidade = 0, tipo = 'work' },
	{ hash = 81717913, name = 'policiacapricesid', price = 1000, banido = true, modelo = 'GM Caprice SID', capacidade = 0, tipo = 'work' },
	{ hash = 589099944, name = 'policiaschaftersid', price = 1000, banido = true, modelo = 'GM Schafter SID', capacidade = 0, tipo = 'work' },
	{ hash = 1884511084, name = 'policiasilverado', price = 1000, banido = true, modelo = 'Chevrolet Silverado', capacidade = 0, tipo = 'work' },
	{ hash = 1865641415, name = 'policiatahoe', price = 1000, banido = true, modelo = 'Chevrolet Tahoe', capacidade = 0, tipo = 'work' },
	{ hash = -377693317, name = 'policiaexplorer', price = 1000, banido = true, modelo = 'Ford Explorer', capacidade = 0, tipo = 'work' },
	{ hash = 2059081152, name = 'polraptor', price = 1, banido = true, modelo = 'Viatura', capacidade = 120, tipo = 'work' },
	{ hash = 7622941175, name = 'VRa3', price = 1, banido = true, modelo = 'Viatura', capacidade = 60, tipo = 'work' },
	{ hash = -2128390391, name = 'VRa4', price = 1, banido = true, modelo = 'Viatura', capacidade = 60, tipo = 'work' },
	{ hash = -673061815, name = 'VRdm1200', price = 1, banido = true, modelo = 'Viatura', capacidade = 60, tipo = 'work' },
	{ hash = -1509752196, name = 'VRrs5', price = 1, banido = true, modelo = 'Viatura', capacidade = 60, tipo = 'work' },
	{ hash = 364700142, name = 'VRrs6', price = 1, banido = true, modelo = 'Viatura', capacidade = 60, tipo = 'work' },
	{ hash = -722708199, name = 'VRrs6av', price = 1, banido = true, modelo = 'Viatura', capacidade = 60, tipo = 'work' },
	{ hash = 431385387, name = 'WRclassxv2', price = 1, banido = true, modelo = 'Viatura', capacidade = 120, tipo = 'work' },
	{ hash = -1799742390, name = 'r820p', price = 1, banido = true, modelo = 'Viatura', capacidade = 30, tipo = 'work' },
	{ hash = 1775498021, name = 'WRr1200', price = 1, banido = true, modelo = 'WRr1200', capacidade = 20, tipo = 'work' },
	{ hash = 112218935, name = 'policiataurus', price = 1000, banido = true, modelo = 'Ford Taurus', capacidade = 0, tipo = 'work' },
	{ hash = 1611501436, name = 'policiavictoria', price = 1000, banido = true, modelo = 'Ford Victoria', capacidade = 0, tipo = 'work' },
	{ hash = -1624991916, name = 'policiabmwr1200', price = 1000, banido = true, modelo = 'BMW R1200', capacidade = 0, tipo = 'work' },
	{ hash = -875050963, name = 'policiaheli', price = 1000, banido = true, modelo = 'Policia Helicóptero', capacidade = 0, tipo = 'work' },
	{ hash = -137337379, name = 'amarokpolicia', price = 1000, banido = true, modelo = 'Amarok NOOSE', capacidade = 0, tipo = 'work' },
	{ hash =  1743739647, name = 'policiacharger2018', price = 1000, banido = true, modelo = 'Dodge Charger', capacidade = 0, tipo = 'work' },
	{ hash =  -1683453063, name = 'sahpexplorer2', price = 1000, banido = true, modelo = 'Paramédico', capacidade = 0, tipo = 'work' },
	{ hash =  -404584118, name = 'policiabmwr1200l', price = 1000, banido = true, modelo = 'Moto Médica', capacidade = 0, tipo = 'work' },
	{ hash = -1647941228, name = 'fbi2', price = 1000, banido = true, modelo = 'Granger SOG', capacidade = 0, tipo = 'work' },
	{ hash = -34623805, name = 'policeb', price = 1000, banido = true, modelo = 'Harley Davidson', capacidade = 0, tipo = 'work' },
	{ hash = -792745162, name = 'paramedicoambu', price = 1000, banido = true, modelo = 'Ambulância', capacidade = 0, tipo = 'work' },
	{ hash = 108063727, name = 'paramedicocharger2014', price = 1000, banido = true, modelo = 'Dodge Charger 2014', capacidade = 0, tipo = 'work' },
	{ hash = 2020690903, name = 'paramedicoheli', price = 1000, banido = true, modelo = 'Paramédico Helicóptero', capacidade = 0, tipo = 'work' },
	{ hash = -2007026063, name = 'pbus', price = 1000, banido = true, modelo = 'PBus', capacidade = 0, tipo = 'work' },
	{ hash = -2052737935, name = 'mule3', price = 260000, banido = false, modelo = 'Burrito3', capacidade = 400, tipo = 'carros' },
	{ hash = 1945374990, name = 'mule4', price = 260000, banido = false, modelo = 'Burrito4', capacidade = 400, tipo = 'carros' },
	{ hash = -2103821244, name = 'rallytruck', price = 260000, banido = false, modelo = 'Burrito4', capacidade = 400, tipo = 'carros' },
	{ hash = -1205689942, name = 'riot', price = 1000, banido = true, modelo = 'Blindado', capacidade = 0, tipo = 'work' },
	{ hash = -2072933068, name = 'coach', price = 1000, banido = true, modelo = 'Coach', capacidade = 0, tipo = 'work' },
	{ hash = -713569950, name = 'bus', price = 1000, banido = true, modelo = 'Ônibus', capacidade = 0, tipo = 'work' },
	{ hash = 1353720154, name = 'flatbed', price = 1000, banido = true, modelo = 'Reboque', capacidade = 0, tipo = 'work' },
	{ hash = -1323100960, name = 'towtruck', price = 1000, banido = true, modelo = 'Towtruck', capacidade = 0, tipo = 'work' },
	{ hash = -442313018, name = 'towtruck2', price = 1000, banido = true, modelo = 'Towtruck2', capacidade = 0, tipo = 'work' },
	{ hash = -667151410, name = 'ratloader', price = 1000, banido = true, modelo = 'Caminhão', capacidade = 80, tipo = 'work' },
	{ hash = -589178377, name = 'ratloader2', price = 1000, banido = false, modelo = 'Ratloader2', capacidade = 70, tipo = 'work' },
	{ hash = -1705304628, name = 'rubble', price = 1000, banido = true, modelo = 'Caminhão', capacidade = 0, tipo = 'work' },
	{ hash = -956048545, name = 'taxi', price = 1000, banido = true, modelo = 'Taxi', capacidade = 0, tipo = 'work' },
	{ hash = 444171386, name = 'boxville4', price = 1000, banido = false, modelo = 'Caminhão', capacidade = 70, tipo = 'work' },
	{ hash = 1917016601, name = 'trash', price = 1000, banido = false, modelo = 'Caminhão', capacidade = 80, tipo = 'work' },
	{ hash = 48339065, name = 'tiptruck', price = 1000, banido = false, modelo = 'Tiptruck', capacidade = 70, tipo = 'work' },
	{ hash = -186537451, name = 'scorcher', price = 1000, banido = true, modelo = 'Scorcher', capacidade = 0, tipo = 'work' },
	{ hash = 1127861609, name = 'tribike', price = 1000, banido = true, modelo = 'Tribike', capacidade = 0, tipo = 'work' },
	{ hash = -1233807380, name = 'tribike2', price = 1000, banido = true, modelo = 'Tribike2', capacidade = 0, tipo = 'work' },
	{ hash = -400295096, name = 'tribike3', price = 1000, banido = true, modelo = 'Tribike3', capacidade = 0, tipo = 'work' },
	{ hash = -836512833, name = 'fixter', price = 1000, banido = true, modelo = 'Fixter', capacidade = 0, tipo = 'work' },
	{ hash = 448402357, name = 'cruiser', price = 1000, banido = true, modelo = 'Cruiser', capacidade = 0, tipo = 'work' },
	{ hash = 1131912276, name = 'bmx', price = 1000, banido = true, modelo = 'Bmx', capacidade = 0, tipo = 'work' },
	{ hash = 1033245328, name = 'dinghy', price = 1000, banido = true, modelo = 'Dinghy', capacidade = 0, tipo = 'work' },
	{ hash = 861409633, name = 'jetmax', price = 1000, banido = true, modelo = 'Jetmax', capacidade = 0, tipo = 'work' },
	{ hash = -1043459709, name = 'marquis', price = 1000, banido = true, modelo = 'Marquis', capacidade = 0, tipo = 'work' },
	{ hash = -311022263, name = 'seashark3', price = 1000, banido = true, modelo = 'Seashark3', capacidade = 0, tipo = 'work' },
	{ hash = 231083307, name = 'speeder', price = 1000, banido = true, modelo = 'Speeder', capacidade = 0, tipo = 'work' },
	{ hash = 437538602, name = 'speeder2', price = 1000, banido = true, modelo = 'Speeder2', capacidade = 0, tipo = 'work' },
	{ hash = 400514754, name = 'squalo', price = 1000, banido = true, modelo = 'Squalo', capacidade = 0, tipo = 'work' },
	{ hash = -282946103, name = 'suntrap', price = 1000, banido = true, modelo = 'Suntrap', capacidade = 0, tipo = 'work' },
	{ hash = 1070967343, name = 'toro', price = 1000, banido = true, modelo = 'Toro', capacidade = 0, tipo = 'work' },
	{ hash = 908897389, name = 'toro2', price = 1000, banido = true, modelo = 'Toro2', capacidade = 0, tipo = 'work' },
	{ hash = 290013743, name = 'tropic', price = 1000, banido = true, modelo = 'Tropic', capacidade = 0, tipo = 'work' },
	{ hash = 1448677353, name = 'tropic2', price = 1000, banido = true, modelo = 'Tropic2', capacidade = 0, tipo = 'work' },
	{ hash = -2137348917, name = 'phantom', price = 1000, banido = true, modelo = 'Phantom', capacidade = 0, tipo = 'work' },
	{ hash = 569305213, name = 'packer', price = 1000, banido = true, modelo = 'Packer', capacidade = 0, tipo = 'work' },
	{ hash = 710198397, name = 'supervolito', price = 1000, banido = true, modelo = 'Supervolito', capacidade = 0, tipo = 'work' },
	{ hash = -1671539132, name = 'supervolito2', price = 1000, banido = true, modelo = 'Supervolito2', capacidade = 0, tipo = 'work' },
	{ hash = -726768679, name = 'seasparrow', price = 1000, banido = true, modelo = 'Paramédico Helicóptero Água', capacidade = 0, tipo = 'work' },
	{ hash = -644710429, name = 'cuban800', price = 1000, banido = true, modelo = 'Cuban800', capacidade = 0, tipo = 'work' },
	{ hash = -1746576111, name = 'mammatus', price = 1000, banido = true, modelo = 'Mammatus', capacidade = 0, tipo = 'work' },
	{ hash = 1341619767, name = 'vestra', price = 1000, banido = true, modelo = 'Vestra', capacidade = 0, tipo = 'work' },
	{ hash = 1077420264, name = 'velum2', price = 1000, banido = true, modelo = 'Velum2', capacidade = 0, tipo = 'work' },
	{ hash = 745926877, name = 'buzzard2', price = 1000, banido = true, modelo = 'Buzzard2', capacidade = 0, tipo = 'work' },
	{ hash = 744705981, name = 'frogger', price = 1000, banido = true, modelo = 'Frogger', capacidade = 0, tipo = 'work' },
	{ hash = -1660661558, name = 'maverick', price = 1000, banido = true, modelo = 'Maverick', capacidade = 0, tipo = 'work' },
	{ hash = 1956216962, name = 'tanker2', price = 1000, banido = true, modelo = 'Gas', capacidade = 0, tipo = 'work' },
	{ hash = -1207431159, name = 'armytanker', price = 1000, banido = true, modelo = 'Diesel', capacidade = 0, tipo = 'work' },
	{ hash = -1770643266, name = 'tvtrailer', price = 1000, banido = true, modelo = 'Show', capacidade = 0, tipo = 'work' },
	{ hash = 2016027501, name = 'trailerlogs', price = 1000, banido = true, modelo = 'Woods', capacidade = 0, tipo = 'work' },
	{ hash = 2091594960, name = 'tr4', price = 1000, banido = true, modelo = 'Cars', capacidade = 0, tipo = 'work' },
	{ hash = -60313827, name = 'nissangtr', price = 1000000, banido = false, modelo = 'Nissan GTR', capacidade = 40, tipo = 'import' },
	{ hash = -2015218779, name = 'nissan370z', price = 1000000, banido = false, modelo = 'Nissan 370Z', capacidade = 40, tipo = 'import' },
	{ hash = 1601422646, name = 'dodgechargersrt', price = 2000000, banido = false, modelo = 'Dodge Charger SRT', capacidade = 50, tipo = 'import' },
	{ hash = -1173768715, name = 'ferrariitalia', price = 1000000, banido = false, modelo = 'Ferrari Italia 478', capacidade = 30, tipo = 'import' },
	{ hash = 1978768527, name = '14r8', price = 1000000, banido = false, modelo = 'Audi R8 2014', capacidade = 30, tipo = 'import' },
	{ hash = 1676738519, name = 'audirs6', price = 1500000, banido = false, modelo = 'Audi RS6', capacidade = 60, tipo = 'import' },
	{ hash = -157095615, name = 'bmwm3f80', price = 1350000, banido = false, modelo = 'BMW M3 F80', capacidade = 50, tipo = 'import' },
	{ hash = -13524981, name = 'bmwm4gts', price = 1000000, banido = false, modelo = 'BMW M4 GTS', capacidade = 50, tipo = 'import' },
	{ hash = -1573350092, name = 'fordmustang', price = 1900000, banido = false, modelo = 'Ford Mustang', capacidade = 40, tipo = 'import' },
	{ hash = 1114244595, name = 'lamborghinihuracan', price = 1000000, banido = false, modelo = 'Lamborghini Huracan', capacidade = 30, tipo = 'import' },
	{ hash = 2034235290, name = 'mazdarx7', price = 1000000, banido = false, modelo = 'Mazda RX7', capacidade = 40, tipo = 'import' },
	{ hash = 670022011, name = 'nissangtrnismo', price = 1000000, banido = false, modelo = 'Nissan GTR Nismo', capacidade = 40, tipo = 'import' },
    { hash = -4816535, name = 'nissanskyliner34', price = 1000000, banido = false, modelo = 'Nissan Skyline R34', capacidade = 50, tipo = 'import' },
	{ hash = 351980252, name = 'teslaprior', price = 1750000, banido = false, modelo = 'Tesla Prior', capacidade = 50, tipo = 'import' },
	{ hash = 723779872, name = 'toyotasupra', price = 1000000, banido = false, modelo = 'Toyota Supra', capacidade = 35, tipo = 'import' },
	{ hash = -740742391, name = 'mercedesa45', price = 1200000, banido = false, modelo = 'Mercedes A45', capacidade = 40, tipo = 'import' },
	{ hash = 819937652, name = 'focusrs', price = 1000000, banido = false, modelo = 'Focus RS', capacidade = 40, tipo = 'import' },
	{ hash = -133349447, name = 'lancerevolution9', price = 1400000, banido = false, modelo = 'Lancer Evolution 9', capacidade = 50, tipo = 'import' },
	{ hash = 1911052153, name = 'ninjah2', price = 1000000, banido = false, modelo = 'Ninja H2', capacidade = 15, tipo = 'import' },
	{ hash = -333868117, name = 'trr', price = 1000000, banido = false, modelo = 'KTM TRR', capacidade = 15, tipo = 'import' },
	{ hash = -189438188, name = 'p1', price = 1000000, banido = false, modelo = 'Mclaren P1', capacidade = 20, tipo = 'import' },
	{ hash = 1718441594, name = 'i8', price = 1000000, banido = false, modelo = 'BMW i8', capacidade = 35, tipo = 'import' },
	{ hash = -380714779, name = 'bme6tun', price = 1000000, banido = false, modelo = 'BMW M5', capacidade = 50, tipo = 'import' },
	{ hash = -1481236684, name = 'aperta', price = 10000000, banido = false, modelo = 'La Ferrari', capacidade = 20, tipo = 'import' },
	{ hash = -498891507, name = 'bettle', price = 1000000, banido = false, modelo = 'New Bettle', capacidade = 35, tipo = 'import' },
	{ hash = -433961724, name = 'senna', price = 1000000, banido = false, modelo = 'Mclaren Senna', capacidade = 20, tipo = 'import' },
	{ hash = 2045784380, name = 'rmodx6', price = 1000000, banido = false, modelo = 'BMW X6', capacidade = 40, tipo = 'import' },
	{ hash = 113372153, name = 'bnteam', price = 1000000, banido = false, modelo = 'Bentley', capacidade = 20, tipo = 'import' },
	{ hash = -1274284606, name = 'rmodlp770', price = 1000000, banido = false, modelo = 'Lamborghini Centenario', capacidade = 20, tipo = 'import' },
	{ hash = 1503141430, name = 'divo', price = 1000000, banido = false, modelo = 'Buggati Divo', capacidade = 20, tipo = 'import' },
	{ hash = 1966489524, name = 's15', price = 1000000, banido = false, modelo = 'Nissan Silvia S15', capacidade = 20, tipo = 'import' },
	{ hash = -915188472, name = 'amggtr', price = 1000000, banido = false, modelo = 'Mercedes AMG', capacidade = 20, tipo = 'import' },
	{ hash = -264618235, name = 'lamtmc', price = 1000000, banido = false, modelo = 'Lamborghini Terzo', capacidade = 20, tipo = 'import' },
	{ hash = -1067176722, name = 'vantage', price = 1000000, banido = false, modelo = 'Aston Martin Vantage', capacidade = 20, tipo = 'import' },
	{ hash = -520214134, name = 'urus', price = 10000000, banido = false, modelo = 'Lamborghini Urus', capacidade = 50, tipo = 'import' }, 
	{ hash = 493030188, name = 'amarok', price = 1000000, banido = false, modelo = 'VW Amarok', capacidade = 150, tipo = 'import' }, 
	{ hash = 493030188, name = '911gtrs', price = 10000000, banido = false, modelo = 'Porsche 911', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'c63w205', price = 1000000, banido = false, modelo = 'Mercedes C63', capacidade = 50, tipo = 'import' }, 
	{ hash = 493030188, name = 'golfgti', price = 100000, banido = false, modelo = 'GOLF GTI', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'saveiro', price = 90000, banido = false, modelo = 'SAVEIRO', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'up', price = 1000000, banido = false, modelo = 'UP', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'voyage', price = 50000, banido = false, modelo = 'VOYAGE QUADRADRO', capacidade = 50, tipo = 'import' },  
	{ hash = 493030188, name = 'jeepreneg', price = 1000000, banido = false, modelo = 'JEEP RENEGADE', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'uno', price = 30000, banido = false, modelo = 'UNO DESCOLADO', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'a45amg', price = 500000, banido = false, modelo = 'Mercedes A45', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'astra', price = 1000000, banido = false, modelo = 'ASTRA', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'audia3', price = 1500000, banido = false, modelo = 'Audi A3', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'bmw130i', price = 1000000, banido = false, modelo = 'BMW 130I', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'bmwm4gts', price = 1000000, banido = false, modelo = 'BMW 4GTS', capacidade = 50, tipo = 'import' }, 
	{ hash = 493030188, name = 'golquadrado', price = 80000, banido = false, modelo = 'GOL', capacidade = 50, tipo = 'import' }, 
	{ hash = 493030188, name = 'gtoxx', price = 1000000, banido = false, modelo = 'Ferrari Gtoxx', capacidade = 50, tipo = 'import' },  
	{ hash = 493030188, name = 'kadett', price = 850000, banido = false, modelo = 'KADETT', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'jetta2017', price = 250000, banido = false, modelo = 'JETTA 2017', capacidade = 50, tipo = 'carros' },
	{ hash = 493030188, name = 'civic2017', price = 1250000, banido = false, modelo = 'Honda Civic', capacidade = 50, tipo = 'import' },
	{ hash = 493030188, name = 'corolla2017', price = 250000, banido = false, modelo = 'Corola 2017', capacidade = 50, tipo = 'import' }, 
	{ hash = 2093958905, name = 'slsamg', price = 1000000, banido = false, modelo = 'Mercedes SLS', capacidade = 20, tipo = 'import' },
	{ hash = 104532066, name = 'g65amg', price = 1000000, banido = false, modelo = 'Mercedes G65', capacidade = 0, tipo = 'import' },
	{ hash = 1995020435, name = 'celta', price = 56000, banido = false, modelo = 'Celta Paredão', capacidade = 50, tipo = 'import' },
	{ hash = 137494285, name = 'eleanor', price = 1000000, banido = false, modelo = 'Mustang Eleanor', capacidade = 30, tipo = 'import' },
	{ hash = -863499820, name = 'rmodamgc63', price = 1000000, banido = false, modelo = 'Mercedes AMG C63', capacidade = 40, tipo = 'import' },
	{ hash = -1315334327, name = 'palameila', price = 1000000, banido = false, modelo = 'Porsche Panamera', capacidade = 50, tipo = 'import' },
	{ hash = 2047166283, name = 'bmws', price = 1000000, banido = false, modelo = 'BMW S1000', capacidade = 15, tipo = 'import' },
	{ hash = 494265960, name = 'cb500x', price = 1000000, banido = false, modelo = 'Honda CB500', capacidade = 15, tipo = 'import' },
	{ hash = -1031680535, name = 'rsvr16', price = 1000000, banido = false, modelo = 'Ranger Rover', capacidade = 50, tipo = 'import' },
	{ hash = -42051018, name = 'veneno', price = 1000000, banido = false, modelo = 'Lamborghini Veneno', capacidade = 20, tipo = 'import' },
	{ hash = -1824291874, name = '19ramdonk', price = 1000000, banido = false, modelo = 'Dodge Ram Donk', capacidade = 80, tipo = 'import' },
	{ hash = -304124483, name = 'silv86', price = 1000000, banido = false, modelo = 'Silverado Donk', capacidade = 80, tipo = 'import' },
	{ hash = -402398867, name = 'bc', price = 1000000, banido = false, modelo = 'Pagani Huayra', capacidade = 20, tipo = 'import' },
	{ hash = 2113322010, name = '70camarofn', price = 1000000, banido = false, modelo = 'camaro Z28 1970', capacidade = 20, tipo = 'import' },
	{ hash = -654239719, name = 'agerars', price = 1000000, banido = false, modelo = 'Koenigsegg Agera RS', capacidade = 20, tipo = 'import' },
	{ hash = 580861919, name = 'fc15', price = 1000000, banido = false, modelo = 'Ferrari California', capacidade = 20, tipo = 'import' },
	{ hash = 1402024844, name = 'bbentayga', price = 1000000, banido = false, modelo = 'Bentley Bentayga', capacidade = 50, tipo = 'import' },
	{ hash = 1085789913, name = 'regera', price = 1000000, banido = false, modelo = 'Koenigsegg Regera', capacidade = 20, tipo = 'import' },
	{ hash = 144259586, name = '911r', price = 1000000, banido = false, modelo = 'Porsche 911R', capacidade = 30, tipo = 'import' },
	{ hash = 1047274985, name = 'africat', price = 1000000, banido = false, modelo = 'Honda CRF 1000', capacidade = 15, tipo = 'import' },
	{ hash = -653358508, name = 'msohs', price = 1000000, banido = false, modelo = 'Mclaren 688 HS', capacidade = 20, tipo = 'import' },
	{ hash = -2011325074, name = 'gt17', price = 1000000, banido = false, modelo = 'Ford GT 17', capacidade = 20, tipo = 'import' },
	{ hash = 1224601968, name = '19ftype', price = 1000000, banido = false, modelo = 'Jaguar F-Type', capacidade = 50, tipo = 'import' },
	{ hash = -1593808613, name = '488gtb', price = 1000000, banido = false, modelo = 'Ferrari 488 GTB', capacidade = 30, tipo = 'import' },
	{ hash = 235772231, name = 'fxxkevo', price = 1000000, banido = false, modelo = 'Ferrari FXXK Evo', capacidade = 30, tipo = 'import' },
	{ hash = -1313740730, name = 'm2', price = 1000000, banido = false, modelo = 'BMW M2', capacidade = 50, tipo = 'import' },
	{ hash = 233681897, name = 'defiant', price = 1000000, banido = false, modelo = 'AMC Javelin 72', capacidade = 40, tipo = 'import' },
	{ hash = -1507259850, name = 'f12tdf', price = 1000000, banido = false, modelo = 'Ferrari F12 TDF', capacidade = 20, tipo = 'import' },
	{ hash = -1863430482, name = '71gtx', price = 1000000, banido = false, modelo = 'Plymouth 71 GTX', capacidade = 50, tipo = 'import' },
	{ hash = 859592619, name = 'porsche992', price = 1000000, banido = false, modelo = 'Porsche 992', capacidade = 20, tipo = 'import' },
	{ hash = -187294055, name = '18macan', price = 1000000, banido = false, modelo = 'Porsche Macan', capacidade = 60, tipo = 'import' },
	{ hash = 1270688730, name = 'm6e63', price = 1000000, banido = false, modelo = 'BMW M6 E63', capacidade = 50, tipo = 'import' },
	{ hash = -1467569396, name = '180sx', price = 1000000, banido = false, modelo = 'Nissan 180SX', capacidade = 10, tipo = 'import' },
	{ hash = -192929549, name = 'audirs7', price = 1800000, banido = false, modelo = 'Audi RS7', capacidade = 60, tipo = 'import' },
	{ hash = 653510754, name = 'hondafk8', price = 1700000, banido = false, modelo = 'Honda FK8', capacidade = 40, tipo = 'import' },
	{ hash = -148915999, name = 'mustangmach1', price = 1100000, banido = false, modelo = 'Mustang Mach 1', capacidade = 40, tipo = 'import' },
	{ hash = 2009693397, name = 'porsche930', price = 1300000, banido = false, modelo = 'Porsche 930', capacidade = 20, tipo = 'import' },
	{ hash = 624514487, name = 'raptor2017', price = 1000000, banido = false, modelo = 'Ford Raptor 2017', capacidade = 150, tipo = 'import' },
	{ hash = -2096912321, name = 'filthynsx', price = 1000000, banido = false, modelo = 'Honda NSX', capacidade = 20, tipo = 'import' },
	{ hash = -1671973728, name = '2018zl1', price = 1000000, banido = false, modelo = 'Camaro ZL1', capacidade = 40, tipo = 'import' },
	{ hash = 1603211447, name = 'eclipse', price = 1000000, banido = false, modelo = 'Mitsubishi Eclipse', capacidade = 30, tipo = 'import' },
	{ hash = 949614817, name = 'lp700r', price = 1000000, banido = false, modelo = 'Lamborghini LP700R', capacidade = 0, tipo = 'import' },
	{ hash = 765170133, name = 'amv19', price = 1000000, banido = false, modelo = 'Aston Martin', capacidade = 50, tipo = 'import' },
	{ hash = 1069692054, name = 'beetle74', price = 500000, banido = false, modelo = 'Fusca 74', capacidade = 40, tipo = 'import' },
	{ hash = 1649254367, name = 'fe86', price = 500000, banido = false, modelo = 'Escorte', capacidade = 40, tipo = 'import' },
	{ hash = -251450019, name = 'type263', price = 500000, banido = false, modelo = 'Kombi 63', capacidade = 60, tipo = 'import' },
	{ hash = 1128102088, name = 'pistas', price = 1000000, banido = false, modelo = 'Ferrari Pista', capacidade = 30, tipo = 'import' },
	{ hash = -1152345593, name = 'yzfr125', price = 1000000, banido = false, modelo = 'Yamaha YZF R125', capacidade = 10, tipo = 'import' },
	{ hash = 1301770299, name = 'mt03', price = 1000000, banido = false, modelo = 'Yamaha MT 03', capacidade = 10, tipo = 'import' },
	{ hash = 2037834373, name = 'flatbed3', price = 1000, banido = false, modelo = 'flatbed3', capacidade = 0, tipo = 'work' },
	{ hash = 194235445, name = '20r1', price = 1000000, banido = false, modelo = 'Yamaha YZF R1', capacidade = 10, tipo = 'import' },
	{ hash = -1820486602, name = 'SVR14', price = 1000000, banido = false, modelo = 'Ranger Rover', capacidade = 50, tipo = 'import' },
	{ hash = 1663453404, name = 'evoque', price = 1000000, banido = false, modelo = 'Ranger Rover Evoque', capacidade = 50, tipo = 'import' },
	{ hash = -1343964931, name = 'Bimota', price = 1000000, banido = false, modelo = 'Ducati Bimota', capacidade = 10, tipo = 'import' },
	{ hash = -1385753106, name = 'r8ppi', price = 1000000, banido = false, modelo = 'Audi R8 PPI Razor', capacidade = 30, tipo = 'import' },
	{ hash = -1221749859, name = 'bobbes2', price = 1000000, banido = false, modelo = 'Harley D. Bobber S', capacidade = 15, tipo = 'import' },
	{ hash = -1830458836, name = 'bobber', price = 1000000, banido = false, modelo = 'Harley D. Bobber ', capacidade = 15, tipo = 'import' },
	{ hash = -716699448, name = '911tbs', price = 1000000, banido = false, modelo = 'Porsche 911S', capacidade = 25, tipo = 'import' },
	{ hash = -1845487887, name = 'volatus', price = 1000000, banido = false, modelo = 'Volatus', capacidade = 45, tipo = 'work' },
	{ hash = -2049243343, name = 'rc', price = 1000000, banido = false, modelo = 'KTM RC', capacidade = 15, tipo = 'import' },
	{ hash = 16211617168, name = 'cargobob2', price = 1000000, banido = false, modelo = 'Cargo Bob', capacidade = 0, tipo = 'work' },
	{ hash = -714386060, name = 'zx10r', price = 1000000, banido = false, modelo = 'Kawasaki ZX10R', capacidade = 20, tipo = 'import' },
	{ hash = 1257756827, name = 'fox600lt', price = 1000000, banido = false, modelo = 'McLaren 600LT', capacidade = 40, tipo = 'import' },
	{ hash = -791711053, name = 'foxbent1', price = 1000000, banido = false, modelo = 'Bentley Liter 1931', capacidade = 40, tipo = 'import' },
	{ hash = -1421258057, name = 'foxevo', price = 1000000, banido = false, modelo = 'Lamborghini EVO', capacidade = 40, tipo = 'import' },
	{ hash = -245054982, name = 'jeepg', price = 1000000, banido = false, modelo = 'Jeep Gladiator', capacidade = 90, tipo = 'import' },
	{ hash = 545993358, name = 'foxharley1', price = 1000000, banido = false, modelo = 'Harley-Davidson Softail F.B.', capacidade = 20, tipo = 'import' },
	{ hash = 305501667, name = 'foxharley2', price = 1000000, banido = false, modelo = '2016 Harley-Davidson Road Glide', capacidade = 20, tipo = 'import' },
	{ hash = 1720228960, name = 'foxleggera', price = 1000000, banido = false, modelo = 'Aston Martin Leggera', capacidade = 50, tipo = 'import' },
	{ hash = -470882965, name = 'foxrossa', price = 1000000, banido = false, modelo = 'Ferrari Rossa', capacidade = 40, tipo = 'import' },
	{ hash = 69730216, name = 'foxshelby', price = 1000000, banido = false, modelo = 'Ford Shelby GT500', capacidade = 40, tipo = 'import' },
	{ hash = 182795887, name = 'foxsian', price = 1000000, banido = false, modelo = 'Lamborghini Sian', capacidade = 40, tipo = 'import' },
	{ hash = 1065452892, name = 'foxsterrato', price = 1000000, banido = false, modelo = 'Lamborghini Sterrato', capacidade = 40, tipo = 'import' },
	{ hash = 16473409, name = 'foxsupra', price = 1000000, banido = false, modelo = 'Toyota Supra', capacidade = 50, tipo = 'import' },
	{ hash = 53299675, name = 'm6x6', price = 1000000, banido = false, modelo = 'Mercedes Benz 6x6', capacidade = 90, tipo = 'import' },
	{ hash = -1677172839, name = 'm6gt3', price = 1000000, banido = false, modelo = 'BMW M6 GT3', capacidade = 40, tipo = 'import' },
	{ hash = 730959932, name = 'w900', price = 1000000, banido = false, modelo = 'Kenworth W900', capacidade = 130, tipo = 'import' },
	{ hash = -431692672, name = 'panto', price = 1000000, banido = false, modelo = 'Panto', capacidade = 130, tipo = 'carros' },
	{ hash =  1301689862, name = '488', price = 1000, banido = false, modelo = '488', capacidade = 50, tipo = 'Import' },
	{ hash =  1301689862, name = 'acs8', price = 1000, banido = false, modelo = 'acs8', capacidade = 50, tipo = 'Import' },
	{ hash =  -1481236684, name = 'aperta', price = 1000, banido = false, modelo = 'aperta', capacidade = 50, tipo = 'Import' },
	{ hash =  1879538617, name = 'bmwg20', price = 1000, banido = false, modelo = 'bmwg20', capacidade = 50, tipo = 'Import' },
	{ hash =  874739883, name = 'c7', price = 1000, banido = false, modelo = 'c7', capacidade = 50, tipo = 'Import' },
	{ hash =  -1696240789, name = 'cx75', price = 1000, banido = false, modelo = 'CX75', capacidade = 50, tipo = 'Import' },
	{ hash =  1127414868, name = 'f812', price = 1000, banido = false, modelo = 'F812', capacidade = 50, tipo = 'Import' },
	{ hash =  -1919297986, name = 'fpacehm', price = 1000, banido = false, modelo = 'fpacehm', capacidade = 50, tipo = 'Import' },
	{ hash =  104532066, name = 'g65amg', price = 1000, banido = false, modelo = 'g65amg', capacidade = 50, tipo = 'Import' },
	{ hash =  -1752116803, name = 'gtr', price = 1000, banido = false, modelo = 'gtr', capacidade = 50, tipo = 'Import' },
	{ hash =  949614817, name = 'lp700r', price = 1000, banido = false, modelo = 'lp700r', capacidade = 50, tipo = 'Import' },
	{ hash =  1061824004, name = 'macanturbo', price = 1000, banido = false, modelo = 'macanturbo', capacidade = 50, tipo = 'Import' },
	{ hash =  44601179, name = 'macla', price = 1000, banido = false, modelo = 'macla', capacidade = 50, tipo = 'Import' },
	{ hash =  -1432034260, name = 'mgt', price = 1000, banido = false, modelo = 'mgt', capacidade = 50, tipo = 'Import' },
	{ hash =  -189438188, name = 'p1', price = 1000, banido = false, modelo = 'p1', capacidade = 50, tipo = 'Import' },
	{ hash =  194366558, name = 'panamera17turbo', price = 1000, banido = false, modelo = 'panamera17turbo', capacidade = 50, tipo = 'Import' },
	{ hash =  -1730825510, name = 'q7w', price = 1000, banido = false, modelo = 'q7w', capacidade = 50, tipo = 'Import' },
	{ hash =  1599265874, name = 'str20', price = 1000, banido = false, modelo = 'str20', capacidade = 50, tipo = 'Import' },
	{ hash =  1094481404, name = 'urus2018', price = 1000, banido = false, modelo = 'urus2018', capacidade = 50, tipo = 'Import' },
	{ hash =  -1067176722, name = 'vantage', price = 1000, banido = false, modelo = 'vantage', capacidade = 50, tipo = 'Import' },
	{ hash =  -1095688294, name = 'wraith', price = 1000, banido = false, modelo = 'wraith', capacidade = 50, tipo = 'Import' },
	{ hash =  -506359117, name = 'x6m', price = 1000, banido = false, modelo = 'x6m', capacidade = 50, tipo = 'Import' },
	{ hash =  129391352, name = 'cooperworks', price = 1000, banido = false, modelo = 'cooperworks', capacidade = 50, tipo = 'Import' },
	{ hash =  -1702326766, name = 'corolla', price = 1000, banido = false, modelo = 'corolla', capacidade = 50, tipo = 'Import' },
	{ hash =  629443124, name = 'cox2013', price = 1000, banido = false, modelo = 'cox2013', capacidade = 50, tipo = 'Import' },
	{ hash =  -947724703, name = 'ds4', price = 1000, banido = false, modelo = 'ds4', capacidade = 50, tipo = 'Import' },
	{ hash =  -54736684, name = 'ds7', price = 1000, banido = false, modelo = 'ds7', capacidade = 50, tipo = 'Import' },
	{ hash =  1603211447, name = 'eclipse', price = 1000, banido = false, modelo = 'eclipse', capacidade = 50, tipo = 'Import' },
	{ hash =  -228528329, name = 'evo9', price = 1000, banido = false, modelo = 'evo9', capacidade = 50, tipo = 'Import' },
	{ hash =  1924372706, name = 'fusca', price = 1000, banido = false, modelo = 'fusca', capacidade = 50, tipo = 'Import' },
	{ hash =  -1193237073, name = 'fx4', price = 1000, banido = false, modelo = 'fx4', capacidade = 50, tipo = 'Import' },
	{ hash =  -1270846222, name = 'hilux2019', price = 1000, banido = false, modelo = 'hilux2019', capacidade = 50, tipo = 'Import' },
	{ hash =  -1691715558, name = 'jeep2012', price = 1000, banido = false, modelo = 'jeep2012', capacidade = 50, tipo = 'Import' },
	{ hash =  -1246383966, name = '488', price = 1000, banido = false, modelo = '488', capacidade = 50, tipo = 'Import' },
	{ hash =  991407206, name = 'r1250', price = 1000, banido = false, modelo = 'TigerR1250', capacidade = 50, tipo = 'Import' },
	{ hash =  1088829493, name = 'cg160', price = 0, banido = true, modelo = 'CG 150 Entregas', capacidade = 0, tipo = 'work' },
	{ hash =  -233098306, name = 'boxville2', price = 1000, banido = true, modelo = 'Van de Entregas', capacidade = 50, tipo = 'work' },
	{ hash =  -701653192, name = 'trailcivileie', price = 1000, banido = true, modelo = 'Trail Civil', capacidade = 50, tipo = 'work' },
	{ hash = -1987109409, name = '150', price = 30000, banido = false, modelo = '150', capacidade = 40, tipo = 'import' },
	{ hash = -127896429, name = '488', price = 30000, banido = false, modelo = 'Ferrari488', capacidade = 20, tipo = 'import' },
	{ hash = 130168962, name = 'acs8', price = 30000, banido = false, modelo = 'BMW ACS8', capacidade = 40, tipo = 'import' },
	{ hash = 493030188, name = 'amarok', price = 30000, banido = false, modelo = 'Amarok', capacidade = 40, tipo = 'import' },
	{ hash = -1481236684, name = 'aperta', price = 30000, banido = false, modelo = 'LaFerrari', capacidade = 40, tipo = 'import' },
	{ hash = 2015170161, name = 'biz25', price = 30000, banido = false, modelo = 'biz25', capacidade = 40, tipo = 'import' },
	{ hash = 1879538617, name = 'bmwg20', price = 30000, banido = false, modelo = 'bmwg20', capacidade = 40, tipo = 'import' },
	{ hash = 2047166283, name = 'bmws', price = 30000, banido = false, modelo = 'bmws', capacidade = 40, tipo = 'import' },
	{ hash = 874739883, name = 'c7', price = 30000, banido = false, modelo = 'c7', capacidade = 40, tipo = 'import' },
	{ hash = 735175855, name = 'cbrr', price = 30000, banido = false, modelo = 'cbrr', capacidade = 40, tipo = 'import' },
	{ hash = 321407703, name = 'CBTWISTER', price = 30000, banido = false, modelo = 'CBTWISTER', capacidade = 40, tipo = 'import' },
	{ hash = 1088829493, name = 'cg160', price = 30000, banido = false, modelo = 'cg160', capacidade = 40, tipo = 'work' },
	{ hash = -1045541610, name = 'comet2', price = 30000, banido = false, modelo = 'comet2', capacidade = 40, tipo = 'iwork' },
	{ hash = 1671178289, name = 'd99', price = 30000, banido = false, modelo = 'd99', capacidade = 40, tipo = 'import' },
	{ hash = 1127414868, name = 'f812', price = 30000, banido = false, modelo = 'f812', capacidade = 40, tipo = 'import' },
	{ hash = -1919297986, name = 'fpacehm', price = 30000, banido = false, modelo = 'fpacehm', capacidade = 40, tipo = 'import' },
	{ hash = 104532066 , name = 'g65amg', price = 30000, banido = false, modelo = 'g65amg', capacidade = 40, tipo = 'import' },
	{ hash = -1752116803, name = 'gtr', price = 30000, banido = false, modelo = 'gtr', capacidade = 40, tipo = 'import' },
	{ hash = -688419137, name = 'hayabusa', price = 30000, banido = false, modelo = 'hayabusa', capacidade = 40, tipo = 'import' },
	{ hash = -1265899455, name = 'hcbr17', price = 30000, banido = false, modelo = 'hcbr17', capacidade = 40, tipo = 'import' },
	{ hash = -1761239425, name = 'hornet', price = 30000, banido = false, modelo = 'hornet', capacidade = 40, tipo = 'import' },
	{ hash = -1474280704, name = 'hvrod', price = 30000, banido = false, modelo = 'hvrod', capacidade = 40, tipo = 'import' },
	{ hash = 949614817, name = 'lp700r', price = 30000, banido = false, modelo = 'lp700r', capacidade = 40, tipo = 'import' },
	{ hash = 44601179, name = 'macla', price = 30000, banido = false, modelo = 'macla', capacidade = 40, tipo = 'import' },
	{ hash = 1061824004, name = 'mgt', price = 30000, banido = false, modelo = 'mgt', capacidade = 40, tipo = 'import' },
	{ hash = -1667727259, name = 'nh2r', price = 30000, banido = false, modelo = 'nh2r', capacidade = 40, tipo = 'import' },
	{ hash = -189438188, name = 'p1', price = 30000, banido = false, modelo = 'p1', capacidade = 40, tipo = 'import' },
	{ hash = 194366558, name = 'panamera17turbo', price = 30000, banido = false, modelo = 'panamera17turbo', capacidade = 40, tipo = 'import' },
	{ hash = -1730825510, name = 'Q7', price = 30000, banido = false, modelo = 'Q7', capacidade = 70, tipo = 'import' },
	{ hash = 1474015055, name = 'r1', price = 30000, banido = false, modelo = 'r1', capacidade = 40, tipo = 'import' },
	{ hash = -188978926, name = 'r6', price = 30000, banido = false, modelo = 'r6', capacidade = 40, tipo = 'import' },
	{ hash = -1532432776, name = 'R1200GS', price = 30000, banido = false, modelo = 'R1200GS', capacidade = 40, tipo = 'import' },
	{ hash = -2049243343, name = 'rc', price = 30000, banido = false, modelo = 'rc', capacidade = 40, tipo = 'import' },
	{ hash = 1599265874, name = 'str20', price = 30000, banido = false, modelo = 'str20', capacidade = 40, tipo = 'import' },
	{ hash = -130814154, name = 'surfboard', price = 30000, banido = false, modelo = 'surfboard', capacidade = 40, tipo = 'import' },
	{ hash = -85371949, name = 'tmax', price = 30000, banido = false, modelo = 'tmax', capacidade = 40, tipo = 'import' },
	{ hash = 1094481404, name = 'urus2018', price = 30000, banido = false, modelo = 'urus2018', capacidade = 70, tipo = 'import' },
	{ hash = -1067176722, name = 'vantage', price = 30000, banido = false, modelo = 'vantage', capacidade = 40, tipo = 'import' },
	{ hash = -1095688294, name = 'wraith', price = 30000, banido = false, modelo = 'wraith', capacidade = 40, tipo = 'import' },
	{ hash = -506359117, name = 'x6m', price = 30000, banido = false, modelo = 'x6m', capacidade = 40, tipo = 'import' },
	{ hash = 342059638, name = 'xj6', price = 30000, banido = false, modelo = 'xj6', capacidade = 40, tipo = 'import' },
	{ hash = 1744543800, name = 'z1000', price = 30000, banido = false, modelo = 'z1000', capacidade = 40, tipo = 'import' },
	{ hash = -1983015514, name = '911gtrs', price = 30000, banido = false, modelo = '911gtrs', capacidade = 40, tipo = 'import' },
	{ hash = 1676738519, name = 'audirs6', price = 30000, banido = false, modelo = 'audirs6', capacidade = 40, tipo = 'import' },
	{ hash = -1540353819, name = 'bmwi8', price = 30000, banido = false, modelo = 'bmwi8', capacidade = 40, tipo = 'import' },
	{ hash = -157095615, name = 'bmwm3f80', price = 30000, banido = false, modelo = 'bmwm3f80', capacidade = 40, tipo = 'import' },
	{ hash = -13524981, name = 'bmwm4gts', price = 30000, banido = false, modelo = 'bmwm4gts', capacidade = 40, tipo = 'import' },
	{ hash = 1828026872, name = 'btsupra94', price = 30000, banido = false, modelo = 'btsupra94', capacidade = 40, tipo = 'import' },
	{ hash = 1601422646, name = 'dodgechargersrt', price = 30000, banido = false, modelo = 'dodgechargersrt', capacidade = 40, tipo = 'import' },
	{ hash = -1661854193, name = 'dune', price = 30000, banido = false, modelo = 'dune', capacidade = 40, tipo = 'import' },
	{ hash = -1173768715, name = 'ferrariitalia', price = 30000, banido = false, modelo = 'ferrariitalia', capacidade = 40, tipo = 'import' },
	{ hash = -1573350092, name = 'fordmustang', price = 30000, banido = false, modelo = 'fordmustang', capacidade = 40, tipo = 'import' },
	{ hash = 1106910537, name = 'fordmustanggt', price = 30000, banido = false, modelo = 'fordmustanggt', capacidade = 40, tipo = 'import' },
	{ hash = 744705981, name = 'frogger', price = 30000, banido = false, modelo = 'frogger', capacidade = 40, tipo = 'import' },
	{ hash = 1978088379, name = 'lancerevolutionx', price = 30000, banido = false, modelo = 'lancerevolutionx', capacidade = 40, tipo = 'import' },
	{ hash = 2034235290, name = 'mazdarx7', price = 30000, banido = false, modelo = 'mazdarx7', capacidade = 40, tipo = 'import' },
	{ hash = -2015218779, name = 'nissan370z', price = 30000, banido = false, modelo = 'nissan370z', capacidade = 40, tipo = 'import' },
	{ hash = -60313827, name = 'nissangtr', price = 30000, banido = false, modelo = 'nissangtr', capacidade = 40, tipo = 'import' },
	{ hash = -1683569033, name = 'paganihuayra', price = 30000, banido = false, modelo = 'paganihuayra', capacidade = 40, tipo = 'import' },
	{ hash = -792745162, name = 'paramedicoambu', price = 30000, banido = false, modelo = 'paramedicoambu', capacidade = 40, tipo = 'work' },
	{ hash = -1296077726, name = 'pturismo', price = 30000, banido = false, modelo = 'pturismo', capacidade = 40, tipo = 'import' },
	{ hash = 1162065741, name = 'rumpo', price = 30000, banido = false, modelo = 'rumpo', capacidade = 40, tipo = 'work' },
	{ hash = 351980252, name = 'teslaprior', price = 30000, banido = false, modelo = 'teslaprior', capacidade = 40, tipo = 'import' },
	{ hash = 723779872, name = 'toyotasupra', price = 30000, banido = false, modelo = 'toyotasupra', capacidade = 40, tipo = 'import' },
	{ hash = 1448677353, name = 'tropic2', price = 30000, banido = false, modelo = 'tropic2', capacidade = 40, tipo = 'import' },
	{ hash = 1473628167, name = 'vwgolf', price = 30000, banido = false, modelo = 'vwgolf', capacidade = 40, tipo = 'import' },
	{ hash = -1858654120, name = 'zr350', price = 430000, banido = false, modelo = 'Annis ZR350', capacidade = 30, tipo = 'carros' },
	{ hash = -1858654120, name = 'zr350', price = 430000, banido = false, modelo = 'Annis ZR350', capacidade = 30, tipo = 'carros' },
	{ hash = -291021213, name = 'sultan3', price = 410000, banido = false, modelo = 'Karin Sultan RS Classic', capacidade = 30, tipo = 'carros' },
	{ hash = -1976092471, name = 'VRtahoe', price = 410000, banido = false, modelo = 'Tahoe Hospital', capacidade = 30, tipo = 'service' },
	{ hash = -1284811839, name = 'Wrasprinter', price = 410000, banido = false, modelo = 'Ambulancia', capacidade = 30, tipo = 'service' },
	{ hash = 987469656, name = 'sugoi', price = 320000, banido = false, modelo = 'Sugoi', capacidade = 50, tipo = 'carros' },
	{ hash = 1755697647, name = 'cypher', price = 480000, banido = false, modelo = 'Cypher', capacidade = 30, tipo = 'carros' },
	{ hash = -1331336397, name = 'bdivo', price = 30000, banido = false, modelo = 'bdivo', capacidade = 40, tipo = 'import' },
	{ hash = -216150906, name = '16challenger', price = 30000, banido = false, modelo = '16challenger', capacidade = 40, tipo = 'import' },
	{ hash = 1897651510, name = 'm5e60', price = 30000, banido = false, modelo = 'm5e60', capacidade = 40, tipo = 'import' },
	{ hash = 991407206, name = 'amr1250', price = 30000, banido = false, modelo = 'r1250', capacidade = 40, tipo = 'import' },
	{ hash = 347665913, name = 'civic2017', price = 120000, banido = false, modelo = 'civic2017', capacidade = 40, tipo = 'import' },
	----------------------------------------------------------[policia]-----------------------------------------------------------
	{ hash = 456714581, name = 'policet', price = 30000, banido = false, modelo = 'policet', capacidade = 40, tipo = 'service' },
	{ hash = 882175746, name = 'cruzeprf2', price = 30000, banido = false, modelo = 'cruzeprf2', capacidade = 40, tipo = 'service' },
	{ hash = 1938952078, name = 'firetruk', price = 30000, banido = false, modelo = 'firetruk', capacidade = 40, tipo = 'service' },
	{ hash = 1416139207, name = 'spacepm1', price = 30000, banido = false, modelo = 'spacepm1', capacidade = 40, tipo = 'service' },
	{ hash = -1030779560, name = 'l200prf', price = 30000, banido = false, modelo = 'l200prf', capacidade = 40, tipo = 'service' },
	{ hash = -1668722828, name = 'paliopmrp1', price = 30000, banido = false, modelo = 'paliopmrp1', capacidade = 40, tipo = 'service' },
	{ hash = 1912215274, name = 'police3', price = 120000, banido = false, modelo = 'police3', capacidade = 40, tipo = 'service' },
	{ hash = -865769403, name = 'SpinCGP', price = 30000, banido = false, modelo = 'SpinCGP', capacidade = 40, tipo = 'service' },
	{ hash = 154038430, name = 'sw4geral', price = 30000, banido = false, modelo = 'sw4geral', capacidade = 40, tipo = 'service' },
	{ hash = -1664202718, name = 'trail21geral', price = 30000, banido = false, modelo = 'trail21geral', capacidade = 40, tipo = 'service' },
	{ hash = -373757526, name = 'xre2019pm1', price = 120000, banido = false, modelo = 'xre2019pm1', capacidade = 40, tipo = 'service' },
	{ hash = 991407206, name = 'r1250', price = 400000, banido = false, modelo = 'BMW R1200', capacidade = 50, tipo = 'import' }, -- ok 285 (50)
	{ hash = 2047166283, name = 'bmws', price = 400000, banido = false, modelo = 'BMW S1000RR', capacidade = 30, tipo = 'import' }, -- ok 300 (45)
	{ hash = -1265899455, name = 'hcbr17', price = 400000, banido = false, modelo = 'Honda CBR 2017', capacidade = 30, tipo = 'import' }, -- ok 300 (45)
	{ hash = -188978926, name = 'r6', price = 400000, banido = false, modelo = 'Yamaha R6', capacidade = 30, tipo = 'import' }, -- ok 280 (45)
	{ hash = -2049243343, name = 'rc', price = 400000, banido = false, modelo = 'KTM RC 200', capacidade = 30, tipo = 'import' }, -- ok 250 (30)
	{ hash = 1474015055, name = 'r1', price = 400000, banido = false, modelo = 'Yamaha R1', capacidade = 30, tipo = 'import' }, -- ok 310 (50)
	{ hash = -714386060, name = 'zx10r', price = 400000, banido = false, modelo = 'Kawasaki Ninja', capacidade = 30, tipo = 'import' }, -- ok 250 (30)
	{ hash = -486920242, name = 'dm1200', price = 400000, banido = false, modelo = 'Ducati Monster 1200', capacidade = 30, tipo = 'import' }, -- ok 250 (30)
	{ hash = 1744543800, name = 'z1000', price = 400000, banido = false, modelo = 'Kawasaki z1000', capacidade = 30, tipo = 'import' }, -- ok 260 (30)
	{ hash = 1671178289, name = 'd99', price = 400000, banido = false, modelo = 'Ducati 1199 Panigale', capacidade = 30, tipo = 'import' }, -- ok 260 (30)
	{ hash = 341441189, name = 'fz07', price = 400000, banido = false, modelo = 'Yamaha MT-07', capacidade = 30, tipo = 'import' }, -- ok 250 (30)
	{ hash = 1303167849, name = 'f4rr', price = 400000, banido = false, modelo = 'Mv Agusta F4 RR', capacidade = 30, tipo = 'import' }, -- ok 260 (30)
	{ hash = 1047274985, name = 'africat', price = 400000, banido = false, modelo = 'Honda Africa Twin', capacidade = 50, tipo = 'import' }, -- ok 230 (45)
	{ hash = 494265960, name = 'cb500x', price = 400000, banido = false, modelo = 'Honda CB500X', capacidade = 30, tipo = 'import' }, -- ok 250 (30)
	{ hash = -688419137, name = 'hayabusa', price = 400000, banido = false, modelo = 'Suzuki Hayabusa GSX1300', capacidade = 40, tipo = 'import' }, -- ok 320 (50)
	--## Carros VIP ##--
	--## BMW ##--
	{ hash = 1093697054, name = 'bmci', price = 800000, banido = false, modelo = 'BMW M5 F90', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 47055373, name = 'rmodm3e36', price = 800000, banido = false, modelo = 'BMW M3 E36', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 934775262, name = 'rmodm4gts', price = 800000, banido = false, modelo = 'BMW M4 GTS', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -1850735528, name = 'rmodbmwi8', price = 800000, banido = false, modelo = 'BMW I8', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -506359117, name = 'x6m', price = 800000, banido = false, modelo = 'BMW X6M', capacidade = 50, tipo = 'import' }, -- ok
	--## Bentley ##--
	{ hash = -1980604310, name = 'bentaygast', price = 800000, banido = false, modelo = 'Bentley Bentayga', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -2049275303, name = 'ben17', price = 800000, banido = false, modelo = 'Bentley Continental GT', capacidade = 50, tipo = 'import' }, -- ok
	--## Honda ##--
	{ hash = -1745789659, name = 'fk8', price = 800000, banido = false, modelo = 'Honda FK8', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -1549019518, name = 'ap2', price = 800000, banido = false, modelo = 'Honda S2000', capacidade = 50, tipo = 'import' }, -- ok
	--## Nissan ##--
	{ hash = 466040693, name = '370z', price = 800000, banido = false, modelo = 'Nissan 370Z Nismo', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 1221510024, name = 'nissantriton17', price = 800000, banido = false, modelo = 'Nissan Titan Warrior', capacidade = 150, tipo = 'import' }, -- ok
	--## Lamborghini ##--
	{ hash = -1796140063, name = 'lp610', price = 800000, banido = false, modelo = 'Lamborghini Huracan Spyder', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 1454998807, name = 'rmodsian', price = 800000, banido = false, modelo = 'Lamborghini SiÃ¡n FKP', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -520214134, name = 'urus', price = 800000, banido = false, modelo = 'Lamborghini Urus', capacidade = 50, tipo = 'import' }, -- ok
	--## Ferrari ##--
	{ hash = 1361437403, name = 'f4090', price = 800000, banido = false, modelo = 'Ferrari F40', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -784906648, name = 'fct', price = 800000, banido = false, modelo = 'Ferrari California T', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -635747987, name = '458italia', price = 800000, banido = false, modelo = 'Ferrari 458 Italia', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 29976887, name = 'rmodf12tdf', price = 800000, banido = false, modelo = 'Ferrari F12 TDF', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 1128102088, name = 'pistas', price = 800000, banido = false, modelo = 'Ferrari 488 Pista Spider', capacidade = 50, tipo = 'import' }, -- ok
	--## Aston Martin ##--
	{ hash = -1067176722, name = 'vantage', price = 800000, banido = false, modelo = 'Aston Martin Vantage', capacidade = 50, tipo = 'import' }, -- ok 
	--## Audi ##--
	{ hash = 1813965170, name = 'rs7', price = 800000, banido = false, modelo = 'Audi RS7 Sportback', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -1385753106, name = 'r8ppi', price = 800000, banido = false, modelo = 'Audi R8 PPI', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 422090481, name = 'rmodrs6', price = 800000, banido = false, modelo = 'Audi RS6', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 119794591, name = 'sq72016', price = 800000, banido = false, modelo = 'Audi SQ7', capacidade = 50, tipo = 'import' }, -- ok
	--## Chevrolet ##--
	{ hash = -1475032069, name = '21camaro', price = 800000, banido = false, modelo = 'Chevrolet Camaro 2021', capacidade = 50, tipo = 'import' }, -- ok
	--## Ford ##--
	{ hash = -1432034260, name = 'mgt', price = 800000, banido = false, modelo = 'Ford Mustang GT', capacidade = 50, tipo = 'import' }, -- ok
	--## Dodge ##--
	{ hash = 8880015, name = 'rmodcharger69', price = 800000, banido = false, modelo = 'Dodge Charger 1969', capacidade = 50, tipo = 'import' }, -- ok
	--## McLaren ##--
	{ hash = 362375920, name = '600LT', price = 800000, banido = false, modelo = 'McLaren 600LT', capacidade = 50, tipo = 'import' }, -- ok
	--## Toyota ##--
	{ hash = 905399718, name = 'a80', price = 800000, banido = false, modelo = 'Toyota Supra A80', capacidade = 50, tipo = 'import' }, -- ok
	--## Mercedes-Benz ##--
	{ hash = -2136030678, name = 'a45amg', price = 800000, banido = false, modelo = 'Mercedes A45 AMG', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 104532066, name = 'g65amg', price = 800000, banido = false, modelo = 'Mercedes G65 AMG', capacidade = 50, tipo = 'import' }, -- ok
	--## Pagani ##--
	{ hash = -1135949905, name = 'huayra', price = 800000, banido = false, modelo = 'Pagani Huayra', capacidade = 50, tipo = 'import' }, -- ok
	--## Corvette ##--
	{ hash = -1136096889, name = 'stingray', price = 800000, banido = false, modelo = 'Corvette Stingray', capacidade = 50, tipo = 'import' }, -- ok
	--## Mazda ##--
	{ hash = 1324261434, name = 'rx7tunable', price = 800000, banido = false, modelo = 'Mazda RX-7', capacidade = 50, tipo = 'import' }, -- ok
	--## Tesla ##--
	{ hash = -435728526, name = 'teslapd', price = 800000, banido = false, modelo = 'Tesla S P100D', capacidade = 50, tipo = 'import' }, -- ok
	--## VolksWagen ##--
	{ hash = 493030188, name = 'amarok', price = 800000, banido = false, modelo = 'Volkswagen Amarok', capacidade = 150, tipo = 'import' }, -- ok
	--## Porsche ##--
	{ hash = -1382835569, name = 'cayenne', price = 800000, banido = false, modelo = 'Porsche Cayenne Turbo S', capacidade = 150, tipo = 'import' }, -- ok
	--## Carros LUXO ##--
	--## Nissan ##--
	{ hash = -1752116803, name = 'gtr', price = 800000, banido = false, modelo = 'Nissan GT-R ', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 2117711508, name = 'skyline', price = 800000, banido = false, modelo = 'Nissan Skyline R34', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -1835937232, name = 'rmodskyline34', price = 800000, banido = false, modelo = 'Nissan Skyline R34 Brian', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 1674460262, name = 'rmodgtr50', price = 800000, banido = false, modelo = 'Nissan GTR-50', capacidade = 50, tipo = 'import' }, -- ok
	--## Mercedes-Benz ##--
	{ hash = 980885719, name = 'rmodgt63', price = 800000, banido = false, modelo = 'Mercedes AMG GT63', capacidade = 50, tipo = 'import' }, -- ok
	--## Koenigsegg ##--
	{ hash = 1784428761, name = 'rmodjesko', price = 800000, banido = false, modelo = 'Koenigsegg Jesko', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 1085789913, name = 'regera', price = 800000, banido = false, modelo = 'Koenigsegg Regera', capacidade = 50, tipo = 'import' }, -- ok
	--## BMW ##--
	{ hash = 242156012, name = 'rmodbmwm8', price = 800000, banido = false, modelo = 'BMW M8 Competition', capacidade = 50, tipo = 'import' }, -- ok 
	--## Ferrari ##--
	{ hash = 1200120654, name = 'fxxk', price = 800000, banido = false, modelo = 'Ferrari FXX-K', capacidade = 50, tipo = 'import' }, -- ok 
	--## Porsche ##--
	{ hash = 194366558, name = 'panamera17turbo', price = 800000, banido = false, modelo = 'Porsche Panamera Turbo', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = -2091594350, name = '918', price = 800000, banido = false, modelo = 'Porsche 918 Spyder', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 2046572318, name = '911turbos', price = 800000, banido = false, modelo = 'Porsche 911 Turbo S', capacidade = 50, tipo = 'import' }, -- ok
	--## Lamborghini ##--
	{ hash = -42051018, name = 'veneno', price = 800000, banido = false, modelo = 'Lamborghini Veneno', capacidade = 50, tipo = 'import' }, -- ok
	--## Bugatti ##--
	{ hash = 1503141430, name = 'divo', price = 800000, banido = false, modelo = 'Bugatti Divo', capacidade = 50, tipo = 'import' }, -- ok
	--## McLaren ##--
	{ hash = -1370111350, name = '720s', price = 800000, banido = false, modelo = 'McLaren 720s', capacidade = 50, tipo = 'import' }, -- ok
	--## Ferrari ##--
	{ hash = 1561761574, name = '458spc', price = 800000, banido = false, modelo = 'Ferrari 458 Speciale', capacidade = 50, tipo = 'import' }, -- ok
	{ hash = 1644055914, name = 'weevil', price = 10000000, banido = false, modelo = 'VW Fusca', capacidade = 40, tipo = 'compact'},
	{ hash = 2112052861, name = 'pounder', price = 10000000, banido = false, modelo = 'pounder', capacidade = 700, tipo = 'compact'},
	{ hash = -1365970431, name = 's10pequi', price = 10000000, banido = false, modelo = 's10pequi', capacidade = 700, tipo = 'import'},
	}
----------------------------------------------
----------------------------------------------
----------------------------------------------
-- RETORNA A LISTA DE VEÍCULOS
config.getVehList = function()
	return config.vehList
end

-- RETORNA AS INFORMAÇÕES CONTIDAS NA LISTA DE UM VEÍCULO ESPECÍFICO
config.getVehicleInfo = function(vehicle)
	for i in ipairs(config.vehList) do
		if vehicle == config.vehList[i].hash or vehicle == config.vehList[i].name then
            return config.vehList[i]
        end
    end
    return false
end

-- RETORNA O MODELO DE UM VEÍCULO ESPECÍFICO (NOME BONITINHO)
config.getVehicleModel = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.modelo or vehicle
	end
	return vehicle
end

-- RETORNA A CAPACIDADE DO PORTA-MALAS DE UM VEÍCULO ESPECÍFICO
config.getVehicleTrunk = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.capacidade or 0
	end
	return 0
end

-- RETORNA O PREÇO DE UM VEÍCULO ESPECÍFICO
config.getVehiclePrice = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.price or 0
	end
	return 0
end

-- RETORNA O TIPO DE UM VEÍCULO ESPECÍFICO
config.getVehicleType = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.tipo or 0
	end
	return "none"
end

-- RETORNA O STATUS DE BANIDO DE UM VEÍCULO ESPECÍFICO
config.isVehicleBanned = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.banido
	end
	return false
end

function  cnVRP.checkItem()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.tryGetInventoryItem(user_id,"encomenda",1) then
       return true
	else 
		TriggerClientEvent("Notify",source,"error","Você não possui o item encomenda ")
	   return false 
	end
end

function cnVRP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id  then
        randmoney = math.random(500,1000) * 2
	    vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..vRP.format(parseInt(randmoney)).." rupias.")
	end
end

function cnVRP.checkPackeg()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("encomenda") <= vRP.getInventoryMaxWeight(user_id) then
			TriggerClientEvent("progress",source,5000,"Empacontando Encomenda")			
			vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
			SetTimeout(10000,function()
				vRPclient._stopAnim(source,false)
				vRP.giveInventoryItem(user_id,"encomenda",1)
				TriggerClientEvent("Notify",source,"sucesso","Você empacotou a encomenda.")
			end)
		end
	end
end

cnVRP.checkJobActive = function()
	local source = source
	local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("queryEmployer",{ user_id = user_id })
	if #rows > 0 then		
		return rows[1].id	   
	end
	return 0
end

