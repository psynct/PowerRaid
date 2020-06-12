local ConsumablesTab =  {}
_G["ConsumablesTab"] = ConsumablesTab

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")

local bossKeys = {
    "General", "PVP", "Azuregos", "Lord Kazzak", "Emeriss", "Lethon", "Taerar", "Ysondre", "Lucifron", "Magmadar",
    "Gehennas", "Garr", "Shazzrah", "Baron Geddon", "Golemagg the Incinerator", "Sulfuron Harbinger",
    "Majordomo Executus", "Ragnaros", "Razorgore the Untamed", "Vaelastrasz the Corrupt", "Broodlord Lashlayer",
    "Firemaw", "Ebonroc", "Flamegor", "Chromaggus", "Nefarian"
}
local bosses = {}
for _, boss in pairs(bossKeys) do
    bosses[boss] = L[boss]
end

local consumablesInfo = {
    ["16040"] = {}, -- Arcane Bomb
    ["13813"] = { -- Blessed Sunfruit Juice
        ["buffId"] = "18141",
    },
    ["13810"] = { -- Blessed Sunfruit
        ["buffId"] = "18125",
    },
    ["5206"] = { -- Bogling Root
        ["buffId"] = "5665",
    },
    ["20748"] = { -- Brilliant Mana Oil
        ["buffId"] = "25123",
        ["lesserItemIds"] = {"20747"},
        ["lesserBuffIds"] = {"25120"}
    },
    ["20749"] = { -- Brilliant Wizard Oil
        ["buffId"] = "25122",
        ["lesserItemIds"] = {"20750"},
        ["lesserBuffIds"] = {"25121"}
    },
    ["8423"] = { -- Cerebral Cortex Compound
        ["buffId"] = "10692",
    },
    ["11566"] = {}, -- Crystal Charge
    ["11567"] = { -- Crystal Spire
        ["buffId"] = "15279",
    },
    ["11564"] = { -- Crystal Ward
        ["buffId"] = "15233",
    },
    ["12662"] = { -- Demonic Rune/Dark Rune
        ["altItemIds"] = {"20520"}
    },
    ["18641"] = {}, -- Dense Dynamite
    ["12404"] = { -- Dense Sharpening Stone
        ["buffId"] = "16138",
    },
    ["21023"] = { -- Dirge's Kickin' Chimaerok Chops
        ["buffId"] = "25661",
    },
    ["12654"] = {}, -- Doomshot
    ["18262"] = { -- Elemental Sharpening Stone
        ["buffId"] = "22756",
    },
    ["13453"] = { -- Elixir of Brute Force
        ["buffId"] = "17537",
    },
    ["3825"] = { -- Elixir of Fortitude
        ["buffId"] = "3593",
    },
    ["17708"] = { -- Elixir of Frost Power
        ["buffId"] = "21920",
    },
    ["9206"] = { -- Elixir of Giants
        ["buffId"] = "11405",
    },
    ["9187"] = { -- Elixir of Greater Agility
        ["buffId"] = "11334",
    },
    ["21546"] = { -- Elixir of Greater Firepower
        ["buffId"] = "26276",
    },
    ["9179"] = { -- Elixir of Greater Intellect
        ["buffId"] = "11396",
    },
    ["3386"] = {}, -- Elixir of Poison Resistance
    ["9264"] = { -- Elixir of Shadow Power
        ["buffId"] = "11474",
    },
    ["13445"] = { -- Elixir of Superior Defense
        ["buffId"] = "11348",
    },
    ["13452"] = { -- Elixir of the Mongoose
        ["buffId"] = "17538",
    },
    ["13447"] = { -- Elixir of the Sages
        ["buffId"] = "17535",
    },
    ["13513"] = { -- Flask of Chromatic Resistance
        ["buffId"] = "17629",
    },
    ["13511"] = { -- Flask of Distilled Wisdom
        ["buffId"] = "17627",
    },
    ["13506"] = {}, -- Flask of Petrification
    ["13512"] = { -- Flask of Supreme Power
        ["buffId"] = "17628",
    },
    ["13510"] = { -- Flask of the Titans
        ["buffId"] = "17626",
    },
    ["5634"] = {}, -- Free Action Potion
    ["9088"] = { -- Gift of Arthas
        ["buffId"] = "11371",
    },
    ["8424"] = { -- Gizzard Gum
        ["buffId"] = "10693",
    },
    ["10646"] = {}, -- Goblin Sapper Charge
    ["18269"] = { -- Gordok Green Grog
        ["buffId"] = "22789",
    },
    ["13454"] = { -- Greater Arcane Elixir
        ["buffId"] = "17539",
        ["lesserItemIds"] = {"9155"},
        ["lesserBuffIds"] = {"11390"}
    },
    ["13461"] = { -- Greater Arcane Protection Potion
        ["buffId"] = "17549",
    },
    ["13457"] = { -- Greater Fire Protection Potion
        ["buffId"] = "17543",
        ["lesserItemIds"] = {"6049"},
        ["lesserBuffIds"] = {"7233"}
    },
    ["13456"] = { -- Greater Frost Protection Potion
        ["buffId"] = "17544",
        ["lesserItemIds"] = {"6050"},
        ["lesserBuffIds"] = {"7239"}
    },
    ["13460"] = { -- Greater Holy Protection Potion
        ["buffId"] = "17545",
        ["lesserItemIds"] = {"6051"},
        ["lesserBuffIds"] = {"7245"}
    },
    ["13458"] = { -- Greater Nature Protection Potion
        ["buffId"] = "17546",
        ["lesserItemIds"] = {"6052"},
        ["lesserBuffIds"] = {"7254"}
    },
    ["13459"] = { -- Greater Shadow Protection Potion
        ["buffId"] = "17548",
        ["lesserItemIds"] = {"6048"},
        ["lesserBuffIds"] = {"7242"}
    },
    ["13455"] = { -- Greater Stoneshield Potion
        ["buffId"] = "17540",
    },
    ["13928"] = { -- Grilled Squid
        ["buffId"] = "18192",
    },
    ["8412"] = { -- Ground Scorpok Assay
        ["buffId"] = "10669",
    },
    ["14530"] = {}, -- Heavy Runecloth Bandage
    ["8928"] = { -- Instant Poison VI
        ["buffId"] = "11340",
    },
    ["12457"] = { -- Juju Chill
        ["buffId"] = "16325",
    },
    ["12455"] = { -- Juju Ember
        ["buffId"] = "16326",
    },
    ["12450"] = { -- Juju Flurry
        ["buffId"] = "16322",
    },
    ["12460"] = { -- Juju Might
        ["buffId"] = "16329",
    },
    ["12451"] = { -- Juju Power
        ["buffId"] = "16323",
    },
    ["18284"] = { -- Kreeg's Stout Beatdown
        ["buffId"] = "22790",
    },
    ["3387"] = {}, -- Limited Invulnerability Potion
    ["20008"] = {}, -- Living Action Potion
    ["8411"] = { -- Lung Juice Cocktail
        ["buffId"] = "10668",
    },
    ["20007"] = { -- Mageblood Potion
        ["buffId"] = "24363",
    },
    ["2091"] = {}, -- Magic Dust
    ["19013"] = { -- Major Healthstone
        ["altItemIds"] = {"19012", "9421"}
    },
    ["13444"] = {}, -- Major Mana Potion
    ["20004"] = { -- Major Troll's Blood Potion
        ["buffId"] = "24361",
    },
    ["9449"] = { -- Manual Crowd Pummeler
        ["buffId"] = "13494",
    },
    ["13442"] = {}, -- Mighty Rage Potion
    ["11952"] = { -- Night Dragon's Breath
        ["altItemIds"] = {"14894"}
    },
    ["13931"] = { -- Nightfin Soup
        ["buffId"] = "18194",
    },
    ["8956"] = {}, -- Oil of Immolation
    ["19440"] = {}, -- Powerful Anti-Venom
    ["8410"] = { -- R.O.I.D.S.
        ["buffId"] = "10667",
    },
    ["9030"] = {}, -- Restorative Potion
    ["21151"] = { -- Rumsey Rum Black Label
        ["buffId"] = "25804",
    },
    ["18254"] = { -- Runn Tum Tuber Surprise
        ["buffId"] = "22730",
    },
    ["21217"] = { -- Sagefish Delight
        ["buffId"] = "25941",
    },
    ["20080"] = { -- Sheen of Zanza
        ["buffId"] = "24417",
    },
    ["20452"] = { -- Smoked Desert Dumplings
        ["buffId"] = "24799",
    },
    ["20079"] = { -- Spirit of Zanza
        ["buffId"] = "24382",
    },
    ["13180"] = {}, -- Stratholme Holy Water
    ["20081"] = { -- Swiftness of Zanza
        ["buffId"] = "24383",
    },
    ["18045"] = { -- Tender Wolf Steak
        ["buffId"] = "19710",
    },
    ["7676"] = {}, -- Thistle Tea
    ["15993"] = { -- Thorium Grenade
        ["altItemIds"] = {"16005", "10830", "10586", "10562", "10514", "4394", "4390", "4380", "4374", "4370", "4360", "4403"}
    },
    ["18042"] = {}, -- Thorium Headed Arrow
    ["15997"] = {}, -- Thorium Shells
    ["11951"] = {}, -- Whipper Root Tuber
    ["12820"] = { -- Winterfall Firewater
        ["buffId"] = "17038",
    }
}

