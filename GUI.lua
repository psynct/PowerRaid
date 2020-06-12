local GUI = {}
_G["PowerRaidGUI"] = GUI
_G["PowerRaidGUI_Shown"] = false
local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid");

LibStub("AceHook-3.0"):Embed(GUI)

local frame = nil
local tabGroup = nil

GUI.RaidBuffsTabId = "raid_buffs"
GUI.WorldBuffsTabId = "world_buffs"
GUI.PaladinBuffsTabId = "paladin_buffs"
GUI.RaidItemsTabId = "raid_items"
GUI.ConsumablesTabId = "consumables"
GUI.TalentsTabId = "talents"
GUI.SettingsTabId = "settings"

GUI.tabIdsToTabNames = {
    [GUI.RaidBuffsTabId] = L["Raid Buffs"],
    [GUI.WorldBuffsTabId] = L["World Buffs"],
    [GUI.PaladinBuffsTabId] = L["Paladin Buffs"],
    [GUI.RaidItemsTabId] = L["Raid Items"],
    [GUI.ConsumablesTabId] = L["Consumables"],
    [GUI.TalentsTabId] = L["Talents"],
    [GUI.SettingsTabId] = L["Settings"],
}

function GUI:ReloadCurrentTab()
    if PowerRaidGUI_Shown then
        tabGroup:SelectTab(PowerRaid.db.char.currentTab)
    end
end

function GUI:Toggle()
    if(frame and frame:IsShown()) then
        PowerRaidGUI_Shown = false
        frame:Hide()
    else
        if not frame then
            GUI:SetUpGUI()
        else
            tabGroup:SelectTab(PowerRaid.db.char.currentTab)
        end
        PowerRaidGUI_Shown = true
        frame:Show()
    end
end

function GUI:GetReportSettingsDialog(tabId)
    local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

    if not reportSettingsDialogFrame then
        reportSettingsDialogFrame = AceGUI:Create("Frame")
        _G["PowerRaidGUI_reportSettingsDialogFrame"] = reportSettingsDialogFrame
        reportSettingsDialogFrame:Hide()
        reportSettingsDialogFrame:SetWidth(500)
        reportSettingsDialogFrame:SetHeight(300)
        reportSettingsDialogFrame:EnableResize(false)
        reportSettingsDialogFrame:SetLayout("Fill")
        tinsert(UISpecialFrames, "PowerRaidGUI_reportSettingsDialogFrame")

        local reportDialogGroup = AceGUI:Create("SimpleGroup")
        reportDialogGroup:SetFullWidth(true)
        reportDialogGroup:SetFullHeight(true)
        reportDialogGroup:SetLayout("List")
        reportSettingsDialogFrame:AddChild(reportDialogGroup)

        local reportTypeDropdown = AceGUI:Create("Dropdown")
        reportTypeDropdown:SetWidth(250)
        reportSettingsDialogFrame.reportTypeDropdown = reportTypeDropdown
        reportDialogGroup:AddChild(reportTypeDropdown)

        local reportDropdown = AceGUI:Create("Dropdown")
        reportDropdown:SetWidth(250)
        reportSettingsDialogFrame.reportDropdown = reportDropdown
        reportDialogGroup:AddChild(reportDropdown)

        local showUnknownCheckbox = AceGUI:Create("CheckBox")
        showUnknownCheckbox:SetLabel(L["showUnknownLabel"])
        showUnknownCheckbox:SetFullWidth(true)
        reportSettingsDialogFrame.showUnknownCheckbox = showUnknownCheckbox
        reportDialogGroup:AddChild(showUnknownCheckbox)

        local showUnknownDescLabel = AceGUI:Create("Label")
        showUnknownDescLabel:SetText(L["showUnknownDesc"])
        showUnknownDescLabel:SetFullWidth(true)
        reportDialogGroup:AddChild(showUnknownDescLabel)

        local reportExample = AceGUI:Create("Label")
        reportExample:SetFullWidth(true)
        reportExample:SetHeight(150)
        reportSettingsDialogFrame.reportExample = reportExample
        reportDialogGroup:AddChild(reportExample)
    end
    reportSettingsDialogFrame:SetTitle(format(L["ReportDialogSettingsTitle"], tabName))

    local function UpdateReportExampleText()
        reportSettingsDialogFrame.reportExample:SetText(GetReportTypeExample(tabId,
                PowerRaid.db.char.currentReportOutputTypes[tabId],
                PowerRaid.db.char.currentReportOutputChannels[tabId],
                PowerRaid.db.char.reportUnknownPlayers[tabId]))
    end

    local reportType = PowerRaid.db.char.currentReportOutputTypes[tabId]
    reportSettingsDialogFrame.reportTypeDropdown:SetLabel(format(L["ReportDialogSettingsTypeLabel"], tabName))
    reportSettingsDialogFrame.reportTypeDropdown:SetList(GetReportTypes(tabId, tabName), GetReportTypesOrder(tabId))
    reportSettingsDialogFrame.reportTypeDropdown:SetValue(reportType)
    reportSettingsDialogFrame.reportTypeDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        PowerRaid.db.char.currentReportOutputTypes[tabId] = key
        UpdateReportExampleText()
    end)

    local reportChannel = PowerRaid.db.char.currentReportOutputChannels[tabId]
    reportSettingsDialogFrame.reportDropdown:SetLabel(format(L["ReportDialogSettingsChannelLabel"], tabName))
    reportSettingsDialogFrame.reportDropdown:SetList(GetChatChannels(tabId))
    reportSettingsDialogFrame.reportDropdown:SetValue(reportChannel)
    reportSettingsDialogFrame.reportDropdown:SetCallback("OnValueChanged", function(widget, event, key)
        PowerRaid.db.char.currentReportOutputChannels[tabId] = key
        UpdateReportExampleText()
    end)

    local reportUnknownPlayers = PowerRaid.db.char.reportUnknownPlayers[tabId]
    reportSettingsDialogFrame.showUnknownCheckbox:SetValue(reportUnknownPlayers)
    reportSettingsDialogFrame.showUnknownCheckbox:SetCallback("OnValueChanged", function()
        PowerRaid.db.char.reportUnknownPlayers[tabId] = reportSettingsDialogFrame.showUnknownCheckbox:GetValue()
        UpdateReportExampleText()
    end)

    reportSettingsDialogFrame.reportExample:SetText(GetReportTypeExample(tabId, reportType, reportChannel, reportUnknownPlayers))

    return reportSettingsDialogFrame;
