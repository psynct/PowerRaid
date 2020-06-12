local PowerRaidData =  {}
_G["PowerRaidData"] = PowerRaidData

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid");
local ordered_table = LibStub("ordered_table")

PowerRaidData.RaidBuffs = ordered_table.create()
PowerRaidData.RaidBuffs["Prayer of Fortitude"] = {
    ["alts"] = {"21564", "10938"},
    ["castingClass"] = "PRIEST",
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Fort"],
}
PowerRaidData.RaidBuffs["Prayer of Spirit"] = {
    ["alts"] = {"27681", "27841"},
    ["castingClass"] = "PRIEST",
    ["excludedClasses"] = {"WARRIOR", "ROGUE"},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Spirit"],
}
PowerRaidData.RaidBuffs["Gift of the Wild"] = {
    ["alts"] = {"21850", "9885"},
    ["castingClass"] = "DRUID",
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["MoTW"],
}
PowerRaidData.RaidBuffs["Arcane Brilliance"] = {
    ["alts"] = {"23028", "10157"},
    ["castingClass"] = "MAGE",
    ["excludedClasses"] = {"WARRIOR", "ROGUE"},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Int"],
}
PowerRaidData.RaidBuffs["Prayer of Shadow Protection"] = {
    ["alts"] = {"27683", "10958"},
    ["castingClass"] = "PRIEST",
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["ShadowProt"],
}