local numConsumablesFetching = 0
for itemId, itemData in pairs(consumablesInfo) do
    itemData["itemId"] = itemId
    itemData["toolTip"] = nil
    itemData["name"] = GetItemName(tonumber(itemId))
    itemData["icon"] = GetItemIcon(tonumber(itemId))
    if itemData["name"] == nil then
        numConsumablesFetching = numConsumablesFetching + 1
        local item = Item:CreateFromItemID(tonumber(itemId))
        item:ContinueOnItemLoad(function()
            numConsumablesFetching = numConsumablesFetching - 1
            itemData["name"] = item:GetItemName()
        end)
    end
end

local specs = {
    ["All Classes"] = {
        ["englishClass"] = "",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
        ["currentSpecs"] = {},
    },
    ["Shaman (Ele)"] = {
        ["englishClass"] = "SHAMAN",
        ["hidden"] = true,
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Shaman (Enh)"] = {
        ["englishClass"] = "SHAMAN",
        ["hidden"] = true,
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Druid (Feral DPS)"] = {
        ["englishClass"] = "DRUID",
        ["hidden"] = true,
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Druid (Moonkin)"] = {
        ["englishClass"] = "DRUID",
        ["hidden"] = true,
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Druid (Feral Tank)"] = {
        ["englishClass"] = "DRUID",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Priest (Healing)"] = {
        ["englishClass"] = "PRIEST",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Paladin (Holy)"] = {
        ["englishClass"] = "PALADIN",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Hunter"] = {
        ["englishClass"] = "HUNTER",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Mage"] = {
        ["englishClass"] = "MAGE",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Paladin (Prot)"] = {
        ["englishClass"] = "PALADIN",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Warrior (Prot)"] = {
        ["englishClass"] = "WARRIOR",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Druid (Resto)"] = {
        ["englishClass"] = "DRUID",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Shaman (Resto)"] = {
        ["englishClass"] = "SHAMAN",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Paladin (Ret)"] = {
        ["englishClass"] = "PALADIN",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Rogue"] = {
        ["englishClass"] = "ROGUE",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Priest (Shadow)"] = {
        ["englishClass"] = "PRIEST",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Warlock"] = {
        ["englishClass"] = "WARLOCK",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
    ["Warrior (DPS)"] = {
        ["englishClass"] = "WARRIOR",
        ["currentBuffs"] = {},
        ["currentItems"] = {},
    },
}

local tabId = PowerRaidGUI.ConsumablesTabId
local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

local function OnValueChanged(value, spec, spellName)
    local currType = PowerRaid.db.char.currentConsumableType
    local currBoss = PowerRaid.db.char.currentBoss
    PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currType][spellName] = value
