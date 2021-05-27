--[[
    MeWantRevengeCommand.lua

    Description:
    Most of the commands implemented for MeWantRevenge are for testing purposes.

    Maybe some useful user-oriented commands will be added in the future.
]]

local function MeWantRevenge_Execute()
    if MeWantRevengeWindow:IsShown() then
        MeWantRevengeWindow:Hide()
    else
        MeWantRevengeWindow:Show()
    end
end

local function MeWantRevenge_Help(...)
    print("HELP!!!!1!!!1!!!")
end


---------------------------------------------------------------
-- MeWantRevenge_Command()
-- A global dictionary is created to optimize commands access.
MeWantRevenge_Command_CommandsDictionary = {
    [''] = MeWantRevenge_Execute,
    ['HELP'] = MeWantRevenge_Help,
    ['OTHER'] = MeWantRevenge_Help
}
-- The function itself
local function MeWantRevenge_Command(arg1)
    if arg1 == nil then
        arg1 = ''
    end
	local Command = string.upper(arg1);
	local DescriptionOffset = string.find(arg1,"%s",1);
	local Description = nil;
	
	if (DescriptionOffset) then
		Command = string.upper(string.sub(arg1, 1, DescriptionOffset - 1));
		Description = tostring(string.sub(arg1, DescriptionOffset + 1));
	end
	
    print("Executing Command : " .. Command);

    MeWantRevenge_Command_CommandsDictionary[Command]()
    print("Command executed successfully.")
end

SLASH_ME_WANT_REVENGE1 = "/MeWantRevenge"
SLASH_ME_WANT_REVENGE2 = "/MeWantRevenge"
SlashCmdList["ME_WANT_REVENGE"] = MeWantRevenge_Command;