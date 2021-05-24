--------------------------DEBUG-------------------------------[[
-- Aliases
SLASH_FRAMESTK1 = "/fs"
SlashCmdList["FRAMESTK"] = function ()
    LoadAddOn('Blizzard_DebugTools')    
    FrameStackTooltip_Toggle()    
end

-- To be able to use the arrow keys in the chat
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
end
--------------------------DEBUG-------------------------------]]


-------------------------------MeWantRevenge Code-------------------------------[[
local AceGUI = LibStub("AceGUI-3.0")

local guids = {}
--------- CreateFrame 4th argument can be a comma-separated list of XML templates!
local window = AceGUI:Create("Frame")
window:SetTitle("MeWantRevenge")
window:SetStatusText("MeWantRevenge Container Frame")

------------------------------------------------------
-- On Window Load
function MeWantRevenge_OnLoad()
    print("Loading MeWantRevenge...")

    function window:NAME_PLATE_UNIT_ADDED(unit)
        guids[UnitGUID(unit)] = unit
    end
    
    function window:UNIT_PHASE(unit)
        print("phase_add ", unit)
    end
    
    function window:UNIT_TARGETABLE_CHANGED(unit)
        print("targetable_added ", unit)
    end
    
    function window:NAME_PLATE_UNIT_REMOVED(unit)
        guids[UnitGUID(unit)] = nil
    end
    
    window:SetScript("OnEvent", function(f, event, ...)
        f[event](f, ...)
    end)
    
    window:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    window:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    window:RegisterEvent("UNIT_PHASE")
    window:RegisterEvent("UNIT_TARGETABLE_CHANGED")
    
    print("MeWantRevenge loaded.")
end

window:Show()
-------------------------------MeWantRevenge Code-------------------------------]]
