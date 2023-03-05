local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("riqz_rotas",func)
fclient = Tunnel.getInterface("riqz_rotas")


vRP_groups = module("vrp", "cfg/groups")


function func.checkPayment(Item, ItemMin, ItemMax)
   local user_id = vRP.getUserId(source)
   local quantidade = math.random(ItemMin, ItemMax)
   if user_id then
        if vRP.computeInvWeight(user_id)+vRP.itemWeightList(Item) <= vRP.getBackpack(user_id) then
            vRP.giveInventoryItem(user_id,Item,quantidade)
            TriggerClientEvent("progress",source,10000,"coletando")
            TriggerClientEvent("Notify",source,"sucesso","<b>Você recebeu <r>"..quantidade.."x</r> de "..Item.."</b>")
            return true
        else
            TriggerClientEvent("Notify",source,"negado","<b>Inventário Cheio</b>.")
        end
	end
end



function func.getUserPerm(perm)
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,perm) then 
        return true
    end
end