end

function ConsumablesTab:getConsumablesInfo()
    return consumablesInfo
end

function ConsumablesTab:getSpecs()
    return specs
end

function ConsumablesTab:getBosses()
    return bosses
end

function ConsumablesTab:ShouldShowSpec(specData)
    return not specData["hidden"] and ((PowerRaid.faction == "Horde" and specData["englishClass"] ~= "PALADIN") or (PowerRaid.faction == "Alliance" and specData["englishClass"] ~= "SHAMAN"))
end

function ConsumablesTab:GetLocalizedSpecNameWithColor(spec)
    return format("|c%s%s|r",
            GetClassColorFromEnglishClass(specs[spec]["englishClass"]),
            GetLocalizedSpecName(spec))
end

function ConsumablesTab:SendConsumesOrBuffQuestion(type, spec, reportAfterScan)
    local currBoss = PowerRaid.db.char.currentBoss
    if spec == "All Classes" then
        for aspec, _ in pairs(specs) do
            specs[aspec][(type == "ITEM" and "currentItems" or "currentBuffs")] = {}
        end
    else
        specs[spec][(type == "ITEM" and "currentItems" or "currentBuffs")] = {}
    end
    local consumeIds = {}
    for _, consumeId in pairs(PowerRaid.db.char.consumesForSpecs[spec]) do
        local count = tonumber(PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][type][consumeId])
        if count ~= nil and count > 0 then
            table.insert(consumeIds, consumeId)
        end
    end
    if #consumeIds > 0 then
        PowerRaid.tabsScanActive[tabId] = true
        if reportAfterScan then
            PowerRaid.tabsReportActive[tabId] = true
        end
        if type == "ITEM" then
            PowerRaid:ConsumablesQuestion(spec, consumeIds, PowerRaid.db.char.consumablesLesserEnabled)
        elseif type == "BUFF" then
            PowerRaid:QuestionBuffs(spec, consumeIds, PowerRaid.db.char.consumablesLesserEnabled)
        end
    end
end

-- buff or item scan
function ConsumablesTab:ScanConsumables(type, spec, reportAfterScan)
    if spec == "All Classes" then
        for aspec, v in pairs(specs) do
            self:SendConsumesOrBuffQuestion(type, aspec, reportAfterScan)
        end
    else
        self:SendConsumesOrBuffQuestion(type, "All Classes", reportAfterScan)
        self:SendConsumesOrBuffQuestion(type, spec, reportAfterScan)
    end
end

local function CreateCurrentClassConsumeRowItem(consumableInfo, count, requiredCount)
    local currConsume = AceGUI:Create("Icon")
    if(consumableInfo["icon"]) then
        currConsume:SetImage(consumableInfo["icon"])
    else
        currConsume:SetImage("Interface\\Icons\\inv_misc_questionmark")
    end
    currConsume:SetImageSize(16, 16)
    currConsume.image:SetAllPoints()
    currConsume:SetWidth(16)
    currConsume:SetHeight(16)

    --if consumableInfo["itemId"] then
    --    currConsume.frame:SetScript("OnEnter", function()
    --        if(consumableInfo["toolTip"] == nil) then
    --            consumableInfo["toolTip"] = CreateFrame("GameTooltip", consumableInfo["itemId"] .. spec .. spec .. player, nil, "GameTooltipTemplate")
    --        end
    --        consumableInfo["toolTip"]:SetOwner(currConsume.frame, "ANCHOR_CURSOR")
    --        consumableInfo["toolTip"]:SetItemByID(consumableInfo["itemId"])
    --        consumableInfo["toolTip"]:Show()
    --    end)
    --    currConsume.frame:SetScript("OnLeave", function()
    --        consumableInfo["toolTip"]:Hide()
    --    end)
    --end

    if count < requiredCount then
        currConsume.image:SetVertexColor(1, 1, 1, 0.2)
    else
        currConsume.image:SetVertexColor(1, 1, 1, 1)
    end

    return currConsume
end

