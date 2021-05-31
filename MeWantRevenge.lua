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
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("MeWantRevenge")
local _

local guids = {}
--------- CreateFrame 4th argument can be a comma-separated list of XML templates!
MeWantRevengeWindow = AceGUI:Create("Frame", nil, UIParent)
MeWantRevengeWindow:SetTitle("MeWantRevenge")
MeWantRevengeWindow:SetWidth(300)
MeWantRevengeWindow:SetHeight(300)

local logo = AceGUI:Create("Label")
logo:SetImage("Interface\\Addons\\MeWantRevenge\\resources\\logo.tga")
logo:SetImageSize(150, 150)
MeWantRevengeWindow:AddChild(logo)

local editbox = AceGUI:Create("EditBox")
editbox:SetLabel("Insert text:")
editbox:SetWidth(200)
MeWantRevengeWindow:AddChild(editbox)

local ColorPicker = AceGUI:Create("ColorPicker")
MeWantRevengeWindow:AddChild(ColorPicker)

local slider = AceGUI:Create("Slider")
slider:SetWidth(200)
slider:SetHeight(200)
MeWantRevengeWindow:AddChild(slider)

------------------------------------------------------
-- On Window Load
function MeWantRevenge_OnLoad()
    print("Loading MeWantRevenge...")

    function MeWantRevengeWindow:NAME_PLATE_UNIT_ADDED(unit)
        guids[UnitGUID(unit)] = unit
    end
    
    function MeWantRevengeWindow:UNIT_PHASE(unit)
        print("phase_add ", unit)
    end
    
    function MeWantRevengeWindow:UNIT_TARGETABLE_CHANGED(unit)
        print("targetable_added ", unit)
    end
    
    function MeWantRevengeWindow:NAME_PLATE_UNIT_REMOVED(unit)
        guids[UnitGUID(unit)] = nil
    end
    
    MeWantRevengeWindow:SetScript("OnEvent", function(f, event, ...)
        f[event](f, ...)
    end)
    
    MeWantRevengeWindow:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    MeWantRevengeWindow:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    MeWantRevengeWindow:RegisterEvent("UNIT_PHASE")
    MeWantRevengeWindow:RegisterEvent("UNIT_TARGETABLE_CHANGED")
    
    print("MeWantRevenge loaded.")
end

MeWantRevengeWindow:Hide()
-------------------------------MeWantRevenge Code-------------------------------]]
