
local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if not BattlefieldMinimap_Update then return end

	local function noop() end
	local function setalpha()
		if GetNumMapOverlays() == 0 then for i=1,12 do _G["BattlefieldMinimap"..i]:RealSetAlpha(1) end
		else for i=1,12 do _G["BattlefieldMinimap"..i]:RealSetAlpha(.4) end end
	end
	for i=1,12 do
		local f = _G["BattlefieldMinimap"..i]
		f.SetAlpha, f.RealSetAlpha = noop, f.SetAlpha
	end

	hooksecurefunc("BattlefieldMinimap_Update", function()
		for i=1,NUM_BATTLEFIELDMAP_OVERLAYS do
			_G["BattlefieldMinimapOverlay"..i]:SetAlpha(1)
			_G["BattlefieldMinimapOverlay"..i].SetAlpha = noop
		end

		setalpha()
	end)

	self:SetParent(BattlefieldMinimap)
	self:SetScript("OnShow", function()
		setalpha()
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
		BattlefieldMinimap_Toggle()
	end
end)
f:SetScript("OnHide", function()
	if visible then
		BattlefieldMinimap_Toggle()
		visible = false
	end
end)
