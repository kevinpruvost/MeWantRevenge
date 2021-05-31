function MeWantRevenge:CreateFrame(Name, Title, Height, Width, ShowFunc, HideFunc)
	local theFrame = CreateFrame("Frame", Name, UIParent, "BackdropTemplate")

	theFrame:ClearAllPoints()
	theFrame:SetPoint("TOP", UIParent)
	theFrame:SetHeight(Height)
	theFrame:SetWidth(Width)
	theFrame:EnableMouse(true)
	theFrame:SetMovable(true)
	theFrame:SetScript("OnMouseDown", function(self, event) 
		if (((not self.isLocked) or (self.isLocked == 0)) and (event == "LeftButton")) then
			MeWantRevenge:SetWindowTop(self)
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	theFrame:SetScript("OnMouseUp", function(self) 
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			MeWantRevenge:SaveMainWindowPosition()
		end
	end)
	theFrame.ShowFunc = ShowFunc
	theFrame:SetScript("OnShow", function(self)
		MeWantRevenge:SetWindowTop(self)
		if (self.ShowFunc) then
			self:ShowFunc()
		end
	end)
	theFrame.HideFunc = HideFunc
	theFrame:SetScript("OnHide", function(self) 
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
		if (self.HideFunc) then
			self:HideFunc()
		end
	end)
	
	theFrame.Background = theFrame:CreateTexture(nil, "BACKGROUND")	
	theFrame.Background:ClearAllPoints()
	theFrame.Background:SetTexture("Interface\\CHARACTERFRAME\\UI-Party-Background")
	if not MeWantRevenge.db.profile.InvertMeWantRevenge then
		theFrame.Background:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 0, -32)
		theFrame.Background:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", 0, 2)	
	else
		theFrame.Background:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 0, -34)
		theFrame.Background:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", 0, 0)		
	end
	theFrame.Background:SetHeight(Height)
	theFrame.Background:SetWidth(Width)	
	theFrame.Background:SetAlpha(1)

    MeWantRevenge.Colors:RegisterBorder(
        Name == "MeWantRevenge_MainWindow" and "Window" or "Other Windows",
        "Title", theFrame)
    MeWantRevenge.Colors:RegisterBackground(
        Name == "MeWantRevenge_MainWindow" and "Window" or "Other Windows", 
        "Background", theFrame)

	theFrame.TitleBar = CreateFrame("Frame", "TestFrame", theFrame, "BackdropTemplate")	
	theFrame.TitleBar:SetFrameStrata("BACKGROUND")
	if not MeWantRevenge.db.profile.InvertMeWantRevenge then	
		theFrame.TitleBar:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 0, -11)
		theFrame.TitleBar:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", 0, -11)
	else
		theFrame.TitleBar:SetPoint("BOTTOMLEFT", theFrame, "BOTTOMLEFT", 0, -21)
		theFrame.TitleBar:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", 0, -21)
	end
	theFrame.TitleBar:SetHeight(22)

    theFrame.TitleBar:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,			
		insets = {left = 2, right = 2, top = 2, bottom = 2},			
	})
	theFrame.TitleBar:SetBackdropColor(0,0,0,1) 
	theFrame.TitleBar:SetBackdropBorderColor(1,1,1,1)
	print("border")

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if not MeWantRevenge.db.profile.InvertMeWantRevenge then 	
		theFrame.Title:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -16)
	else
		theFrame.Title:SetPoint("BOTTOMLEFT", theFrame, "BOTTOMLEFT", 8, -15)
	end	
	theFrame.Title:SetJustifyH("LEFT")
	theFrame.Title:SetTextColor(1.0, 1.0, 1.0, 1.0)
	theFrame.Title:SetText(Title)
	theFrame.Title:SetHeight(MeWantRevenge.db.profile.MainWindow.TextHeight)
	MeWantRevenge:AddFontString(theFrame.Title)

	if Name == "MeWantRevenge_MainWindow" then
		MeWantRevenge.Colors:UnregisterItem(theFrame.Title)
		MeWantRevenge.Colors:RegisterFont("Window", "Title Text", theFrame.Title)
	else
		MeWantRevenge.Colors:UnregisterItem(theFrame.Title)
		MeWantRevenge.Colors:RegisterFont("Other Windows", "Title Text", theFrame.Title)
	end
	theFrame.CloseButton = CreateFrame("Button", nil, theFrame)
	theFrame.CloseButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	theFrame.CloseButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	theFrame.CloseButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.CloseButton:SetWidth(20)
	theFrame.CloseButton:SetHeight(20)
	if not MeWantRevenge.db.profile.InvertMeWantRevenge then 	
		theFrame.CloseButton:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -4, -12)
	else
		theFrame.CloseButton:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", -4, -19)
	end		
	theFrame.CloseButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["Close"], 1, 0.82, 0, 1)
		GameTooltip:AddLine(L["CloseDescription"],0,0,0,1)
		GameTooltip:Show()
	end)
	theFrame.CloseButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide() 
	end)
	theFrame.CloseButton:SetScript("OnClick", function(self)
		self:GetParent():Hide()
	end)

	return theFrame
end