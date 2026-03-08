hammerCraftRecipeCode = hammerCraftRecipeCode or {}
hammerCraftRecipeCode.KeyDuplicator = {}
hammerCraftRecipeCode.CopyCarKey = {}

--
-- hammerCraftRecipeCode.KeyDuplicator.OnTest(items, player)
--
-- We check if the key duplicator have electricity to work

-- Return true if we have electricity
-- Return false for anything else (as pz default behavior)

function hammerCraftRecipeCode.KeyDuplicator.OnTest(items, player)
	htPrint("hammerCraftRecipeCode.KeyDuplicator.OnTest triggered | Server:", isServer(), "Client:", isClient())
    -- We get the current square where the player is
    local square = player:getCurrentSquare()
    if not square then return false end
    
    -- We check if the electricity is still available on the map
    local globalPower = getWorld():isHydroPowerOn()

    -- We check if we have electricity from a generator
    local squareHasPower = square:haveElectricity()

    --htPrint("Power Debug - Global: " .. tostring(getWorld():isHydroPowerOn()) .. " Square: " .. tostring(square:haveElectricity()))

	-- Return true if we have globalPower or squareHasPower return true
    if globalPower or squareHasPower then
        return true
    end

    return false
end

--
-- hammerCraftRecipeCode.CopyCarKey.OnCreate(params)
--
-- The original PZ RecipeCodeOnCreate.copyKey script only accept buildings key for duplicating or it will return -1 for the keyId. So we need to create our own for duplicating cars keys. 
--
-- This script will rename the new key and set the keyId on it
-- 

function hammerCraftRecipeCode.CopyCarKey.OnCreate(items, player)
	htPrint("hammerCraftRecipeCode.CopyCarKey.OnCreate triggered | Server:", isServer(), "Client:", isClient())
    local keyId = -1

    -- We get all the input items variable of the recipe
    local allInputItems = items:getAllInputItems()
    
    for i=0, allInputItems:size() - 1 do

		local item = allInputItems:get(i)

        -- We check if we got a CarKey
        if item:getType() == "CarKey" then
			
			-- We get the KeyId from the original key
            keyId = item:getKeyId()
            -- We get the Name from the original key
            keyName = item:getName()
            break
        end
    end
    
    -- Configuration of the output item (newKey)
    
    local copyCarKeyOutput = items:getAllCreatedItems()
	
	-- Filter of the output items
     for i=0, copyCarKeyOutput:size() - 1 do
     
		local newKey = copyCarKeyOutput:get(i)
		
        -- We check if we got a CarKey
        if newKey:getType() == "CarKey" then
			-- We set the keyId
			newKey:setKeyId(keyId)
			-- We set the name of the newKey
			newKey:setName(keyName .. '#' .. keyId)
			
			player:Say(getText("IGUI_htCopyKeyCompleted") .. '-' .. keyName)
            break
        end
    end
end
