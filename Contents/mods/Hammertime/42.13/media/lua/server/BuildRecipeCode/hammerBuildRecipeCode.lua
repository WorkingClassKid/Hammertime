hammerBuildRecipeCode = hammerBuildRecipeCode or {}
hammerBuildRecipeCode.GarageDoor = {}
hammerBuildRecipeCode.WallCabinet = {}
hammerBuildRecipeCode.WallCabinetCorner = {}

--
-- DEBUG: We can inspect the contents of the params variable using this snippet.
-- Place the snipplet as the first line of any functions in this file and be sure to have PZ debug mode on
--
--    htPrint("---- params DUMP ----")
--    for k, v in pairs(params) do
--        htPrint("params key:", k, "value:", tostring(v))
--    end
--    htPrint("----- END DUMP params ----")



--
-- hammerBuildRecipeCode.GarageDoor.OnCreate(params)
--
-- By default, PZ spawn every structure build by a player using an entities script as an IsoThumpable.
-- Because of this, Garage Doors entities script didn't work "out of the box" because they spawn as IsoThumpable and the game expect and IsoDoor to get it works.
-- To get garage doors working, we need to create an IsoDoor for the garage door and be sure that the IsoThumpable is deleted from the square and never sent to the client.

function hammerBuildRecipeCode.GarageDoor.OnCreate(params)
    htPrint("hammerBuildRecipeCode.GarageDoor.OnCreate triggered | Server:", isServer(), "Client:", isClient())

    local thumpable = params.thumpable
    
    -- Create an IsoDoor
    local garageDoor = IsoDoor.new(getCell(), thumpable:getSquare(), thumpable:getSprite(), thumpable:getNorth())
    local md = garageDoor:getModData()
    
    -- Set a ModData GarageDoorCustom to the new garage door...just for tracking purpose
    md.GarageDoorCustom = true
    garageDoor:transmitModData()

    -- Debug print the thumpable and the new garageDoor if we are in Debug mode
    htPrint("thumpable variable:", thumpable)
    htPrint("garageDoor variable:", garageDoor)
    -- Debut print the ModData of garageDoor if we are in Debug mode
    htPrint("---- garageDoor MODDATA DUMP ----")
        for k, v in pairs(md) do
            htPrint("   ", k, "=", tostring(v))
        end
    htPrint("---- END DUMP garageDoor ----")
    htPrint("thumpable variable:", thumpable)
    htPrint("garageDoor variable:", garageDoor)

    -- Set the new garageDoor properties
    garageDoor:setName(thumpable:getName())
    garageDoor:setHealth(thumpable:getHealth())
    garageDoor:setKeyId(thumpable:getKeyId())
    garageDoor:setIsLocked(false)
    garageDoor:setLockedByKey(false)
    garageDoor:setModData(copyTable(thumpable:getModData()))

    -- We add the garageDoor to the world and transmit the information to the client
    garageDoor:getSquare():AddSpecialObject(garageDoor) 
    garageDoor:transmitCompleteItemToClients()

    -- Debug print the list of Special Objects on the square BEFORE the IsoThumpable get removed
    
    --htPrint("---- BEFORE SPECIAL OBJECTS ON SQUARE ----")
    --local bsquare = params.thumpable and params.thumpable:getSquare()
    --local beforelist = bsquare:getSpecialObjects()
    --
    --for i = 0, beforelist:size()-1 do
    --    local beforeobj = beforelist:get(i)
    --    htPrint("Index:", i, "Object:", beforeobj, "Type:", tostring(beforeobj:getObjectName()))
    --
    --  -- Dump modData too
    --   local beforemd = beforeobj:getModData()
    --    htPrint("   ModData:")
    --    for k, v in pairs(beforemd) do
    --        htPrint("      ", k, "=", tostring(v))
    --    end
    --end
    --htPrint("---- END BEFORE SPECIAL OBJECTS ON SQUARE ----")
    
    
    -- We remove the thumpable from the square
    thumpable:removeFromWorld();
    thumpable:removeFromSquare();
    
    -- We make sure garageDoor is synced
    garageDoor:sync()

    --local x = thumpable:getX()
    --local y = thumpable:getY()
    --local z = thumpable:getZ()
    --htPrint("coords:", x, y, z)

    -- Debug print the list of Special Objects on the square AFTER the IsoThumpable get removed
    
    --htPrint("---- AFTER SPECIAL OBJECTS ON SQUARE ----")
    --local square = params.thumpable and params.thumpable:getSquare()
    --local list = square:getSpecialObjects()
    --for i = 0, list:size()-1 do
    --    local obj = list:get(i)
    --    htPrint("Index:", i, "Object:", obj, "Type:", tostring(obj:getObjectName()))
    --
    --    -- Dump modData too
    --    local md = obj:getModData()
    --    htPrint("   ModData:")
    --    for k, v in pairs(md) do
    --        htPrint("      ", k, "=", tostring(v))
    --    end
    --end
    --htPrint("---- END AFTER SPECIAL OBJECTS ON SQUARE -----")

    -- We return objectAlreadyTransmitted = true to tell the vanilla building script (media\lua\server\BuildingObjects\ISBuildIsoEntity.lua (line 784)) that the information as already been sent to the client dans not send the IsoThumpable to the client
    return { objectAlreadyTransmitted = true }
