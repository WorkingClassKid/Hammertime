htPrint = {};

-- 
-- htPrint
--
-- An alternative to print. Used to print only when PZ debug mode is on
-- Usage: htPrint("my debug message")
--

function htPrint(...)
    if isDebugEnabled() then
        print("Hammertime : ", ...)
    end
end

