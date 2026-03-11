hammerBuildRecipeCode = hammerBuildRecipeCode or {}
hammerBuildRecipeCode.KeyDuplicator = {}
--
-- hammerBuildRecipeCode.KeyDuplicator.OnIsValid(params)
--
--
function hammerBuildRecipeCode.KeyDuplicator.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.KeyDuplicator.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    
    -- List of vanilla tile that have IsTable parameter in the tilesheet def but we can't build a Key Duplicator on
    local forbiddenVanillaTiles = {
    }

    local errorCount = 0 -- Set errorCount to 0
    local originalSq = params.square
    local square = params.square
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    local face = params.facing
    htPrint(face)
    
    square = getSquare(x, y, z)
    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)
        
        -- Check if it's a table (IsTable if the tiledef)
        if (obj:getProperties():has("IsTable")) then 
        --htPrint(obj)
        
            -- If it's a table (IsTable), we will perform additionnal checks
            
            for j = 0, originalSq:getObjects():size() - 1 do
                local sObj = originalSq:getObjects():get(j)
                htPrint("Index:", j, "Object on Square:", sObj, "Type:", tostring(sObj:getObjectName()))
                
                -- Additionnal check against forbiddentVanillaTiles
                -- Add an error if spriteName is in forbiddenVanillaTiles
                local sprite = sObj:getSprite()
                local spriteName = sprite:getName()
                htPrint("spriteName:", spriteName) 
                if spriteName then
                    for _, v in ipairs(forbiddenVanillaTiles) do
                        if v == spriteName then
                            htPrint("false forbiddenVanillaTiles")
                            errorCount = errorCount + 1
                            break
                        end
                    end
                end               
            end

            htPrint("Still true after IsTable.... Checking for additionnal checks errorCount")
            -- If errorCount > 0 the script return false
            if errorCount > 0 then
                htPrint("false errorCount > 0")
                return false
             
             -- If errorCount == 0 the script return true
            else
                htPrint("true hammerBuildRecipeCode.KeyDuplicator.OnIsValid (IsTable + no errorCount)")
                return true
            end
        end
    end
    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.KeyDuplicator.OnIsValid")
    return false
end
