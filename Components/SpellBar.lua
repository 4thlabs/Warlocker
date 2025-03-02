Warlocker:LoadComponent(function()

local _G = _G or getfenv(0)
local SpellBar = {}

-- Registering component
Warlocker.SpellBar = SpellBar

--- OnLoad Handler
function SpellBar:OnLoad()
    self.spellBarFrame = _G["Warlocker_SpellBarFrame"]
    self.petMenuButton = _G["Warlocker_SpellBarPetMenuButton"]
    self.stoneMenuButton = _G["Warlocker_SpellBarStoneMenuButton"]
    self.buffMenuButton = _G["Warlocker_SpellBarBuffMenuButton"]
    
    self.spellBarFrame:SetScale(0.85)
    if Warlocker.initialized then
        this:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    end
end

--- OnEvent Handler
function SpellBar:OnEvent(event)
    if event == "ACTIONBAR_UPDATE_COOLDOWN" then
        self:UpdateCooldown()
    end
end

function SpellBar:OnLoadMenu()
    this:SetScale(0.85)
end

function SpellBar:ShowMenu(name)
    if name then
        _G[name]:Show()
    else
        this:Show()
    end
end

function SpellBar:HideMenu(name)
    local focus = GetMouseFocus()
    if focus and not strfind(focus:GetName(), 'SpellBar') then
        if name then
            _G[name]:Hide()
        else
            this:Hide()
        end
    end
end

function SpellBar:HideAllMenu()
    _G["Warlocker_SpellBarPet"]:Hide()
    _G["Warlocker_SpellBarStone"]:Hide()
    _G["Warlocker_SpellBarBuff"]:Hide()
    _G["Warlocker_SpellBarInvoc"]:Hide()
end

function SpellBar:Update()
    self:UpdateMenu("Warlocker_SpellBarPet", WarlockerPetSpellRange.Min, WarlockerPetSpellRange.Max)
    self:UpdateMenu("Warlocker_SpellBarStone", WarlockerStoneSpellRange.Min, WarlockerStoneSpellRange.Max)
    self:UpdateMenu("Warlocker_SpellBarBuff", WarlockerBuffSpellRange.Min, WarlockerBuffSpellRange.Max)
    self:UpdateMenu("Warlocker_SpellBarInvoc", WarlockerInvocSpellRange.Min, WarlockerInvocSpellRange.Max)
    
    self:UpdateCooldown()
end

function SpellBar:UpdateMenu(name, min, max)
    local buttonId = 1
    for j = min, max, 1 do
        if WarlockerSpellTable[j].ID ~= nil then
            local index = j;
            local texture = GetSpellTexture(WarlockerSpellTable[index].ID, BOOKTYPE_SPELL)
            WarlockerSpellTable[index].Button = _G[name .. "Button" .. buttonId]
            WarlockerSpellTable[index].Button:Show()
            
            _G[WarlockerSpellTable[index].Button:GetName() .. "Icon"]:SetTexture(texture)
            
            WarlockerSpellTable[index].Button:SetScript("OnClick", function ()
                if (WarlockerSpellTable[index].BagCount and WarlockerSpellTable[index].BagCount > 0) then
                    self:UseItem(index)
                else
                    self:CastSpell(index)
                end
            end)
            
            buttonId = buttonId + 1
        end
    end
    
    -- Hiding lefthover buttons
    for i = buttonId, WarlockerMaxSpellMenuButton, 1 do
        _G[name .. "Button" .. i]:Hide()
    end
end

-- Update Cooldown of the various spells.
function SpellBar:UpdateCooldown()
    for i = WarlockerSpellRange.Min, WarlockerSpellRange.Max, 1 do
        if WarlockerSpellTable[i].Button ~= nil then
            local start, duration, enable = GetSpellCooldown( WarlockerSpellTable[i].ID, BOOKTYPE_SPELL );
            CooldownFrame_SetTimer( _G[WarlockerSpellTable[i].Button:GetName() .. "Cooldown"], start, duration, enable );
        end
    end
end

function SpellBar:UpdateStoneCount()
    for i = WarlockerStoneSpellRange.Min, WarlockerStoneSpellRange.Max, 1 do
        if WarlockerSpellTable[i].Button ~= nil then
            _G[WarlockerSpellTable[i].Button:GetName() .. "Count"]:SetText(WarlockerSpellTable[i].BagCount)
        end
    end
end

function SpellBar:Tooltip(button, index)
    GameTooltip:SetOwner(WarlockerSpellTable[index].Button, ANCHOR_BOTTOMLEFT)
    GameTooltip:SetSpell(WarlockerSpellTable[index].ID)
end

function SpellBar:UseItem(index)
    local name = WarlockerSpellTable[index].Item
    
    if name then
        for container=0, 4, 1 do
            for slot=1, GetContainerNumSlots(container), 1 do
                local item = GetContainerItemLink(container, slot)
                
                if item and string.find(item, name) then
                    --print(gsub(item, "\124", "\124\124"))
                    UseContainerItem(container, slot)
                end
            end
        end
    end
end

--- Cast a spell from the spell table
---@param index integer The spell table index
function SpellBar:CastSpell(index)
    if WarlockerSpellTable[index].ID then
        
        if WarlockerSpellTable[index].Name == "Ritual of Summoning" then
            if UnitExists("target") then
                local name = UnitName("target")
                SendChatMessage("Summoning " .. name .." ! Click !", "YELL")
            end
        elseif WarlockerSpellTable[index].Name == "Ritual of Souls" then
          SendChatMessage("Free candy for everyone! Click !", "YELL")
        end
        
        CastSpell(WarlockerSpellTable[index].ID, BOOKTYPE_SPELL)
    end
end

end)





