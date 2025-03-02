if GetLocale() == "enGB" or GetLocale() == "enUS" then
    
WarlockerItemName = {
    SoulShard = "Soul Shard",
    Soulstone = "Soulstone",
    Healthstone = "Healthstone",
    Firestone = "Firestone",
    Felstone = "Felstone",
    Wrathstone = "Wrathstone",
    Spellstone = "Spellstone"
}

WarlockerMaxSpellMenuButton = 7

WarlockerSpellRange = { Min = 1, Max = 23}
WarlockerPetSpellRange = { Min = 1, Max = 6 }
WarlockerStoneSpellRange = { Min = 7, Max = 12 }
WarlockerBuffSpellRange = { Min = 13, Max = 17 }
WarlockerInvocSpellRange = { Min = 18, Max = 23 }

WarlockerSpellTable = {
    -- Pet Spells
    [1] = {ID = nil, Name = "Fel Domination", Rank = nil, Cooldown = true, Button = nil},
    [2] = {ID = nil, Name = "Demonic Sacrifice", Rank = nil, Cooldown = false, Button = nil},
    [3] = {ID = nil, Name = "Summon Imp", Rank = nil, Cooldown = false, Button = nil},
    [4] = {ID = nil, Name = "Summon Voidwalker", Rank = nil, Cooldown = false, Button = nil},
    [5] = {ID = nil, Name = "Summon Succubus", Rank = nil, Cooldown = false, Button = nil},
    [6] = {ID = nil, Name = "Summon Felhunter", Rank = nil, Cooldown = false, Button = nil},
    
    -- Stone Spells
    [7] = {ID = nil, Name = "Create Soulstone (Major)", Rank = nil, Item=WarlockerItemName.Soulstone, BagCount = 0, Button = nil},
    [8] = {ID = nil, Name = "Create Healthstone (Major)", Rank = nil, Item=WarlockerItemName.Healthstone, BagCount = 0, Button = nil},
    [9] = {ID = nil, Name = "Create Firestone", Rank = nil, Item=WarlockerItemName.Firestone, BagCount = 0, Button = nil},
    [10] = {ID = nil, Name = "Create Felstone", Rank = nil, Item=WarlockerItemName.Felstone, BagCount = 0, Button = nil},
    [11] = {ID = nil, Name = "Create Wrathstone", Rank = nil, Item=WarlockerItemName.Wrathstone, BagCount = 0, Button = nil},
    [12] = {ID = nil, Name = "Create Spellstone", Rank = nil, Item=WarlockerItemName.Spellstone, BagCount = 0, Button = nil},
    
    -- Buff Spells
    [13] = {ID = nil, Name = "Demon Armor", Rank = nil, Cooldown = false, Button = nil},
    [14] = {ID = nil, Name = "Unending Breath", Rank = nil, Cooldown = false, Button = nil},
    [15] = {ID = nil, Name = "Detect Greater Invisibility", Rank = nil, Cooldown = false, Button = nil},
    [16] = {ID = nil, Name = "Sense Demons", Rank = nil, Cooldown = false, Button = nil},
    [17] = {ID = nil, Name = "Shadow Ward", Rank = nil, Cooldown = true, Button = nil},
    
    -- Invoc Spells
    [18] = {ID = nil, Name = "Ritual of Summoning", Rank = nil, Cooldown = false, Button = nil},
    [19] = {ID = nil, Name = "Inferno", Rank = nil, Cooldown = true, Button = nil},
    [20] = {ID = nil, Name = "Demon Gate", Rank = nil, Cooldown = true, Button = nil},
    [21] = {ID = nil, Name = "Ritual of Doom", Rank = nil, Cooldown = true, Button = nil},
    [22] = {ID = nil, Name = "Ritual of Souls", Rank = nil, Cooldown = false, Button = nil},
    [23] = {ID = nil, Name = "Eye of Kilrogg", Rank = nil, Cooldown = false, Button = nil},
}
    
end