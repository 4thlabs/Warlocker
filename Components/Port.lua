---
--- Warlocker Port component
---
Warlocker:LoadComponent(function()
    
local _G = _G or getfenv(0)

local Port = {
    Ui = {
        -- Height of an item in the list.
        ItemHeight = 20,
        -- The offset from the title to be added
        ItemOffset = 30,
        -- Main frame of the Port component
        frame = nil,
        -- List item cache
        itemCache = {}
    },
    
    MsgPrefix = {
        Add = "RSAdd",
        Remove = "RSRemove",
        Summon = "123"
    },
    
    -- The Players to be summoned
    playerList = {}
}

-- Registering component
Warlocker.Port = Port

---OnLoad handler
function Port:OnLoad()
    self.Ui.frame = this
    if Warlocker.initialized then
        this:RegisterForDrag("LeftButton")
        
        this:RegisterEvent("CHAT_MSG_RAID")
        this:RegisterEvent("CHAT_MSG_RAID_LEADER")
        this:RegisterEvent("CHAT_MSG_PARTY")
        this:RegisterEvent("CHAT_MSG_ADDON")
    end
end

---Event handler
function Port:OnEvent(event, arg1, arg2)
    if event == "CHAT_MSG_RAID" or  event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_PARTY" then
        self:ProcessChatMessage(arg1, arg2)
    elseif event == "CHAT_MSG_ADDON" and arg1 == self.MsgPrefix.Add then
        print("Received RSAdd for: " .. arg2)
        self:AddPlayer(arg2)
    elseif event == "CHAT_MSG_ADDON" and arg1 == self.MsgPrefix.Remove then
        self:RemovePlayer(arg2)
    end
end

function Port:OnDragStart()
    this:StartMoving()
end

function Port:OnDragStop()
    this:StopMovingOrSizing()
end

---Item click handler
---@param index integer The index of the player to be summoned or removed
function Port:OnItemClick(button, index)
    if button == "LeftButton" then
        self:SummonPlayer(index)
    elseif button == "RightButton" then
        SendAddonMessage(self.MsgPrefix.Remove, self.playerList[index].name, "RAID")
    end
end

function Port:ProcessChatMessage(message, name)
    local ownName, _ =  UnitName("player")
    
    if string.find(message, "^"..self.MsgPrefix.Summon) then
        if self:GetPlayerIndex(name) == nil and name ~= ownName then
            SendAddonMessage(self.MsgPrefix.Add, name, "RAID")
        end
    end
end

---Updates the list of 
function Port:UpdateList()
    self:ClearList()
    self:UpdateRoaster()
    
    for i = 1, table.getn(self.playerList), 1 do
        local index = i;
        local item = self:GetListItem(i)
        
        local c = RAID_CLASS_COLORS[string.upper(self.playerList[i].class)]
        _G[item:GetName() .. "Name"]:SetText(self.playerList[i].name)
        _G[item:GetName() .. "Name"]:SetTextColor(c.r, c.g, c.b, 1.0)
        
        item:ClearAllPoints()
        item:SetPoint("TOP", 0, -(self.Ui.ItemOffset + ((i - 1) * self.Ui.ItemHeight)))
        
        item:SetScript("OnClick", function() self:OnItemClick(arg1, index) end)
        
        item:Show()
    end
end

--- Retreives a button frame either by creating it or reusing one.
---@param index integer
function Port:GetListItem(index)
    if (index > table.getn(self.Ui.itemCache)) then -- Creating Ui element
        self.Ui.itemCache[index] = CreateFrame("Button", "$parentItem" .. index, self.Ui.frame, "Warlocker_PortItemTemplate")
        self.Ui.itemCache[index]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    end
    
    return self.Ui.itemCache[index]
end

function Port:ClearList()
    for _, v in ipairs(self.Ui.itemCache) do
        v:Hide()
    end
end

--- Adds a player to the list.
---@param name string The player name
function Port:AddPlayer(name)
    local ownName, _ =  UnitName("player")
    self.Ui.frame:Show()

    if self:GetPlayerIndex(name) == nil and name ~= ownName then    
        table.insert(self.playerList, {id = nil, name = name, class = nil})
        self:UpdateList()
    end
end

--- Removes a player from the list.
---@param name string The player name
function Port:RemovePlayer(name)
    local index = self:GetPlayerIndex(name)
    
    if index ~= nil then
        table.remove(self.playerList, index)
        self:UpdateList()
    end
end

function Port:GetPlayerIndex(name)
    local index = nil
    for k,v in ipairs(self.playerList) do
        if name == v.name then
            index = k
            break
        end
    end
    return index
end

function Port:SummonPlayer(index)
    self:UpdateRoaster()

    local playerId = 0
    if self:IsInRaid() then
        playerId = "raid"..self.playerList[index].id
    else
        playerId = "party"..self.playerList[index].id
    end

    if  not UnitAffectingCombat("player") and not UnitAffectingCombat(playerId) then
        -- Removing from clients
        -- Need to add a 3rd event telling other client that this player is currently being summoned
        -- Removing player from list must be done after by checking distance
        SendAddonMessage(self.MsgPrefix.Remove, self.playerList[index].name, "RAID")
        
        TargetUnit(playerId)

        SendChatMessage("Summoning " .. self.playerList[index].name .. " ! Click !", self:IsInRaid() and "RAID" or "PARTY")
        SendChatMessage("Summoning you to " .. GetZoneText() .. "-" .. GetSubZoneText(), "WHISPER", nil, self.playerList[index].name)
        
        CastSpell(WarlockerSpellTable[18].ID, BOOKTYPE_SPELL)
    end
end

function Port:IsInRaid()
    return UnitInRaid("player") ~= nil
end

--- Updates players informations (id, class)
function Port:UpdateRoaster()
    if self:IsInRaid() then
        self:UpdateRaid()
    else
        self:UpdateParty()
    end
end

function Port:UpdateParty()
    for i = 1, GetNumPartyMembers(), 1 do
        local name = UnitName("party"..i)
        local class = UnitClass("party"..i)
        local playerIndex = self:GetPlayerIndex(name)
        if playerIndex ~= nil then
            self.playerList[playerIndex].id = i
            self.playerList[playerIndex].class = class
        end
    end
end

function Port:UpdateRaid()
    for i = 1, GetNumRaidMembers(), 1 do
        local name, rank, _, level, class = GetRaidRosterInfo(i)
        local playerIndex = self:GetPlayerIndex(name)
        if playerIndex ~= nil then
            self.playerList[playerIndex].id = i
            self.playerList[playerIndex].class = class
        end
    end
end
    
end)