end

--
-- hammerBuildRecipeCode.WallCabinet.OnIsValid(params)
--
-- By default, PZ doesn’t allow any needToBeAgainstWall placement over objects classified as IsoThumpable (which includes most player‑built structures).
-- This function is a modified version of the vanilla needToBeAgainstWall logic from ISBuildIsoEntity.lua, allowing players to place a Cabinet_Wall on top of a crafted Cabinet_Base.
--
-- Return false if placed over a Cabinet_Base that don't have "Counter" setup as CustomName in the tilesheet def
-- Return false if the originalSq have a forbidenVanillaTiles on it
-- Return false if their is already a hammertime Cabinet_Wall of the tile. Hammertime crafted Cabinet_Wall have "WallCounter" as CustomName in the tilesheet def
-- Return true if Cabinet_Base have "Counter" setup as CustomName, their is no forbidenVanillaTiles on the square and it's against a wall
-- Return false for anything else (as pz default behavior)
--
function hammerBuildRecipeCode.WallCabinet.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.WallCabinet.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    
    -- List of vanilla tile that have CustomName = Counter in the tilesheet def but we can't build a Cabinet_Wall on
    local forbidenVanillaTiles = {
        "location_trailer_02_18",
        "furniture_shelving_01_1"
    }

    local errorCount = 0 -- Set errorCount to 0
    local originalSq = params.square
    local square = params.square
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    local face = params.facing
    if("n" == face) then
		y = y + 1;
	end
    	if("w" == face) then
		x = x + 1;
	end
    htPrint(face)
    square = getSquare(x, y, z)
    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)
        
        -- Check if it's againts a wall
        if (params.north and obj:getProperties():has("WallN")) or (not params.north and obj:getProperties():has("WallW")) then 
        --htPrint(obj)
        
            -- If it's against a wall, we will perform additionnal checks
            
            for j = 0, originalSq:getObjects():size() - 1 do
                local sObj = originalSq:getObjects():get(j)
                htPrint("Index:", j, "Object on Square:", sObj, "Type:", tostring(sObj:getObjectName()))
                
                -- Additionnal check against forbidentVanillaTiles 
                -- Add an error if spriteName is in forbidenVanillaTiles
                local sprite = sObj:getSprite()
                local spriteName = sprite:getName()
                htPrint("spriteName:", spriteName) 
                if spriteName then
                    for _, v in ipairs(forbidenVanillaTiles) do
                        if v == spriteName then
                            htPrint("false forbidenVanillaTiles")
                            errorCount = errorCount + 1
                            break
                        end
                    end
                end
                
                -- Additionnal check to see if their is an IsoThumpable on the tile and if we can add a Cabinel_Wall on the same tile.
                -- Return true error if sprite CustomName = Counter 
                -- Add an error if sprite CustomName = WallCounter
                -- Add an error for anything else
                if instanceof(sObj, "IsoThumpable") then 
                    local customName = sObj:getProperties():get("CustomName")
                    if customName == "Counter" then
                        htPrint("true CustomName = Counter") 
                    elseif customName == "WallCounter" then
                        htPrint("false Already have a hammertime Cabinet_Wall") 
                        errorCount = errorCount + 1
                    else
                        htPrint("false Failed isoThumpable check")
                        errorCount = errorCount + 1
                    end
                end
            end

            htPrint("Still true after -Check if it's againts a wall-.... Checking for additionnal checks errorCount")
            -- If errorCount > 0 the script return false
            if errorCount > 0 then
                htPrint("false errorCount > 0")
                return false
             
             -- If errorCount == 0 the script return true
            else
                htPrint("true hammerBuildRecipeCode.WallCabinetCorner.OnIsValid (true wall + no errorCount)")
                return true
            end
        end
    end
    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.WallCabinet.OnIsValid")
    return false
