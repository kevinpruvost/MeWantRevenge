local FontStrings={}
local FontFile
local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local _

SM:Register("font", "Big Noodle Titling", [[Interface\AddOns\MeWantRevenge\Fonts\BigNoodleTitling.ttf]])
SM:Register("font", "Expressway", [[Interface\AddOns\MeWantRevenge\Fonts\Expressway.ttf]])
SM:Register("font", "Myriad", [[Interface\AddOns\MeWantRevenge\Fonts\Myriad.ttf]])

function MeWantRevenge:AddFontString(string)
	local Font, Height, Flags

	FontStrings[#FontStrings+1] = string

	if not FontFile and MeWantRevenge.db.profile.Font then
		FontFile = SM:Fetch("font", MeWantRevenge.db.profile.Font)
	end

	if FontFile then
		Font, Height, Flags = string:GetFont()
		if Font ~= FontFile then
			string:SetFont(FontFile, Height, Flags)
		end
	end
end

function MeWantRevenge:SetFont(fontname)
	local Height, Flags

	MeWantRevenge.db.profile.Font = fontname
	FontFile = SM:Fetch("font",fontname)

	for k, v in pairs(FontStrings) do
		k, Height, Flags = v:GetFont()
		v:SetFont(FontFile, Height, Flags)
	end
end