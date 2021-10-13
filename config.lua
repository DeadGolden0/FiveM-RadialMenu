local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isDead = false
local isInstructorMode = true
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local PlayerData = {}

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

rootMenuConfig =  {
    --[[
        Exemple :

        {
            id = "police-vehicle",
            displayName = "Police",
            icon = "#police-vehicle",
            enableMenu = function()
                return (PlayerData.job.name == 'police' and not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
            end,
            subMenus = {"general:unseatnearest", "police:runplate", "police:toggleradar"}
        },
    ]]
    -- Main menu
    {
        id = "inventory",
        displayName = "Inventaire",
        icon = "#box",
        functionName = "",
        enableMenu = function()
            return not isDead
        end
    },
    {
        id = "vetement",
        displayName = "Vêtements",
        icon = "#tshirt",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {}
    },
    {
        id = "portefeuille",
        displayName = "Portefeuille",
        icon = "#id",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"portefeuille:idcard", "portefeuille:idcard2", "portefeuille:drivelicence", "portefeuille:drivelicence2"}
    },
    {
        id = "actions",
        displayName = "Actions",
        icon = "#magic",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {}
    },
    {
        id = "animations",
        displayName = "Emotes",
        icon = "#animation",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "animations:crossarms", "animations:sit", "animations:sitchair", "animations:salute", "animations:surrender", "animations:finger", "animations:stop",  "animations:pushup",  "animations:hug",  "animations:karate" }
    },
    {
        id = "walking",
        displayName = "Démarches",
        icon = "#walking",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "walk:brave", "walk:hurry", "walk:alien", "walk:tipsy", "walk:injured","walk:tough", "walk:default"}
    },
    -- Job Menu
    {
        id = "police-action",
        displayName = "Police",
        icon = "#police-action",
        enableMenu = function()
            return (PlayerData.job.name == 'police' and not isDead)
        end,
        subMenus = {"police:cuff", "police:checklicenses", "police:removeweapons", "police:escort", "police:frisk"}
    },
    {
        id = "police-vehicle",
        displayName = "Polizei Autochecks",
        icon = "#police-vehicle",
        enableMenu = function()
            return (PlayerData.job.name == 'police' and not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end,
        subMenus = {"police:runplate", "police:toggleradar"}
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
            return (PlayerData.job.name == 'ambulance' and not isDead)
        end,
        subMenus = {}
    },
    {
        id = "vehicle",
        displayName = "Gestion vehicule",
        icon = "#vehicle-options-vehicle",
        functionName = "veh:options",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    }
}