PowerRaidData.WorldBuffs = ordered_table.create()
PowerRaidData.WorldBuffs["Rallying Cry of the Dragonslayer"] = {
    ["alts"] = {"22888"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Ony/Nef"],
}
PowerRaidData.WorldBuffs["Songflower Serenade"] = {
    ["alts"] = {"15366"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Songflower"],
}
PowerRaidData.WorldBuffs["Warchief's Blessing"] = {
    ["alts"] = {"16609"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = "Horde",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Rend"],
}
PowerRaidData.WorldBuffs["DMF"] = {
    ["alts"] = {"23736", "23766", "23738", "23737", "23735", "23767", "23769", "23768"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["DMF"],
    ["hideSpellTooltip"] = true,
}
PowerRaidData.WorldBuffs["DM Tribute"] = {
    ["alts"] = {"22817", "22820", "22818"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = "Interface\\Icons\\spell_nature_massteleport",
    ["label"] = L["DMT"],
    ["playersBuffStatus"] = {},
    ["short"] = L["DMT"],
    ["hideSpellTooltip"] = true,
}
PowerRaidData.WorldBuffs["Spirit of Zandalar"] = {
    ["alts"] = {"24425"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["ZG"],
}
PowerRaidData.WorldBuffs["Resist Fire"] = {
    ["alts"] = {"15123"},
    ["castingClass"] = nil,
    ["excludedClasses"] = {},
    ["faction"] = nil,
    ["icon"] = nil,
    ["label"] = L["UBRS"],
    ["playersBuffStatus"] = {},
    ["short"] = L["UBRS"],
}

PowerRaidData.PaladinBuffs = ordered_table.create()
PowerRaidData.PaladinBuffs["Greater Blessing of Kings"] = {
    ["alts"] = {"25898", "20217"},
    ["castingClass"] = "PALADIN",
    ["excludedClasses"] = {},
    ["faction"] = "Alliance",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Kings"],
}
PowerRaidData.PaladinBuffs["Greater Blessing of Might"] = {
    ["alts"] = {"25916", "25291"},
    ["castingClass"] = "PALADIN",
    ["excludedClasses"] = {"MAGE", "WARLOCK", "PRIEST"},
    ["faction"] = "Alliance",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Might"],
}
PowerRaidData.PaladinBuffs["Greater Blessing of Wisdom"] = {
    ["alts"] = {"25918", "25290"},
    ["castingClass"] = "PALADIN",
    ["excludedClasses"] = {"WARRIOR", "ROGUE"},
    ["faction"] = "Alliance",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Wisdom"],
}
PowerRaidData.PaladinBuffs["Greater Blessing of Salvation"] = {
    ["alts"] = {"25895", "1038"},
    ["castingClass"] = "PALADIN",
    ["excludedClasses"] = {},
    ["faction"] = "Alliance",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Salvation"],
}
PowerRaidData.PaladinBuffs["Greater Blessing of Sanctuary"] = {
    ["alts"] = {"25899", "20911"},
    ["castingClass"] = "PALADIN",
    ["excludedClasses"] = {},
    ["faction"] = "Alliance",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Sanctuary"],
}
PowerRaidData.PaladinBuffs["Greater Blessing of Light"] = {
    ["alts"] = {"25890", "19979"},
    ["castingClass"] = "PALADIN",
    ["excludedClasses"] = {},
    ["faction"] = "Alliance",
    ["icon"] = nil,
    ["label"] = "",
    ["playersBuffStatus"] = {},
    ["short"] = L["Light"],
}

local iterators = { PowerRaidData.RaidBuffs, PowerRaidData.WorldBuffs, PowerRaidData.PaladinBuffs }
for _, iterator in pairs(iterators) do
    for _, spellData in pairs(iterator) do
        if spellData["names"] == nil then
            spellData["names"] = {}
        end
        for _, spellId in pairs(spellData["alts"]) do
            local name, _, icon = GetSpellInfo(spellId)
            table.insert(spellData["names"], name)
            if spellData["icon"] == nil then
                spellData["icon"] = icon
            end
        end
    end
end

PowerRaidData.DefaultConsumesForSpecs = {
    ["All Classes"] = {
        "5634",  -- Free Action Potion
        "10646", -- Goblin Sapper Charge
        "13461", -- Greater Arcane Protection Potion
        "13457", -- Greater Fire Protection Potion
        "13456", -- Greater Frost Protection Potion
        "13458", -- Greater Nature Protection Potion
        "13459", -- Greater Shadow Protection Potion
        "14530", -- Heavy Runecloth Bandage
        "3387",  -- Limited Invulnerability Potion
        "20008", -- Living Action Potion
        "19013", -- Major Healthstone
        "9030",  -- Restorative Potion
        "15993", -- Thorium Grenade
    },
    ["Shaman (Ele)"] = {},
    ["Shaman (Enh)"] = {},
    ["Druid (Feral DPS)"] = {},
    ["Druid (Moonkin)"] = {},
    ["Druid (Feral Tank)"] = {
        "13810", -- Blessed Sunfruit
        "12662", -- Demonic Rune/Dark Rune
        "9206",  -- Elixir of Giants
        "13452", -- Elixir of the Mongoose
        "13510", -- Flask of the Titans
        "18269", -- Gordok Green Grog
        "13928", -- Grilled Squid
        "8412",  -- Ground Scorpok Assay
        "12450", -- Juju Flurry
        "12460", -- Juju Might
        "12451", -- Juju Power
        "8411",  -- Lung Juice Cocktail
        "9449",  -- Manual Crowd Pummeler
        "8410",  -- R.O.I.D.S.
        "21151", -- Rumsey Rum Black Label
    },
    ["Priest (Healing)"] = {
        "8423",  -- Cerebral Cortex Compound
        "12662", -- Demonic Rune/Dark Rune
        "9179",  -- Elixir of Greater Intellect
        "13511", -- Flask of Distilled Wisdom
        "8424",  -- Gizzard Gum
        "18284", -- Kreeg's Stout Beatdown
        "20007", -- Mageblood Potion
        "13444", -- Major Mana Potion
        "13931", -- Nightfin Soup
    },
    ["Paladin (Holy)"] = {
        "12662", -- Demonic Rune/Dark Rune
        "13511", -- Flask of Distilled Wisdom
        "18269", -- Gordok Green Grog
        "8411",  -- Lung Juice Cocktail
        "20007", -- Mageblood Potion
        "13444", -- Major Mana Potion
        "13931", -- Nightfin Soup
        "21151", -- Rumsey Rum Black Label
    },
    ["Hunter"] = {
        "12662", -- Demonic Rune/Dark Rune
        "12654", -- Doomshot
        "9187",  -- Elixir of Greater Agility
        "13452", -- Elixir of the Mongoose
        "13510", -- Flask of the Titans
        "18269", -- Gordok Green Grog
        "13928", -- Grilled Squid
        "8412",  -- Ground Scorpok Assay
        "12460", -- Juju Might
        "12451", -- Juju Power
        "13444", -- Major Mana Potion
        "8410",  -- R.O.I.D.S.
        "21151", -- Rumsey Rum Black Label
        "18042", -- Thorium Headed Arrow
        "15997", -- Thorium Shells
        "12820", -- Winterfall Firewater
    },
    ["Mage"] = {
        "12662", -- Demonic Rune/Dark Rune
        "17708", -- Elixir of Frost Power
        "21546", -- Elixir of Greater Firepower
        "13447", -- Elixir of the Sages
        "13512", -- Flask of Supreme Power
        "13454", -- Greater Arcane Elixir
        "20007", -- Mageblood Potion
        "13444", -- Major Mana Potion
        "13931", -- Nightfin Soup
        "18254", -- Runn Tum Tuber Surprise
    },
    ["Paladin (Prot)"] = {
        "13810", -- Blessed Sunfruit
        "12662", -- Demonic Rune/Dark Rune
        "18262", -- Elemental Sharpening Stone
        "3825",  -- Elixir of Fortitude
        "13452", -- Elixir of the Mongoose
        "13510", -- Flask of the Titans
        "18269", -- Gordok Green Grog
        "13454", -- Greater Arcane Elixir
        "8412",  -- Ground Scorpok Assay
        "12450", -- Juju Flurry
        "12460", -- Juju Might
        "12451", -- Juju Power
        "13444", -- Major Mana Potion
        "8410",  -- R.O.I.D.S.
        "21151", -- Rumsey Rum Black Label
    },
    ["Warrior (Prot)"] = {
        "13810", -- Blessed Sunfruit
        "12404", -- Dense Sharpening Stone
        "21023", -- Dirge's Kickin' Chimaerok Chops
        "18262", -- Elemental Sharpening Stone
        "9187",  -- Elixir of Greater Agility
        "13452", -- Elixir of the Mongoose
        "13510", -- Flask of the Titans
        "13455", -- Greater Stoneshield Potion
        "8412",  -- Ground Scorpok Assay
        "12460", -- Juju Might
        "12451", -- Juju Power
        "8411",  -- Lung Juice Cocktail
        "13442", -- Mighty Rage Potion
        "8410",  -- R.O.I.D.S.
        "21151", -- Rumsey Rum Black Label
        "20452", -- Smoked Desert Dumplings
        "18045", -- Tender Wolf Steak
    },
    ["Druid (Resto)"] = {
        "13813", -- Blessed Sunfruit Juice
        "12662", -- Demonic Rune/Dark Rune
        "13511", -- Flask of Distilled Wisdom
        "18284", -- Kreeg's Stout Beatdown
        "20007", -- Mageblood Potion
        "13444", -- Major Mana Potion
        "13931", -- Nightfin Soup
        "18254", -- Runn Tum Tuber Surprise
    },
    ["Shaman (Resto)"] = {
        "8423",  -- Cerebral Cortex Compound
        "12662", -- Demonic Rune/Dark Rune
        "13511", -- Flask of Distilled Wisdom
        "8424",  -- Gizzard Gum
        "20007", -- Mageblood Potion
        "13444", -- Major Mana Potion
        "13931", -- Nightfin Soup
    },
    ["Paladin (Ret)"] = {
        "12662", -- Demonic Rune/Dark Rune
        "18262", -- Elemental Sharpening Stone
        "13452", -- Elixir of the Mongoose
        "13452", -- Elixir of the Mongoose
        "13511", -- Flask of Distilled Wisdom
        "13510", -- Flask of the Titans
        "18269", -- Gordok Green Grog
        "13454", -- Greater Arcane Elixir
        "8412",  -- Ground Scorpok Assay
        "12450", -- Juju Flurry
        "12460", -- Juju Might
        "12451", -- Juju Power
        "13444", -- Major Mana Potion
        "8410",  -- R.O.I.D.S.
        "21151", -- Rumsey Rum Black Label
        "20452", -- Smoked Desert Dumplings
        "12820", -- Winterfall Firewater
    },
    ["Rogue"] = {
        "13810", -- Blessed Sunfruit
        "9206",  -- Elixir of Giants
        "9187",  -- Elixir of Greater Agility
        "13452", -- Elixir of the Mongoose
        "13510", -- Flask of the Titans
        "13928", -- Grilled Squid
        "8412",  -- Ground Scorpok Assay
        "8928",  -- Instant Poison VI
        "12460", -- Juju Might
        "12451", -- Juju Power
        "8410",  -- R.O.I.D.S.
        "7676",  -- Thistle Tea
        "12820", -- Winterfall Firewater
    },
    ["Priest (Shadow)"] = {
        "8423",  -- Cerebral Cortex Compound
        "12662", -- Demonic Rune/Dark Rune
        "9264",  -- Elixir of Shadow Power
        "13512", -- Flask of Supreme Power
        "8424",  -- Gizzard Gum
        "13454", -- Greater Arcane Elixir
        "18284", -- Kreeg's Stout Beatdown
        "20007", -- Mageblood Potion
        "13444", -- Major Mana Potion
        "13931", -- Nightfin Soup
    },
    ["Warlock"] = {
        "12662", -- Demonic Rune/Dark Rune
        "21546", -- Elixir of Greater Firepower
        "9264",  -- Elixir of Shadow Power
        "13512", -- Flask of Supreme Power
        "18269", -- Gordok Green Grog
        "13454", -- Greater Arcane Elixir
        "13444", -- Major Mana Potion
        "21151", -- Rumsey Rum Black Label
        "18254", -- Runn Tum Tuber Surprise
    },
    ["Warrior (DPS)"] = {
        "13810", -- Blessed Sunfruit
        "18262", -- Elemental Sharpening Stone
        "9206",  -- Elixir of Giants
        "9187",  -- Elixir of Greater Agility
        "13452", -- Elixir of the Mongoose
        "13510", -- Flask of the Titans
        "18269", -- Gordok Green Grog
        "8412",  -- Ground Scorpok Assay
        "12460", -- Juju Might
        "12451", -- Juju Power
        "13442", -- Mighty Rage Potion
        "8410",  -- R.O.I.D.S.
        "21151", -- Rumsey Rum Black Label
        "20452", -- Smoked Desert Dumplings
    }
}
