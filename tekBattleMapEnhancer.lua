

local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if not BattlefieldMinimap_Update then return end

	local function noop() end
	hooksecurefunc("BattlefieldMinimap_Update", function()
		for i=1,NUM_BATTLEFIELDMAP_OVERLAYS do
			_G["BattlefieldMinimapOverlay"..i]:SetAlpha(1)
			_G["BattlefieldMinimapOverlay"..i].SetAlpha = noop
		end

		if GetNumMapOverlays() == 0 then for i=1,12 do _G["BattlefieldMinimap"..i]:Show() end
		else for i=1,12 do _G["BattlefieldMinimap"..i]:Hide() end end
	end)

	self:SetParent(BattlefieldMinimap)
	self:SetScript("OnShow", function()
		for i=1,12 do
			_G["BattlefieldMinimap"..i]:SetAlpha(1)
			_G["BattlefieldMinimap"..i]:Hide()
		end
		BattlefieldMinimapCorner:Hide()
		BattlefieldMinimapBackground:Hide()
		BattlefieldMinimapCloseButton:Hide()
	end)

	BattlefieldMinimap:SetClampedToScreen(true)
	BattlefieldMinimap:SetClampRectInsets(0,-100,0,100)

	self:SetAllPoints()
	self:EnableMouse(true)
	self:SetScript("OnEnter", function() BattlefieldMinimap:SetScale(3) end)
	self:SetScript("OnLeave", function() BattlefieldMinimap:SetScale(1) end)

	LibStub("tekKonfig-AboutPanel").new(nil, "tekBattleMapEnhancer")

	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end)


local visible
local f = CreateFrame("Frame", nil, WorldMapFrame)
f:SetScript("OnShow", function()
	if BattlefieldMinimap:IsVisible() then
		visible = true
		BattlefieldMinimap:Hide()
	end
end)
f:SetScript("OnHide", function()
	if visible then
		BattlefieldMinimap:Show()
		visible = false
	end
end)
