Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "HammerTime_Client" or command ~= "CreateGarageDoor" then
        return
    end
    print("HammerTime Client: Command received", module, command)
    print("HammerTime Client: Server:", isServer(), "Client:", isClient())
    print(args)
     for k, v in pairs(args) do
            print("      ", k, "=", tostring(v))
        end
    local cSquare = getSquare(args.x, args.y, args.z)
    print("Square:", cSquare)
    --local cThumpable = cSquare:getDoor()

    --cSquare:transmitRemoveItemFromSquare(thumpable)
    cSquare:RecalcProperties()
    cSquare:RecalcAllWithNeighbours(true)
    cSquare:setSquareChanged()

    print("HammerTime Client: Door created and transmitted")
end)