local function DrawCurrentClassConsumeRow(player, spec, consumeIterator, consumeIteratorAll)
    local currType = PowerRaid.db.char.currentConsumableType
    local currBoss = PowerRaid.db.char.currentBoss

    local playerContainer = AceGUI:Create("SimpleGroup")
    playerContainer:SetLayout("Flow")
    playerContainer:SetFullWidth(true)

    local currName = AceGUI:Create("Label")
    local _, englishClass, classIndex = UnitClass(player)
    currName:SetText("|c" .. GetClassColorFromEnglishClass(englishClass) .. player .. "|r")

    local childrenIcons = {}
    if consumeIterator then
        for consumeId, count in pairs(consumeIterator) do
            local requiredCount = tonumber(PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currType][consumeId])
            if requiredCount ~= nil and requiredCount > 0 then
                table.insert(childrenIcons, CreateCurrentClassConsumeRowItem(consumablesInfo[consumeId], count, requiredCount))
            end
        end
    end

    if consumeIteratorAll then
        for consumeId, count in pairs(consumeIteratorAll) do
            local requiredCount = tonumber(PowerRaid.db.char.consumablesToCheckFor[currBoss]["All Classes"][currType][consumeId])
            if requiredCount ~= nil and requiredCount > 0 then
                table.insert(childrenIcons, CreateCurrentClassConsumeRowItem(consumablesInfo[consumeId], count, requiredCount))
            end
        end
    end

    local iconsContainer = AceGUI:Create("SimpleGroup")
    iconsContainer:SetLayout("Flow")
    iconsContainer:SetWidth(16 * #childrenIcons + 1)
    iconsContainer:SetHeight(16)

    currName:SetWidth(350 - 16 * #childrenIcons - 1)
    currName:SetHeight(16)

    playerContainer:AddChild(currName)
    playerContainer:AddChild(iconsContainer)
    iconsContainer:AddChildren(unpack(childrenIcons))

    return playerContainer
end

local function DrawCurrentClassConsumables()
    local currentSpec = PowerRaid.db.char.currentSpecTab
    local raidContainer = AceGUI:Create("SimpleGroup")
    raidContainer:SetFullWidth(true)
    raidContainer:SetLayout("Flow")

    local groupContainer = AceGUI:Create("SimpleGroup")
    groupContainer:SetRelativeWidth(1)
    groupContainer:SetLayout("List")
    groupContainer:SetFullWidth(true)

    local consumeType
    if PowerRaid.db.char.currentConsumableType == "ITEM" then
        consumeType = "currentItems"
    elseif PowerRaid.db.char.currentConsumableType == "BUFF" then
        consumeType = "currentBuffs"
    end

    local playerContainers = {}
    if consumeType then
        if currentSpec == "All Classes" then
            for aspec, _ in pairs(specs) do
                if aspec ~= "All Classes" then
                    local players = {}
                    for player, currentItems in pairs(specs[aspec][consumeType]) do
                        table.insert(playerContainers, DrawCurrentClassConsumeRow(player, aspec, currentItems, specs["All Classes"][consumeType][player]))
                        players[player] = true
                    end
                    for player, currentItemsAll in pairs(specs["All Classes"][consumeType]) do
                        if not players[player] and specs["All Classes"]["currentSpecs"][player] == aspec then
                            table.insert(playerContainers, DrawCurrentClassConsumeRow(player, aspec, specs[aspec][consumeType][player], currentItemsAll))
                        end
                    end
                end
            end
        else
            local players = {}
            for player, currentItems in pairs(specs[currentSpec][consumeType]) do
                table.insert(playerContainers, DrawCurrentClassConsumeRow(player, currentSpec, currentItems, specs["All Classes"][consumeType][player]))
                players[player] = true
            end
            for player, currentItemsAll in pairs(specs["All Classes"][consumeType]) do
                if not players[player] and specs["All Classes"]["currentSpecs"][player] == currentSpec then
                    table.insert(playerContainers, DrawCurrentClassConsumeRow(player, currentSpec, specs[currentSpec][consumeType][player], currentItemsAll))
                end
            end
        end
    end

    raidContainer:AddChild(groupContainer)
    groupContainer:AddChildren(unpack(playerContainers))
    return raidContainer
end

function ConsumablesTab:findMissingItems(spec, type, playersMissingAll, playersMissingAny, itemOrBuffToPlayersMissingList, playersHaveAll, playersHaveAny, itemOrBuffToPlayersHaveList)
    local boss = PowerRaid.db.char.currentBoss
    for player, consumeIds in pairs(specs[spec][(type == "ITEM" and "currentItems" or "currentBuffs")]) do
        for consumeId, count in pairs(consumeIds) do
            local itemNum = tonumber(PowerRaid.db.char.consumablesToCheckFor[boss][spec][type][consumeId])
            if itemNum ~= nil and itemNum > 0 then
                local itemNameMaybeWithCount = consumablesInfo[consumeId]["name"]
                if itemNum > 1 then
                    itemNameMaybeWithCount = itemNameMaybeWithCount .. " (" .. itemNum .. ")"
                end
                if count < itemNum then
                    playersMissingAny[player] = true
                    playersHaveAll[player] = false
                    if itemOrBuffToPlayersMissingList[itemNameMaybeWithCount] == nil then
                        itemOrBuffToPlayersMissingList[itemNameMaybeWithCount] = {}
                    end
                    table.insert(itemOrBuffToPlayersMissingList[itemNameMaybeWithCount], player)
                elseif count >= itemNum then
                    playersHaveAny[player] = true
                    playersMissingAll[player] = false
                    if itemOrBuffToPlayersHaveList[itemNameMaybeWithCount] == nil then
                        itemOrBuffToPlayersHaveList[itemNameMaybeWithCount] = {}
                    end
                    table.insert(itemOrBuffToPlayersHaveList[itemNameMaybeWithCount], player)
                end
            end
        end
    end
end

function ConsumablesTab:outputReport()
    local channel = PowerRaid.db.char.currentReportOutputChannels[tabId]
    local reportType = PowerRaid.db.char.currentReportOutputTypes[tabId]
    local type = PowerRaid.db.char.currentConsumableType
    local spec = PowerRaid.db.char.currentSpecTab

    local intro = format("[%s] %s: ", L["Power Raid"],
            format(L["reportOutputting"], GetReportTypes(tabId, format("%s (%s)", tabName, type == "ITEM" and L["Items"] or L["Buffs"]))[reportType]))
    local knownPlayers = {}

    local playersMissingAll = {}
    local playersMissingAny = {}
    local itemOrBuffToPlayersMissingList = {}

    local playersHaveAll = {}
    local playersHaveAny = {}
    local itemOrBuffToPlayersHaveList = {}

    if spec == "All Classes" then
        for aspec, _ in pairs(specs) do
            for player, _ in pairs(specs[aspec][(type == "ITEM" and "currentItems" or "currentBuffs")]) do
                knownPlayers[player] = true
                playersMissingAll[player] = true
                playersHaveAll[player] = true
            end
        end
    else
        for player, _ in pairs(specs["All Classes"][(type == "ITEM" and "currentItems" or "currentBuffs")]) do
            knownPlayers[player] = true
            playersMissingAll[player] = true
            playersHaveAll[player] = true
        end
        for player, _ in pairs(specs[spec][(type == "ITEM" and "currentItems" or "currentBuffs")]) do
            knownPlayers[player] = true
            playersMissingAll[player] = true
            playersHaveAll[player] = true
        end
    end

    if spec == "All Classes" then
        for aspec, _ in pairs(specs) do
            ConsumablesTab:findMissingItems(aspec, type, playersMissingAll, playersMissingAny, itemOrBuffToPlayersMissingList, playersHaveAll, playersHaveAny, itemOrBuffToPlayersHaveList)
        end
    else
        ConsumablesTab:findMissingItems("All Classes", type, playersMissingAll, playersMissingAny, itemOrBuffToPlayersMissingList, playersHaveAll, playersHaveAny, itemOrBuffToPlayersHaveList)
        ConsumablesTab:findMissingItems(spec, type, playersMissingAll, playersMissingAny, itemOrBuffToPlayersMissingList, playersHaveAll, playersHaveAny, itemOrBuffToPlayersHaveList)
    end

    local playersMissingAllList = ConvertTruthyDictToList(playersMissingAll)
    local playersMissingAnyList = ConvertTruthyDictToList(playersMissingAny)
    local playersHaveAllList = ConvertTruthyDictToList(playersHaveAll)
    local playersHaveAnyList = ConvertTruthyDictToList(playersHaveAny)

    local showUnknown = PowerRaid.db.char.reportUnknownPlayers[tabId]
    if reportType == "missing_all" then
        OutputPlayersList(channel, intro, playersMissingAllList, knownPlayers, showUnknown)
    elseif reportType == "missing_any" then
        OutputPlayersList(channel, intro, playersMissingAnyList, knownPlayers, showUnknown)
    elseif reportType == "missing_each" then
        OutputItemToPlayers(channel, intro, itemOrBuffToPlayersMissingList, knownPlayers, showUnknown)
    elseif reportType == "has_all" then
        OutputPlayersList(channel, intro, playersHaveAllList, knownPlayers, showUnknown)
    elseif reportType == "has_any" then
        OutputPlayersList(channel, intro, playersHaveAnyList, knownPlayers, showUnknown)
    elseif reportType == "has_each" then
        OutputItemToPlayers(channel, intro, itemOrBuffToPlayersHaveList, knownPlayers, showUnknown)
    end
end

local itemIncrementerMax = 10
local function GetConsumeItemNum(spec, consumeId)
    local currBoss = PowerRaid.db.char.currentBoss
    local currConsumableType = PowerRaid.db.char.currentConsumableType
    local itemNum = tonumber(PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currConsumableType][consumeId])
    if itemNum == nil or itemNum < 0 then
        itemNum = 0
        PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currConsumableType][consumeId] = itemNum
    elseif itemNum > itemIncrementerMax then
        itemNum = itemIncrementerMax
        PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currConsumableType][consumeId] = itemNum
    end
    return itemNum
