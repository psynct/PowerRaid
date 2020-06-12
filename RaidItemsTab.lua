local RaidItemsTab =  {}
_G["RaidItemsTab"] = RaidItemsTab

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")
local ordered_table = LibStub("ordered_table")

RaidItemsTab.raidItems = ordered_table.create()
RaidItemsTab.raidItems["22754"] = {
    ["itemIds"] = {"22754", "17333"},
    ["short"] = L["Quint"],
    ["label"] = "",
    ["icon"] = nil,
    ["hasThisItem"] = {},
    ["requireEquip"] = false,
    ["toolTip"] = nil
}
RaidItemsTab.raidItems["16309"] = {
    ["itemIds"] = {"16309"},
    ["short"] = L["Ony Key"],
    ["label"] = "",
    ["icon"] = nil,
    ["hasThisItem"] = {},
    ["requireEquip"] = false,
    ["toolTip"] = nil
}
RaidItemsTab.raidItems["15138"] = {
    ["itemIds"] = {"15138"},
    ["short"] = L["Ony Cloak"],
    ["label"] = "",
    ["icon"] = nil,
    ["hasThisItem"] = {},
    ["requireEquip"] = false,
    ["toolTip"] = nil
}
RaidItemsTab.raidItems["15138_equip"] = {
    ["itemIds"] = {"15138"},
    ["short"] = format("%s (%s)", L["Ony Cloak"], L["Equipped"]),
    ["label"] = L["Equipped"],
    ["icon"] = "Interface\\Icons\\inv_misc_head_dragon_01",
    ["hasThisItem"] = {},
    ["requireEquip"] = true,
    ["toolTip"] = nil
}
RaidItemsTab.raidItems["12344"] = {
    ["itemIds"] = {"12344"},
    ["short"] = L["UBRS Key"],
    ["label"] = "",
    ["icon"] = nil,
    ["hasThisItem"] = {},
    ["requireEquip"] = false,
    ["toolTip"] = nil
}
RaidItemsTab.raidItems["19183"] = {
    ["itemIds"] = {"19183"},
    ["short"] = L["Sand"],
    ["label"] = "",
    ["icon"] = nil,
    ["hasThisItem"] = {},
    ["requireEquip"] = false,
    ["toolTip"] = nil
}

for _, raidItemData in pairs(RaidItemsTab.raidItems) do
    if raidItemData["icon"] == nil then
        raidItemData["icon"] = GetItemIcon(raidItemData["itemIds"][1])
    end
end

local tabId = PowerRaidGUI.RaidItemsTabId
local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

local function DrawRaidItemsRaidFrames()
    local subgroups = {}
    for i = 1, NUM_RAID_GROUPS do
        subgroups[i] = {}
    end
    for i = 1, MAX_RAID_MEMBERS do
        local tempPlayerName, _, subgroup, _, class, englishClass, _, online = GetRaidRosterInfo(i)
        if tempPlayerName ~= nil and class ~= nil then
            local playerName, _ = UnitName(tempPlayerName)
            local icons = {}
            for item, itemData in RaidItemsTab.raidItems:opairs() do
                if PowerRaid.db.char.raidItemsToCheckFor[item] then
                    local opacity = 0.2
                    if itemData["hasThisItem"][playerName] then
                        opacity = 1
                    end
                    table.insert(icons, {
                        ["path"] = itemData["icon"],
                        ["opacity"] = opacity
                    })
                end
            end
            table.insert(subgroups[subgroup], {
                ["name"] = playerName,
                ["class"] = englishClass,
                ["icons"] = icons,
                ["online"] = online,
            })
        end
    end

    return RaidFramesRenderer:Render(subgroups, 14, false)
end

function RaidItemsTab:ScanRaidItems(reportAfterScan)
    local items = {}
    for item, itemData in pairs(RaidItemsTab.raidItems) do
        if PowerRaid.db.char.raidItemsToCheckFor[item] then
            table.insert(items, item)
        end
    end
    if #items > 0 then
        for _, itemData in pairs(RaidItemsTab.raidItems) do
            itemData['hasThisItem'] = {}
        end
        PowerRaid.tabsScanActive[tabId] = true
        if reportAfterScan then
            PowerRaid.tabsReportActive[tabId] = true
        end
        PowerRaid:ScanForItems(table.concat(items, ","))
    end
end

