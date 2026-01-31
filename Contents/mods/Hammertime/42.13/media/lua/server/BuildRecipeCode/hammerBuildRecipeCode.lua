hammerBuildRecipeCode = hammerBuildRecipeCode or {}
hammerBuildRecipeCode.GarageDoor = {}

function hammerBuildRecipeCode.GarageDoor.OnCreate(params)
    print("hammerBuildRecipeCode.GarageDoor.OnCreate triggered | Server:", isServer(), "Client:", isClient())

    print("---- params DUMP ----")
    for k, v in pairs(params) do
        print("params key:", k, "value:", tostring(v))
    end
    print("----- END DUMP params ----")

    local thumpable = params.thumpable
    local garageDoor = IsoDoor.new(getCell(), thumpable:getSquare(), thumpable:getSprite(), thumpable:getNorth())
    local md = garageDoor:getModData()
    md.GarageDoorCustom = true
    garageDoor:transmitModData()

    print("---- garageDoor MODDATA DUMP ----")
        for k, v in pairs(md) do
            print("   ", k, "=", tostring(v))
        end
    print("---- END DUMP garageDoor ----")

    print("thumpable variable:", thumpable)
    print("garageDoor variable:", garageDoor)

    garageDoor:setName(thumpable:getName())
    garageDoor:setHealth(thumpable:getHealth())
    garageDoor:setKeyId(thumpable:getKeyId())
    garageDoor:setIsLocked(false)
    garageDoor:setLockedByKey(false)
    garageDoor:setModData(copyTable(thumpable:getModData()))


    garageDoor:getSquare():AddSpecialObject(garageDoor) -- Ajoute l'objet spÃ©cial (3 tiles)
    garageDoor:transmitCompleteItemToClients()

    print("---- BEFORE SPECIAL OBJECTS ON SQUARE ----")
    local bsquare = params.thumpable and params.thumpable:getSquare()
    local beforelist = bsquare:getSpecialObjects()

    for i = 0, beforelist:size()-1 do
        local beforeobj = beforelist:get(i)
        print("Index:", i, "Object:", beforeobj, "Type:", tostring(beforeobj:getObjectName()))

        -- Dump modData too
        local beforemd = beforeobj:getModData()
        print("   ModData:")
        for k, v in pairs(beforemd) do
            print("      ", k, "=", tostring(v))
        end
    end
    print("---- END BEFORE SPECIAL OBJECTS ON SQUARE ----")

    thumpable:removeFromWorld();
    thumpable:removeFromSquare();
    garageDoor:sync()

    --garageDoor:getSquare():transmitRemoveItemFromSquare(garageDoor)
    --garageDoor:getSquare():transmitAddObjectToSquare(garageDoor, 0)

    local x = thumpable:getX()
    local y = thumpable:getY()
    local z = thumpable:getZ()
    print("coords:", x, y, z)


    print("---- AFTER SPECIAL OBJECTS ON SQUARE ----")
    local square = params.thumpable and params.thumpable:getSquare()
    local list = square:getSpecialObjects()
    for i = 0, list:size()-1 do
        local obj = list:get(i)
        print("Index:", i, "Object:", obj, "Type:", tostring(obj:getObjectName()))

        -- Dump modData too
        local md = obj:getModData()
        print("   ModData:")
        for k, v in pairs(md) do
            print("      ", k, "=", tostring(v))
        end
    end
    print("---- END AFTER SPECIAL OBJECTS ON SQUARE -----")


    return { objectAlreadyTransmitted = true }
end