end

local function GetItemIncrementerLabelText(num)
    local labelString = " "
    if num < 10 then
        labelString = labelString .. " "
    end
    if num == 0 then
        return labelString .. "|cFFC1C4C6" .. tostring(num) .. "|r"
    else
        return labelString .. "|cFF00FF00" .. tostring(num) .. "|r"
    end
end

local function UpdateItemIncrementerButton(num, button, buttonType)
    local buttonText
    local isDisabled
    if buttonType == "LEFT" then
        buttonText = "-"
        isDisabled = (num <= 0)
    else
        buttonText = "+"
        isDisabled = (num >= itemIncrementerMax)
    end
    button:SetDisabled(isDisabled)
    if isDisabled then
        button:SetText("|cFF999DA0" .. buttonText .. "|r")
    else
        button:SetText(buttonText)
    end
end

local function CreateItemIncrementer(spec, consumeId, consumableInfo)
    local currBoss = PowerRaid.db.char.currentBoss
    local currConsumableType = PowerRaid.db.char.currentConsumableType
    local itemSelector = AceGUI:Create("SimpleGroup")
    itemSelector:SetWidth(64)
    itemSelector:SetLayout("Flow")
    local tempIcon = AceGUI:Create("InteractiveLabel")
    tempIcon:SetWidth(64)
    tempIcon:SetImage(consumableInfo["icon"])
    tempIcon:SetImageSize(16, 16)
    if consumableInfo["itemId"] then
        tempIcon:SetCallback("OnEnter", function()
            if(consumableInfo["toolTip"] == nil) then
                consumableInfo["toolTip"] = CreateFrame( "GameTooltip", consumeId .. spec .. currConsumableType .. "checkbox" , nil, "GameTooltipTemplate" )
            end
            consumableInfo["toolTip"]:SetOwner(tempIcon.frame, "ANCHOR_CURSOR")
            consumableInfo["toolTip"]:SetItemByID(consumableInfo["itemId"])
            consumableInfo["toolTip"]:Show()
        end)
        tempIcon:SetCallback("OnLeave", function()
            consumableInfo["toolTip"]:Hide()
        end)
    end
    local itemNum = GetConsumeItemNum(spec, consumeId)
    local tempLabel = AceGUI:Create("Label")
    tempLabel:SetWidth(16)
    tempLabel:SetHeight(12)
    tempLabel:SetText(GetItemIncrementerLabelText(itemNum))
    local tempLeftButton = AceGUI:Create("Button")
    tempLeftButton:SetWidth(12)
    tempLeftButton:SetHeight(12)
    UpdateItemIncrementerButton(itemNum, tempLeftButton, "LEFT")
    local tempRightButton = AceGUI:Create("Button")
    tempRightButton:SetWidth(12)
    tempRightButton:SetHeight(12)
    UpdateItemIncrementerButton(itemNum, tempRightButton, "RIGHT")
    local getIncrementDecrementCallback = (function(isIncrement)
        return (function()
            local num = GetConsumeItemNum(spec, consumeId)
            if isIncrement and num < itemIncrementerMax then
                num = num + 1
            elseif not isIncrement and num > 0 then
                num = num - 1
            end
            UpdateItemIncrementerButton(num, tempLeftButton, "LEFT")
            UpdateItemIncrementerButton(num, tempRightButton, "RIGHT")
            PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currConsumableType][consumeId] = num
            tempLabel:SetText(GetItemIncrementerLabelText(num))
        end)
    end)
    tempLeftButton:SetCallback("OnClick", getIncrementDecrementCallback(false))
    local incrementCallback = getIncrementDecrementCallback(true)
    tempRightButton:SetCallback("OnClick", incrementCallback)
    tempIcon:SetCallback("OnClick", incrementCallback)
    itemSelector:AddChild(tempIcon)
    local spacer = AceGUI:Create("Label")
    spacer:SetWidth(12)
    spacer:SetText("")
    itemSelector:AddChild(spacer)
    itemSelector:AddChild(tempLeftButton)
    itemSelector:AddChild(tempLabel)
    itemSelector:AddChild(tempRightButton)
    return itemSelector
