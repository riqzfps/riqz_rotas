local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

func = {}
Tunnel.bindInterface("riqz_rotas", func)
func = Tunnel.getInterface("riqz_rotas")

onMenu = false
local menuactive = false


function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		onMenu = true
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ menu = 'showmenu' })
	else
		onMenu = false
		SetNuiFocus(false,false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ menu = 'hidemenu' })
	end
end


RegisterNUICallback("retornar",function(data,cb)
	if data == "fechar" then
		ToggleActionMenu()
    end
end)

RegisterNUICallback("rota",function(data,cb)
	inicia.rota(data.rota)
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0

local processo = false
local segundos = 0

local locs = ''
local CoordenadaX = ''
local CoordenadaY = ''
local CoordenadaZ = ''
local item = ''
local itemselected = ''
local maxlocs = ''
local random = ''
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMEÇAR A TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local riqz = 1000
			for k, i in pairs(config) do
				local org = k
				local configs = i

				verificaorg = func.getUserPerm(configs.perm)
		
				if verificaorg then
			
					CoordenadaX = configs.blip.x
					CoordenadaY = configs.blip.y
					CoordenadaZ = configs.blip.z

					ItemMin = configs.Quantidade[1]
					ItemMax = configs.Quantidade[2]

					itens = configs.itens

					locs = configs.locs

					random = configs.random

					for k,v in ipairs(locs) do
						if k > parseInt(maxlocs) then
							maxlocs = k
						end
					end
				end
			end

		Citizen.Wait(riqz)
	end
end)



Citizen.CreateThread(function()
	while true do
		local riqz = 1000
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 10 then
				local riqz = 1
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,186,186,186,80,0,0,0,1)
				DrawMarker(27,CoordenadaX,CoordenadaY,CoordenadaZ-1,0,0,0,0.0,0,0,0.5,0.5,0.4,186,186,186,80,0,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ABRIR O PAINEL DE COLETAS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
						SendNUIMessage({type = 'open', itens = itens})
					end
				end
			end
		end
		Citizen.Wait(riqz)
	end
end)

RegisterNUICallback("iniciar",function(data,cb)
	if data.numitem == nil then 
		return
	else
	    func.iniciar(data.numitem)
	end
end)


function func.iniciar(numeroitem)
	itemselected = itens[numeroitem][1]

	if itemselected ~= nil then
		servico = true

		if random == true then
			selecionado = math.random(12)
		else 
			selecionado = 1
		end
		CriandoBlip(locs,selecionado)
		TriggerEvent("Notify","sucesso","Você entrou em serviço.")
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local riqz = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)
			
			if distance <= 3 then
				local riqz = 1
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA COLETAR "..string.upper(itemselected).."",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
						if func.checkPayment(itemselected, ItemMin, ItemMax) then
							TriggerEvent('cancelando',true)
							RemoveBlip(blips)
							backentrega = selecionado
							processo = true
							segundos = 4
							vRP._playAnim(false,{{"anim@heists@ornate_bank@grab_cash_heels","grab"}},true)
							if random == true then
								selecionada = math.random(maxlocs)
								while (selecionada == backentrega) do
									selecionada = math.random(maxlocs)
								end
								selecionado = selecionada
							else
								if selecionado == #locs then
									selecionado = 1
								else
									selecionado = selecionado + 1
								end
							end
							CriandoBlip(locs,selecionado)
						end
					end
				end
			end
		end
		Citizen.Wait(riqz)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			if IsControlJustPressed(0,168) then
				servico = false
				itemselected = ''
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				TriggerEvent('cancelando',false)
				ClearPedTasks(PlayerPedId())
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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
	AddTextComponentString("COLETAR "..string.upper(itemselected).."")
	EndTextCommandSetBlipName(blips)
end

Citizen.CreateThread(function()
	while true do
      local riqz = 1000
      if servico then
		riqz = 5
		drawTxt("VÁ ATÉ O DESTINO PARA COLETAR ~g~"..string.upper(itemselected).."",4,0.270,0.93,0.45,255,255,255,200)
		drawTxt("PRESSIONE ~r~F7~w~ SE DESEJA FINALIZAR A ROTA",4,0.270,0.905,0.45,255,255,255,200)
      end
	  Citizen.Wait(riqz)
	end
end)