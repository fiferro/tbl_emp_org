local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

config = {}
Proxy.addInterface("nation_garages", config)

----------------------------------------------
----------------- CONFIG ---------------------
----------------------------------------------
config.detido = 3 -- taxa para ser paga quando o veiculo for detido (porcentagem do valor do veiculo)
config.seguradora = 2 -- taxa para ser paga quando o veiculo estiver apreendido (porcentagem do valor do veiculo)
config.use_tryFullPayment = true -- quando true, aceita pagamentos de taxas com o dinheiro do banco
config.dv_permission = "dv.permissao" -- permissao para dv
config.guardar_veiculo_proximo = true -- mostrar botão de guardar veículo próximo
config.server_side_check = true -- checa se o veículo já foi retirado da garagem pelo player via server-side (o player não conseguirá retirar o veículo até guardá-lo novamente / DV)
----------------------------------------------
----------------- MARKERS --------------------
----------------------------------------------
--- TIPOS DE MARKERS (DEFINIDO NO ATRIBUTO MARKER DE CADA GARAGEM)
config.markers = {
	["avião"] = 33,
	["helicóptero"] = 34,
	["barco"] = 35,
	["carro"] = 36,
	["moto"] = 37,
	["bicicleta"] = 38,
	["truck"] = 39,
}

config.drawMarker = function(coords,marker) -- funcao para desenhar os markers das garagens no chão
	local idTop = config.markers[marker] or config.markers["carro"] 
	local idBase = 27
	DrawMarker(idTop,coords,0,0,0,0,0,0,1.0,1.0,1.0,255, 255, 255,100,1,1,0,0)
end

----------------------------------------------
----------------- BLIPS ----------------------
----------------------------------------------

config.showBlips = false -- quando true, mostra os blips das garagens públicas no mapa
config.blipId = 357 -- id do blip
config.blipColor = 3 -- cor do blip
config.blipSize = 0.4 -- tamanho do blip

----------------------------------------------
-------- DELETAR VEICULOS INATIVOS -----------
----------------------------------------------

config.reset = false -- quando true, deleta os veículos que estão parados durante um determinado tempo
config.tempoReset = 800 -- tempo para deletar um veículo inativo (em minutos)

----------------------------------------------
----------------- IMAGENS --------------------
----------------------------------------------

config.defaultImg = "https://svgsilh.com/svg/160895.svg" -- imagem default
config.imgDir = "http://189.1.172.114/images/" -- url ou diretorio das imagens
----------------------------------------------
----------- LISTA DE VEÍCULOS ----------------
----------------------------------------------
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
	---
	--- viaturas  ---- 
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
	
--------
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
	-- { hash = 1978088379, name = 'lancerevolutionx', price = 1700000, banido = false, modelo = 'Lancer Evolution X', capacidade = 50, tipo = 'import' },
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
	-- { hash = 1221510024, name = 'nissantitan17', price = 1000000, banido = false, modelo = 'Nissan Titan 2017', capacidade = 120, tipo = 'import' },
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


	-----------------------------------------------------------VIP--------------------------------------------------------------------------
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
-----------------------------------(Pasta): vrp_motos----------------------------------------------------
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
		----------------------------------------------------------[vrp_veiculos]-----------------------------------------------------------
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
	-- { hash = 1114244595, name = 'lamborghinihuracan', price = 30000, banido = false, modelo = 'lamborghinihuracan', capacidade = 40, tipo = 'import' },
	{ hash = 1978088379, name = 'lancerevolutionx', price = 30000, banido = false, modelo = 'lancerevolutionx', capacidade = 40, tipo = 'import' },
	{ hash = 2034235290, name = 'mazdarx7', price = 30000, banido = false, modelo = 'mazdarx7', capacidade = 40, tipo = 'import' },
	{ hash = -2015218779, name = 'nissan370z', price = 30000, banido = false, modelo = 'nissan370z', capacidade = 40, tipo = 'import' },
	{ hash = -60313827, name = 'nissangtr', price = 30000, banido = false, modelo = 'nissangtr', capacidade = 40, tipo = 'import' },
	-- { hash = -4816535, name = 'nissanskyliner34', price = 30000, banido = false, modelo = 'nissanskyliner34', capacidade = 40, tipo = 'import' },
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

	----------------------------------------------------------[vrp_veiculosvip2]-----------------------------------------------------------
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