newSubMenus = {
      --[[
        Exemple :

        ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
        },
      ]]


    -- Id Card
    ['portefeuille:idcard'] = {
        title = "Montrer Carte d'identité",
        icon = "#id-card",
        functionName = "chatMessage",
        functionParameters =  { "test" }
    },
    ['portefeuille:idcard2'] = {
        title = "Voir Carte d'identité",
        icon = "#id-card",
        functionName = "escortPlayer"
    },
    ['portefeuille:drivelicence'] = {
        title = "Montrer Permis",
        icon = "#car",
        functionName = "escortPlayer"
    },
    ['portefeuille:drivelicence2'] = {
        title = "Voir Permis",
        icon = "#car",
        functionName = "escortPlayer"
    },

    -- Animations
    ['animations:stop'] = {
        title="Stopper",
        icon="#stop-anim",
        functionName = "e c",
    },
    ['animations:crossarms'] = {
        title = "Bras croisés",
        icon = "#animation",
        functionName = "e cop2"
    },   
    ['animations:sit'] = {
        title = "S'asseoir au sol",
        icon = "#animation",
        functionName = "e sit"
    },
    ['animations:sitchair'] = {
        title = "S'asseoir",
        icon = "#animation",
        functionName = "e sitchair"
    },
    ['animations:salute'] = {
        title = "Salut Militaire",
        icon = "#animation",
        functionName = "e salute"
    },
    ['animations:surrender'] = {
        title = "Se rendre",
        icon = "#animation",
        functionName = "e surrender"
    },
    ['animations:finger'] = {
        title = "Doigt d'honneur",
        icon = "#animation",
        functionName = "e finger"
    },
    ['animations:pushup'] = {
        title = "Pompe",
        icon = "#animation",
        functionName = "e pushup"
    },
    ['animations:hug'] = {
        title = "Calin",
        icon = "#animation",
        functionName = "e hug"
    },
    ['animations:karate'] = {
        title = "Karate",
        icon = "#animation",
        functionName = "e karate"
    },


    -- Walk 
    ['walk:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "walk brave"
    },
    ['walk:hurry'] = {
        title = "Presser",
        icon = "#animation-hurry",
        functionName = "walk hurry"
    },
    ['walk:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "walk alien"
    },
    ['walk:tipsy'] = {
        title = "Soûl",
        icon = "#animation-tipsy",
        functionName = "walk drunk"
    },
    ['walk:injured'] = {
        title = "Blesser",
        icon = "#animation-injured",
        functionName = "walk injured"
    },
    ['walk:tough'] = {
        title = "Musclé",
        icon = "#animation-tough",
        functionName = "walk toughguy"
    },
    ['walk:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "walk reset"
    },

    -- Medic
    ['medic:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "revive"
    },
    ['medic:heal'] = {
        title = "Heal",
        icon = "#medic-heal",
        functionName = "ems:heal"
    },

    -- Police
    ['police:cuff'] = {
        title = "Menotter",
        icon = "#cuffs-cuff",
        functionName = "police:cuffFromMenu"
    },
    ['police:checklicenses'] = {
        title = "Vérifier Licences",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
    ['police:removeweapons'] = {
        title = "Retirer Licence d'arme",
        icon = "#police-action-remove-weapons",
        functionName = "police:removeWeapon"
    },
    ['police:escort'] = {
        title = "Escorter",
        icon = "#police-action-gsr",
        functionName = "escortPlayer"
    },
    ['police:toggleradar'] = {
        title = "Activer Radar",
        icon = "#police-vehicle-radar",
        functionName = "startSpeedo"
    },
    ['police:runplate'] = {
        title = "Rechercher une plaque",
        icon = "#police-vehicle-plate",
        functionName = "clientcheckLicensePlate"
    },
    ['police:frisk'] = {
        title = "Fouille",
        icon = "#police-action-frisk",
        functionName = "police:frisk"
    },

}

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)


RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ambulance" then isMedic = false end
    if isPolice and job ~= "police" then isPolice = false end
    if isDoctor and job ~= "doctor" then isDoctor = false end
    if job == "police" then isPolice = true end
    if job == "ambulance" then isMedic = true end
    if job == "doctor" then isDoctor = true end
    myJob = job
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

trainstations = {
    {-547.34057617188,-1286.1752929688,25.3059978411511},
    {-892.66284179688,-2322.5168457031,-13.246466636658},
    {-1100.2299804688,-2724.037109375,-8.3086919784546},
    {-1071.4924316406,-2713.189453125,-8.9240007400513},
    {-875.61907958984,-2319.8686523438,-13.241264343262},
    {-536.62890625,-1285.0009765625,25.301458358765},
    {270.09558105469,-1209.9177246094,37.465930938721},
    {-287.13568115234,-327.40936279297,8.5491418838501},
    {-821.34295654297,-132.45257568359,18.436864852905},
    {-1359.9794921875,-465.32354736328,13.531299591064},
    {-498.96591186523,-680.65930175781,10.295949935913},
    {-217.97073364258,-1032.1605224609,28.724565505981},
    {113.90325164795,-1729.9976806641,28.453630447388},
    {117.33223724365,-1721.9318847656,28.527353286743},
    {-209.84713745117,-1037.2414550781,28.722997665405},
    {-499.3971862793,-665.58514404297,10.295639038086},
    {-1344.5224609375,-462.10494995117,13.531820297241},
    {-806.85192871094,-141.39852905273,18.436403274536},
    {-302.21514892578,-327.28854370117,8.5495929718018},
    {262.01733398438,-1198.6135253906,37.448017120361},
    {2072.4086914063,1569.0856933594,76.712524414063},
    {664.93090820313,-997.59942626953,22.261747360229},
    {190.62687683105,-1956.8131103516,19.520135879517},
    {2611.0278320313,1675.3806152344,26.578210830688},
    {2615.3901367188,2934.8666992188,39.312232971191},
    {2885.5346679688,4862.0146484375,62.551517486572},
    {47.061096191406,6280.8969726563,31.580261230469},
    {2002.3624267578,3619.8029785156,38.568252563477},
    {2609.7016601563,2937.11328125,39.418235778809}
}
