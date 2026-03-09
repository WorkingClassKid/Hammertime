hammerBuildRecipeCode = hammerBuildRecipeCode or {}
hammerBuildRecipeCode.HESCOBarrierLvl2 = {}

--
-- hammerBuildRecipeCode.HESCOBarrier.OnIsValid(params)
--
-- This code check if we can build a HESCO Barrier Lvl 2 on the top of a HESCO Barrier Lvl 1.
--
-- Return false if their is no HESCO Barrier Lvl 1 on the tile
-- Return false if their is already a HESCO Barrier Lvl 2 on the tile
-- Return true if their is already a HESCO Barrier Lvl 1 on the tile and their is no HESCO Barrier Lvl 2 on the same tile
-- Return false for anything else (as pz default behavior)


function hammerBuildRecipeCode.HESCOBarrierLvl2.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.HESCOBarrierLvl2.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    local errorCount = 0 -- Set errorCount to 0
    local allowedTilesCheck = 0 -- Set allowedTilesCheck to 0
    
    -- List of level 1 HESCO Barrier where we can build the level 2 on
    local allowedTiles = {
		"ht_vanilla_fencing_01_0",
		"ht_vanilla_fencing_01_2",
		"ht_vanilla_fencing_01_4",
    }
    
    -- List of level 2 HESCO Barrier as we don't want to build a level 2 barrier when their is already one on the square
    local forbidenTiles = {
		"ht_vanilla_fencing_01_1",
		"ht_vanilla_fencing_01_3",
		"ht_vanilla_fencing_01_5",
    }
    
    local square = params.square
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()

    
    square = getSquare(x, y, z)
    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)
        
		local sprite = obj:getSprite()
        local spriteName = sprite:getName()
        htPrint("spriteName:", spriteName) 
        if spriteName then
			-- We check if the sprite on the tile are a HESCO Barrier Lvl 1
			for _, v in ipairs(allowedTiles) do
				if v == spriteName then
					htPrint("true AllowedTiles")
					allowedTilesCheck = allowedTilesCheck + 1
                end 
                
            end 
            
            -- We check if their is already an HESCO Barrier Lvl 2 on the tile to prevent duplicate
            for _, v in ipairs(forbidenTiles) do
				if v == spriteName then
					htPrint("false forbidenTiles")
                    errorCount = errorCount + 1
                end
            end
                 
        end    
    end
    
    -- If errorCount > 0 the script will return false
    if (allowedTilesCheck > 0 and errorCount <= 0) then
		htPrint("true hammerBuildRecipeCode.HESCOBarrierLvl2.OnIsValid (errorCount > 0)")
        return true
             
   -- If errorCount > 0 the script return false
    else
		htPrint("false hammerBuildRecipeCode.HESCOBarrierLvl2.OnIsValid")
        return false
    end
            
    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.HESCOBarrierLvl2.OnIsValid")
    return false
end