end

local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    PowerRaid.db.char.currentTab = group
    if group == GUI.SettingsTabId then
        SettingsTab:DrawSettings(container)
    elseif group == GUI.RaidBuffsTabId then
        RaidBuffsTab:DrawBuffs(container)
    elseif group == GUI.WorldBuffsTabId then
        WorldBuffsTab:DrawBuffs(container)
    elseif group == GUI.RaidItemsTabId then
        RaidItemsTab:DrawRaidItems(container)
    elseif group == GUI.TalentsTabId then
        TalentsTab:DrawTalents(container)
    elseif group == GUI.ConsumablesTabId then
        ConsumablesTab:DrawConsumables(container)
    elseif group == GUI.PaladinBuffsTabId then
        PaladinBuffsTab:DrawBuffs(container)
    end
end

function GUI:SelectTab(tab)
    tabGroup:SelectTab(tab)
end

function GUI:SetUpGUI()
    frame = AceGUI:Create("Frame")
    _G["PowerRaidGUI_frame"] = frame
    frame:Hide()
    frame:EnableResize(false)
    frame:SetWidth(840)
    frame:SetTitle("Power Raid")
    local specName = GetLocalizedSpecName(PowerRaid.thisPlayerSpec)
    if not specName then
        specName = L["Unknown Spec"]
    end
    frame:SetStatusText(format("v%s  %s: %s  %s: %s",
            PowerRaid.version,
            L["Spec"], specName,
            L["Class"], PowerRaid.allClasses[PowerRaid.thisPlayerClass]))
    tinsert(UISpecialFrames, "PowerRaidGUI_frame")
    frame:SetLayout("Fill")
    tabGroup = AceGUI:Create("TabGroup")
    local tabIds = {GUI.RaidBuffsTabId, GUI.WorldBuffsTabId, GUI.RaidItemsTabId, GUI.ConsumablesTabId, GUI.TalentsTabId, GUI.SettingsTabId}
    if PowerRaid.faction == "Alliance" then
        table.insert(tabIds, 3, GUI.PaladinBuffsTabId)
    end
    local tabs = {}
    for _, tabId in pairs(tabIds) do
        table.insert(tabs, {value = tabId, text = GUI.tabIdsToTabNames[tabId]})
    end
    tabGroup:SetTabs(tabs)
    tabGroup:SetCallback("OnGroupSelected", SelectGroup)
    tabGroup:SelectTab(PowerRaid.db.char.currentTab)
    frame:AddChild(tabGroup)
end
