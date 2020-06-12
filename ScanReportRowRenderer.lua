local ScanReportRowRenderer =  {}
_G["ScanReportRowRenderer"] = ScanReportRowRenderer

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")

function ScanReportRowRenderer:StartTimeout(tabId)
    PR_wait(10, function()
        if PowerRaid.tabsScanActive[tabId] or PowerRaid.tabsReportActive[tabId] then
            PowerRaid.tabsScanActive[tabId] = false
            PowerRaid.tabsReportActive[tabId] = false
            if PowerRaid.db.char.currentTab == tabId then
                PowerRaidGUI:ReloadCurrentTab()
            end
        end
    end, tabId .. "_timeout")
end

function ScanReportRowRenderer:GetAssignmentsDialog(tabId, classesWithGroupAssignments)
    local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

    if not assignmentsDialogFrame then
        assignmentsDialogFrame = AceGUI:Create("Frame")
        _G["PowerRaidGUI_assignmentsDialogFrame"] = assignmentsDialogFrame
        assignmentsDialogFrame:Hide()
        assignmentsDialogFrame:SetWidth(500)
        assignmentsDialogFrame:SetHeight(300)
        assignmentsDialogFrame:EnableResize(false)
        assignmentsDialogFrame:SetLayout("Fill")
        tinsert(UISpecialFrames, "PowerRaidGUI_assignmentsDialogFrame")

        local scrollContainer = AceGUI:Create("SimpleGroup")
        scrollContainer:SetLayout("Fill")

        local scroll = AceGUI:Create("ScrollFrame")
        scroll:SetLayout("Flow")
        assignmentsDialogFrame.scroll = scroll
        scrollContainer:AddChild(scroll)

        assignmentsDialogFrame:AddChild(scrollContainer)
    end
    assignmentsDialogFrame:SetTitle(format(L["%s Assignments"], tabName))

    assignmentsDialogFrame.scroll:ReleaseChildren()

    local assignmentsLabel = AceGUI:Create("Label")
    assignmentsLabel:SetText(format(L["assignmentsDialogDesc"], tabName, tabName))
    assignmentsLabel:SetFullWidth(true)
    assignmentsDialogFrame.scroll:AddChild(assignmentsLabel)

    local dropdownItems = {}
    for i = 1, NUM_RAID_GROUPS do
        dropdownItems[i] = tostring(i)
    end
    local classToPlayerContainers = {}
    for i = 1, MAX_RAID_MEMBERS do
        local tempPlayerName, _, _, _, class, englishClass = GetRaidRosterInfo(i)
        if tempPlayerName ~= nil and class ~= nil and classesWithGroupAssignments ~= nil and classesWithGroupAssignments[englishClass] then
            if classToPlayerContainers[englishClass] == nil then
                classToPlayerContainers[englishClass] = {}
            end
            local playerName, _ = UnitName(tempPlayerName)

            local playerContainer = AceGUI:Create("SimpleGroup")
            playerContainer:SetLayout("Flow")
            playerContainer:SetFullWidth(true)

            local nameLabel = AceGUI:Create("Label")
            nameLabel:SetText("|c" .. RAID_CLASS_COLORS[englishClass].colorStr ..playerName .. "|r")
            nameLabel:SetWidth(280)
            playerContainer:AddChild(nameLabel)

            local typeDropdown = AceGUI:Create("Dropdown")
            typeDropdown:SetLabel("Groups:")
            typeDropdown:SetWidth(150)
            typeDropdown:SetList(dropdownItems)
            typeDropdown:SetMultiselect(true)
            if PowerRaid.db.char.groupAssignments[tabId][playerName] == nil then
                PowerRaid.db.char.groupAssignments[tabId][playerName] = {}
            end
            for k, v in pairs(PowerRaid.db.char.groupAssignments[tabId][playerName]) do
                typeDropdown:SetItemValue(k, v)
            end
            typeDropdown:SetCallback("OnValueChanged", function(widget, event, key, value)
                PowerRaid.db.char.groupAssignments[tabId][playerName][key] = value
            end)
            playerContainer:AddChild(typeDropdown)

            table.insert(classToPlayerContainers[englishClass], playerContainer)
        end
    end
    for _, playerContainers in pairs(classToPlayerContainers) do
        for _, playerContainer in pairs(playerContainers) do
            assignmentsDialogFrame.scroll:AddChild(playerContainer)
        end
    end

    return assignmentsDialogFrame;