end



--
-- hammerBuildRecipeCode.WallCabinetCorner.OnIsValid(params)
--
-- This fuction is a modified version of hammerBuildRecipeCode.WallCabinet.OnIsValid(params).
-- This function allow placing Cabinet_Wall corners on a vanilla corner WALLNW tile.
-- Also solve and issue where you can't place a Cabinet_Wall corner in the top-left corner.
--
-- Return false if placed over a Cabinet_Base that don't have "Counter" setup as CustomName in the tilesheet def
-- Return false if the originalSq have a forbidenVanillaTiles on it
-- Return false if their is already a hammertime Cabinet_Wall of the tile. Hammertime crafted Cabinet_Wall have "WallCounter" as CustomName in the tilesheet def
-- Return true if Cabinet_Base have "Counter" setup as CustomName, their is no forbidenVanillaTiles on the square and it's against a wall
-- Return false for anything else (as pz default behavior)
--

function hammerBuildRecipeCode.WallCabinetCorner.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.WallCabinetCorner.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    
    -- List of vanilla tile that have CustomName = Counter in the tilesheet def but we can't build a Cabinet_Wall on
    local forbidenVanillaTiles = {
        "location_trailer_02_18" 
    }

    local errorCount = 0 -- Set errorCount to 0
    local originalSq = params.square
    local square = params.square
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    local face = params.facing
    if("n" == face) then
		y = y + 1;
	end
    htPrint(face)
    square = getSquare(x, y, z)
    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)
        
        -- Check if it's againts a wall
        if (params.north and obj:getProperties():has("WallN")) or (not params.north and obj:getProperties():has("WallW")) or (not params.north and obj:getProperties():has("WallNW")) then 
        --htPrint(obj)
        
            -- If it's against a wall, we will perform additionnal checks
            
            for j = 0, originalSq:getObjects():size() - 1 do
                local sObj = originalSq:getObjects():get(j)
                htPrint("Index:", j, "Object on Square:", sObj, "Type:", tostring(sObj:getObjectName()))
                
                -- Additionnal check against forbidentVanillaTiles 
                -- Add an error if spriteName is in forbidenVanillaTiles
                local sprite = sObj:getSprite()
                local spriteName = sprite:getName()
                htPrint("spriteName:", spriteName) 
                if spriteName then
                    for _, v in ipairs(forbidenVanillaTiles) do
                        if v == spriteName then
                            htPrint("false forbidenVanillaTiles")
                            errorCount = errorCount + 1
                            break
                        end
                    end
                end
                
                -- Additionnal check to see if their is an IsoThumpable on the tile and if we can add a Cabinel_Wall on the same tile.
                -- Return true error if sprite CustomName = Counter 
                -- Add an error if sprite CustomName = WallCounter
                -- Add an error for anything else
                if instanceof(sObj, "IsoThumpable") then 
                    local customName = sObj:getProperties():get("CustomName")
                    if customName == "Counter" then
                        htPrint("true CustomName = Counter") 
                    elseif customName == "WallCounter" then
                        htPrint("false Already have a hammertime Cabinet_Wall") 
                        errorCount = errorCount + 1
                    else
                        htPrint("false Failed isoThumpable check")
                        errorCount = errorCount + 1
                    end
                end
            end

            htPrint("Still true after -Check if it's againts a wall-.... Checking for additionnal checks errorCount")
            -- If errorCount > 0 the script return false
            if errorCount > 0 then
                htPrint("false errorCount > 0")
                return false
             
             -- If errorCount == 0 the script return true
            else
                htPrint("true hammerBuildRecipeCode.WallCabinetCorner.OnIsValid (true wall + no errorCount)")
                return true
            end
        end
    end
    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.WallCabinetCorner.OnIsValid")
    return false
end
