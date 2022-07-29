local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")

vRPclient = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

local cfg = module("vrp", "cfg/groups")
local groups = cfg.groups

func = {}
Tunnel.bindInterface("vrp_control_people", func)

funcCliente = Tunnel.getInterface("vrp_control_people")

vRP._prepare("vRP/update_foto",
             "UPDATE vrp_user_identities SET foto = @foto WHERE user_id = @user_id")
vRP._prepare("vRP/insert_doctor",
             "INSERT IGNORE INTO doctor (doctor_id,user_id,dkey,dvalue,img,valor,date,id_key) VALUES (@doctor_id, @user_id, @dkey, @dvalue, @img, @valor, NOW(),@id_key)")
vRP._prepare("vRP/select",
             "SELECT p.id, p.dvalue, p.img, p.valor, DATE_FORMAT(p.datahora, '%d/%m/%Y %H:%i') datahora, u.name, u.firstname FROM doctor p INNER JOIN vrp_user_identities u ON u.user_id=p.doctor_id WHERE p.user_id = @user_id AND p.dkey=@dkey ORDER BY 1 DESC LIMIT 0,20")
vRP._prepare("vRP/select_all",
             "SELECT p.id, p.dvalue, u2.foto, p.valor, DATE_FORMAT(p.datahora, '%d/%m/%Y %H:%i') datahora, u.name as nomeMedico,    u.firstname as sobrenomeMedico,    u2.name as nomePatient,    u2.firstname as sobrenomePatient FROM doctor p INNER JOIN    vrp_user_identities u ON u.user_id = p.doctor_id        INNER JOIN    vrp_user_identities u2 ON u2.user_id = p.user_id WHERE p.dkey=@dkey ORDER BY 1 DESC LIMIT 0,20")
vRP._prepare("vRP/select_patient",
             "SELECT p.id, p.user_id, p.dvalue, u2.foto, p.valor, DATE_FORMAT(p.datahora, '%d/%m/%Y %H:%i') datahora, u.name as nomeDoutor,    u.firstname as sobrenomeDoutor,    u2.name as nomePatient,    u2.firstname as sobrenomePatient FROM    doctor p        INNER JOIN    vrp_user_identities u ON u.user_id = p.doctor_id        INNER JOIN    vrp_user_identities u2 ON u2.user_id = p.user_id WHERE    p.dkey = 'patient' AND u2.patient = 1 ORDER BY 1 DESC")
vRP._prepare("vRP/update_patient",
             "UPDATE vrp_user_identities SET patient = @patient WHERE user_id = @user_id")
vRP._prepare("vRP/delete_patient",
             "DELETE FROM doctor WHERE dkey = 'patient' AND user_id = @user_id")

------------------------------------------------------
--------------  BANCO   ------------------------------
------------------------------------------------------
vRP._prepare("vRP/select_bank_all",
             "SELECT bank FROM vrp_user_moneys WHERE user_id = @user_id")
vRP._prepare("vRP/select_bank_extract",
             "SELECT bank FROM vrp_user_data WHERE user_id = @user_id and dkey=@dkey ")


function func.setRegistro(passaporte, dkey, dvalue, img, valor, id_key)
    local source = source
    local doctor_id = vRP.getUserId(source)

    local isPatient = false

    if dkey == "patient" and valor == 1 then
        local patients = vRP.query("vRP/select_patient")
        for a, b in pairs(patients) do
            if b.user_id == passaporte then
                isPatient = true
                return
            end
        end
    end

    if (dkey == "patient" and not isPatient and valor == 1) or dkey ~=
        "patient" then

        vRP.execute("vRP/insert_Doctor", {
            doctor_id = doctor_id,
            user_id = passaporte,
            dkey = dkey,
            dvalue = dvalue,
            img = img,
            valor = valor or 0,
            id_key = id_key or 0
        })
    elseif dkey == "patient" and valor == 0 then
        vRP.execute("vRP/delete_patient", {user_id = passaporte})
    end
    if dkey == "multa" then func.setMulta(passaporte, valor) end
    if dkey == "procedimento" then func.setProcedimento(passaporte, valor) end
    if dkey == "patient" then
        vRP.execute("vRP/update_patient",
                    {patient = valor, user_id = passaporte})
    end

    return true
