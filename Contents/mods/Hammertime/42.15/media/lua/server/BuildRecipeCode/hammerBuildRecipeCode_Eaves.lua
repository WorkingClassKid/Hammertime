hammerBuildRecipeCode = hammerBuildRecipeCode or {}
hammerBuildRecipeCode.Eaves= {}
hammerBuildRecipeCode.EavesCorner= {}
hammerBuildRecipeCode.EavesEnding= {}
--
-- hammerBuildRecipeCode.Eaves.OnIsValid(params)
--
-- This script allow players to places eaves
-- This function is a modified version of the vanilla needToBeAgainstWall logic from ISBuildIsoEntity.lua.
--
-- Return false if not placed against a DoorWallN, WallN, WindowN, DoorWallW, WallW, or WindowW.
-- Return false if the square contains a forbiddenVanillaTile.
-- Return false if there is already an eave on the square (based on the 'isEave' flag in the tilesheet. Eaves without this flag should be added to forbiddenVanillaTiles.)
-- Return true if placed against a wall, door frame, or window frame, provided there are no forbiddenVanillaTiles on the square.
-- Return false for anything else (default Project Zomboid behaviour).
--
function hammerBuildRecipeCode.Eaves.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.Eaves.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    local errorCount = 0 -- Set errorCount to 0
    local allowedTilesCheck = 0 -- Set allowedTilesCheck to 0

    -- List of tiles we can build eaves on but don't have any special properties (DoorWallN, WallN, WindowN, DoorWallW, WallW, WindowW)
    local allowedTiles = {
        "fixtures_doors_frames_01_1",
    }

    -- List of vanilla tile that don't have the isEave tile property and we don't want to build eaves on
    local forbiddenVanillaTiles = {
    }

    local originalSq = params.square
    local x = originalSq:getX()
    local y = originalSq:getY()
    local z = originalSq:getZ()
    local face = params.facing
    htPrint("Face: " .. face)

    square = getSquare(x, y, z)
    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)

        -- Check if it's againts a wall
        if (params.north and obj:getProperties():has("DoorWallN"))
            or (params.north and obj:getProperties():has("WallN"))
            or (params.north and obj:getProperties():has("WindowN"))
            or (not params.north and obj:getProperties():has("DoorWallW"))
            or (not params.north and obj:getProperties():has("WallW"))
            or (not params.north and obj:getProperties():has("WindowW"))
            then

            -- If it's against a wall, we will perform additionnal checks

            for j = 0, square:getObjects():size() - 1 do
                local sObj = square:getObjects():get(j)
                htPrint("Index:", j, "Object on Square:", sObj, "Type:", tostring(sObj:getObjectName()))

                -- Additionnal check against forbiddentVanillaTiles
                -- Add an error if spriteName is in forbiddenVanillaTiles
                local sprite = sObj:getSprite()
                local spriteName = sprite:getName()
                htPrint("spriteName:", spriteName)

                if spriteName then
                    for _, v in ipairs(forbiddenVanillaTiles) do
                        if v == spriteName then
                            htPrint("hammerBuildRecipeCode.Eaves.OnIsValid (errorCount + 1)")
                            errorCount = errorCount + 1
                            break
                        end
                    end
                end

                -- We check if the sprite is in allowedTiles
                for _, v in ipairs(allowedTiles) do
                    if v == spriteName then
                        htPrint("hammerBuildRecipeCode.Eaves.OnIsValid (allowedTilesCheck + 1)")
                        allowedTilesCheck = allowedTilesCheck + 1
                    end

                end

                -- We check if their is already a Eave on the tile. If yes, we return false
                if (sObj:getProperties():has(IsoFlagType.isEave)) then
                       htPrint("false hammerBuildRecipeCode.Eaves.OnIsValid (isEave)")
                       return false
                end
            end

            -- If errorCount > 0 the script will return false
            if (allowedTilesCheck >= 0 and errorCount <= 0) then
                htPrint("true hammerBuildRecipeCode.Eaves.OnIsValid (errorCount < 0)")
                return true

                -- If errorCount > 0 the script return false
                else
                    htPrint("false hammerBuildRecipeCode.Eaves.OnIsValid (errorCount > 0)")
                    return false
                end

                -- return false for anything else
                htPrint("false hammerBuildRecipeCode.Eaves.OnIsValid")
                return false
            end

        end

    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.Eaves.OnIsValid")
    return false
