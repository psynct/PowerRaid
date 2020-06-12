local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")

function CreateBuffsTab(tabId, buffsData)
    local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

    local BuffsTab = {}

    function BuffsTab:shouldCheckBuff(buffName)
        local shouldCheck = PowerRaid.db.char.buffsToCheckFor[buffName]
        return shouldCheck and (buffsData[buffName]["faction"] == nil or buffsData[buffName]["faction"] == PowerRaid.faction)
    end

    function BuffsTab:ScanBuffs()
        local buffStatuses = {}
        for i = 1, MAX_RAID_MEMBERS do
            local tempPlayerName, _, subgroup, _, _, englishClass, _, online = GetRaidRosterInfo(i)
            if tempPlayerName ~= nil and englishClass ~= nil then
                local playerName, _ = UnitName(tempPlayerName)
                for buffName, buffData in buffsData:opairs() do
                    if buffStatuses[buffName] == nil then buffStatuses[buffName] = {} end
                    if BuffsTab:shouldCheckBuff(buffName) and online then
                        local filtered = false
                        if PowerRaid.db.char.smartBuffFiltering then
                            for _, classToFilter in pairs(buffData["excludedClasses"]) do
                                if classToFilter == englishClass then
                                    filtered = true
                                    break
                                end
                            end
                        end
                        if filtered then
                            buffStatuses[buffName][playerName] = 0
                        else
                            buffStatuses[buffName][playerName] = -subgroup
                            for _, buffId in pairs(buffData["alts"]) do
                                local hasBuff = CheckUnitForBuff(playerName, buffId)
                                if hasBuff then
                                    buffStatuses[buffName][playerName] = subgroup
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        return buffStatuses
    end

    function BuffsTab:DrawBuffsRaidFrames(buffStatuses)
        local subgroups = {}
        for i = 1, NUM_RAID_GROUPS do
            subgroups[i] = {}
        end
        for i = 1, MAX_RAID_MEMBERS do
            local tempPlayerName, _, subgroup, _, _, englishClass, _, online = GetRaidRosterInfo(i)
            if tempPlayerName ~= nil and englishClass ~= nil then
                local playerName, _ = UnitName(tempPlayerName)
                local icons = {}
                for buffName, buffData in buffsData:opairs() do
                    if buffStatuses[buffName][playerName] ~= nil then
                        local iconPath
                        local iconOpacity = 0.2
                        if buffStatuses[buffName][playerName] == 0 then
                            iconPath = "Interface\\Icons\\spell_chargenegative"
                            iconOpacity = 0.5
                        else
                            iconPath = buffData["icon"]
                            if buffStatuses[buffName][playerName] > 0 then
                                iconOpacity = 1
                            end
                        end
                        table.insert(icons, {
                            ["path"] = iconPath,
                            ["opacity"] = iconOpacity
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

    function BuffsTab:outputWhisperReport(channel, buffToPlayersListForWhisper)
        local intro = format("[%s] %s: ", L["Power Raid"],
                format(L["reportMissingWhisper"], PowerRaidGUI.tabIdsToTabNames[tabId]))
        local myName, _ = UnitName("player")
        for i = 1, MAX_RAID_MEMBERS do
            local tempPlayerName, _, _, _, _, englishClass, _, online = GetRaidRosterInfo(i)
            if tempPlayerName ~= nil and englishClass ~= nil then
                local playerName, _ = UnitName(tempPlayerName)
                if playerName ~= myName and online and PowerRaid.db.char.groupAssignments[tabId][playerName] then
                    local playerGroupAssignments = PowerRaid.db.char.groupAssignments[tabId][playerName]
                    local reportList = {}
                    for buffName, raidGroups in pairs(buffToPlayersListForWhisper) do
                        if buffsData[buffName]["castingClass"] == englishClass then
                            for raidGroup, playersWithBuffAndGroup in pairs(raidGroups) do
                                if playerGroupAssignments[raidGroup] then
                                    for _, playerWithBuffAndGroup in pairs(playersWithBuffAndGroup) do
                                        table.insert(reportList, playerWithBuffAndGroup)
                                    end
                                end
                            end
                        end
                    end
                    if #reportList > 0 then
                        local lines = GetOutputLinesFromList(intro, reportList)
                        if #lines > 0 then
                            OutputLinesWithChannel(lines, channel, playerName)
                        end
                    end
                end
            end
        end
    end

    function BuffsTab:outputReport(channel, reportType)
        local buffStatuses = BuffsTab:ScanBuffs()
        local intro = format("[%s] %s: ", L["Power Raid"],
                format(L["reportOutputting"], GetReportTypes(tabId, tabName)[reportType]))
        local knownPlayers = {}

        local playersMissingAll = {}
        local playersMissingAny = {}
        local buffToPlayersMissingList = {}
        local buffToPlayersMissingListForWhisper = {}

        local playersHaveAll = {}
        local playersHaveAny = {}
        local buffToPlayersHaveList = {}

        for buffName, _ in pairs(buffsData) do
            if BuffsTab:shouldCheckBuff(buffName) and buffStatuses[buffName] then
                for player, _ in pairs(buffStatuses[buffName]) do
                    knownPlayers[player] = true
                    playersMissingAll[player] = true
                    playersHaveAll[player] = true
                end
            end
        end

        for buffName, buffData in buffsData:opairs() do
            if BuffsTab:shouldCheckBuff(buffName) and buffStatuses[buffName] then
                for player, status in pairs(buffStatuses[buffName]) do
                    if status < 0 then
                        playersMissingAny[player] = true
                        playersHaveAll[player] = false
                        if buffToPlayersMissingList[buffData['short']] == nil then
                            buffToPlayersMissingList[buffData['short']] = {}
                        end
                        table.insert(buffToPlayersMissingList[buffData['short']], player .. " [" .. abs(status) .. "]")
                        if buffToPlayersMissingListForWhisper[buffName] == nil then
                            buffToPlayersMissingListForWhisper[buffName] = {}
                        end
                        if buffToPlayersMissingListForWhisper[buffName][abs(status)] == nil then
                            buffToPlayersMissingListForWhisper[buffName][abs(status)] = {}
                        end
                        table.insert(buffToPlayersMissingListForWhisper[buffName][abs(status)], player .. " [" .. buffData['short'] .. "][" .. abs(status) .. "]")
                    elseif status > 0 then
                        playersHaveAny[player] = true
                        playersMissingAll[player] = false
                        if buffToPlayersHaveList[buffData['short']] == nil then
                            buffToPlayersHaveList[buffData['short']] = {}
                        end
                        table.insert(buffToPlayersHaveList[buffData['short']], player .. " [" .. abs(status) .. "]")
                    end
                end
            end
        end

        local playersMissingAllList = ConvertTruthyDictToList(playersMissingAll)
        local playersMissingAnyList = ConvertTruthyDictToList(playersMissingAny)
        local playersHaveAllList = ConvertTruthyDictToList(playersHaveAll)
        local playersHaveAnyList = ConvertTruthyDictToList(playersHaveAny)

        if channel == "WHISPER" then
            if reportType == "missing_each" then
                BuffsTab:outputWhisperReport(channel, buffToPlayersMissingListForWhisper)
            end
        else
            local showUnknown = PowerRaid.db.char.reportUnknownPlayers[tabId]
            if reportType == "missing_all" then
                OutputPlayersList(channel, intro, playersMissingAllList, knownPlayers, showUnknown)
            elseif reportType == "missing_any" then
                OutputPlayersList(channel, intro, playersMissingAnyList, knownPlayers, showUnknown)
            elseif reportType == "missing_each" then
                OutputItemToPlayers(channel, intro, buffToPlayersMissingList, knownPlayers, showUnknown)
            elseif reportType == "has_all" then
                OutputPlayersList(channel, intro, playersHaveAllList, knownPlayers, showUnknown)
            elseif reportType == "has_any" then
                OutputPlayersList(channel, intro, playersHaveAnyList, knownPlayers, showUnknown)
            elseif reportType == "has_each" then
                OutputItemToPlayers(channel, intro, buffToPlayersHaveList, knownPlayers, showUnknown)
            end
        end
    end

    function BuffsTab:DrawBuffs(container)
        local checkBoxContainer = AceGUI:Create("InlineGroup")
        checkBoxContainer:SetTitle(format(L["checkForTabTitle"], tabName))
        checkBoxContainer:SetFullWidth(true)
        checkBoxContainer:SetLayout("Flow")

        local spacerGroup = AceGUI:Create("Label")
        spacerGroup:SetWidth(30)
        checkBoxContainer:AddChild(spacerGroup)

        local castingClasses = {}
        local buffsCheckBoxes = {}
        for buffName, buffData in buffsData:opairs() do
            if buffData["castingClass"] ~= nil then
                castingClasses[buffData["castingClass"]] = true
            end
            if buffData["faction"] == nil or buffData["faction"] == PowerRaid.faction then
                local buffCheckbox = AceGUI:Create("CheckBox")
                buffCheckbox:SetWidth(buffData["label"] == "" and 65 or 100)
                buffCheckbox:SetLabel(buffData["label"])
                buffCheckbox:SetValue(PowerRaid.db.char.buffsToCheckFor[buffName])
                buffCheckbox:SetImage(buffData["icon"])
                buffCheckbox:SetCallback("OnValueChanged", function()
                    PowerRaid.db.char.buffsToCheckFor[buffName] = buffCheckbox:GetValue()
                end)
                buffCheckbox:SetCallback("OnEnter", function()
                    if(buffData['toolTip'] == nil) then
                        buffData['toolTip'] = CreateFrame("GameTooltip", buffName .. "checkbox" , nil, "GameTooltipTemplate")
                    end
                    buffData['toolTip']:SetOwner(buffCheckbox.frame, "ANCHOR_CURSOR")
                    if buffData["hideSpellTooltip"] then
                        buffData['toolTip']:SetText(table.concat(buffData["names"], "\n"))
                    else
                        buffData['toolTip']:SetSpellByID(buffData['alts'][1])
                    end
                    buffData['toolTip']:Show()
                end)
                buffCheckbox:SetCallback("OnLeave", function()
                    buffData['toolTip']:Hide()
                end)
                table.insert(buffsCheckBoxes, buffCheckbox)
            end
        end
        checkBoxContainer:AddChildren(unpack(buffsCheckBoxes))

        container:AddChild(checkBoxContainer)

        container:AddChild(ScanReportRowRenderer:Render(tabId, nil, function()
            PowerRaidGUI:ReloadCurrentTab()
        end, function()
            BuffsTab:outputReport(PowerRaid.db.char.currentReportOutputChannels[tabId], PowerRaid.db.char.currentReportOutputTypes[tabId])
            PowerRaidGUI:ReloadCurrentTab()
        end, castingClasses))

        container:AddChild(BuffsTab:DrawBuffsRaidFrames(BuffsTab:ScanBuffs()))
    end

    return BuffsTab
end
