Warlocker:LoadComponent(function()

local Counter = {}

-- Registering component
Warlocker.Counter = Counter

function Counter:OnLoad()
    this:RegisterEvent("BAG_UPDATE")
end

function Counter:OnEvent(event)
    if event == "BAG_UPDATE" then
        Warlocker_ShardCountFontString:SetText(tostring(Warlocker.soulShardCount))
    end
end

function Counter:OnMouseDown(trux)
    Warlocker:UpdateSpellBar()
end

end)