end

--
-- hammerBuildRecipeCode.EavesCorner.OnIsValid(params)
--
-- This script allow players to places eaves corners
-- This function is a modified version of the vanilla needToBeAgainstWall logic from ISBuildIsoEntity.lua.
--
-- Return false if not placed against a wall corner (WallSE)
-- Return false if the square contains a forbiddenVanillaTile.
-- Return false if there is already an eave on the square (based on the 'isEave' flag in the tilesheet. Eaves without this flag should be added to forbiddenVanillaTiles.)
-- Return true if placed against a wall corner (WallSE) and there are no forbiddenVanillaTiles on the square.
-- Return false for anything else (default Project Zomboid behaviour).
--
function hammerBuildRecipeCode.EavesCorner.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.EavesCorner.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    local errorCount = 0 -- Set errorCount to 0
    local allowedTilesCheck = 0 -- Set allowedTilesCheck to 0

    -- List of tiles we can build eaves on but don't have any special properties (WallSE)
    local allowedTiles = {

    }

    -- List of vanilla tile that don't have the isEave tile property and we don't want to build eaves on
    local forbiddenVanillaTiles = {
    }

    local originalSq = params.square
    local x = originalSq:getX()
    local y = originalSq:getY()
    local z = originalSq:getZ()
    local face = params.facing
    htPrint("Face: " .. face)

    square = getSquare(x, y, z)
    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)

        -- Check if it's againts a wall corner (WallSE)
        if (obj:getProperties():has(IsoFlagType.WallSE))
            then

            -- If it's against a wall, we will perform additionnal checks

            for j = 0, square:getObjects():size() - 1 do
                local sObj = square:getObjects():get(j)
                htPrint("Index:", j, "Object on Square:", sObj, "Type:", tostring(sObj:getObjectName()))

                -- Additionnal check against forbiddentVanillaTiles
                -- Add an error if spriteName is in forbiddenVanillaTiles
                local sprite = sObj:getSprite()
                local spriteName = sprite:getName()
                htPrint("spriteName:", spriteName)

                if spriteName then
                    for _, v in ipairs(forbiddenVanillaTiles) do
                        if v == spriteName then
                            htPrint("hammerBuildRecipeCode.EavesCorner.OnIsValid (errorCount + 1)")
                            errorCount = errorCount + 1
                            break
                        end
                    end
                end

                -- We check if the sprite is in allowedTiles
                for _, v in ipairs(allowedTiles) do
                    if v == spriteName then
                        htPrint("hammerBuildRecipeCode.EavesCorner.OnIsValid (allowedTilesCheck + 1)")
                        allowedTilesCheck = allowedTilesCheck + 1
                    end

                end

                -- We check if their is already a Eave on the tile. If yes, we return false
                if (sObj:getProperties():has(IsoFlagType.isEave)) then
                       htPrint("false hammerBuildRecipeCode.EavesCorner.OnIsValid (isEave)")
                       return false
                end
            end

            -- If errorCount > 0 the script will return false
            if (allowedTilesCheck >= 0 and errorCount <= 0) then
                htPrint("true hammerBuildRecipeCode.EavesCorner.OnIsValid (errorCount < 0)")
                return true

                -- If errorCount > 0 the script return false
                else
                    htPrint("false hammerBuildRecipeCode.EavesCorner.OnIsValid (errorCount > 0)")
                    return false
                end

                -- return false for anything else
                htPrint("false hammerBuildRecipeCode.EavesCorner.OnIsValid")
                return false
            end

        end

    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.EavesCorner.OnIsValid")
    return false
end


