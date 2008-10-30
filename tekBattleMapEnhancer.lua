
local SCALE, POISCALE = 3, 1.25

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


	local function sizePOI(poi, size)
		poi:SetWidth(size)
		poi:SetHeight(size)
	end
	local function sizePOIs()
		local iconSize = DEFAULT_POI_ICON_SIZE * GetBattlefieldMapIconScale()
		if BattlefieldMinimap:GetScale() == SCALE then iconSize = iconSize/SCALE*POISCALE end
		for i=1,NUM_BATTLEFIELDMAP_POIS do sizePOI(_G["BattlefieldMinimapPOI"..i], iconSize) end
		for i=1,4 do sizePOI(_G["BattlefieldMinimapParty"..i], iconSize) end
		for i=1,40 do sizePOI(_G["BattlefieldMinimapRaid"..i], iconSize) end
	end


	hooksecurefunc("BattlefieldMinimap_Update", function()
		for i=1,NUM_BATTLEFIELDMAP_OVERLAYS do
			_G["BattlefieldMinimapOverlay"..i]:SetAlpha(1)
			_G["BattlefieldMinimapOverlay"..i].SetAlpha = noop
		end

		setalpha()
		sizePOIs()
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
	local function OnEnter(frame)
		BattlefieldMinimap:SetScale(SCALE)
		sizePOIs()
		if frame ~= self then BattlefieldMinimapUnit_OnEnter(frame) end
	end
	self:SetScript("OnEnter", OnEnter)
	for i=1,4 do _G["BattlefieldMinimapParty"..i]:SetScript("OnEnter", OnEnter) end
	for i=1,40 do _G["BattlefieldMinimapRaid"..i]:SetScript("OnEnter", OnEnter) end
	self:SetScript("OnLeave", function()
		BattlefieldMinimap:SetScale(1)
		sizePOIs()
	end)

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
