local TalentsTab =  {}
_G["TalentsTab"] = TalentsTab

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")

TalentsTab.currentTalents = {}

local tabId = PowerRaidGUI.TalentsTabId
local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

local function DrawTalentsRaidFrames()
    local subgroups = {}
    for i = 1, NUM_RAID_GROUPS do
        subgroups[i] = {}
    end
    for i = 1, MAX_RAID_MEMBERS do
        local tempPlayerName, _, subgroup, _, class, englishClass, _, online = GetRaidRosterInfo(i)
        if tempPlayerName ~= nil and class ~= nil then
            local playerName, _ = UnitName(tempPlayerName)
            local talentsStatus = 0
            if TalentsTab.currentTalents[playerName] then
                for _, talentData in pairs(PowerRaid.db.char.validTalents[englishClass]) do
                    if TalentsTab.currentTalents[playerName]["talents"] == talentData["talents"] then
                        talentsStatus = 1
                        break
                    else
                        talentsStatus = -1
                    end
                end
            end
            local iconPath = "Interface\\Icons\\"
            local iconOpacity = 1
            if talentsStatus == 0 then
                iconPath = iconPath .. "inv_misc_questionmark"
                iconOpacity = 0.2
            elseif talentsStatus < 0 then
                iconPath = iconPath .. "spell_chargenegative"
            else
                iconPath = iconPath .. "spell_chargepositive"
            end
            table.insert(subgroups[subgroup], {
                ["name"] = playerName,
                ["class"] = englishClass,
                ["icons"] = { {["path"] = iconPath, ["opacity"] = iconOpacity} },
                ["online"] = online,
            })
        end
    end

    return RaidFramesRenderer:Render(subgroups, 14, false)
end

function TalentsTab:outputReport()
    local channel = PowerRaid.db.char.currentReportOutputChannels[tabId]
    local reportType = PowerRaid.db.char.currentReportOutputTypes[tabId]

    local intro = format("[%s] %s: ", L["Power Raid"],
            format(L["reportOutputting"], GetReportTypes(tabId, tabName)[reportType]))
    local knownPlayers = {}

    local playersWithInvalidTalents = {}
    local playersWithValidTalents = {}

    for player, playerTalentsData in pairs(TalentsTab.currentTalents) do
        knownPlayers[player] = true
        local validTalentsForClass = PowerRaid.db.char.validTalents[playerTalentsData["englishClass"]]
        local foundCorrectTalents = false
        local numValidTalents = 0
        for _, talentsData in pairs(validTalentsForClass) do
            numValidTalents = numValidTalents + 1
            if playerTalentsData["talents"] == talentsData["talents"] then
                foundCorrectTalents = true
                break
            end
        end
        if numValidTalents > 0 then
            if foundCorrectTalents then
                table.insert(playersWithValidTalents, player)
            else
                table.insert(playersWithInvalidTalents, player)
            end
        end
    end

    local showUnknown = PowerRaid.db.char.reportUnknownPlayers[tabId]
    if reportType == "invalid" then
        OutputPlayersList(channel, intro, playersWithInvalidTalents, knownPlayers, showUnknown)
    elseif reportType == "valid" then
        OutputPlayersList(channel, intro, playersWithValidTalents, knownPlayers, showUnknown)
    end
end

function TalentsTab:DrawTalents(container)
    local topTitleGroup = AceGUI:Create("SimpleGroup")
    topTitleGroup:SetFullWidth(true)
    topTitleGroup:SetLayout("Flow")

    local classDropdown = AceGUI:Create("Dropdown")
    classDropdown:SetLabel(L["specClass"])
    classDropdown:SetWidth(100)
    classDropdown:SetList(PowerRaid.allClasses)
    classDropdown:SetValue(PowerRaid.db.char.currentTalentsClass)
    classDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        PowerRaid.db.char.currentTalentsClass = key
    end)
    topTitleGroup:AddChild(classDropdown)

    local specNameEditBox = AceGUI:Create("EditBox")
    specNameEditBox:SetLabel(L["specName"])
    specNameEditBox:SetWidth(100)
    specNameEditBox:DisableButton(true)
    topTitleGroup:AddChild(specNameEditBox)

    local specDataEditBox = AceGUI:Create("EditBox")
    specDataEditBox:SetLabel(L["specAddEditBoxLabel"])
    specDataEditBox:SetWidth(250)
    specDataEditBox:DisableButton(true)
    topTitleGroup:AddChild(specDataEditBox)

    local addSpecBtn = AceGUI:Create("Button")
    addSpecBtn:SetText("Add Spec")
    addSpecBtn:SetWidth(100)
    addSpecBtn:SetCallback("OnClick", function()
        local talents = specDataEditBox:GetText()
        local talentTab1 = string.gmatch(talents, "[0-9]+")
        local talentTab2 = string.gmatch(talents, "-([0-9]+)-")
        local talentTab3 = string.gmatch(talents, "-([0-9]+)$")
        local talentTabs = {talentTab1(), talentTab2(), talentTab3()}
        local talentCounts = {}
        for tabIndex = 1,3 do
            local count = 0
            if talentTabs[tabIndex] then
                for c in string.gmatch(talentTabs[tabIndex],".") do
                    count = count + tonumber(c)
                end
            end
            table.insert(talentCounts, count)
        end
        local shortTalents = table.concat(talentCounts, "/")
        local talentsName = specNameEditBox:GetText()
        PowerRaid.db.char.validTalents[PowerRaid.db.char.currentTalentsClass][talentsName] = {
            ["name"] = talentsName,
            ["talents"] = talents,
            ["shortTalents"] = shortTalents,
        }
        specNameEditBox:SetText("")
        specDataEditBox:SetText("")
        PowerRaidGUI:ReloadCurrentTab()
    end)
    topTitleGroup:AddChild(addSpecBtn)

    local validTalentsDropdown = AceGUI:Create("Dropdown")
    validTalentsDropdown:SetLabel(L["talentDeleteLabel"])
    validTalentsDropdown:SetWidth(200)
    local talentsDropdownItems = {}
    for class, validTalentsForClass in pairs(PowerRaid.db.char.validTalents) do
        for _, talentsData in pairs(validTalentsForClass) do
            talentsDropdownItems[class .. ":" .. talentsData["name"]] = format("%s : %s : %s", PowerRaid.allClasses[class], talentsData["name"], talentsData["shortTalents"])
        end
    end
    validTalentsDropdown:SetList(talentsDropdownItems)
    validTalentsDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        if key then
            local tokens = splitString(key, ":")
            local class = tokens[1]
            local name = tokens[2]
            if class and name then
                PowerRaid.db.char.validTalents[class] = removeKeyFromTable(PowerRaid.db.char.validTalents[class], name)
                PowerRaidGUI:ReloadCurrentTab()
            end
        end
    end)
    topTitleGroup:AddChild(validTalentsDropdown)

    container:AddChild(topTitleGroup)

    container:AddChild(ScanReportRowRenderer:Render(tabId, nil, function()
        TalentsTab.currentTalents = {}
        PowerRaid.tabsScanActive[tabId] = true
        PowerRaid:QuestionTalents()
        PowerRaidGUI:ReloadCurrentTab()
    end, function()
        TalentsTab.currentTalents = {}
        PowerRaid.tabsScanActive[tabId] = true
        PowerRaid.tabsReportActive[tabId] = true
        PowerRaid:QuestionTalents()
        PowerRaidGUI:ReloadCurrentTab()
    end))

    container:AddChild(DrawTalentsRaidFrames())
end
