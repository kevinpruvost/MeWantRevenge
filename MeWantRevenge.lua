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
MWRWindow = AceGUI:Create("Frame")
MWRWindow:SetTitle("MeWantRevenge")
MWRWindow:SetStatusText("MeWantRevenge Container Frame")

------------------------------------------------------
-- On Window Load
function MeWantRevenge_OnLoad()
    print("Loading MeWantRevenge...")

    function MWRWindow:NAME_PLATE_UNIT_ADDED(unit)
        guids[UnitGUID(unit)] = unit
    end
    
    function MWRWindow:UNIT_PHASE(unit)
        print("phase_add ", unit)
    end
    
    function MWRWindow:UNIT_TARGETABLE_CHANGED(unit)
        print("targetable_added ", unit)
    end
    
    function MWRWindow:NAME_PLATE_UNIT_REMOVED(unit)
        guids[UnitGUID(unit)] = nil
    end
    
    MWRWindow:SetScript("OnEvent", function(f, event, ...)
        f[event](f, ...)
    end)
    
    MWRWindow:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    MWRWindow:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    MWRWindow:RegisterEvent("UNIT_PHASE")
    MWRWindow:RegisterEvent("UNIT_TARGETABLE_CHANGED")
    
    print("MeWantRevenge loaded.")
end

MWRWindow:Hide()
-------------------------------MeWantRevenge Code-------------------------------]]