-----------------------------------------------------------------
------------- GARAGENS PÚBLICAS E DE SERVIÇO --------------------
-----------------------------------------------------------------
config.garages = {
	[1] = { type = 'service', coords = vec3(-1077.57, -852.36, 4.89), perm = 'policia.permissao', -- Garagem DP
		vehiclePositions = {
			[1] = { vec3(-1072.77, -854.74, 4.25), h = 220.69 }, 
			[2] = { vec3(-1069.39, -852.29, 4.52), h = 220.69 },
		},
		vehicles = {
		{ vehicle = 'VRa4', modelo = 'Audi' },
		{ vehicle = 'VRrs6av', modelo = 'Audi rs6v' },
		{ vehicle = 'VRdm1200', modelo = 'Ducati' },
		{ vehicle = 'r820p', modelo = 'R820 Speed' }, 
		{ vehicle = 'polraptor', modelo = 'Ranger Raptor' },
		{ vehicle = 'WRclassxv2', modelo = 'Mercedes 4x4' },
		}
	},   

	[2] = { type = 'service', coords = vec3(463.82, -982.28, 43.7), perm = 'policia.permissao',  -- Heli Polciia Praça
  		vehiclePositions = {
			[1] = { vec3(449.18, -981.18, 43.7), h = 89.91 },
  		},
 		 vehicles = {
			{ vehicle = 'polmav', modelo = 'polmav' },
		}
	},	
	[3] = { type = 'service', coords = vec3(-1138.62, -1713.91, 4.78), perm = 'bombeiros.permissao',  -- Bombeiros
	 	 vehiclePositions = {
		[1] = { vec3(-1135.54, -1712.63, 4.62), h = 211.84 },
		[2] = { vec3(-1130.41, -1709.04, 4.62), h = 211.84 },
	  },
	  	vehicles = {
		{ vehicle = 'ambulance', modelo = 'Ambulância de Emergência' },
		{ vehicle = 'firetruk', modelo = 'Caminhão de Bombeiros' },
	  }
	},

	[4] = { type = 'service', coords = vec3(339.12, -586.64, 28.8), perm = 'paramedico.permissao',  --// Paramedico terrestre
		vehiclePositions = {
		  [1] = { vec3(329.99, -588.51, 28.8), h = 336.69 },
		  [2] = { vec3(326.15, -587.8, 28.8), h = 336.69 },
		  [3] = { vec3(323.59, -586.1, 28.8), h = 336.69 },
		},
		vehicles = {
	  		{ vehicle = 'VRtahoe', modelo = 'Tahoe' },  
	  		{ vehicle = 'Wrasprinter', modelo = 'Ambulancia' },  
	  		{ vehicle = 'WRr1200', modelo = 'Resgate Rapido' },  
		}
	},
	[5] = { type = 'service', coords = vec3(338.33,-586.60,74.16), perm = 'paramedico.permissao',  --// Heli Paramédico
		vehiclePositions = {
	 	 [1] = { vec3(350.57,-587.35,74.02), h = 245.40 },
		},
		vehicles = {
		{ vehicle = 'frogger', modelo = 'Helicoptero' },
		{ vehicle = 'seasparrow', modelo = 'seasparrow' },
		}
	},
	[6] = { type = 'service', coords = vec3(-354.12, -155.04, 39.02), perm = 'mecanico.permissao', --GARAGEM DA BENNYS //
		vehiclePositions = {
			[1] = { vec3(-356.04, -161.21, 38.07), h = 32.53 },
		},
		vehicles = {
			{ vehicle = 'flatbed3', modelo = 'flatbed3' },
			{ vehicle = 'yosemite3', modelo = 'yosemite3' },
		}
	},
	[7] = { type = 'service', coords = vec3(454.13, -600.72, 28.58), perm = nil,   -- Motorista //
		vehiclePositions = {
			[1] = { vec3(462.22,-605.06,28.49), h = 220.0 },
		},
		vehicles = {
			{ vehicle = 'coach', modelo = 'Mic.Onibus' },
		}
	},
	[8] = { type = 'service', coords = vec3(899.6, -174.57, 73.92), perm = nil,  -- // Taxi
		vehiclePositions = {
			[1] = { vec3(900.34, -181.21, 73.39), h = 237.10 },
		},
		vehicles = {
			{ vehicle = 'taxi', modelo = 'taxi' },  
		}
	},
	[9] = { type = 'service', coords = vec3(-537.10,-886.54, 25.208), perm = nil, --  // Weazel (CARRO)
		vehiclePositions = {
			[1] = { vec3(-542.19, -892.47, 24.643), h = 100.0 },
		},
		vehicles = {
			{ vehicle = 'rumpo', modelo = 'rumpo' },  
		}
	},	
	[10] = { type = 'service', coords = vec3(-341.19,-1567.68,25.22), perm = nil, -- // Lixeiro
		vehiclePositions = {
			[1] = { vec3(-336.67,-1563.24,24.95), h = 90.84 },
		},
		vehicles = { 
			{ vehicle = 'trash2', modelo = 'trash2' },  
		}
	},
	[11] = { type = 'service', coords = vec3(1054.51,-1952.59,32.09), perm = nil, -- //
		vehiclePositions = {
	 		 [1] = { vec3(1052.62,-1962.34,30.64), h = 182.76 },
		},
		vehicles = {
			{ vehicle = 'tiptruck', modelo = 'tiptruck' },  
		}
	},	
	[12] = { type = 'service', coords = vec3(1200.41,-1276.48, 35.22), perm = nil,  -- Lenhadores
		vehiclePositions = {
	 		[1] = { vec3(1212.45,-1273.60, 34.93), h = 85.64 },
		},
		vehicles = {
	  		{ vehicle = 'ratloader', modelo = 'ratloader' },  
		}
  }	,	
	[13] = { type = 'service', coords = vec3(-1032.1600,-2729.84,13.7566), perm = nil, -- BIKES AEROPORTO//
		vehiclePositions = {
	  		[1] = { vec3(-1018.32, -2732.6, 13.65), h = 244.29 },
	 		[2] = { vec3(-1024.81, -2728.76, 13.66), h = 244.29 }, 
	  		[3] = { vec3(-1014.72, -2734.31, 13.66), h = 244.29 },
		},
		vehicles = {
			{ vehicle = 'scorcher', modelo = 'scorcher' },
			{ vehicle = 'tribike', modelo = 'tribike' },
			{ vehicle = 'tribike2', modelo = 'tribike2' },
			{ vehicle = 'tribike3', modelo = 'tribike3' },
			{ vehicle = 'fixter', modelo = 'fixter' },
			{ vehicle = 'cruiser', modelo = 'cruiser' },
			{ vehicle = 'bmx', modelo = 'bmx' },  
		}
	},		
	[14] = { type = 'public', coords = vec3(55.55,-876.43,30.66), perm = nil, -- GARAGEM 1 - Los Santos
		vehiclePositions = {
			[1] = { vec3(50.66,-873.02,30.45), h = 159.65 },                            -- Mais prox do player
			[2] = { vec3(47.53, -872.55, 29.78), h = 159.65 }, 
			[3] = { vec3(43.67, -871.8, 30.45), h = 159.65 },
		}
	},
	[15] = { type = 'public', coords = vec3(596.4,90.65,93.12), perm = nil,  -- GARAGEM 2 proxi central
		vehiclePositions = {
			[1] = { vec3(599.38,98.16,92.06), h = 249.86 },  
			[2] = { vec3(598.81, 94.25, 92.9), h = 249.86 }, -- Mais prox do player
			[3] = { vec3(601.24, 101.6, 92.91), h = 249.86 }, -- Mais distante
		},
  	},
	[16] = { type = 'public', coords = vec3(-340.76,265.97,85.67), perm = nil,  -- GARAGEM 3
		vehiclePositions = {
			[1] = { vec3(-329.74,274.2,85.44), h = 93.8 },
			[2] = { vec3(-330.61, 277.63, 86.24), h = 93.8 },
			[3] = { vec3(-330.47, 281.18, 86.17), h = 93.8 },
		},
	},
	[17] = { type = 'public', coords = vec3(-2030.01,-465.97,11.6), perm = nil, -- GARAGEM 4
		vehiclePositions = {
			[1] = { vec3(-2024.27,-471.93,11.4), h = 140.0 },   
			[2] = { vec3(-2022.83, -474.82, 11.39), h = 140.0 },
			[3] = { vec3(-2020.05, -476.59, 11.4), h = 140.0 },
		}, 
  	},
	[18] = { type = 'public', coords = vec3(-1184.92,-1510.0,4.64), perm = nil, -- GARAGEM 5 // 
		vehiclePositions = {
			[1] = { vec3(-1183.49,-1495.92,4.37), h = 125.0 },
			[2] = { vec3(-1186.58, -1494.06, 4.38), h = 125.0 },
			[3] = { vec3(-1188.28, -1491.64, 4.38), h = 125.0 },
		},
	},
	[19] = { type = 'public', coords = vec3(-73.44,-2004.99,18.27), perm = nil,  -- GARAGEM 6 //
		vehiclePositions = {
			[1] = { vec3(-84.96,-2004.22,18.01), h = 352.0 },
			[2] = { vec3(-81.05, -2002.57, 18.02), h = 352.0 },
			[3] = { vec3(-88.79, -2001.97, 18.02), h = 352.0 },
		},
	},
	[20] = { type = 'public', coords = vec3(214.02,-808.44,31.01), perm = nil, --GARAGEM 7 (atras da praça) //
		vehiclePositions = {
			[1] = { vec3(222.11,-804.16,29.83), h = 247.0 },
			[2] = { vec3(225.07, -799.47, 30.65), h = 247.0 },
			[3] = { vec3(226.79, -794.48, 30.66), h = 247.0 },
		},
	},

	[21] = { type = 'service', coords = vec3(-1605.19,-1164.37,1.28), perm = nil, --EMBARCAÇÕES --PRAIA
		vehiclePositions = {
			[1] = { vec3(-1609.49,-1169.72,0.71), h = 130.0 },
			[2] = { vec3(-1610.59,-1165.13,0.96), h = 130.0 },
		},
		vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
			{ vehicle = 'seashark3', modelo = 'seashark3' },
		},
	},
	[22] = { type = 'service', coords = vec3(-1522.68,1494.92,111.58), perm = nil, --EMBARCAÇÕES
		vehiclePositions = {
	  		[1] = { vec3(-1526.63,1499.64,109.08), h = 350.0 },
		},
	  	vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
			{ vehicle = 'seashark3', modelo = 'seashark3' },
		},
  	},
	[23] = { type = 'service', coords = vec3(1337.36,4269.71,31.5), perm = nil, --EMBARCAÇÕES - PESCA
		vehiclePositions = {
			[1] = { vec3(1342.19, 4269.05, 30.15), h = 160.0 },
		},
		vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
		},
   	},
	[24] = { type = 'service', coords = vec3(-192.32,791.54,198.1), perm = nil,  --EMBARCAÇÕES
		vehiclePositions = {
			[1] = { vec3(-195.95,788.35,195.93), h = 230.0 },
		},
		vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
			{ vehicle = 'seashark3', modelo = 'seashark3' },
		},
	},
	[25] = { type = 'public', coords = vec3(885.44, -863.18, 26.12), perm = nil, --Garagem Mecanica //
		vehiclePositions = {
		--   [1] = { vec3(883.01, -863.48, 25.49), h = 169.27 },
		--   [2] = { vec3(108.99, -1060.12, 29.2), h = 66.32 },
		--   [3] = { vec3(111.05, -1057.15, 29.2), h = 66.32 },
			[1] = { vec3(883.05, -864.77, 26.16), h = 180.85 },
			[2] = { vec3(878.78, -865.21, 26.08), h = 180.85 },
		},
	},
	[26] = { type = 'service', coords = vec3(2832.27, 2797.7, 57.46), perm = nil, --Garagem Minerador  //
		vehiclePositions = {
			[1] = { vec3(2827.94, 2798.07, 57.65), h = 161.46 },
		},
		vehicles = {
			{ vehicle = 'tiptruck', modelo = 'Mineradora' },
		}
  	},
	[27] = { type = 'service', coords = vec3(448.42, 6462.58, 28.99), perm = nil, -- Garagem Graos  //
		vehiclePositions = {
			[1] = { vec3(452.68, 6459.54, 29.61), h = 220.40 },
			[2] = { vec3(450.5, 6455.49, 29.53), h = 220.40 },
		},
		vehicles = {
			{ vehicle = 'tractor2', modelo = 'Tractor2' },
			{ vehicle = 'rebel', modelo = 'Rebel' },
		}
	},
	[28] = { type = 'service', coords = vec3(53.44, 114.78, 79.2), perm = nil, --Garagem Carteiro  //
		vehiclePositions = {
			[1] = { vec3(67.5, 122.15, 79.13), h = 162.85 },
		},
		vehicles = {
			{ vehicle = 'boxville2', modelo = 'Van de Entregas' },
		}
	},
	[29] = { type = 'service', coords = vec3(846.66, -961.26, 26.53), perm = 'mecanico.permissao', -- Garagem Mecanica para os mecanicos  //
		vehiclePositions = {
				[1] = { vec3(856.26, -945.63, 26.28), h = 120 }, 
				[2] = { vec3(849.66, -957.07, 26.29), h = 120},
		},
		vehicles = {
			{ vehicle = 'flatbed', modelo = 'Flatebed' },
			{ vehicle = 'slamvan3', modelo = 'Slamvan3' },
		}
 	},
	[30] = { type = 'public', coords = vec3(2544.72, -760.15, 84.16), perm = nil, -- Favela FBI  //
	 	vehiclePositions = {
		  	[1] = { vec3(2549.55, -759.66, 83.43), h = 2.88 },
	 	--   [2] = { vec3(1547.43, 3780.89, 34.07), h = 27.98 },
	 	},
	},

	[31] = { type = 'public', coords = vec3(699.63, -285.57, 59.27), perm = nil, -- Favela Campínho  //
		vehiclePositions = {
		[1] = { vec3(702.29, -287.32, 59.32), h = 205.85 },
		--   [2] = { vec3(1547.43, 3780.89, 34.07), h = 27.98 },
		},
	},
	[32] = { type = 'service', coords = vec3(-1133.71, -2861.2, 13.95), perm = 'volatus.permissao', marker = "helicóptero", -- GARAGEM 8 aeroporto //
		vehiclePositions = {
	      [1] = { vec3(-1145.69, -2864.46, 13.95) },
		},
		vehicles = {
			{ vehicle = 'volatus', modelo = 'Volatus' },
			
		}
  	},
	  [33] = { type = 'public', coords = vec3(157.26, -124.67, 54.83), perm = nil,  -- Concessionaria  //
	vehiclePositions = {
	  [1] = { vec3(153.57, -123.25, 54.83), h = 339.38 },
	  [2] = { vec3(149.49, -121.41, 54.83), h = 339.38 },
	  
	},
  },	
	  [34] = { type = 'public', coords = vec3(361.9,297.81,103.88), perm = nil, -- Loja 6  //
	vehiclePositions = {
	  [1] = { vec3(361.08,293.5,102.65), h = 249.67 },
	  [2] = { vec3(359.96, 289.89, 103.51), h = 249.67 },
	  [3] = { vec3(357.82, 286.62, 103.51), h = 249.67 },
	},
  },
	  [35] = { type = 'public', coords = vec3(-773.34,5598.15,33.6), perm = nil, -- Teleferico GARAGEM 11(RESPAW PALETO) //
	vehiclePositions = {
	  [1] = { vec3(-772.82,5578.48,32.64), h = 89.01 },
	  [2] = { vec3(-772.52, 5572.67, 33.49), h = 89.01 }, 
	},
  },
	  [36] = { type = 'public', coords = vec3(323.5,-203.07,54.08), perm = nil, -- Vila do Chaves //
	vehiclePositions = {
	  [1] = { vec3(318.07,-203.28,53.24), h = 249.14 },
	  [2] = { vec3(317.4, -206.44, 54.09), h = 249.14 },
	  [3] = { vec3(316.23, -210.4, 54.09), h = 249.14 },
	},
  },
	  [37] = { type = 'public', coords = vec3(317.25,2623.14,44.46), perm = nil, -- Posto 12 GARAGEM 13 //
	vehiclePositions = {
	  [1] = { vec3(334.52,2623.09,44.49), h = 20.0 },
	},
  },
	  [38] = { type = 'public', coords = vec3(1156.9,-453.73,66.98), perm = nil, -- Barbearia 5 GARAGEM 14 //
	vehiclePositions = {
	  [1] = { vec3(1155.2,-461.58,65.97), h = 167.96 },
	  [2] = { vec3(1158.49, -463.41, 66.78), h = 167.96 },
	  [3] = { vec3(1161.52, -464.83, 66.66), h = 167.96 },
	},
  },
	  [39] = { type = 'public', coords = vec3(-102.21,6345.18,31.57), perm = nil, -- Em frente ao galinheiro GARAGEM 15 //
	vehiclePositions = {
	  [1] = { vec3(-98.29,6341.76,30.64), h = 224.27 },
	  [2] = { vec3(-100.56, 6338.39, 31.5), h = 224.27 },
	  [3] = { vec3(-94.26, 6343.83, 31.5), h = 224.27 },
	},
  },

	  [40] = { type = 'public', coords = vec3(1539.67,3780.9,34.06), perm = nil, -- proximo ammu 11 Garagem do norte  //
	vehiclePositions = {
	  [1] = { vec3(1543.06,3780.08,33.64), h = 27.98 },
	  [2] = { vec3(1547.43, 3780.89, 34.07), h = 27.98 },
	},
  },
  	  [41] = { type = 'service', coords = vec3(959.25,-121.06,74.97), perm = 'thelost.permissao', --Garagem MotoClube  //
	vehiclePositions = {
	  [1] = { vec3(950.86, -123.76, 74.02), h = 215.52 },	  
	},
	vehicles = {
		{ vehicle = 'sanctus', modelo = 'Sanctus' },
		{ vehicle = 'gburrito', modelo = 'Van' },
	}
  },

  	 [42] = { type = 'public', coords = vec3(-1120.73,-832.72,13.34), perm = nil, -- Policia //
	vehiclePositions = {
	  [1] = { vec3(-1126.37,-836.86,12.82), h = 215.52 },
	  
	},
  },

  [43] = { type = 'public', coords = vec3(-2418.17, 1777.42, 187.62), perm = nil, -- França //
	vehiclePositions = {
	  [1] = { vec3(-2423.4, 1778.94, 187.1), h = 43.16 },
	  
	},
  },
	
  [44] = { type = 'public', coords = vec3(-2606.23, 2891.78, 4.84), perm = nil, -- 
	vehiclePositions = {
	  [1] = { vec3(-2613.4, 2899.49, 5.35), h = 61.71 },
	  
	},
  },
	
  [45] = { type = 'public', coords = vec3(2444.08, 3813.57, 39.91), perm = nil, -- Favela norte //
  vehiclePositions = {
	[1] = { vec3(2437.55, 3804.68, 39.68), h = 127.92 },
	
  },
},   
  [46] = { type = 'public', coords = vec3(143.22, -1290.34, 29.37), perm = nil, -- Vanilla //
  vehiclePositions = {
	[1] = { vec3(144.54, -1284.63, 28.94), h = 300.47 },
	[2] = { vec3(143.46, -1281.62, 28.6), h = 300.47 },
	
  },
},
[47] = { type = 'service', coords = vec3(-1133.71, -2861.2, 13.95), perm = 'swift.permissao', marker = "helicóptero", -- GARAGEM 8 aeroporto //
		vehiclePositions = {
	      [1] = { vec3(-1145.69, -2864.46, 13.95) },
		},
		vehicles = {
			{ vehicle = 'swift', modelo = 'Swift' },
			
		}
  	},