--
-- hammerBuildRecipeCode.EavesEnding.OnIsValid(params)
--
-- This script allow players to places eaves ending
-- This function is a modified version of the vanilla needToBeAgainstWall logic from ISBuildIsoEntity.lua.
--
-- Return false if not placed against a DoorWallN, WallN, WindowN, DoorWallW, WallW, WallSE or WindowW.
-- Return false if the square contains a forbiddenVanillaTile.
-- Return false if there is already an eave ending on the square (based on the 'isEave' flag in the tilesheet. Eaves without this flag should be added to forbiddenVanillaTiles.)
-- Return true if placed against a wall, door frame, or window frame, provided there are no forbiddenVanillaTiles on the square.
-- Return false for anything else (default Project Zomboid behaviour).
--
function hammerBuildRecipeCode.EavesEnding.OnIsValid(params)
    htPrint("hammerBuildRecipeCode.EavesEnding.OnIsValid triggered | Server:", isServer(), "Client:", isClient())
    local errorCount = 0 -- Set errorCount to 0
    local allowedTilesCheck = 0 -- Set allowedTilesCheck to 0

    -- List of tiles we can build eaves on but don't have any special properties (WallSE)
    local allowedTiles = {

    }

    -- List of vanilla tile that don't have the isEave tile property and we don't want to build eaves on
    local forbiddenVanillaTiles = {
    }


    local originalSq = params.square
    local x = originalSq:getX()
    local y = originalSq:getY()
    local z = originalSq:getZ()
    local face = params.facing
    htPrint("Face: " .. face)

    -- We modify the square location to get the corner tile
    if("n" == face) then
        x = x + 1;
	end
    	if("w" == face) then
		y = y + 1;
	end
    square = getSquare(x, y, z)

    for i = 0, square:getObjects():size() - 1 do
        local obj = square:getObjects():get(i)

        -- Check if it's againts a wall corner (WallSE)
        if (params.north and obj:getProperties():has("DoorWallN"))
        or (params.north and obj:getProperties():has("WallN"))
        or (params.north and obj:getProperties():has("WindowN"))
        or (not params.north and obj:getProperties():has("DoorWallW"))
        or (not params.north and obj:getProperties():has("WallW"))
        or (not params.north and obj:getProperties():has("WindowW"))
        or (obj:getProperties():has(IsoFlagType.WallSE))
            then

            -- If it's against a wall, we will perform additionnal checks

            for j = 0, square:getObjects():size() - 1 do
                local sObj = square:getObjects():get(j)
                htPrint("Index:", j, "Object on Square:", sObj, "Type:", tostring(sObj:getObjectName()))

                -- Additionnal check against forbiddentVanillaTiles
                -- Add an error if spriteName is in forbiddenVanillaTiles
                local sprite = sObj:getSprite()
                local spriteName = sprite:getName()
                htPrint("spriteName:", spriteName)

                if spriteName then
                    for _, v in ipairs(forbiddenVanillaTiles) do
                        if v == spriteName then
                            htPrint("hammerBuildRecipeCode.EavesEnding.OnIsValid (errorCount + 1)")
                            errorCount = errorCount + 1
                            break
                        end
                    end
                end

                -- We check if the sprite is in allowedTiles
                for _, v in ipairs(allowedTiles) do
                    if v == spriteName then
                        htPrint("hammerBuildRecipeCode.EavesEnding.OnIsValid (allowedTilesCheck + 1)")
                        allowedTilesCheck = allowedTilesCheck + 1
                    end

                end

            end

            -- We perform additionnal check on the originalSquare to see if their is already a eave ending on the tile

            for j = 0, originalSq:getObjects():size() - 1 do
                local originalSqObj = originalSq:getObjects():get(j)
                htPrint("Index:", j, "Object on originalSq:", originalSqObj, "Type:", tostring(originalSqObj:getObjectName()))

                local originalSqSprite = originalSqObj:getSprite()
                local originalSqSpriteName = originalSqSprite:getName()
                htPrint("originalSqSpriteName:", originalSqSpriteName)


                -- We check if their is already a Eave ending on the tile. If yes, we return false
                if (originalSqObj:getProperties():has(IsoFlagType.isEave)) then
                       htPrint("false hammerBuildRecipeCode.EavesEnding.OnIsValid (isEave)")
                       return false
                end

            end

            -- If errorCount > 0 the script will return false
            if (allowedTilesCheck >= 0 and errorCount <= 0) then
                htPrint("true hammerBuildRecipeCode.EavesEnding.OnIsValid (errorCount < 0)")
                return true

                -- If errorCount > 0 the script return false
                else
                    htPrint("false hammerBuildRecipeCode.EavesEnding.OnIsValid (errorCount > 0)")
                    return false
                end

                -- return false for anything else
                htPrint("false hammerBuildRecipeCode.EavesEnding.OnIsValid")
                return false
            end

        end

    -- return false for anything else
    htPrint("false hammerBuildRecipeCode.EavesEnding.OnIsValid")
    return false
end