end

function ScanReportRowRenderer:Render(tabId, tabDisplayName, scanCallback, reportCallback, classesWithGroupAssignments)
    local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]
    if tabDisplayName == nil then
        tabDisplayName = tabName
    end

    local spacer = AceGUI:Create("SimpleGroup")
    spacer:SetFullWidth(true)
    spacer:SetLayout("Flow")
    spacer:SetHeight(80)

    local scanOrReportActive = PowerRaid.tabsScanActive[tabId] or PowerRaid.tabsReportActive[tabId]

    local scanBtn = AceGUI:Create("Button")
    scanBtn:SetText(scanOrReportActive and L["loading"] or format(L["scanForTab"], tabName))
    scanBtn:SetDisabled(scanOrReportActive)
    scanBtn:SetWidth(200)
    if not (IsInGroup() or IsInRaid()) then
        scanBtn:SetDisabled(true)
        scanBtn:SetText(L["Can't scan, not in a group"])
    end
    scanBtn:SetCallback("OnClick", function()
        scanCallback()
        ScanReportRowRenderer:StartTimeout(tabId)
    end)
    spacer:AddChild(scanBtn)

    local reportBtn = AceGUI:Create("Button")
    reportBtn:SetText(scanOrReportActive and L["loading"] or format(L["reportForTab"], tabName))
    reportBtn:SetDisabled(scanOrReportActive)
    reportBtn:SetWidth(200)
    if not (IsInGroup() or IsInRaid()) then
        reportBtn:SetDisabled(true)
        reportBtn:SetText(L["Can't report, not in a group"])
    end
    reportBtn:SetCallback("OnClick", function()
        reportCallback()
        ScanReportRowRenderer:StartTimeout(tabId)
    end)
    reportBtn:SetCallback("OnEnter", function()
        if reportBtnTooltip == nil then
            reportBtnTooltip = CreateFrame("GameTooltip", "reportBtn" , nil, "GameTooltipTemplate")
        end
        reportBtnTooltip:SetOwner(reportBtn.frame, "ANCHOR_CURSOR")
        local channel = PowerRaid.db.char.currentReportOutputChannels[tabId]
        local reportType = PowerRaid.db.char.currentReportOutputTypes[tabId]
        reportBtnTooltip:SetText(format("%s\n%s: %s\n%s: %s",
                L["This will scan before reporting!"],
                L["Channel"], GetChatChannels(tabId)[channel],
                L["Type"], GetReportTypes(tabId, tabDisplayName)[reportType]))
        reportBtnTooltip:Show()
    end)
    reportBtn:SetCallback("OnLeave", function()
        reportBtnTooltip:Hide()
    end)
    spacer:AddChild(reportBtn)

    local reportSettingsBtn = AceGUI:Create("Button")
    reportSettingsBtn:SetText(L["Report Settings"])
    reportSettingsBtn:SetWidth(150)
    reportSettingsBtn:SetCallback("OnClick", function()
        local dialog = PowerRaidGUI:GetReportSettingsDialog(tabId)
        dialog:Show()
        dialog.frame:Raise()
    end)
    spacer:AddChild(reportSettingsBtn)

    if tabId == PowerRaidGUI.RaidBuffsTabId or tabId == PowerRaidGUI.PaladinBuffsTabId then
        local assignmentsBtn = AceGUI:Create("Button")
        assignmentsBtn:SetText(format(L["%s Assignments"], tabName))
        assignmentsBtn:SetWidth(230)
        assignmentsBtn:SetCallback("OnClick", function()
            local dialog = ScanReportRowRenderer:GetAssignmentsDialog(tabId, classesWithGroupAssignments)
            dialog:Show()
            dialog.frame:Raise()
        end)
        spacer:AddChild(assignmentsBtn)
    end

    return spacer
end
