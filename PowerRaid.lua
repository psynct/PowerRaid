PowerRaid = LibStub("AceAddon-3.0"):NewAddon("PowerRaid", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
_G["PowerRaid"] = PowerRaid

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid");

PowerRaid:RegisterChatCommand(L["pr"], "ChatCommand")

PowerRaid.LibDeflate = LibStub("LibDeflate")

local questionVersionPrefix = "PR_ss"
local sendVersionPrefix = "PR_sr"
local questionItemsPrefix = "PR_qi"
local sendItemsPrefix = "PR_si"
local consumableQuestionItemsPrefix = "PR_cqi"
local consumableSendItemsPrefix = "PR_csi"
local consumableQuestionBuffsPrefix = "PR_cqb"
local consumableSendBuffsPrefix = "PR_csb"
local questionTalentsPrefix = "PR_qt"
local sendTalentsPrefix = "PR_st"

local version = GetAddOnMetadata("PowerRaid", "Version")
PowerRaid.version = version

local name, _ = UnitName("player")
local _, thisPlayerClass, _ = UnitClass("player")
PowerRaid.thisPlayerClass = thisPlayerClass
local faction, _ = UnitFactionGroup("player")
PowerRaid.faction = faction
PowerRaid.thisPlayerSpec = "Unknown Spec"

PowerRaid.allClasses = FillLocalizedClassList({})

PowerRaid.tabsScanActive = {}
PowerRaid.tabsReportActive = {}

PowerRaid.CHAT_PREFIX = format("|cff29921b[%s]|r ", L["PowerRaid"])

function PowerRaid:ScanVersion()
    SettingsTab.playerVersions[name] = version
    PowerRaid:SendMessage(version, questionVersionPrefix)
end

function PowerRaid:OnInitialize()
    local consumablesToCheckFor = {}
    for boss, _ in pairs(ConsumablesTab:getBosses()) do
        consumablesToCheckFor[boss] = {}
        for spec, _ in pairs(ConsumablesTab:getSpecs()) do
            consumablesToCheckFor[boss][spec] = {
                ["ITEM"] = {},
                ["BUFF"] = {}
            }
        end
    end

    local validTalents = {}
    for englishClass, _ in pairs(PowerRaid.allClasses) do
        validTalents[englishClass] = {}
    end

    local defaultReportOutputChannels = {}
    for tabId, _ in pairs(PowerRaidGUI.tabIdsToTabNames) do
        defaultReportOutputChannels[tabId] = "RAID"
    end

    local defaultReportOutputTypes = {}
    for tabId, _ in pairs(PowerRaidGUI.tabIdsToTabNames) do
        if tabId ~= PowerRaidGUI.TalentsTabId then
            defaultReportOutputTypes[tabId] = "missing_each"
        end
    end
    defaultReportOutputTypes[PowerRaidGUI.WorldBuffsTabId] = "missing_all"
    defaultReportOutputTypes[PowerRaidGUI.TalentsTabId] = "invalid"

    local defaultGroupAssignments = {}
    for tabId, _ in pairs(PowerRaidGUI.tabIdsToTabNames) do
        defaultGroupAssignments[tabId] = {}
    end

    local defaultReportUnknownPlayers = {}
    for tabId, _ in pairs(PowerRaidGUI.tabIdsToTabNames) do
        defaultReportUnknownPlayers[tabId] = false
    end

    self.db = LibStub("AceDB-3.0"):New("PowerRaid3DB", {
        factionrealm = {
            minimapButton = {hide = false}
        },
        char = {
            buffsToCheckFor = {},
            raidItemsToCheckFor = {},
            consumablesToCheckFor = consumablesToCheckFor,
            validTalents = validTalents,
            currentReportOutputChannels = defaultReportOutputChannels,
            currentReportOutputTypes = defaultReportOutputTypes,
            reportUnknownPlayers = defaultReportUnknownPlayers,
            groupAssignments = defaultGroupAssignments,
            smartBuffFiltering = true,
            currentTab = PowerRaidGUI.RaidBuffsTabId,
            currentSpecTab = "All Classes",
            currentConsumableType = "ITEM",
            consumablesLesserEnabled = true,
            currentBoss = "General",
            currentTalentsClass = "DRUID",
            consumesForSpecs = PowerRaidData.DefaultConsumesForSpecs,
        }
    }, true)

    self:RegisterComm(questionVersionPrefix, "OnQuestionVersion")
    self:RegisterComm(sendVersionPrefix, "OnSendVersion")
    self:RegisterComm(questionItemsPrefix, "OnQuestionItems")
    self:RegisterComm(sendItemsPrefix, "OnSendItems")
    self:RegisterComm(consumableQuestionItemsPrefix, "OnConsumableQuestionItems")
    self:RegisterComm(consumableSendItemsPrefix, "OnConsumableSendItems")
    self:RegisterComm(consumableQuestionBuffsPrefix, "OnConsumableQuestionBuffs")
    self:RegisterComm(consumableSendBuffsPrefix, "OnConsumableSendBuffs")
    self:RegisterComm(questionTalentsPrefix, "OnQuestionTalents")
    self:RegisterComm(sendTalentsPrefix, "OnSendTalents")
    
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent", function(self)
        PowerRaid.thisPlayerSpec = determineSpec(PowerRaid.thisPlayerClass)
    end)

    _G["RaidBuffsTab"] = CreateBuffsTab(PowerRaidGUI.RaidBuffsTabId, PowerRaidData.RaidBuffs)
    _G["WorldBuffsTab"] = CreateBuffsTab(PowerRaidGUI.WorldBuffsTabId, PowerRaidData.WorldBuffs)
    _G["PaladinBuffsTab"] = CreateBuffsTab(PowerRaidGUI.PaladinBuffsTabId, PowerRaidData.PaladinBuffs)

    PowerRaid:SetUpMinimapIcon()

    local options = {
        name = format("%s v%s", L["Power Raid"], PowerRaid.version),
        type = "group",
        args = {
            desc = {
                type = "description",
                name = "|CffDEDE42" .. format(L["optionsDesc"], L["pr"], L["window"]),
                fontSize = "medium",
                order = 1,
            },
            openPowerRaid = {
                type = "execute",
                name = L["Open Power Raid"],
                desc = L["Open the main Power Raid window."],
                func = (function()
                    PowerRaidGUI:Toggle()
                end),
                order = 2,
                width = 1.7,
            },
        }
    }
    LibStub("AceConfig-3.0"):RegisterOptionsTable("PowerRaid", options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PowerRaid", L["Power Raid"]);
end

function PowerRaid:IsValidChannelAndReportTypeForTabId(tabId, channel, reportType)
    local _, channels = GetChatChannels(tabId)
    local channelValid = false
    for _, chl in pairs(channels) do
        if chl == channel then channelValid = true; break; end
    end
    local reportTypes = GetReportTypesOrder(tabId)
    local reportTypeValid = false
    for _, type in pairs(reportTypes) do
        if type == reportType then reportTypeValid = true; break; end
    end
    if not channelValid then
        print(PowerRaid.CHAT_PREFIX .. format(L["invalidChannel"], table.concat(channels, ", ")))
    end
    if not reportTypeValid then
        print(PowerRaid.CHAT_PREFIX .. format(L["invalidReportType"], table.concat(reportTypes, ", ")))
    end
    if not (channelValid and reportTypeValid) then
        local tabs = {PowerRaidGUI.RaidBuffsTabId, PowerRaidGUI.WorldBuffsTabId, PowerRaidGUI.PaladinBuffsTabId}
        print(PowerRaid.CHAT_PREFIX .. format(L["reportConsoleExample"], L["pr"], L["report"], table.concat(tabs, ", ")))
    end
    return channelValid and reportTypeValid
end

function PowerRaid:ChatCommand(input)
    input = strtrim(input)
    local inputs = splitString(input, " ")
    local tabs = {PowerRaidGUI.RaidBuffsTabId, PowerRaidGUI.WorldBuffsTabId, PowerRaidGUI.PaladinBuffsTabId}
    if inputs[1] == L["window"] then
        PowerRaidGUI:Toggle()
    elseif #inputs >= 2 and inputs[1] == L["report"] then
        if not (IsInGroup() or IsInRaid()) then
            print(PowerRaid.CHAT_PREFIX .. format("|cffff0000%s|r", L["Can't report, not in a group"]))
            return
        end
        local tabId, channel, reportType = inputs[2], inputs[3], inputs[4]
        if tabId == PowerRaidGUI.RaidBuffsTabId then
            if PowerRaid:IsValidChannelAndReportTypeForTabId(tabId, channel, reportType) then
                RaidBuffsTab:outputReport(channel, reportType)
            end
        elseif tabId == PowerRaidGUI.WorldBuffsTabId then
            if PowerRaid:IsValidChannelAndReportTypeForTabId(tabId, channel, reportType) then
                WorldBuffsTab:outputReport(channel, reportType)
            end
        elseif tabId == PowerRaidGUI.PaladinBuffsTabId then
            if PowerRaid:IsValidChannelAndReportTypeForTabId(tabId, channel, reportType) then
                PaladinBuffsTab:outputReport(channel, reportType)
            end
        else
            print(PowerRaid.CHAT_PREFIX .. format(L["invalidTab"], table.concat(tabs, ", ")))
            print(PowerRaid.CHAT_PREFIX .. format(L["reportConsoleExample"], L["pr"], L["report"], table.concat(tabs, ", ")) .. " - " .. L["reportConsole"])
        end
    else
        print(PowerRaid.CHAT_PREFIX .. format("/%s %s - %s", L["pr"], L["window"], L["windowConsole"]))
        print(PowerRaid.CHAT_PREFIX .. format(L["reportConsoleExample"], L["pr"], L["report"], table.concat(tabs, ", ")) .. " - " .. L["reportConsole"])
    end

end

function PowerRaid:SendMessage(msg, prefix, sender)
    msg = PowerRaid.LibDeflate:EncodeForWoWAddonChannel(PowerRaid.LibDeflate:CompressDeflate(msg))
    if sender ~= nil then
        PowerRaid:SendCommMessage(prefix, msg, "WHISPER", sender)
        return
    end
    local instance, instanceType = IsInInstance()
    if instance then
        if instanceType == "raid" then
            PowerRaid:SendCommMessage(prefix, msg, "RAID")
        elseif instanceType == "party" then
            PowerRaid:SendCommMessage(prefix, msg, "PARTY")
        else
            PowerRaid:SendCommMessage(prefix, msg, "INSTANCE_CHAT")
        end
    elseif IsInRaid() then
        PowerRaid:SendCommMessage(prefix, msg, "RAID")
    elseif IsInGroup() then
        PowerRaid:SendCommMessage(prefix, msg, "PARTY")
    end
end

function PowerRaid:ConsumablesQuestion(spec, consumeIds, consumablesLesserEnabled)
    local lesserEnabledString = "0"
    if consumablesLesserEnabled then
        lesserEnabledString = "1"
    end
    PowerRaid:SendMessage(spec .. "--" .. table.concat(consumeIds, ",") .. "--" .. lesserEnabledString, consumableQuestionItemsPrefix)
end

function PowerRaid:QuestionBuffs(spec, consumeIds, consumablesLesserEnabled)
    local lesserEnabledString = "0"
    if consumablesLesserEnabled then
        lesserEnabledString = "1"
    end
    PowerRaid:SendMessage(spec .. "--" .. table.concat(consumeIds, ",") .. "--" .. lesserEnabledString, consumableQuestionBuffsPrefix)
end

function PowerRaid:QuestionTalents()
    PowerRaid:SendMessage("ALL", questionTalentsPrefix)
end

function PowerRaid:OnConsumableQuestionItems(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local tokens = splitString(message, "--")
    local spec = tokens[1]
    local consumeIds = splitString(tokens[2], ",")
    local lesserEnabled = (tokens[3] == "1")
    local consumablesInfo = ConsumablesTab:getConsumablesInfo()
    if spec == PowerRaid.thisPlayerSpec or spec == "All Classes" then
        local sendCounts = {}
        local sendConsumeIds = {}
        for _, consumeId in pairs(consumeIds) do
            if consumablesInfo[consumeId] then
                local itemId = consumablesInfo[consumeId]["itemId"]
                -- check to see if this players spec and the item checking for is in the consumables list, protects against malicious
                local count = GetItemCount(itemId)
                if consumablesInfo[consumeId]["altItemIds"] then
                    for _, altItemId in pairs(consumablesInfo[consumeId]["altItemIds"]) do
                        count = count + GetItemCount(altItemId)
                    end
                end
                -- only do this if consumables lesser option is enabled
                if lesserEnabled and consumablesInfo[consumeId]["lesserItemIds"] then
                    for _, lesserItemId in pairs(consumablesInfo[consumeId]["lesserItemIds"]) do
                        count = count + GetItemCount(lesserItemId)
                    end
                end
                table.insert(sendCounts, count)
                table.insert(sendConsumeIds, consumeId)
            end
        end
        if #sendConsumeIds > 0 and #sendCounts > 0 then
            PowerRaid:SendMessage(table.concat(sendConsumeIds, ",") .. "--" .. table.concat(sendCounts, ",") .. "--" .. spec .. "--" .. PowerRaid.thisPlayerSpec, consumableSendItemsPrefix, sender)
        end
    end
end

function PowerRaid:OnConsumableSendItems(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local specs = ConsumablesTab:getSpecs()
    local tokens = splitString(message, "--")
    local receivedConsumeIds = splitString(tokens[1], ",")
    local counts = splitString(tokens[2], ",")
    for i, count in pairs(counts) do
        counts[i] = tonumber(count)
    end
    local currentSpec = tokens[3]
    local playerSpec = tokens[4]

    if specs[currentSpec] == nil then
        return
    end

    if specs[currentSpec]["currentItems"][sender] == nil then
        specs[currentSpec]["currentItems"][sender] = {}
    end

    for i, receivedConsumeId in pairs(receivedConsumeIds) do
        for _, consumeId in pairs(PowerRaid.db.char.consumesForSpecs[currentSpec]) do
            if receivedConsumeId == consumeId then
                specs[currentSpec]["currentItems"][sender][consumeId] = counts[i]
                break
            end
        end
    end

    if currentSpec == "All Classes" then
        specs[currentSpec]["currentSpecs"][sender] = playerSpec
    end

    PR_wait(1, function()
        if PowerRaid.tabsReportActive[PowerRaidGUI.ConsumablesTabId] then
            PowerRaid.tabsReportActive[PowerRaidGUI.ConsumablesTabId] = false
            ConsumablesTab:outputReport()
        end
        PowerRaid.tabsScanActive[PowerRaidGUI.ConsumablesTabId] = false
        if PowerRaid.db.char.currentTab == PowerRaidGUI.ConsumablesTabId then
            PowerRaidGUI:ReloadCurrentTab()
        end
    end, PowerRaidGUI.ConsumablesTabId)
end

function PowerRaid:OnConsumableQuestionBuffs(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local tokens = splitString(message, "--")
    local spec = tokens[1]
    local consumeIds = splitString(tokens[2], ",")
    local lesserEnabled = (tokens[3] == "1")
    local consumablesInfo = ConsumablesTab:getConsumablesInfo()
    if spec == PowerRaid.thisPlayerSpec or spec == "All Classes" then
        local sendExpirationTimes = {}
        local sendConsumeIds = {}
        for _, consumeId in pairs(consumeIds) do
            if consumablesInfo[consumeId] then
                local buffId = consumablesInfo[consumeId]["buffId"]
                -- check to see if this players spec and the item checking for is in the consumables list, protects against malicious
                local hasBuff, duration, expirationTime = CheckUnitForBuff("player", buffId)
                if not hasBuff then
                    expirationTime = 0
                end
                if expirationTime == 0 and consumablesInfo[consumeId]["altBuffIds"] then
                    for _, altBuffId in pairs(consumablesInfo[consumeId]["altBuffIds"]) do
                        hasBuff, duration, expirationTime = CheckUnitForBuff("player", altBuffId)
                        if not hasBuff then
                            expirationTime = 0
                        end
                    end
                end
                -- only do this if consumables lesser option is enabled
                if lesserEnabled and expirationTime == 0 and consumablesInfo[consumeId]["lesserBuffIds"] then
                    for _, lesserBuffId in pairs(consumablesInfo[consumeId]["lesserBuffIds"]) do
                        hasBuff, duration, expirationTime = CheckUnitForBuff("player", lesserBuffId)
                        if not hasBuff then
                            expirationTime = 0
                        end
                    end
                end
                table.insert(sendExpirationTimes, expirationTime)
                table.insert(sendConsumeIds, consumeId)
            end
        end
        if #sendConsumeIds and #sendExpirationTimes then
            PowerRaid:SendMessage(table.concat(sendConsumeIds, ",") .. "--" .. table.concat(sendExpirationTimes, ",") .. "--" .. spec .. "--" .. PowerRaid.thisPlayerSpec, consumableSendBuffsPrefix, sender)
        end
    end
end

function PowerRaid:OnConsumableSendBuffs(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local specs = ConsumablesTab:getSpecs()
    local tokens = splitString(message, "--")
    local receivedConsumeIds = splitString(tokens[1], ",")
    local expirationTimes = splitString(tokens[2], ",")
    for i, expirationTime in pairs(expirationTimes) do
        expirationTimes[i] = tonumber(expirationTime)
    end
    local currentSpec = tokens[3]
    local playerSpec = tokens[4]

    if specs[currentSpec] == nil then
        return
    end

    if specs[currentSpec]["currentBuffs"][sender] == nil then
        specs[currentSpec]["currentBuffs"][sender] = {}
    end

    for i, receivedConsumeId in pairs(receivedConsumeIds) do
        for _, consumeId in pairs(PowerRaid.db.char.consumesForSpecs[currentSpec]) do
            if receivedConsumeId == consumeId then
                specs[currentSpec]["currentBuffs"][sender][consumeId] = expirationTimes[i]
                break
            end
        end
    end

    if currentSpec == "All Classes" then
        specs[currentSpec]["currentSpecs"][sender] = playerSpec
    end
        
    PR_wait(1, function()
        if PowerRaid.tabsReportActive[PowerRaidGUI.ConsumablesTabId] then
            PowerRaid.tabsReportActive[PowerRaidGUI.ConsumablesTabId] = false
            ConsumablesTab:outputReport()
        end
        PowerRaid.tabsScanActive[PowerRaidGUI.ConsumablesTabId] = false
        if PowerRaid.db.char.currentTab == PowerRaidGUI.ConsumablesTabId then
            PowerRaidGUI:ReloadCurrentTab()
        end
    end, PowerRaidGUI.ConsumablesTabId)
end

function PowerRaid:ScanForItems(message)
    PowerRaid:SendMessage(message, questionItemsPrefix)
end

function PowerRaid:OnQuestionItems(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local counts = {}
    local items = splitString(message, ",")
    for i, item in pairs(items) do
        local foundItem = false
        for key, value in pairs(RaidItemsTab.raidItems) do
            if (key == item) then
                for k, v in pairs(value["itemIds"]) do
                    if value["requireEquip"] then
                        if IsEquippedItem(v) then
                            foundItem = true
                        end
                    else
                        local count  = GetItemCount(v)
                        if count > 0 then
                            foundItem = true
                        end
                    end
                end
            end
        end
        if foundItem then
            table.insert(counts, 1)
        else
            table.insert(counts, 0)
        end
    end
    PowerRaid:SendMessage(message .. "--" .. table.concat(counts, ","), sendItemsPrefix, sender)
end

function PowerRaid:OnSendItems(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local tokens = splitString(message, "--")
    local items = splitString(tokens[1], ",")
    local counts = splitString(tokens[2], ",")
    for i, item in pairs(items) do
        for key, value in pairs(RaidItemsTab.raidItems) do
            if key == item then
                value["hasThisItem"][sender] = counts[i] == "1"
                PR_wait(1, function()
                    if PowerRaid.tabsReportActive[PowerRaidGUI.RaidItemsTabId] then
                        PowerRaid.tabsReportActive[PowerRaidGUI.RaidItemsTabId] = false
                        RaidItemsTab:outputReport()
                    end
                    PowerRaid.tabsScanActive[PowerRaidGUI.RaidItemsTabId] = false
                    if PowerRaid.db.char.currentTab == PowerRaidGUI.RaidItemsTabId then
                        PowerRaidGUI:ReloadCurrentTab()
                    end
                end, PowerRaidGUI.RaidItemsTabId)
                break
            end
        end
    end
end

function PowerRaid:OnQuestionTalents(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))
    local _, englishClass, _ = UnitClass("player");
    if message == "ALL" or message == englishClass then
        local talentStrings = {}
        local talentCounts = {}
        for tabIndex = 1,3 do
            local talentTabString = ""
            local talentTabCount = 0
            for talentIndex = 1, GetNumTalents(tabIndex) do
                local _, _, _, _, currentRank = GetTalentInfo(tabIndex, talentIndex);
                talentTabString = talentTabString .. currentRank
                talentTabCount = talentTabCount + currentRank
            end
            talentTabString = talentTabString:gsub("0*$", "")
            table.insert(talentStrings, talentTabString)
            table.insert(talentCounts, talentTabCount)
        end
        local talentString = table.concat(talentStrings, "-")
        local shortTalentString = table.concat(talentCounts, "/")
        talentString = talentString:gsub("-*$", "")
        PowerRaid:SendMessage(englishClass .. "," .. talentString .. "," .. shortTalentString, sendTalentsPrefix, sender)
    end
end

function PowerRaid:OnSendTalents(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    local tokens = splitString(message, ",")
    local englishClass = tokens[1]
    local talents = tokens[2]
    local shortTalents = tokens[2]

    TalentsTab.currentTalents[sender] = {
        ["englishClass"] = englishClass,
        ["talents"] = talents,
        ["shortTalents"] = shortTalents,
    }

    PR_wait(1, function()
        if PowerRaid.tabsReportActive[PowerRaidGUI.TalentsTabId] then
            PowerRaid.tabsReportActive[PowerRaidGUI.TalentsTabId] = false
            TalentsTab:outputReport()
        end
        PowerRaid.tabsScanActive[PowerRaidGUI.TalentsTabId] = false
        if PowerRaid.db.char.currentTab == PowerRaidGUI.TalentsTabId then
            PowerRaidGUI:ReloadCurrentTab()
        end
    end, PowerRaidGUI.TalentsTabId)
end

function PowerRaid:OnQuestionVersion(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    PowerRaid:SendMessage(version, sendVersionPrefix, sender)
end

function PowerRaid:OnSendVersion(prefix, message, distribution, sender)
    message = PowerRaid.LibDeflate:DecompressDeflate(PowerRaid.LibDeflate:DecodeForWoWAddonChannel(message))

    SettingsTab.playerVersions[sender] = message
    
    PR_wait(1, function()
        PowerRaid.tabsReportActive[PowerRaidGUI.SettingsTabId] = false
        PowerRaid.tabsScanActive[PowerRaidGUI.SettingsTabId] = false
        if PowerRaid.db.char.currentTab == PowerRaidGUI.SettingsTabId then
            PowerRaidGUI:ReloadCurrentTab()
        end
    end, PowerRaidGUI.SettingsTabId)
end

function PowerRaid:SetUpMinimapIcon()
	LibStub("LibDBIcon-1.0"):Register("PowerRaid", LibStub("LibDataBroker-1.1"):NewDataObject("PowerRaid",
	{
		type = "data source",
		text = "Power Raid",
		icon = "Interface\\Icons\\ability_creature_disease_02",
		OnClick = function(self, button) 
			if (button == "LeftButton") then
				PowerRaidGUI:Toggle()
            end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddDoubleLine(L["Power Raid"], format("|cff777777v%s", PowerRaid.version));
			tooltip:AddLine(format("|cFFCFCFCF%s:|r %s", L["Left Click"], L["Show GUI"]))
		end
	}), self.db.factionrealm.minimapButton);
end