end

local function DrawCurrentClassTab()
    local spec = PowerRaid.db.char.currentSpecTab
    local currBoss = PowerRaid.db.char.currentBoss
    local currConsumableType = PowerRaid.db.char.currentConsumableType
    local fullTab = AceGUI:Create("SimpleGroup")
    fullTab:SetFullWidth(true)
    fullTab:SetLayout("Flow")
    local consumeIterator = { [1] = spec }
    if spec == "All Classes" then
        consumeIterator = {}
        for spec, _ in pairs(specs) do
            if ConsumablesTab:ShouldShowSpec(specs[spec]) then
                table.insert(consumeIterator, spec)
            end
        end
        table.sort(consumeIterator)
    end
    for i, spec in pairs(consumeIterator) do
        local consumablesForSpec = AceGUI:Create("InlineGroup")
        consumablesForSpec:SetTitle(format(L["specConsumables"], ConsumablesTab:GetLocalizedSpecNameWithColor(spec)))
        consumablesForSpec:SetFullWidth(true)
        consumablesForSpec:SetLayout("Flow")
        for _, consumeId in pairs(PowerRaid.db.char.consumesForSpecs[spec]) do
            if currConsumableType == "ITEM" and consumablesInfo[consumeId]["itemId"] ~= nil then
                consumablesForSpec:AddChild(CreateItemIncrementer(spec, consumeId, consumablesInfo[consumeId]))
            elseif PowerRaid.db.char.currentConsumableType == "BUFF" and consumablesInfo[consumeId]["buffId"] ~= nil then
                local tempCheckBox = AceGUI:Create("CheckBox")
                tempCheckBox:SetWidth(64)
                tempCheckBox:SetLabel("")
                if PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currConsumableType][consumeId] == 1 then
                    tempCheckBox:SetValue(true)
                else
                    tempCheckBox:SetValue(false)
                end
                tempCheckBox:SetImage(consumablesInfo[consumeId]["icon"])
                tempCheckBox:SetCallback("OnValueChanged", function()
                    if tempCheckBox:GetValue() then
                        OnValueChanged(1, spec, consumeId)
                    else
                        OnValueChanged(0, spec, consumeId)
                    end
                end)
                if consumablesInfo[consumeId]["itemId"] then
                    tempCheckBox:SetCallback("OnEnter", function()
                        if(consumablesInfo[consumeId]["toolTip"] == nil) then
                            consumablesInfo[consumeId]["toolTip"] = CreateFrame( "GameTooltip", consumeId .. spec .. currConsumableType .. "checkbox" , nil, "GameTooltipTemplate" )
                        end
                        consumablesInfo[consumeId]["toolTip"]:SetOwner(tempCheckBox.frame, "ANCHOR_CURSOR")
                        consumablesInfo[consumeId]["toolTip"]:SetItemByID(consumablesInfo[consumeId]["itemId"])
                        consumablesInfo[consumeId]["toolTip"]:Show()
                    end)
                    tempCheckBox:SetCallback("OnLeave", function()
                        consumablesInfo[consumeId]["toolTip"]:Hide()
                    end)
                end
                consumablesForSpec:AddChild(tempCheckBox)
            else
                PowerRaid.db.char.consumablesToCheckFor[currBoss][spec][currConsumableType][consumeId] = 0
            end
        end
        fullTab:AddChild(consumablesForSpec)
    end
    return fullTab
end