function RaidItemsTab:outputReport()
    local channel = PowerRaid.db.char.currentReportOutputChannels[tabId]
    local reportType = PowerRaid.db.char.currentReportOutputTypes[tabId]

    local intro = format("[%s] %s: ", L["Power Raid"],
            format(L["reportOutputting"], GetReportTypes(tabId, tabName)[reportType]))
    local knownPlayers = {}

    local playersMissingAll = {}
    local playersMissingAny = {}
    local itemToPlayersMissingList = {}

    local playersHaveAll = {}
    local playersHaveAny = {}
    local itemToPlayersHaveList = {}

    for item, raidItemData in RaidItemsTab.raidItems:opairs() do
        if PowerRaid.db.char.raidItemsToCheckFor[item] and raidItemData['hasThisItem'] then
            for player, _ in pairs(raidItemData['hasThisItem']) do
                knownPlayers[player] = true
                playersMissingAll[player] = true
                playersHaveAll[player] = true
            end
        end
    end

    for item, raidItemData in RaidItemsTab.raidItems:opairs() do
        if PowerRaid.db.char.raidItemsToCheckFor[item] and raidItemData['hasThisItem'] then
            for player, status in pairs(raidItemData['hasThisItem']) do
                if status then
                    playersHaveAny[player] = true
                    playersMissingAll[player] = false
                    if itemToPlayersHaveList[raidItemData['short']] == nil then
                        itemToPlayersHaveList[raidItemData['short']] = {}
                    end
                    table.insert(itemToPlayersHaveList[raidItemData['short']], player)
                else
                    playersMissingAny[player] = true
                    playersHaveAll[player] = false
                    if itemToPlayersMissingList[raidItemData['short']] == nil then
                        itemToPlayersMissingList[raidItemData['short']] = {}
                    end
                    table.insert(itemToPlayersMissingList[raidItemData['short']], player)
                end
            end
        end
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
        OutputItemToPlayers(channel, intro, itemToPlayersMissingList, knownPlayers, showUnknown)
    elseif reportType == "has_all" then
        OutputPlayersList(channel, intro, playersHaveAllList, knownPlayers, showUnknown)
    elseif reportType == "has_any" then
        OutputPlayersList(channel, intro, playersHaveAnyList, knownPlayers, showUnknown)
    elseif reportType == "has_each" then
        OutputItemToPlayers(channel, intro, itemToPlayersHaveList, knownPlayers, showUnknown)
    end
end

function RaidItemsTab:DrawRaidItems(container)
    local checkBoxContainer = AceGUI:Create("InlineGroup")
    checkBoxContainer:SetTitle(format(L["checkForTabTitle"], tabName))
    checkBoxContainer:SetFullWidth(true)

    checkBoxContainer:SetLayout("Flow")

    local spacerGroup = AceGUI:Create("Label")
    spacerGroup:SetWidth(10)
    checkBoxContainer:AddChild(spacerGroup)

    local raidItemsCheckBoxes = {}
    for item, itemData in RaidItemsTab.raidItems:opairs() do
        local itemCheckbox = AceGUI:Create("CheckBox")
        itemCheckbox:SetWidth(itemData["label"] == "" and 65 or 100)
        itemCheckbox:SetLabel(itemData["label"])
        itemCheckbox:SetValue(PowerRaid.db.char.raidItemsToCheckFor[item])
        itemCheckbox:SetImage(itemData["icon"])
        itemCheckbox:SetCallback("OnValueChanged", function()
            PowerRaid.db.char.raidItemsToCheckFor[item] = itemCheckbox:GetValue()
        end)
        itemCheckbox:SetCallback("OnEnter", function()
            if(itemData['toolTip'] == nil) then
                itemData['toolTip'] = CreateFrame("GameTooltip", item .. "checkbox" , nil, "GameTooltipTemplate")
            end
            itemData['toolTip']:SetOwner(itemCheckbox.frame, "ANCHOR_CURSOR")
            itemData['toolTip']:SetItemByID(itemData['itemIds'][1])
            itemData['toolTip']:Show()
        end)
        itemCheckbox:SetCallback("OnLeave", function()
            itemData['toolTip']:Hide()
        end)
        table.insert(raidItemsCheckBoxes, itemCheckbox)
    end
    checkBoxContainer:AddChildren(unpack(raidItemsCheckBoxes))

    container:AddChild(checkBoxContainer)

    container:AddChild(ScanReportRowRenderer:Render(tabId, nil, function()
        RaidItemsTab:ScanRaidItems(false)
        PowerRaidGUI:ReloadCurrentTab()
    end, function()
        RaidItemsTab:ScanRaidItems(true)
        PowerRaidGUI:ReloadCurrentTab()
    end))

    container:AddChild(DrawRaidItemsRaidFrames())

    container:DoLayout()
end