[48] = { type = 'public', coords = vec3(115.09, -1954.73, 20.75), perm = nil, -- Groove - cartel //
	  vehiclePositions = {
		[1] = { vec3(114.32, -1947.81, 20.5), h = 54.06 },
	  },
	},	  
[49] = { type = 'public', coords = vec3(604.71, -3127.02, 6.07), perm = nil, -- Groove - galpão //
	vehiclePositions = {
	    [1] = { vec3(609.68, -3130.71, 6.07), h = 300.15 },	  
	    [2] = { vec3( 609.38, -3123.63, 6.07), h = 300.15 },	  
	  },
	},
[50] = { type = 'public', coords = vec3(-1910.58,2023.78, 140.84), perm = nil, -- vinhedo - galpão //
	vehiclePositions = {
	  [1] = { vec3(-1904.66, 2021.21, 140.77), h = 267.968 },
	  [2] = { vec3(-1905.59, 2016.96, 140.94), h = 267.968 },
	},
  },	  	
}
-----------------------------------------------------------------
------------------ GARAGENS DAS CASAS ---------------------------
-----------------------------------------------------------------

config.homeGarages = {
	[1] = { type = 'home', coords = vec3(21.41,548.3,176.02),
	  vehiclePositions = {
		[1] = { vec3(14.98,549.89,175.5), h = 60.7 },
	  },
	  home = 'MS01'
	},
	[2] = { type = 'home', coords = vec3(-813.06,184.23,72.47),
	  vehiclePositions = {
		[1] = { vec3(-821.16,185.31,71.25), h = 119.13 },
	  },
	  home = 'MS02'
	},
	[3] = { type = 'home', coords = vec3(-681.48,901.64,230.57),
	  vehiclePositions = {
		[1] = { vec3(-675.44,903.59,229.73), h = 326.35 },
	  },
	  home = 'MS03'
	},
	[4] = { type = 'home', coords = vec3(-2596.87,1927.04,167.31),
	  vehiclePositions = {
		[1] = { vec3(-2588.73,1929.85,166.46), h = 275.01 },
	  },
	  home = 'MS04'
	},
	[5] = { type = 'home', coords = vec3(-3014.84,740.75,27.58),
	  vehiclePositions = {
		[1] = { vec3(-3019.92,740.24,26.63), h = 103.34 },
	  },
	  home = 'MS05'
	},
	[6] = { type = 'home', coords = vec3(-1890.29,-572.99,11.82),
	  vehiclePositions = {
		[1] = { vec3(-1886.63,-571.43,10.93), h = 319.54 },
	  },
	  home = 'MS09'
	},
	[7] = { type = 'home', coords = vec3(1551.96,2190.1,78.85),
	  vehiclePositions = {
		[1] = { vec3(1554.26,2196.07,78.5), h = 352.11 },
	  },
	  home = 'SS01'
	},
	[8] = { type = 'home', coords = vec3(-2977.14,650.92,25.78),
	  vehiclePositions = {
		[1] = { vec3(-2982.74,654.65,25.015), h = 106.83 },
	  },
	  home = 'MS08'
	},
	[9] = { type = 'home', coords = vec3(81.27,6644.04,31.93),
	vehiclePositions = {
	  [1] = { vec3(72.41,6635.25,31.75), h = 142.72 },
	},
	home = 'PB31'
  },
	[10] = { type = 'home', coords = vec3(-1937.07,577.96,119.56),
	  vehiclePositions = {
		[1] = { vec3(-1943.92,583.37,118.79), h = 255.987 },
	  },
	  home = 'LX41'
	},
	[11] = { type = 'home', coords = vec3(-491.13,751.51,162.84),
	  vehiclePositions = {
		[1] = { vec3(-492.05,745.92,162.84), h = 329.81 },
	  },
	  home = 'FH85'
	},
	[12] = { type = 'home', coords = vec3(-877.56,497.95,91.02),
	  vehiclePositions = {
		[1] = { vec3(-872.97,499.76,90.47), h = 106.56 },
	  },
	  home = 'FH02'
	},
	[13] = { type = 'home', coords = vec3(-1005.17,715.55,164.0),
	  vehiclePositions = {
		[1] = { vec3(-1006.29,709.66,162.37), h = 344.07 },
	  },
	  home = 'FH16'
	},
	[14] = { type = 'home', coords = vec3(151.2,568.06,183.98),
	  vehiclePositions = {
		[1] = { vec3(148.7,572.69,183.95), h = 86.85 },
	  },
	  home = 'LX57'
	},
	[15] = { type = 'home', coords = vec3(-864.47,463.46,88.22),
	  vehiclePositions = {
		[1] = { vec3(-861.31,462.66,86.93), h = 276.73 },
	  },
	  home = 'FH01'
	},
	[16] = { type = 'home', coords = vec3(-850.62,522.18,90.62),
	  vehiclePositions = {
		[1] = { vec3(-851.05,514.29,90.15), h = 106.56 },
	  },
	  home = 'FH04'
	},
	[17] = { type = 'home', coords = vec3(-938.56,445.34,80.42),
	  vehiclePositions = {
		[1] = { vec3(-942.71,443.81,79.99), h = 198.88 },
	  },
	  home = 'FH11'
	},
	[18] = { type = 'home', coords = vec3(-1074.27,468.75,77.82),
	  vehiclePositions = {
		[1] = { vec3(-1079.1,465.49,76.79), h = 144.79 },
	  },
	  home = 'FH15'
	},
	[19] = { type = 'home', coords = vec3(-971.31,455.98,79.82),
	  vehiclePositions = {
		[1] = { vec3(-967.03,450.03,78.97), h = 199.58 },
	  },
	  home = 'FH19'
	},
	[20] = { type = 'home', coords = vec3(-736.59,439.85,106.9),
	  vehiclePositions = {
		[1] = { vec3(-736.19,446.59,105.88), h = 3.21 },
	  },
	  home = 'FH23'
	},
	[21] = { type = 'home', coords = vec3(-716.59,500.53,109.27),
	  vehiclePositions = {
		[1] = { vec3(-716.94,495.36,108.43), h = 206.78 },
	  },
	  home = 'FH24'
	},
	[22] = { type = 'home', coords = vec3(-692.91,507.84,110.36),
	  vehiclePositions = {
		[1] = { vec3(-688.85,500.77,109.21), h = 201.51 },
	  },
	  home = 'FH26'
	},
	[23] = { type = 'home', coords = vec3(-574.21,492.54,106.97),
	  vehiclePositions = {
		[1] = { vec3(-573.79,498.15,105.38), h = 9.46 },
	  },
	  home = 'FH29'
	},
	[24] = { type = 'home', coords = vec3(-589.59,531.83,108.17),
	  vehiclePositions = {
		[1] = { vec3(-586.67,526.68,106.72), h = 215.41 },
	  },
	  home = 'FH31'
	},
	[25] = { type = 'home', coords = vec3(-574.01,394.76,100.67),
	  vehiclePositions = {
		[1] = { vec3(-574.73,401.65,99.82), h = 19.61 },
	  },
	  home = 'FH32'
	},
	[26] = { type = 'home', coords = vec3(-447.07,376.54,104.77),
	  vehiclePositions = {
		[1] = { vec3(-456.49,372.48,103.93), h = 358.58 },
	  },
	  home = 'FH45'
	},
	[27] = { type = 'home', coords = vec3(-523.67,525.26,112.44),
	  vehiclePositions = {
		[1] = { vec3(-526.66,530.68,110.95), h = 44.11 },
	  },
	  home = 'FH48'
	},
	[28] = { type = 'home', coords = vec3(-517.36,578.31,120.84),
	  vehiclePositions = {
		[1] = { vec3(-511.63,577.15,119.52), h = 97.85 },
	  },
	  home = 'FH49'
	},
	[29] = { type = 'home', coords = vec3(-470.24,538.11,121.46),
	  vehiclePositions = {
		[1] = { vec3(-468.04,542.62,119.92), h = 355.06 },
	  },
	  home = 'FH52'
	},
	[30] = { type = 'home', coords = vec3(-397.25,512.34,120.19),
	  vehiclePositions = {
		[1] = { vec3(-398.63,518.94,119.68), h = 355.21 },
	  },
	  home = 'FH54'
	},
	[31] = { type = 'home', coords = vec3(-356.43,473.56,112.52),
	  vehiclePositions = {
		[1] = { vec3(-351.33,474.7,111.89), h = 299.59 },
	  },
	  home = 'FH55'
	},
	[32] = { type = 'home', coords = vec3(-357.14,517.38,120.15),
	  vehiclePositions = {
		[1] = { vec3(-362.62,514.72,118.67), h = 134.89 },
	  },
	  home = 'FH58'
	},
	[33] = { type = 'home', coords = vec3(-312.45,483.18,113.46),
	  vehiclePositions = {
		[1] = { vec3(-320.42,480.85,111.44), h = 118.55 },
	  },
	  home = 'FH59'
	},
	[34] = { type = 'home', coords = vec3(-1371.63,451.89,105.34),
	  vehiclePositions = {
		[1] = { vec3(-1376.73,453.26,104.04), h = 80.28 },
	  },
	  home = 'FH68'
	},
	[35] = { type = 'home', coords = vec3(-463.57,676.11,148.54),
	  vehiclePositions = {
		[1] = { vec3(-467.37,673.46,146.8), h = 148.4 },
	  },
	  home = 'FH81'
	},
	[36] = { type = 'home', coords = vec3(-956.88,804.188,177.56),
	  vehiclePositions = {
		[1] = { vec3(-958.62,800.59,176.76), h = 152.94 },
	  },
	  home = 'FH91'
	},
	[37] = { type = 'home', coords = vec3(-921.15,813.8,184.33),
	  vehiclePositions = {
		[1] = { vec3(-920.0,806.38,183.37), h = 189.06 },
	  },
	  home = 'FH92'
	},
	[38] = { type = 'home', coords = vec3(-1004.0,783.99,171.38),
	  vehiclePositions = {
		[1] = { vec3(-997.95,786.76,171.06), h = 293.5 },
	  },
	  home = 'FH93'
	},
	[39] = { type = 'home', coords = vec3(-810.25,803.55,202.18),
	  vehiclePositions = {
		[1] = { vec3(-811.6,809.51,201.24), h = 19.71 },
	  },
	  home = 'FH94'
	},
	[40] = { type = 'home', coords = vec3(-876.54,-57.11,38.05),
	  vehiclePositions = {
		[1] = { vec3(-869.45,-54.25,37.6), h = 281.38 },
	  },
	  home = 'LX01'
	},
	[41] = { type = 'home', coords = vec3(-890.55,-17.35,43.1),
	  vehiclePositions = {
		[1] = { vec3(-885.98,-16.18,42.15), h = 304.12 },
	  },
	  home = 'LX02'
	},
	[42] = { type = 'home', coords = vec3(-872.28,51.35,48.78),
	  vehiclePositions = {
		[1] = { vec3(-875.02,46.86,48.39), h = 195.46 },
	  },
	  home = 'LX03'
	},
	[43] = { type = 'home', coords = vec3(-969.08,107.74,55.66),
	  vehiclePositions = {
		[1] = { vec3(-960.77,109.36,55.49), h = 314.26 },
	  },
	  home = 'LX04'
	},
	[44] = { type = 'home', coords = vec3(-1885.63,629.92,129.99),
	  vehiclePositions = {
		[1] = { vec3(-1890.51,626.0,129.15), h = 136.16 },
	  },
	  home = 'LX05'
	},
	[45] = { type = 'home', coords = vec3(-997.43,142.37,60.66),
	  vehiclePositions = {
		[1] = { vec3(-992.02,144.19,59.81), h = 269.99 },
	  },
	  home = 'LX06'
	},
	[46] = { type = 'home', coords = vec3(-1045.16,224.98,63.76),
	  vehiclePositions = {
		[1] = { vec3(-1048.01,219.47,62.91), h = 184.73 },
	  },
	  home = 'LX07'
	},
	[47] = { type = 'home', coords = vec3(-923.9,212.7,67.46),
	  vehiclePositions = {
		[1] = { vec3(-933.57,210.69,66.61), h = 163.52 },
	  },
	  home = 'LX08'
	},
	[48] = { type = 'home', coords = vec3(-905.04,196.27,69.5),
	  vehiclePositions = {
		[1] = { vec3(-911.78,190.68,68.59), h = 179.92 },
	  },
	  home = 'LX09'
	},
	[49] = { type = 'home', coords = vec3(-915.48,114.68,55.31),
	  vehiclePositions = {
		[1] = { vec3(-920.41,112.49,54.47), h = 84.9 },
	  },
	  home = 'LX10'
	},
	[50] = { type = 'home', coords = vec3(-931.72,13.37,47.91),
	  vehiclePositions = {
		[1] = { vec3(-925.27,9.31,46.87), h = 214.83 },
	  },
	  home = 'LX11'
	},
	[51] = { type = 'home', coords = vec3(-835.07,119.47,55.46),
	  vehiclePositions = {
		[1] = { vec3(-839.12,112.3,54.43), h = 210.36 },
	  },
	  home = 'LX12'
	},
	[52] = { type = 'home', coords = vec3(-1058.75,299.58,66.0),
	  vehiclePositions = {
		[1] = { vec3(-1061.49,305.25,65.13), h = 353.81 },
	  },
	  home = 'LX13'
	},
	[53] = { type = 'home', coords = vec3(-827.87,267.95,86.2),
	  vehiclePositions = {
		[1] = { vec3(-824.72,273.44,85.68), h = 342.78 },
	  },
	  home = 'LX14'
	},
	[54] = { type = 'home', coords = vec3(-869.56,322.71,83.97),
	  vehiclePositions = {
		[1] = { vec3(-870.29,317.83,83.13), h = 186.23 },
	  },
	  home = 'LX15'
	},
	[55] = { type = 'home', coords = vec3(-1026.73,363.75,71.36),
	  vehiclePositions = {
		[1] = { vec3(-1011.08,360.01,70.05), h = 331.43 },
	  },
	  home = 'LX17'
	},
	[56] = { type = 'home', coords = vec3(-1555.85,426.75,109.62),
	  vehiclePositions = {
		[1] = { vec3(-1547.98,426.58,109.09), h = 272.82 },
	  },
	  home = 'LX18'
	},
	[57] = { type = 'home', coords = vec3(-1211.88,274.79,69.51),
	  vehiclePositions = {
		[1] = { vec3(-1204.83,267.12,68.69), h = 284.35 },
	  },
	  home = 'LX19'
	},
	[58] = { type = 'home', coords = vec3(-1101.71,354.46,68.48),
	  vehiclePositions = {
		[1] = { vec3(-1096.63,360.3,67.69), h = 357.45 },
	  },
	  home = 'LX20'
	},
	[59] = { type = 'home', coords = vec3(-1490.24,18.76,54.71),
	  vehiclePositions = {
		[1] = { vec3(-1490.16,23.07,53.88), h = 354.88 },
	  },
	  home = 'LX21'
	},
	[60] = { type = 'home', coords = vec3(-1457.65,-50.22,54.65),
	  vehiclePositions = {
		[1] = { vec3(-1455.68,-55.37,52.6), h = 240.6 },
	  },
	  home = 'LX22'
	},
	[61] = { type = 'home', coords = vec3(-1504.43,19.84,56.4),
	  vehiclePositions = {
		[1] = { vec3(-1503.75,26.86,55.15), h = 8.38 },
	  },
	  home = 'LX23'
	},
	[62] = { type = 'home', coords = vec3(-1581.46,-81.3,54.2),
	  vehiclePositions = {
		[1] = { vec3(-1577.19,-86.02,53.29), h = 270.66 },
	  },
	  home = 'LX24'
	},
	[63] = { type = 'home', coords = vec3(-1585.69,-55.63,56.48),
	  vehiclePositions = {
		[1] = { vec3(-1582.02,-61.06,55.64), h = 270.18 },
	  },
	  home = 'LX25'
	},
	[64] = { type = 'home', coords = vec3(-1558.52,17.86,58.83),
	  vehiclePositions = {
		[1] = { vec3(-1552.69,22.78,57.7), h = 347.5 },
	  },
	  home = 'LX26'
	},
	[65] = { type = 'home', coords = vec3(-1616.73,14.71,62.17),
	  vehiclePositions = {
		[1] = { vec3(-1613.07,20.02,61.32), h = 335.94 },
	  },
	  home = 'LX27'
	},
	[66] = { type = 'home', coords = vec3(-1892.99,120.59,81.64),
	  vehiclePositions = {
		[1] = { vec3(-1887.23,123.26,80.86), h = 338.84 },
	  },
	  home = 'LX28'
	},
	[67] = { type = 'home', coords = vec3(-1940.13,179.1,84.66),
	  vehiclePositions = {
		[1] = { vec3(-1932.93,182.84,83.68), h = 307.83 },
	  },
	  home = 'LX29'
	},
	[68] = { type = 'home', coords = vec3(-2000.65,296.59,91.76),
	  vehiclePositions = {
		[1] = { vec3(-1994.21,290.29,90.85), h = 221.21 },
	  },
	  home = 'LX32'
	},
	[69] = { type = 'home', coords = vec3(-2013.18,453.64,102.67),
	  vehiclePositions = {
		[1] = { vec3(-2006.95,454.86,101.79), h = 276.63 },
	  },
	  home = 'LX34'
	},
	[70] = { type = 'home', coords = vec3(-2016.62,485.7,107.18),
	  vehiclePositions = {
		[1] = { vec3(-2011.39,482.71,106.07), h = 255.38 },
	  },
	  home = 'LX35'
	},
	[71] = { type = 'home', coords = vec3(-1868.36,192.09,84.29),
	  vehiclePositions = {
		[1] = { vec3(-1874.17,194.45,83.77), h = 126.46 },
	  },
	  home = 'LX36'
	},
	[72] = { type = 'home', coords = vec3(-1899.62,241.7,86.26),
	  vehiclePositions = {
		[1] = { vec3(-1904.45,242.14,85.6), h = 27.89 },
	  },
	  home = 'LX37'
	},
	[73] = { type = 'home', coords = vec3(-1918.91,285.25,89.07),
	  vehiclePositions = {
		[1] = { vec3(-1925.28,283.01,88.23), h = 182.84 },
	  },
	  home = 'LX38'
	},
	[74] = { type = 'home', coords = vec3(-1935.69,366.09,93.82),
	  vehiclePositions = {
		[1] = { vec3(-1940.58,360.31,92.55), h = 160.68 },
	  },
	  home = 'LX39'
	},
	[75] = { type = 'home', coords = vec3(-1938.82,386.17,96.5),
	  vehiclePositions = {
		[1] = { vec3(-1943.95,385.19,95.6), h = 96.89 },
	  },
	  home = 'LX40'
	},
	[76] = { type = 'home', coords = vec3(-1937.4,462.55,102.42),
	  vehiclePositions = {
		[1] = { vec3(-1947.37,462.9,101.12), h = 99.05 },
	  },
	  home = 'LX41'
	},
	[77] = { type = 'home', coords = vec3(-1856.34,322.6,88.72),
	  vehiclePositions = {
		[1] = { vec3(-1857.45,328.42,87.8), h = 11.41 },
	  },
	  home = 'LX42'
	},
	[78] = { type = 'home', coords = vec3(-1789.94,345.73,88.55),
	  vehiclePositions = {
		[1] = { vec3(-1790.72,353.87,87.72), h = 64.22 },
	  },
	  home = 'LX43'
	},
	[79] = { type = 'home', coords = vec3(-1745.31,368.33,89.72),
	  vehiclePositions = {
		[1] = { vec3(-1750.77,365.56,88.85), h = 114.91 },
	  },
	  home = 'LX44'
	},
	[80] = { type = 'home', coords = vec3(-1665.21,385.25,89.49),
	  vehiclePositions = {
		[1] = { vec3(-1663.42,391.43,88.39), h = 9.57 },
	  },
	  home = 'LX45'
	},
	[81] = { type = 'home', coords = vec3(-1785.52,456.14,128.3),
	  vehiclePositions = {
		[1] = { vec3(-1794.11,459.4,127.46), h = 98.09 },
	  },
	  home = 'LX46'
	},
	[82] = { type = 'home', coords = vec3(-1991.66,605.61,117.9),
	  vehiclePositions = {
		[1] = { vec3(-1985.63,602.72,117.28), h = 238.48 },
	  },
	  home = 'LX47'
	},
	[83] = { type = 'home', coords = vec3(-1937.7,529.39,110.73),
	  vehiclePositions = {
		[1] = { vec3(-1944.07,521.99,108.31), h = 71.0 },
	  },
	  home = 'LX48'
	},
	[84] = { type = 'home', coords = vec3(-1977.58,624.88,122.53),
	  vehiclePositions = {
		[1] = { vec3(-1971.35,620.69,121.14), h = 246.1 },
	  },
	  home = 'LX50'
	},
	[85] = { type = 'home', coords = vec3(-165.4,919.61,235.65),
	  vehiclePositions = {
		[1] = { vec3(-162.36,926.68,234.8), h = 234.16 },
	  },
	  home = 'LX51'
	},
	[86] = { type = 'home', coords = vec3(-172.67,966.12,237.53),
	  vehiclePositions = {
		[1] = { vec3(-167.03,970.73,235.79), h = 316.56 },
	  },
	  home = 'LX52'
	},
	[87] = { type = 'home', coords = vec3(-124.76,1010.75,235.73),
	  vehiclePositions = {
		[1] = { vec3(-127.89,1001.16,234.88), h = 198.68 },
	  },
	  home = 'LX53'
	},
	[88] = { type = 'home', coords = vec3(-101.17,823.95,235.72),
	  vehiclePositions = {
		[1] = { vec3(-105.63,832.61,234.86), h = 10.25 },
	  },
	  home = 'LX54'
	},
	[89] = { type = 'home', coords = vec3(220.71,755.29,204.85),
	  vehiclePositions = {
		[1] = { vec3(215.84,759.38,203.83), h = 47.56 },
	  },
	  home = 'LX55'
	},
	[90] = { type = 'home', coords = vec3(100.21,563.99,182.94),
	  vehiclePositions = {
		[1] = { vec3(93.13,575.77,182.13), h = 86.85 },
	  },
	  home = 'LX58'
	},
	[91] = { type = 'home', coords = vec3(52.84,559.77,180.21),
	  vehiclePositions = {
		[1] = { vec3(53.19,563.71,179.54), h = 21.7 },
	  },
	  home = 'LX59'
	},
	[92] = { type = 'home', coords = vec3(-143.65,593.14,203.9),
	  vehiclePositions = {
		[1] = { vec3(-142.21,597.23,203.12), h = 358.34 },
	  },
	  home = 'LX60'
	},
	[93] = { type = 'home', coords = vec3(-196.6,621.58,197.91),
	  vehiclePositions = {
		[1] = { vec3(-199.24,615.31,196.21), h = 178.98 },
	  },
	  home = 'LX61'
	},
	[94] = { type = 'home', coords = vec3(-174.92,590.04,197.63),
	  vehiclePositions = {
		[1] = { vec3(-178.23,587.21,197.03), h = 359.63 },
	  },
	  home = 'LX62'
	},
	[95] = { type = 'home', coords = vec3(-224.87,588.93,190.02),
	  vehiclePositions = {
		[1] = { vec3(-221.77,593.25,189.61), h = 331.22 },
	  },
	  home = 'LX63'
	},
	[96] = { type = 'home', coords = vec3(-271.65,599.1,181.68),
	  vehiclePositions = {
		[1] = { vec3(-272.26,603.6,181.15), h = 346.6 },
	  },
	  home = 'LX64'
	},
	[97] = { type = 'home', coords = vec3(-241.91,614.9,187.77),
	  vehiclePositions = {
		[1] = { vec3(-244.12,610.79,186.09), h = 149.22 },
	  },
	  home = 'LX65'
	},
	[98] = { type = 'home', coords = vec3(1290.05,-585.69,71.75),
	  vehiclePositions = {
		[1] = { vec3(1295.49,-567.62,71.49), h = 344.65 },
	  },
	  home = 'LS01'
	},
	[99] = { type = 'home', coords = vec3(1311.03,-593.07,72.93),
	  vehiclePositions = {
		[1] = { vec3(1319.19,-575.18,73.25), h = 336.97 },
	  },
	  home = 'LS02'
	},
	[100] = { type = 'home', coords = vec3(1344.65,-609.86,74.36),
	  vehiclePositions = {
		[1] = { vec3(1348.97,-603.76,74.64), h = 334.73 },
	  },
	  home = 'LS03'
	},
	[101] = { type = 'home', coords = vec3(1359.91,-620.48,74.34),
	  vehiclePositions = {
		[1] = { vec3(1360.55,-601.83,74.62), h = 359.42 },
	  },
	  home = 'LS04'
	},
	[102] = { type = 'home', coords = vec3(1392.87,-607.72,74.35),
	  vehiclePositions = {
		[1] = { vec3(1378.33,-596.21,74.61), h = 52.88 },
	  },
	  home = 'LS05'
	},
	[103] = { type = 'home', coords = vec3(1404.84,-570.68,74.35),
	  vehiclePositions = {
		[1] = { vec3(1387.73,-577.37,74.62), h = 113.2 },
	  },
	  home = 'LS06'
	},
	[104] = { type = 'home', coords = vec3(1366.95,-544.46,74.34),
	  vehiclePositions = {
		[1] = { vec3(1363.05,-551.94,74.62), h = 157.25 },
	  },
	  home = 'LS07'
	},
	[105] = { type = 'home', coords = vec3(1360.66,-536.8,73.78),
	  vehiclePositions = {
		[1] = { vec3(1352.89,-553.3,74.31), h = 156.76 },
	  },
	  home = 'LS08'
	},
	[106] = { type = 'home', coords = vec3(1322.0,-524.9,72.13),
	  vehiclePositions = {
		[1] = { vec3(1318.24,-532.96,72.35), h = 160.86 },
	  },
	  home = 'LS09'
	},
	[107] = { type = 'home', coords = vec3(1314.79,-516.59,71.41),
	  vehiclePositions = {
		[1] = { vec3(1307.96,-533.58,71.56), h = 160.38 },
	  },
	  home = 'LS10'
	},
	[108] = { type = 'home', coords = vec3(1245.08,-518.7,69.0),
	  vehiclePositions = {
		[1] = { vec3(1247.17,-522.7,69.25), h = 257.36 },
	  },
	  home = 'LS11'
	},
	[109] = { type = 'home', coords = vec3(1251.25,-490.29,69.5),
	  vehiclePositions = {
		[1] = { vec3(1260.63,-494.22,69.59), h = 255.66 },
	  },
	  home = 'LS12'
	},
	[110] = { type = 'home', coords = vec3(1259.55,-477.81,70.19),
	  vehiclePositions = {
		[1] = { vec3(1280.06,-472.81,69.24), h = 170.02 },
	  },
	  home = 'LS13'
	},
	[111] = { type = 'home', coords = vec3(1268.56,-461.81,69.84),
	  vehiclePositions = {
		[1] = { vec3(1270.98,-463.9,69.87), h = 328.18 },
	  },
	  home = 'LS14'
	},
	[112] = { type = 'home', coords = vec3(1261.12,-426.7,69.81),
	  vehiclePositions = {
		[1] = { vec3(1261.45,-419.35,69.58), h = 297.04 },
	  },
	  home = 'LS15'
	},
	[113] = { type = 'home', coords = vec3(1234.75,-578.25,69.49),
	  vehiclePositions = {
		[1] = { vec3(1243.86,-579.36,69.64), h = 271.53 },
	  },
	  home = 'LS16'
	},
	[114] = { type = 'home', coords = vec3(1236.79,-589.55,69.79),
	  vehiclePositions = {
		[1] = { vec3(1242.92,-586.85,69.55), h = 269.57 },
	  },
	  home = 'LS17'
	},
	[115] = { type = 'home', coords = vec3(1250.47,-626.17,69.35),
	  vehiclePositions = {
		[1] = { vec3(1259.06,-624.91,69.58), h = 296.96 },
	  },
	  home = 'LS18'
	},
	[116] = { type = 'home', coords = vec3(1257.67,-660.38,67.93),
	  vehiclePositions = {
		[1] = { vec3(1271.84,-659.12,68.0), h = 293.69 },
	  },
	  home = 'LS19'
	},
	[117] = { type = 'home', coords = vec3(1267.25,-673.65,65.75),
	  vehiclePositions = {
		[1] = { vec3(1276.75,-673.42,66.25), h = 277.48 },
	  },
	  home = 'LS20'
	},
	[118] = { type = 'home', coords = vec3(1259.79,-711.08,64.72),
	  vehiclePositions = {
		[1] = { vec3(1263.72,-716.66,64.75), h = 239.07 },
	  },
	  home = 'LS21'
	},
	[119] = { type = 'home', coords = vec3(1225.19,-723.04,60.64),
	  vehiclePositions = {
		[1] = { vec3(1223.46,-730.21,60.4), h = 163.48 },
	  },
	  home = 'LS22'
	},
	[120] = { type = 'home', coords = vec3(1228.5,-703.47,60.68),
	  vehiclePositions = {
		[1] = { vec3(1217.85,-704.09,60.7), h = 97.24 },
	  },
	  home = 'LS23'
	},
	[121] = { type = 'home', coords = vec3(1220.91,-664.18,63.13),
	  vehiclePositions = {
		[1] = { vec3(1214.36,-665.12,62.85), h = 103.07 },
	  },
	  home = 'LS24'
	},
	[122] = { type = 'home', coords = vec3(1206.75,-614.0,66.12),
	  vehiclePositions = {
		[1] = { vec3(1199.98,-612.47,65.36), h = 94.4 },
	  },
	  home = 'LS25'
	},
	[123] = { type = 'home', coords = vec3(1192.48,-597.08,64.01),
	  vehiclePositions = {
		[1] = { vec3(1188.28,-595.06,64.23), h = 34.45 },
	  },
	  home = 'LS26'
	},
	[124] = { type = 'home', coords = vec3(1189.79,-573.78,64.32),
	  vehiclePositions = {
		[1] = { vec3(1185.82,-569.96,64.56), h = 25.68 },
	  },
	  home = 'LS27'
	},
	[125] = { type = 'home', coords = vec3(1191.61,-554.97,64.71),
	  vehiclePositions = {
		[1] = { vec3(1187.47,-550.38,64.83), h = 86.85 },
	  },
	  home = 'LS28'
	},
	[126] = { type = 'home', coords = vec3(1089.59,-495.42,65.07),
	  vehiclePositions = {
		[1] = { vec3(1084.78,-493.34,64.4), h = 79.01 },
	  },
	  home = 'LS29'
	},
	[127] = { type = 'home', coords = vec3(1101.7,-468.42,67.06),
	  vehiclePositions = {
		[1] = { vec3(1091.28,-470.87,65.47), h = 77.7 },
	  },
	  home = 'LS30'
	},
	[128] = { type = 'home', coords = vec3(1111.03,-417.0,67.16),
	  vehiclePositions = {
		[1] = { vec3(1111.15,-419.57,67.43), h = 83.31 },
	  },
	  home = 'LS31'
	},
	[129] = { type = 'home', coords = vec3(1112.77,-394.29,68.74),
	  vehiclePositions = {
		[1] = { vec3(1106.07,-399.24,68.2), h = 78.01 },
	  },
	  home = 'LS32'
	},
	[130] = { type = 'home', coords = vec3(1057.42,-384.09,67.86),
	  vehiclePositions = {
		[1] = { vec3(1056.9,-388.45,68.09), h = 221.13 },
	  },
	  home = 'LS33'
	},
	[131] = { type = 'home', coords = vec3(1021.13,-414.33,65.95),
	  vehiclePositions = {
		[1] = { vec3(1022.37,-419.52,66.05), h = 219.15 },
	  },
	  home = 'LS34'
	},
	[132] = { type = 'home', coords = vec3(1009.82,-418.88,64.96),
	  vehiclePositions = {
		[1] = { vec3(1015.92,-423.87,65.32), h = 217.1 },
	  },
	  home = 'LS35'
	},
	[133] = { type = 'home', coords = vec3(987.71,-438.07,63.75),
	  vehiclePositions = {
		[1] = { vec3(995.76,-435.43,64.23), h = 271.01 },
	  },
	  home = 'LS36'
	},
	[134] = { type = 'home', coords = vec3(971.53,-447.94,62.41),
	  vehiclePositions = {
		[1] = { vec3(975.54,-454.41,62.86), h = 213.74 },
	  },
	  home = 'LS37'
	},
	[135] = { type = 'home', coords = vec3(939.3,-463.22,61.26),
	  vehiclePositions = {
		[1] = { vec3(942.05,-469.79,61.53), h = 212.33 },
	  },
	  home = 'LS38'
	},
	[136] = { type = 'home', coords = vec3(928.77,-475.65,60.7),
	  vehiclePositions = {
		[1] = { vec3(933.31,-480.49,60.88), h = 203.27 },
	  },
	  home = 'LS39'
	},
	[137] = { type = 'home', coords = vec3(909.42,-489.73,59.02),
	  vehiclePositions = {
		[1] = { vec3(914.46,-490.17,59.29), h = 204.27 },
	  },
	  home = 'LS40'
	},
	[138] = { type = 'home', coords = vec3(873.98,-503.77,57.5),
	  vehiclePositions = {
		[1] = { vec3(874.77,-507.45,57.72), h = 226.29 },
	  },
	  home = 'LS41'
	},
	[139] = { type = 'home', coords = vec3(854.95,-516.17,57.33),
	  vehiclePositions = {
		[1] = { vec3(858.81,-522.39,57.59), h = 227.66 },
	  },
	  home = 'LS42'
	},
	[140] = { type = 'home', coords = vec3(848.57,-540.12,57.33),
	  vehiclePositions = {
		[1] = { vec3(853.51,-542.76,57.6), h = 266.06 },
	  },
	  home = 'LS43'
	},
	[141] = { type = 'home', coords = vec3(842.1,-567.41,57.71),
	  vehiclePositions = {
		[1] = { vec3(849.29,-567.47,57.99), h = 279.71 },
	  },
	  home = 'LS44'
	},
	[142] = { type = 'home', coords = vec3(868.47,-594.02,58.3),
	  vehiclePositions = {
		[1] = { vec3(872.86,-590.11,58.28), h = 317.23 },
	  },
	  home = 'LS45'
	},
	[143] = { type = 'home', coords = vec3(875.58,-602.34,58.45),
	  vehiclePositions = {
		[1] = { vec3(875.55,-598.36,58.45), h = 316.61 },
	  },
	  home = 'LS46'
	},
	[144] = { type = 'home', coords = vec3(912.15,-631.81,58.05),
	  vehiclePositions = {
		[1] = { vec3(917.67,-627.46,58.32), h = 319.36 },
	  },
	  home = 'LS47'
	},
	[145] = { type = 'home', coords = vec3(913.03,-645.12,57.87),
	  vehiclePositions = {
		[1] = { vec3(917.96,-639.77,58.14), h = 318.18 },
	  },
	  home = 'LS48'
	},
	[146] = { type = 'home', coords = vec3(946.14,-657.5,58.02),
	  vehiclePositions = {
		[1] = { vec3(951.67,-654.13,58.16), h = 309.34 },
	  },
	  home = 'LS49'
	},
	[147] = { type = 'home', coords = vec3(940.18,-672.19,58.02),
	  vehiclePositions = {
		[1] = { vec3(946.99,-669.22,58.29), h = 297.96 },
	  },
	  home = 'LS50'
	},
	[148] = { type = 'home', coords = vec3(969.7,-688.32,57.95),
	  vehiclePositions = {
		[1] = { vec3(973.59,-685.58,57.91), h = 309.99 },
	  },
	  home = 'LS51'
	},
	[149] = { type = 'home', coords = vec3(976.24,-713.97,57.87),
	  vehiclePositions = {
		[1] = { vec3(982.5,-709.42,57.88), h = 312.02 },
	  },
	  home = 'LS52'
	},
	[150] = { type = 'home', coords = vec3(1004.32,-734.1,57.46),
	  vehiclePositions = {
		[1] = { vec3(1008.02,-731.13,57.88), h = 311.05 },
	  },
	  home = 'LS53'
	},
	[151] = { type = 'home', coords = vec3(981.21,-614.8,58.84),
	  vehiclePositions = {
		[1] = { vec3(973.52,-619.61,59.1), h = 128.1 },
	  },
	  home = 'LS54'
	},
	[152] = { type = 'home', coords = vec3(959.79,-601.7,59.5),
	  vehiclePositions = {
		[1] = { vec3(955.45,-598.08,59.65), h = 27.96 },
	  },
	  home = 'LS55'
	},
	[153] = { type = 'home', coords = vec3(984.25,-579.14,59.28),
	  vehiclePositions = {
		[1] = { vec3(982.93,-572.6,59.53), h = 31.32 },
	  },
	  home = 'LS56'
	},
	[154] = { type = 'home', coords = vec3(1008.54,-565.15,60.2),
	  vehiclePositions = {
		[1] = { vec3(1012.51,-563.56,60.44), h = 263.72 },
	  },
	  home = 'LS57'
	},
	[155] = { type = 'home', coords = vec3(943.81,-243.89,68.63),
	  vehiclePositions = {
		[1] = { vec3(939.22,-250.12,68.69), h = 150.37 },
	  },
	  home = 'LS58'
	},
	[156] = { type = 'home', coords = vec3(1003.79,-588.12,59.14),
	  vehiclePositions = {
		[1] = { vec3(1009.07,-590.25,59.2), h = 258.95 },
	  },
	  home = 'LS59'
	},
	[157] = { type = 'home', coords = vec3(922.71,-564.06,57.97),
	  vehiclePositions = {
		[1] = { vec3(926.46,-567.39,58.24), h = 206.14 },
	  },
	  home = 'LS60'
	},
	[158] = { type = 'home', coords = vec3(956.87,-546.73,59.53),
	  vehiclePositions = {
		[1] = { vec3(957.91,-552.49,59.55), h = 211.12 },
	  },
	  home = 'LS61'
	},
	[159] = { type = 'home', coords = vec3(981.96,-530.0,60.12),
	  vehiclePositions = {
		[1] = { vec3(983.27,-536.41,60.19), h = 211.11 },
	  },
	  home = 'LS62'
	},
	[160] = { type = 'home', coords = vec3(1001.36,-510.47,60.7),
	  vehiclePositions = {
		[1] = { vec3(1003.89,-518.48,60.98), h = 205.24 },
	  },
	  home = 'LS63'
	},
	[161] = { type = 'home', coords = vec3(1045.95,-495.92,64.08),
	  vehiclePositions = {
		[1] = { vec3(1049.91,-488.79,64.19), h = 257.03 },
	  },
	  home = 'LS64'
	},
	[162] = { type = 'home', coords = vec3(1049.12,-479.89,64.1),
	  vehiclePositions = {
		[1] = { vec3(1056.64,-483.32,64.11), h = 257.85 },
	  },
	  home = 'LS65'
	},
	[163] = { type = 'home', coords = vec3(1055.36,-445.56,65.97),
	  vehiclePositions = {
		[1] = { vec3(1062.56,-445.67,66.16), h = 257.58 },
	  },
	  home = 'LS66'
	},
	[164] = { type = 'home', coords = vec3(1020.06,-464.4,63.9),
	  vehiclePositions = {
		[1] = { vec3(1019.04,-459.29,64.37), h = 38.05 },
	  },
	  home = 'LS67'
	},
	[165] = { type = 'home', coords = vec3(966.19,-505.37,61.74),
	  vehiclePositions = {
		[1] = { vec3(960.86,-500.52,61.65), h = 29.8 },
	  },
	  home = 'LS68'
	},
	[166] = { type = 'home', coords = vec3(950.42,-516.97,60.25),
	  vehiclePositions = {
		[1] = { vec3(948.5,-511.66,60.5), h = 29.22 },
	  },
	  home = 'LS69'
	},
	[167] = { type = 'home', coords = vec3(921.11,-527.47,59.58),
	  vehiclePositions = {
		[1] = { vec3(915.83,-522.63,59.03), h = 25.35 },
	  },
	  home = 'LS70'
	},
	[168] = { type = 'home', coords = vec3(893.88,-547.44,58.17),
	  vehiclePositions = {
		[1] = { vec3(888.36,-551.92,58.24), h = 115.0 },
	  },
	  home = 'LS71'
	},
	[169] = { type = 'home', coords = vec3(1103.28,-429.62,67.4),
	  vehiclePositions = {
		[1] = { vec3(1097.86,-428.24,66.68), h = 80.97 },
	  },
	  home = 'LS72'
	},
	-- [170] = { type = 'home', coords = vec3(102.82,-1959.78,20.84),
	--   vehiclePositions = {
	-- 	[1] = { vec3(104.57,-1954.94,20.95), h = 355.58 },
	--   },
	--   home = 'KR01'
	-- },
	[171] = { type = 'home', coords = vec3(72.16,-1935.47,20.99),
	  vehiclePositions = {
		[1] = { vec3(81.72,-1932.41,21.02), h = 316.63 },
	  },
	  home = 'KR02'
	},
	[172] = { type = 'home', coords = vec3(14.13,-1886.93,23.24),
	  vehiclePositions = {
		[1] = { vec3(18.48,-1880.11,23.28), h = 320.5 },
	  },
	  home = 'KR03'
	},
	[173] = { type = 'home', coords = vec3(98.75,-1907.55,21.07),
	  vehiclePositions = {
		[1] = { vec3(89.81,-1917.18,20.98), h = 140.59 },
	  },
	  home = 'KR04'
	},
	[174] = { type = 'home', coords = vec3(101.95,-1883.62,24.02),
	  vehiclePositions = {
		[1] = { vec3(105.76,-1879.36,24.22), h = 319.71 },
	  },
	  home = 'KR05'
	},
	[175] = { type = 'home', coords = vec3(157.6,-1901.16,23.0),
	  vehiclePositions = {
		[1] = { vec3(162.82,-1899.28,23.26), h = 334.81 },
	  },
	  home = 'KR06'
	},
	[176] = { type = 'home', coords = vec3(163.9,-1954.67,19.32),
	  vehiclePositions = {
		[1] = { vec3(165.73,-1959.08,19.43), h = 227.78 },
	  },
	  home = 'KR07'
	},
	[177] = { type = 'home', coords = vec3(152.53,-1960.61,19.08),
	  vehiclePositions = {
		[1] = { vec3(152.79,-1965.88,19.04), h = 228.5 },
	  },
	  home = 'KR08'
	},
	[178] = { type = 'home', coords = vec3(58.69,-1878.41,22.39),
	  vehiclePositions = {
		[1] = { vec3(52.14,-1878.42,22.53), h = 136.83 },
	  },
	  home = 'KR09'
	},
	[179] = { type = 'home', coords = vec3(45.4,-1849.13,22.84),
	  vehiclePositions = {
		[1] = { vec3(41.44,-1853.34,23.11), h = 135.2 },
	  },
	  home = 'KR10'
	},
	[180] = { type = 'home', coords = vec3(-45.22,-1791.79,27.45),
	  vehiclePositions = {
		[1] = { vec3(-53.0,-1801.42,27.36), h = 50.04 },
	  },
	  home = 'KR11'
	},
	[181] = { type = 'home', coords = vec3(-54.09,-1781.86,27.88),
	  vehiclePositions = {
		[1] = { vec3(-57.67,-1785.85,28.12), h = 136.73 },
	  },
	  home = 'KR12'
	},
	[182] = { type = 'home', coords = vec3(140.35,-1866.11,24.32),
	  vehiclePositions = {
		[1] = { vec3(136.94,-1869.3,24.4), h = 155.02 },
	  },
	  home = 'KR13'
	},
	[183] = { type = 'home', coords = vec3(189.37,-1872.27,24.73),
	  vehiclePositions = {
		[1] = { vec3(186.58,-1877.13,24.85), h = 154.49 },
	  },
	  home = 'KR14'
	},
	[184] = { type = 'home', coords = vec3(248.21,-1732.71,29.38),
	  vehiclePositions = {
		[1] = { vec3(244.51,-1728.83,29.5), h = 49.0 },
	  },
	  home = 'KR15'
	},
	[185] = { type = 'home', coords = vec3(272.34,-1704.01,29.31),
	  vehiclePositions = {
		[1] = { vec3(268.09,-1700.73,29.57), h = 49.31 },
	  },
	  home = 'KR16'
	},
	[186] = { type = 'home', coords = vec3(291.46,-1783.92,28.26),
	  vehiclePositions = {
		[1] = { vec3(297.45,-1791.53,28.19), h = 228.58 },
	  },
	  home = 'KR17'
	},
	[187] = { type = 'home', coords = vec3(319.33,-1769.51,29.08),
	  vehiclePositions = {
		[1] = { vec3(321.52,-1773.31,28.93), h = 229.23 },
	  },
	  home = 'KR18'
	},
	[188] = { type = 'home', coords = vec3(142.93,-1832.74,27.07),
	  vehiclePositions = {
		[1] = { vec3(138.97,-1830.69,27.29), h = 49.32 },
	  },
	  home = 'KR19'
	},
	[189] = { type = 'home', coords = vec3(83.64,-1973.9,20.93),
	  vehiclePositions = {
		[1] = { vec3(87.72,-1968.8,21.03), h = 319.25 },
	  },
	  home = 'KR20'
	},
	[190] = { type = 'home', coords = vec3(80.39,-1949.55,20.8),
	  vehiclePositions = {
		[1] = { vec3(89.19,-1934.65,20.91), h = 217.76 },
	  },
	  home = 'KR21'
	},
	[191] = { type = 'home', coords = vec3(54.53,-1921.05,21.66),
	  vehiclePositions = {
		[1] = { vec3(62.29,-1910.55,21.78), h = 230.76 },
	  },
	  home = 'KR22'
	},
	[192] = { type = 'home', coords = vec3(37.3,-1926.34,21.8),
	  vehiclePositions = {
		[1] = { vec3(42.47,-1920.65,21.94), h = 320.78 },
	  },
	  home = 'KR23'
	},
	[193] = { type = 'home', coords = vec3(-10.49,-1883.78,24.15),
	  vehiclePositions = {
		[1] = { vec3(0.4,-1878.23,23.07), h = 319.84 },
	  },
	  home = 'KR24'
	},
	[194] = { type = 'home', coords = vec3(7.46,-1884.39,23.32),
	  vehiclePositions = {
		[1] = { vec3(15.62,-1871.47,23.56), h = 228.24 },
	  },
	  home = 'KR25'
	},
	[195] = { type = 'home', coords = vec3(-23.09,-1857.7,25.04),
	  vehiclePositions = {
		[1] = { vec3(-22.28,-1852.32,25.35), h = 318.16 },
	  },
	  home = 'KR26'
	},
	[196] = { type = 'home', coords = vec3(-33.91,-1855.64,26.01),
	  vehiclePositions = {
		[1] = { vec3(-36.14,-1861.29,26.03), h = 318.25 },
	  },
	  home = 'KR27'
	},
	[197] = { type = 'home', coords = vec3(123.49,-1927.1,21.01),
	  vehiclePositions = {
		[1] = { vec3(118.66,-1940.02,20.95), h = 86.06 },
	  },
	  home = 'KR28'
	},
	[198] = { type = 'home', coords = vec3(116.48,-1918.75,20.94),
	  vehiclePositions = {
		[1] = { vec3(109.49,-1924.84,21.03), h = 159.44 },
	  },
	  home = 'KR29'
	},
	[199] = { type = 'home', coords = vec3(112.4,-1884.8,23.59),
	  vehiclePositions = {
		[1] = { vec3(125.42,-1877.96,23.98), h = 245.04 },
	  },
	  home = 'KR30'
	},
	[200] = { type = 'home', coords = vec3(163.74,-1922.7,21.2),
	  vehiclePositions = {
		[1] = { vec3(166.25,-1929.66,21.29), h = 230.07 },
	  },
	  home = 'KR31'
	},
	[201] = { type = 'home', coords = vec3(142.93,-1970.81,18.86),
	  vehiclePositions = {
		[1] = { vec3(153.95,-1978.59,18.55), h = 139.63 },
	  },
	  home = 'KR32'
	},
	[202] = { type = 'home', coords = vec3(28.49,-1852.1,23.68),
	  vehiclePositions = {
		[1] = { vec3(20.42,-1863.32,23.63), h = 50.07 },
	  },
	  home = 'KR33'
	},
	[203] = { type = 'home', coords = vec3(11.84,-1843.19,24.53),
	  vehiclePositions = {
		[1] = { vec3(8.43,-1845.9,24.64), h = 139.44 },
	  },
	  home = 'KR34'
	},
	[204] = { type = 'home', coords = vec3(167.84,-1854.07,24.29),
	  vehiclePositions = {
		[1] = { vec3(165.62,-1861.16,24.41), h = 155.81 },
	  },
	  home = 'KR35'
	},
	[205] = { type = 'home', coords = vec3(206.99,-1892.89,24.43),
	  vehiclePositions = {
		[1] = { vec3(198.9,-1897.55,24.5), h = 142.92 },
	  },
	  home = 'KR36'
	},
	[206] = { type = 'home', coords = vec3(302.56,-1777.35,29.1),
	  vehiclePositions = {
		[1] = { vec3(312.42,-1785.76,28.42), h = 229.27 },
	  },
	  home = 'KR37'
	},
	[207] = { type = 'home', coords = vec3(289.96,-1789.91,27.7),
	  vehiclePositions = {
		[1] = { vec3(297.45,-1791.53,28.19), h = 228.58 },
	  },
	  home = 'KR38'
	},
	[208] = { type = 'home', coords = vec3(311.04,-1735.44,29.54),
	  vehiclePositions = {
		[1] = { vec3(315.43,-1739.08,29.73), h = 231.04 },
	  },
	  home = 'KR39'
	},
	[209] = { type = 'home', coords = vec3(269.11,-1728.64,29.65),
	  vehiclePositions = {
		[1] = { vec3(264.26,-1718.68,29.56), h = 49.25 },
	  },
	  home = 'KR40'
	},
	[210] = { type = 'home', coords = vec3(269.79,-1710.52,29.34),
	  vehiclePositions = {
		[1] = { vec3(257.55,-1701.71,29.31), h = 320.02 },
	  },
	  home = 'KR41'
	},
	[211] = { type = 'home', coords = vec3(248.94,-1936.94,24.35),
	  vehiclePositions = {
		[1] = { vec3(240.16,-1927.99,24.39), h = 319.7 },
	  },
	  home = 'LV01'
	},
	[212] = { type = 'home', coords = vec3(269.8,-1932.86,25.44),
	  vehiclePositions = {
		[1] = { vec3(263.07,-1921.28,25.41), h = 54.74 },
	  },
	  home = 'LV02'
	},
	[213] = { type = 'home', coords = vec3(270.61,-1914.8,25.81),
	  vehiclePositions = {
		[1] = { vec3(270.12,-1905.53,26.78), h = 51.02 },
	  },
	  home = 'LV03'
	},
	[214] = { type = 'home', coords = vec3(279.17,-1899.45,26.89),
	  vehiclePositions = {
		[1] = { vec3(269.73,-1892.82,26.83), h = 319.63 },
	  },
	  home = 'LV04'
	},
	[215] = { type = 'home', coords = vec3(318.07,-1856.29,27.11),
	  vehiclePositions = {
		[1] = { vec3(305.2,-1850.27,27.0), h = 320.21 },
	  },
	  home = 'LV05'
	},
	[216] = { type = 'home', coords = vec3(340.81,-1849.98,27.77),
	  vehiclePositions = {
		[1] = { vec3(335.81,-1835.98,27.61), h = 44.87 },
	  },
	  home = 'LV06'
	},
	[217] = { type = 'home', coords = vec3(344.21,-1828.31,27.95),
	  vehiclePositions = {
		[1] = { vec3(333.16,-1817.23,27.99), h = 320.18 },
	  },
	  home = 'LV07'
	},
	[218] = { type = 'home', coords = vec3(350.15,-1811.51,28.8),
	  vehiclePositions = {
		[1] = { vec3(342.37,-1806.23,28.48), h = 319.97 },
	  },
	  home = 'LV08'
	},
	[219] = { type = 'home', coords = vec3(404.54,-1753.91,29.37),
	  vehiclePositions = {
		[1] = { vec3(403.61,-1739.39,29.54), h = 46.7 },
	  },
	  home = 'LV09'
	},
	[220] = { type = 'home', coords = vec3(430.66,-1741.22,29.61),
	  vehiclePositions = {
		[1] = { vec3(431.33,-1735.54,28.65), h = 50.2 },
	  },
	  home = 'LV10'
	},
	[221] = { type = 'home', coords = vec3(434.96,-1715.43,29.33),
	  vehiclePositions = {
		[1] = { vec3(430.06,-1715.87,28.69), h = 49.34 },
	  },
	  home = 'LV11'
	},
	[222] = { type = 'home', coords = vec3(442.86,-1698.41,29.38),
	  vehiclePositions = {
		[1] = { vec3(442.78,-1693.12,28.66), h = 51.33 },
	  },
	  home = 'LV12'
	},
	[223] = { type = 'home', coords = vec3(498.38,-1698.89,29.41),
	  vehiclePositions = {
		[1] = { vec3(498.01,-1702.77,29.64), h = 236.28 },
	  },
	  home = 'LV13'
	},
	[224] = { type = 'home', coords = vec3(479.02,-1718.03,29.37),
	  vehiclePositions = {
		[1] = { vec3(490.02,-1721.93,29.62), h = 251.19 },
	  },
	  home = 'LV14'
	},
	[225] = { type = 'home', coords = vec3(464.62,-1740.78,29.11),
	  vehiclePositions = {
		[1] = { vec3(473.8,-1744.08,29.21), h = 250.4 },
	  },
	  home = 'LV15'
	},
	[226] = { type = 'home', coords = vec3(475.52,-1755.13,28.76),
	  vehiclePositions = {
		[1] = { vec3(488.5,-1757.75,28.71), h = 163.16 },
	  },
	  home = 'LV16'
	},
	[227] = { type = 'home', coords = vec3(475.02,-1772.84,28.7),
	  vehiclePositions = {
		[1] = { vec3(478.21,-1779.06,28.93), h = 270.19 },
	  },
	  home = 'LV17'
	},
	[228] = { type = 'home', coords = vec3(511.46,-1778.19,28.51),
	  vehiclePositions = {
		[1] = { vec3(499.79,-1777.14,28.64), h = 201.67 },
	  },
	  home = 'LV18'
	},
	[229] = { type = 'home', coords = vec3(504.82,-1799.04,28.49),
	  vehiclePositions = {
		[1] = { vec3(500.19,-1792.86,28.65), h = 161.09 },
	  },
	  home = 'LV19'
	},
	[230] = { type = 'home', coords = vec3(504.77,-1808.65,28.51),
	  vehiclePositions = {
		[1] = { vec3(491.87,-1805.02,28.65), h = 138.92 },
	  },
	  home = 'LV20'
	},
	[231] = { type = 'home', coords = vec3(487.7,-1826.73,28.53),
	  vehiclePositions = {
		[1] = { vec3(479.28,-1819.72,28.1), h = 139.7 },
	  },
	  home = 'LV21'
	},
	[232] = { type = 'home', coords = vec3(431.96,-1828.9,28.18),
	  vehiclePositions = {
		[1] = { vec3(437.06,-1837.91,28.21), h = 223.26 },
	  },
	  home = 'LV22'
	},
	[233] = { type = 'home', coords = vec3(428.72,-1839.65,28.08),
	  vehiclePositions = {
		[1] = { vec3(434.57,-1841.14,28.23), h = 222.18 },
	  },
	  home = 'LV23'
	},
	[234] = { type = 'home', coords = vec3(401.5,-1849.32,27.32),
	  vehiclePositions = {
		[1] = { vec3(394.61,-1849.77,26.41), h = 225.55 },
	  },
	  home = 'LV24'
	},
	[235] = { type = 'home', coords = vec3(396.69,-1872.65,26.25),
	  vehiclePositions = {
		[1] = { vec3(397.28,-1877.44,26.35), h = 222.91 },
	  },
	  home = 'LV25'
	},
	[236] = { type = 'home', coords = vec3(385.03,-1890.77,25.32),
	  vehiclePositions = {
		[1] = { vec3(384.63,-1896.36,25.21), h = 222.83 },
	  },
	  home = 'LV26'
	},
	[237] = { type = 'home', coords = vec3(360.06,-1894.9,24.99),
	  vehiclePositions = {
		[1] = { vec3(357.8,-1896.77,25.08), h = 227.0 },
	  },
	  home = 'LV27'
	},
	[238] = { type = 'home', coords = vec3(315.73,-1937.5,24.82),
	  vehiclePositions = {
		[1] = { vec3(315.5,-1942.05,24.92), h = 230.52 },
	  },
	  home = 'LV28'
	},
	[239] = { type = 'home', coords = vec3(310.66,-1965.91,23.74),
	  vehiclePositions = {
		[1] = { vec3(316.82,-1970.62,23.69), h = 138.57 },
	  },
	  home = 'LV29'
	},
	[240] = { type = 'home', coords = vec3(299.42,-1971.96,22.49),
	  vehiclePositions = {
		[1] = { vec3(306.82,-1982.39,22.39), h = 139.63 },
	  },
	  home = 'LV30'
	},
	[241] = { type = 'home', coords = vec3(282.89,-1980.29,21.4),
	  vehiclePositions = {
		[1] = { vec3(285.64,-1985.85,21.41), h = 229.16 },
	  },
	  home = 'LV31'
	},
	[242] = { type = 'home', coords = vec3(280.83,-1991.24,20.46),
	  vehiclePositions = {
		[1] = { vec3(286.37,-1992.54,20.81), h = 228.61 },
	  },
	  home = 'LV32'
	},
	[243] = { type = 'home', coords = vec3(256.42,-2026.71,18.86),
	  vehiclePositions = {
		[1] = { vec3(267.58,-2029.38,18.82), h = 142.23 },
	  },
	  home = 'LV33'
	},
	[244] = { type = 'home', coords = vec3(240.68,-2021.42,18.71),
	  vehiclePositions = {
		[1] = { vec3(246.74,-2035.94,18.53), h = 228.9 },
	  },
	  home = 'LV34'
	},
	[245] = { type = 'home', coords = vec3(241.9,-2042.78,18.02),
	  vehiclePositions = {
		[1] = { vec3(245.74,-2053.88,18.1), h = 134.18 },
	  },
	  home = 'LV35'
	},
	[246] = { type = 'home', coords = vec3(-442.95,6202.62,29.56),
	  vehiclePositions = {
		[1] = { vec3(-435.4,6206.42,29.57), h = 278.13 },
	  },
	  home = 'PB01'
	},
	[247] = { type = 'home', coords = vec3(-375.5,6187.37,31.54),
	  vehiclePositions = {
		[1] = { vec3(-379.5,6184.85,31.4), h = 223.82 },
	  },
	  home = 'PB02'
	},
	[248] = { type = 'home', coords = vec3(-361.91,6204.76,31.58),
	  vehiclePositions = {
		[1] = { vec3(-367.92,6200.05,31.4), h = 224.98 },
	  },
	  home = 'PB03'
	},
	[249] = { type = 'home', coords = vec3(-359.1,6227.29,31.5),
	  vehiclePositions = {
		[1] = { vec3(-349.5,6217.17,31.4), h = 223.88 },
	  },
	  home = 'PB04'
	},
	[250] = { type = 'home', coords = vec3(-381.48,6254.9,31.49),
	  vehiclePositions = {
		[1] = { vec3(-388.73,6273.42,30.02), h = 50.83 },
	  },
	  home = 'PB05'
	},
	[251] = { type = 'home', coords = vec3(-360.84,6265.04,31.53),
	  vehiclePositions = {
		[1] = { vec3(-352.17,6265.07,31.32), h = 46.14 },
	  },
	  home = 'PB06'
	},
	[252] = { type = 'home', coords = vec3(-436.46,6264.1,30.09),
	  vehiclePositions = {
		[1] = { vec3(-429.99,6260.87,30.31), h = 258.67 },
	  },
	  home = 'PB07'
	},
	[253] = { type = 'home', coords = vec3(-402.95,6317.15,28.95),
	  vehiclePositions = {
		[1] = { vec3(-396.68,6311.99,28.84), h = 220.7 },
	  },
	  home = 'PB08'
	},
	[254] = { type = 'home', coords = vec3(-364.3,6337.74,29.85),
	  vehiclePositions = {
		[1] = { vec3(-360.16,6328.54,29.75), h = 220.61 },
	  },
	  home = 'PB09'
	},
	[255] = { type = 'home', coords = vec3(-311.14,6310.94,32.48),
	  vehiclePositions = {
		[1] = { vec3(-318.17,6317.76,31.77), h = 45.39 },
	  },
	  home = 'PB10'
	},
	[256] = { type = 'home', coords = vec3(-291.83,6335.9,32.49),
	  vehiclePositions = {
		[1] = { vec3(-296.49,6340.57,31.82), h = 46.26 },
	  },
	  home = 'PB11'
	},
	[257] = { type = 'home', coords = vec3(-272.11,6353.73,32.49),
	  vehiclePositions = {
		[1] = { vec3(-267.41,6355.22,32.4), h = 47.15 },
	  },
	  home = 'PB12'
	},
	[258] = { type = 'home', coords = vec3(-250.27,6355.12,31.5),
	  vehiclePositions = {
		[1] = { vec3(-255.08,6360.48,31.39), h = 45.08 },
	  },
	  home = 'PB13'
	},
	[259] = { type = 'home', coords = vec3(-271.22,6408.91,31.12),
	  vehiclePositions = {
		[1] = { vec3(-265.26,6406.49,30.88), h = 210.49 },
	  },
	  home = 'PB14'
	},
	[260] = { type = 'home', coords = vec3(-217.34,6374.6,31.68),
	  vehiclePositions = {
		[1] = { vec3(-219.54,6383.16,31.52), h = 45.87 },
	  },
	  home = 'PB15'
	},
	[261] = { type = 'home', coords = vec3(-238.3,6423.56,31.46),
	  vehiclePositions = {
		[1] = { vec3(-233.04,6420.27,31.16), h = 220.84 },
	  },
	  home = 'PB16'
	},
	[262] = { type = 'home', coords = vec3(-201.42,6396.75,31.87),
	  vehiclePositions = {
		[1] = { vec3(-201.53,6401.82,31.77), h = 46.62 },
	  },
	  home = 'PB17'
	},
	[263] = { type = 'home', coords = vec3(-229.57,6445.5,31.2),
	  vehiclePositions = {
		[1] = { vec3(-224.33,6435.29,31.11), h = 22964 },
	  },
	  home = 'PB18'
	},
	[264] = { type = 'home', coords = vec3(-187.33,6412.01,31.92),
	  vehiclePositions = {
		[1] = { vec3(-187.43,6418.12,31.78), h = 44.99 },
	  },
	  home = 'PB19'
	},
	[265] = { type = 'home', coords = vec3(-122.88,6561.7,29.53),
	  vehiclePositions = {
		[1] = { vec3(-115.59,6567.64,29.43), h = 224.24 },
	  },
	  home = 'PB20'
	},
	[266] = { type = 'home', coords = vec3(-101.69,6531.68,29.81),
	  vehiclePositions = {
		[1] = { vec3(-106.48,6536.09,29.72), h = 45.2 },
	  },
	  home = 'PB21'
	},
	[267] = { type = 'home', coords = vec3(-37.32,6578.82,32.35),
	  vehiclePositions = {
		[1] = { vec3(-40.97,6593.44,30.34), h = 37.22 },
	  },
	  home = 'PB22'
	},
	[268] = { type = 'home', coords = vec3(-15.06,6566.75,31.91),
	  vehiclePositions = {
		[1] = { vec3(-8.44,6561.16,31.88), h = 224.22 },
	  },
	  home = 'PB23'
	},
	[269] = { type = 'home', coords = vec3(11.48,6578.36,33.08),
	  vehiclePositions = {
		[1] = { vec3(15.78,6583.02,32.35), h = 223.198 },
	  },
	  home = 'PB24'
	},
	[270] = { type = 'home', coords = vec3(-17.04,6598.51,31.48),
	  vehiclePositions = {
		[1] = { vec3(-8.5,6598.24,31.38), h = 39.88 },
	  },
	  home = 'PB25'
	},
	[271] = { type = 'home', coords = vec3(-43.93,6634.26,30.23),
	  vehiclePositions = {
		[1] = { vec3(-52.4,6623.94,29.87), h = 221 },
	  },
	  home = 'PB26'
	},
	[272] = { type = 'home', coords = vec3(-14.79,6650.52,31.15),
	  vehiclePositions = {
		[1] = { vec3(-15.82,6645.42,31.03), h = 208.0 },
	  },
	  home = 'PB27'
	},
	[273] = { type = 'home', coords = vec3(2.37,6618.26,31.47),
	  vehiclePositions = {
		[1] = { vec3(-5.0,6618.68,31.34), h = 60.09 },
	  },
	  home = 'PB28'
	},
	[274] = { type = 'home', coords = vec3(25.06,6601.97,32.48),
	  vehiclePositions = {
		[1] = { vec3(36.23,6606.74,32.38), h = 267.62 },
	  },
	  home = 'PB29'
	},
	[275] = { type = 'home', coords = vec3(24.79,6659.22,31.65),
	  vehiclePositions = {
		[1] = { vec3(21.16,6661.48,31.44), h = 182.65 },
	  },
	  home = 'PB30'
	},
  }
  
--------------------------------------------------------------------------------
-- função para checar se o player é dono da casa para poder acessar à garagem --
--------------------------------------------------------------------------------
config.hasHome = function(source,user_id,home)
	local hasHome = vRP.query("homes/get_homepermissions",{ home = tostring(home) })
	if hasHome and #hasHome > 0 then
		return true
	end
	TriggerClientEvent("Notify",source,"negado","Você não tem acesso à essa residência.",3000)
	return false
end
  