function ConsumablesTab:getAddRemoveConsumesDropdownListAndOrder(spec)
    local consumeDropdownListOrder = {}
    local consumeDropdownList = {}

    consumeDropdownList["removeConsumeTitleItem"] = format(L["removeFromSpec"], spec)
    table.insert(consumeDropdownListOrder, "removeConsumeTitleItem")

    for _, consumeId in pairs(PowerRaid.db.char.consumesForSpecs[spec]) do
        consumeDropdownList[consumeId] = consumablesInfo[consumeId]["name"]
        table.insert(consumeDropdownListOrder, consumeId)
    end

    consumeDropdownList["addConsumeTitleItem"] = format(L["addToSpec"], spec)
    table.insert(consumeDropdownListOrder, "addConsumeTitleItem")

    local addConsumeNameToId = {}
    for consumeId, consumableInfo in pairs(consumablesInfo) do
        local consumeExistsInCurrentSpec = false
        for _, consumeIdInSpec in pairs(PowerRaid.db.char.consumesForSpecs[spec]) do
            if consumeIdInSpec == consumeId then
                consumeExistsInCurrentSpec = true
                break
            end
        end
        if not consumeExistsInCurrentSpec then
            consumeDropdownList[consumeId] = consumableInfo["name"]
            addConsumeNameToId[consumableInfo["name"]] = consumeId
        end
    end
    for _, consumeId in orderedPairs(addConsumeNameToId) do
        table.insert(consumeDropdownListOrder, consumeId)
    end

    return consumeDropdownList, consumeDropdownListOrder
end

function ConsumablesTab:RemoveConsumeIdFromSpec(spec, consumeId)
    local removedFromSpec = false
    for i, consumeIdForSpec in pairs(PowerRaid.db.char.consumesForSpecs[spec]) do
        if consumeIdForSpec == consumeId then
            table.remove(PowerRaid.db.char.consumesForSpecs[spec], i)
            removedFromSpec = true
            for boss, _ in pairs(bosses) do
                for type, consumesToCheckForType in pairs(PowerRaid.db.char.consumablesToCheckFor[boss][spec]) do
                    local removedTable = {}
                    local foundConsume = false
                    for id, val in pairs(consumesToCheckForType) do
                        if id == consumeId then
                            foundConsume = true
                        else
                            removedTable[id] = val
                        end
                    end
                    if foundConsume then
                        PowerRaid.db.char.consumablesToCheckFor[boss][spec][type] = removedTable
                    end
                end
            end
            break
        end
    end
    return removedFromSpec
end

function ConsumablesTab:SortListOfConsumeIds(consumeIdsList)
    local nameToIds = {}
    for _, consumeId in pairs(consumeIdsList) do
        nameToIds[consumablesInfo[consumeId]["name"]] = consumeId
    end
    local sorted = {}
    for _, consumeId in orderedPairs(nameToIds) do
        table.insert(sorted, consumeId)
    end
    return sorted
end

