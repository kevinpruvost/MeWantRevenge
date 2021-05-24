--[[
    MeWantRevengeCommand.lua

    Description:
    Most of the commands implemented for MeWantRevenge are for testing purposes.

    Maybe some useful user-oriented commands will be added in the future.
]]

---------------------------------------------------------------
-- MeWantRevenge_Command()
-- A global dictionary is created to optimize commands access.
MeWantRevenge_Command_CommandsDictionary = {
    ["HELP"] = MeWantRevenge_Help,
    ["OTHER"] = MeWantRevenge_Help
}
-- The function itself
function MeWantRevenge_Command(arg1, ...)
	print("Command executed: "..arg1);
	local Command = string.upper(arg1);
	local DescriptionOffset = string.find(arg1,"%s",1);
	local Description = nil;
	
	if (DescriptionOffset) then
		Command = string.upper(string.sub(arg1, 1, DescriptionOffset - 1));
		Description = tostring(string.sub(arg1, DescriptionOffset + 1));
	end
	
	print("Command executed: "..Command);
	
    if #arg >= 0 then
        MeWantRevenge_Command_CommandsDictionary[Command](arg)
    else
        MeWantRevenge_Command_CommandsDictionary[Command]()
    end
end

SLASH_ME_WANT_REVENGE1 = "/mwr"
SLASH_ME_WANT_REVENGE2 = "/MeWantRevenge"
SlashCmdList["ME_WANT_REVENGE"] = MeWantRevenge_Command;