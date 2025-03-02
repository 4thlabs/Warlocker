local _G = _G or getfenv(0)

Warlocker = {
    ItemName = {
        SoulShard = "Soul Shard",
        Soulstone = "Soulstone",
        Healthstone = "Healthstone",
        Firestone = "Firestone",
        Felstone = "Felstone",
        Wrathstone = "Wrathstone",
        Spellstone = "Spellstone"
    },
    
    MaxSpellMenuButton = 7,

    SpellRange = { Min = 1, Max = 20},
    PetSpellRange = { Min = 1, Max = 6 },
    StoneSpellRange = { Min = 7, Max = 12 },
    BuffSpellRange = { Min = 13, Max = 17 },
    InvocSpellRange = { Min = 18, Max = 20 },
    
    Ui = {
        -- Warlocker main frame
        frame = nil
    },
    -- State of warlocker
    initialized = false,
    -- Stones count
    soulShardCount = 0,
    -- spell refresh
    refreshSpells = false,
    -- Timer
    lastLearned = 0
}

-- Simple helper to register local components
function Warlocker:LoadComponent(f)
  f()
end

function Warlocker:OnLoad()
    self.Ui.frame = _G["Warlocker_MainFrame"]

    print(UnitClass("player"))
    if UnitClass("player") == "Warlock" then
        self.Ui.frame:Show()
        
        this:RegisterEvent("BAG_UPDATE")
        this:RegisterEvent("ADDON_LOADED")
        this:RegisterEvent("PLAYER_ENTERING_WORLD")
        this:RegisterEvent("LEARNED_SPELL_IN_TAB")
        
        this:RegisterForDrag("LeftButton")
        
        print("|CFF6A6093Warlocker loaded !")
        
        self.initialized = true
    else
        self.Ui.frame:Hide()
        return
    end
end

function Warlocker:OnDragStart()
    this:StartMoving()
end

function Warlocker:OnDragStop()
    this:StopMovingOrSizing()
end

function Warlocker:OnEvent(event)
    if self.initialized then
        if event == "BAG_UPDATE" then
            self:ScanBag()
            self.SpellBar:UpdateStoneCount()
        elseif event == "ADDON_LOADED" then
            self:ScanSpellBook()
        elseif event == "PLAYER_ENTERING_WORLD" then
            self.SpellBar:Update()
        elseif event == "LEARNED_SPELL_IN_TAB" then
            self.lastLearned = GetTime()
            self.refreshSpells = true
        end
    end
end

function Warlocker:OnUpdate()
    if self.refreshSpells then
        if GetTime() > (self.lastLearned + .5) then
            print("Refreshing spellbook")
            self:UpdateSpellBar()

            self.refreshSpells = false
        end
    end
end

-- Parse the bags and detect the various stones.
function Warlocker:ScanBag()
    self:CleanBag()
    
    for container=0, 4, 1 do
        for slot=1, GetContainerNumSlots(container), 1 do
            local item = GetContainerItemLink(container, slot)
            
            if item then
                if string.find(item, WarlockerItemName.SoulShard) then
                    local _, itemCount = GetContainerItemInfo(container, slot)
                    self.soulShardCount = self.soulShardCount + itemCount
                else
                    for i = WarlockerStoneSpellRange.Min, WarlockerStoneSpellRange.Max, 1 do
                        if string.find(item, WarlockerSpellTable[i].Item) then
                            WarlockerSpellTable[i].BagCount = 1
                        end
                    end
                end
            end
            
        end
    end
end

--- Clean bag stones count.
function Warlocker:CleanBag()
    self.soulShardCount = 0
    for i = WarlockerStoneSpellRange.Min, WarlockerStoneSpellRange.Max, 1 do
        WarlockerSpellTable[i].BagCount = 0
    end
end

--- Scan Spell Book and store found spells in WarlockerSpellTable
function Warlocker:ScanSpellBook()
    local spellId = 1
    
    for spellTabIndex = 0, GetNumSpellTabs(), 1 do
        local _, _, _, numSpells = GetSpellTabInfo(spellTabIndex)
        for spellIndex = 0, numSpells, 1 do
            local spellName, spellRank = GetSpellName(spellId, BOOKTYPE_SPELL)
            
            self:UpdateSpellTable(spellId, spellName, spellRank)
            spellId = spellId + 1
        end
    end
end

-- Updates warlocker spell table
function Warlocker:UpdateSpellTable(ID, Name, Rank)
    for i = 1, table.getn(WarlockerSpellTable), 1 do
        if WarlockerSpellTable[i].Name == Name then
            if WarlockerSpellTable[i].Rank == nil or WarlockerSpellTable[i].Rank < Rank then
                WarlockerSpellTable[i].ID = ID
                WarlockerSpellTable[i].Rank = Rank
            end 
        end
    end
end

function Warlocker:CleanSpellTable()
    for i = 1, table.getn(WarlockerSpellTable), 1 do
        WarlockerSpellTable[i].ID = nil
        WarlockerSpellTable[i].Rank = nil
        WarlockerSpellTable[i].Button = nil
    end
end

function Warlocker:UpdateSpellBar()
    self:CleanSpellTable()
    self:ScanSpellBook()
    self.SpellBar:Update()
end