function ConsumablesTab:DrawConsumables(container)
    local topTitleGroup = AceGUI:Create("SimpleGroup")
    topTitleGroup:SetFullWidth(true)
    topTitleGroup:SetLayout("Flow")

    local specChoosingLabel = AceGUI:Create("Label")
    specChoosingLabel:SetWidth(200)
    specChoosingLabel:SetText(L["Choose Item or Buff and Class to Check for:"])
    topTitleGroup:AddChild(specChoosingLabel)

    local typeDropdown = AceGUI:Create("Dropdown")
    typeDropdown:SetWidth(100)
    typeDropdown:SetList({["ITEM"] = L["Item"], ["BUFF"] = L["Buff"]})
    typeDropdown:SetValue(PowerRaid.db.char.currentConsumableType)
    typeDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        PowerRaid.db.char.currentConsumableType = key
        PowerRaidGUI:ReloadCurrentTab()
    end)
    topTitleGroup:AddChild(typeDropdown)

    local specDropDown = AceGUI:Create("Dropdown")
    specDropDown:SetWidth(120)
    local dropdown = {}
    for key, value in pairs(specs) do
        if ConsumablesTab:ShouldShowSpec(value) then
            dropdown[key] = ConsumablesTab:GetLocalizedSpecNameWithColor(key)
        end
    end
    specDropDown:SetList(dropdown)
    specDropDown:SetValue(PowerRaid.db.char.currentSpecTab)
    specDropDown:SetCallback("OnValueChanged", function(widget, event, key)
        PowerRaid.db.char.currentSpecTab = key
        PowerRaidGUI:ReloadCurrentTab()
    end)
    topTitleGroup:AddChild(specDropDown)

    local bossDropDown = AceGUI:Create("Dropdown")
    bossDropDown:SetWidth(150)
    bossDropDown:SetList(bosses, bossKeys)
    bossDropDown:SetValue(PowerRaid.db.char.currentBoss)
    bossDropDown:SetCallback("OnValueChanged", function(widget, event, key)
        PowerRaid.db.char.currentBoss = key
        PowerRaidGUI:ReloadCurrentTab()
    end)
    topTitleGroup:AddChild(bossDropDown)

    local lesserCheckBox = AceGUI:Create("CheckBox")
    lesserCheckBox:SetLabel(L["Lesser"])
    lesserCheckBox:SetWidth(90)
    lesserCheckBox:SetValue(PowerRaid.db.char.consumablesLesserEnabled)
    lesserCheckBox:SetCallback("OnValueChanged", function()
        PowerRaid.db.char.consumablesLesserEnabled = lesserCheckBox:GetValue()
    end)
    lesserCheckBox:SetCallback("OnEnter", function()
        if(lesserCheckBoxTooltip == nil) then
            lesserCheckBoxTooltip = CreateFrame("GameTooltip", "lessercheckbox" , nil, "GameTooltipTemplate")
        end
        lesserCheckBoxTooltip:SetOwner(lesserCheckBox.frame, "ANCHOR_CURSOR")
        lesserCheckBoxTooltip:SetText(L["lesserDescription"])
        lesserCheckBoxTooltip:Show()
    end)
    lesserCheckBox:SetCallback("OnLeave", function()
        lesserCheckBoxTooltip:Hide()
    end)
    topTitleGroup:AddChild(lesserCheckBox)

    local clearBtn = AceGUI:Create("Button")
    clearBtn:SetText(format("|cFFF2003C%s|r", L["Clear Selected"]))
    clearBtn:SetWidth(120)
    clearBtn:SetCallback("OnClick", function()
        local consumeType
        if PowerRaid.db.char.currentConsumableType == "ITEM" then
            consumeType = "currentItems"
        elseif PowerRaid.db.char.currentConsumableType == "BUFF" then
            consumeType = "currentBuffs"
        end
        if consumeType then
            if PowerRaid.db.char.currentSpecTab == "All Classes" then
                for spec, _ in pairs(PowerRaid.db.char.consumablesToCheckFor[PowerRaid.db.char.currentBoss]) do
                    PowerRaid.db.char.consumablesToCheckFor[PowerRaid.db.char.currentBoss][spec][PowerRaid.db.char.currentConsumableType] = {}
                    specs[spec][consumeType] = {}
                end
            else
                PowerRaid.db.char.consumablesToCheckFor[PowerRaid.db.char.currentBoss][PowerRaid.db.char.currentSpecTab][PowerRaid.db.char.currentConsumableType] = {}
                specs[PowerRaid.db.char.currentSpecTab][consumeType] = {}
            end
        end
        PowerRaidGUI:ReloadCurrentTab()
    end)
    topTitleGroup:AddChild(clearBtn)
    container:AddChild(topTitleGroup)

    local tabDisplayName = format("%s (%s)",
            tabName, PowerRaid.db.char.currentConsumableType == "ITEM" and L["Items"] or L["Buffs"])
    local spacer = ScanReportRowRenderer:Render(tabId, tabDisplayName, function()
        ConsumablesTab:ScanConsumables(PowerRaid.db.char.currentConsumableType, PowerRaid.db.char.currentSpecTab, false)
        PowerRaidGUI:ReloadCurrentTab()
    end, function()
        ConsumablesTab:ScanConsumables(PowerRaid.db.char.currentConsumableType, PowerRaid.db.char.currentSpecTab, true)
        PowerRaidGUI:ReloadCurrentTab()
    end)

    local addConsumeDropdown = AceGUI:Create("Dropdown")
    addConsumeDropdown:SetWidth(230)

    local consumeDropdownList, consumeDropdownListOrder = ConsumablesTab:getAddRemoveConsumesDropdownListAndOrder(PowerRaid.db.char.currentSpecTab)
    addConsumeDropdown:SetList(consumeDropdownList, consumeDropdownListOrder)
    addConsumeDropdown:SetValue(PowerRaid.db.char.CurrentConsumablesOutputChannel)
    addConsumeDropdown:SetText(format(L["addRemoveForSpec"], ConsumablesTab:GetLocalizedSpecNameWithColor(PowerRaid.db.char.currentSpecTab)))
    addConsumeDropdown:SetItemDisabled("removeConsumeTitleItem", true)
    addConsumeDropdown:SetItemDisabled("addConsumeTitleItem", true)
    addConsumeDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        local spec = PowerRaid.db.char.currentSpecTab
        local removedFromSpec = ConsumablesTab:RemoveConsumeIdFromSpec(spec, key)
        if not removedFromSpec then
            table.insert(PowerRaid.db.char.consumesForSpecs[spec], key)
            PowerRaid.db.char.consumesForSpecs[spec] = ConsumablesTab:SortListOfConsumeIds(PowerRaid.db.char.consumesForSpecs[spec])
            if spec == "All Classes" then
                for consumeSpec, _ in pairs(PowerRaid.db.char.consumesForSpecs) do
                    if consumeSpec ~= spec then
                        ConsumablesTab:RemoveConsumeIdFromSpec(consumeSpec, key)
                    end
                end
            else
                ConsumablesTab:RemoveConsumeIdFromSpec("All Classes", key)
            end
        end
        ConsumablesTab:ScanConsumables(PowerRaid.db.char.currentConsumableType, PowerRaid.db.char.currentSpecTab, false)
        PowerRaidGUI:ReloadCurrentTab()
    end)
    spacer:AddChild(addConsumeDropdown)

    container:AddChild(spacer)

    local scrollsContainer = AceGUI:Create("SimpleGroup")
    scrollsContainer:SetFullWidth(true)
    scrollsContainer:SetLayout("Flow")

    local leftScrollContainer = AceGUI:Create("SimpleGroup")
    leftScrollContainer:SetWidth(375)
    leftScrollContainer:SetHeight(300)
    leftScrollContainer:SetLayout("Fill")

    local leftScroll = AceGUI:Create("ScrollFrame")
    leftScroll:SetLayout("Flow")
    leftScrollContainer:AddChild(leftScroll)

    leftScroll:AddChild(DrawCurrentClassTab())
    scrollsContainer:AddChild(leftScrollContainer)

    local spacerLabel = AceGUI:Create("Label")
    spacerLabel:SetWidth(10)
    spacerLabel:SetText("")
    scrollsContainer:AddChild(spacerLabel)

    local rightScrollContainer = AceGUI:Create("SimpleGroup")
    rightScrollContainer:SetWidth(375)
    rightScrollContainer:SetHeight(300)
    rightScrollContainer:SetLayout("Fill")

    local rightScroll = AceGUI:Create("ScrollFrame")
    rightScroll:SetLayout("Flow")
    rightScrollContainer:AddChild(rightScroll)

    rightScroll:AddChild(DrawCurrentClassConsumables())
    scrollsContainer:AddChild(rightScrollContainer)

    container:AddChild(scrollsContainer)
    
    local bottomNote = AceGUI:Create("Label")
    bottomNote:SetFullWidth(true)
    bottomNote:SetText(L["Everyone in the raid needs the addon to be shown here."])
    container:AddChild(bottomNote)
end