end

local inPrisao = {}

AddEventHandler("playerDropped",function(reason)
	local source = source
    local nuser_id = vRP.getUserId(source)
    
    if inPrisao[nuser_id] and inPrisao[nuser_id] > 0 then
        func.setProcedimento2(nuser_id, inPrisao[nuser_id])
    end
end)

function func.setMulta(id, valor)
    local source = source
    if valor > 0 then

        local value = vRP.getUData(parseInt(id), "vRP:multas")
        local multas = json.decode(value) or 0
        vRP.setUData(parseInt(id), "vRP:multas",
                     json.encode(parseInt(multas) + parseInt(valor)))

        local player = vRP.getUserSource(parseInt(id))
        if player then
            TriggerClientEvent("Notify", player, "importante",
                               "Você foi multado no valor de $" ..
                                   vRP.format(parseInt(valor)))
        end
        vRPclient.playSound(source, "Hack_Success",
                            "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
    end
end

function func.getDatasUser(id, dkey)
    if id <= 0 then
        return vRP.query("vRP/select_all", {dkey = dkey})
    else
        return vRP.query("vRP/select", {user_id = id, dkey = dkey})
    end
end

function func.getPatients(dkey) return vRP.query("vRP/select_patients") end

function func.updateFoto(foto, user_id)
    vRP.execute("vRP/update_foto", {foto = foto, user_id = user_id})
end

function func.Identidade(user_id)
    local nplayer = vRP.getUserSource(parseInt(user_id))
    local nuser_id = vRP.getUserId(nplayer)

    if user_id then

        local identity = vRP.getUserIdentity(user_id)
        local multas = vRP.getUData(user_id, "vRP:multas")
        local mymultas = json.decode(multas) or 0

        local groupv = func.getUserGroupByType(nuser_id, "job")
        local cargo = func.getUserGroupByType(nuser_id, "cargo")
        if cargo ~= "" then groupv = cargo end

        if groupv == "Motoclub" or groupv == "TCP" or groupv == "Milicia" or
            groupv == "CV" or groupv == "PCC" or groupv == "Mafia" or groupv == "Yakuza" then groupv = "" end

        if identity then
            return identity, vRP.format(parseInt(mymultas)), groupv
        end
    end
end

function func.getUserGroupByType(user_id, gtype)
    local user_groups = vRP.getUserGroups(user_id)
    for k, v in pairs(user_groups) do
        local kgroup = groups[k]
        if kgroup then
            if kgroup._config and kgroup._config.gtype and kgroup._config.gtype ==
                gtype then return kgroup._config.title end
        end
    end
    return ""
end

function func.isPolice()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, "admin.permissao")
end

---- banco ---- 

function func.getBank(id)
    if id <= 0 then
        return vRP.query("vRP/select_bank_all", {user_id = id})
    end
end

function func.getBankExtract(id, dkey)
    if id <= 0 then
        return vRP.query("vRP/select_bank_extract", {user_id = id, dkey = dkey})
    end
end

function func.getBau()
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then

        local identity = vRP.getUserIdentity(user_id)
        local multas = vRP.getUData(user_id, "vRP:multas")
        local mymultas = json.decode(multas) or 0

        local groupv = func.getUserGroupByType(nuser_id, "job")
        local cargo = func.getUserGroupByType(nuser_id, "cargo")
        if cargo ~= "" then groupv = cargo end

        if groupv == "Motoclub" or groupv == "TCP" or groupv == "Milicia" or
            groupv == "CV" or groupv == "PCC" or groupv == "Mafia" or groupv == "Yakuza" then groupv = "" end

        if identity then
            return identity, vRP.format(parseInt(mymultas)), groupv
        end
    end
end

