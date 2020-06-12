local SettingsTab =  {}
_G["SettingsTab"] = SettingsTab

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")

local json = LibStub("json")
local base64 = LibStub("base64")

SettingsTab.playerVersions = {}

local tabId = PowerRaidGUI.SettingsTabId
local tabName = PowerRaidGUI.tabIdsToTabNames[tabId]

function SettingsTab:ImportSettings(encodedString)
    local pcallResult, err = pcall(function()
        local result = json.decode(PowerRaid.LibDeflate:DecompressDeflate(base64.decode(encodedString)))
        if result then
            for k, v in pairs(result) do
                if PowerRaid.db.char[k] ~= nil then
                    PowerRaid.db.char[k] = v
                end
            end
            PowerRaidGUI:SelectTab(PowerRaid.db.char.currentTab)
        end
    end)
    if not pcallResult then
        print(format("|cFFFF0000%s|r", L["importFailed"]))
        print(err)
    end
end

function SettingsTab:GetImportDialog()
    if importDialogFrame then
        return importDialogFrame
    end
    importDialogFrame = AceGUI:Create("Frame")
    importDialogFrame:SetWidth(500)
    importDialogFrame:SetHeight(550)
    importDialogFrame:SetTitle(L["Import Power Raid Settings"])
    importDialogFrame:EnableResize(false)

    local editBox = AceGUI:Create("MultiLineEditBox")
    editBox:SetLabel(L["Paste settings below:"])
    editBox:SetText("")
    editBox:SetFullWidth(true)
    editBox:SetNumLines(30)
    editBox:SetMaxLetters(0)
    editBox:DisableButton(true)

    importDialogFrame.editBox = editBox
    importDialogFrame:AddChild(editBox)

    local importBtn = AceGUI:Create("Button")
    importBtn:SetText(L["Import Settings String"])
    importBtn:SetFullWidth(true)
    importBtn:SetCallback("OnClick", function()
        SettingsTab:ImportSettings(editBox:GetText())
        importDialogFrame:Hide()
    end)

    importDialogFrame:AddChild(importBtn)

    return importDialogFrame;
end

function SettingsTab:DrawSettings(container)
    local settingsContainer = AceGUI:Create("InlineGroup")
    settingsContainer:SetTitle(L["Settings:"])
    settingsContainer:SetFullWidth(true)
    settingsContainer:SetLayout("Flow")
    container:AddChild(settingsContainer)

    local smartBuffFilteringOption = AceGUI:Create("CheckBox")
    smartBuffFilteringOption:SetValue(PowerRaid.db.char.smartBuffFiltering)
    smartBuffFilteringOption:SetLabel(L["Smart Buff Filtering"])
    smartBuffFilteringOption:SetCallback("OnValueChanged", function()
        PowerRaid.db.char.smartBuffFiltering = smartBuffFilteringOption:GetValue()
    end)
    settingsContainer:AddChild(smartBuffFilteringOption)

    local minimapIconCheckbox = AceGUI:Create("CheckBox")
    minimapIconCheckbox:SetValue(not PowerRaid.db.factionrealm.minimapButton.hide)
    minimapIconCheckbox:SetLabel(L["Show Minimap Icon"])
    minimapIconCheckbox:SetCallback("OnValueChanged", function()
        PowerRaid.db.factionrealm.minimapButton.hide = not minimapIconCheckbox:GetValue()
        if PowerRaid.db.factionrealm.minimapButton.hide then
            LibStub("LibDBIcon-1.0"):Hide("PowerRaid")
        else
            LibStub("LibDBIcon-1.0"):Show("PowerRaid")
        end
    end)
    settingsContainer:AddChild(minimapIconCheckbox)

    local exportSettingsBtn = AceGUI:Create("Button")
    exportSettingsBtn:SetText(L["Export Power Raid Settings"])
    exportSettingsBtn:SetWidth(170)
    exportSettingsBtn:SetCallback("OnClick", function()
        local pcallResult, err = pcall(function()
            local jsonEncode = base64.encode(PowerRaid.LibDeflate:CompressDeflate(json.encode(PowerRaid.db.char)))
            if jsonEncode then
                local dialog = GetExportDialog();
                dialog:SetTitle(L["Export Power Raid Settings"])
                dialog.editBox:SetText(jsonEncode)
                dialog:Show()
                dialog.editBox:SetFocus()
                dialog.editBox:HighlightText()
            end
        end)
        if not pcallResult then
            print(err)
            print(format("|cFFFF0000%s|r", L["exportFailed"]))
        end
    end)
    settingsContainer:AddChild(exportSettingsBtn)

    local importSettingsBtn = AceGUI:Create("Button")
    importSettingsBtn:SetText(L["Import Power Raid Settings"])
    importSettingsBtn:SetWidth(170)
    importSettingsBtn:SetCallback("OnClick", function()
        local dialog = SettingsTab:GetImportDialog();
        dialog.editBox:SetText("")
        dialog:Show()
        dialog.editBox:SetFocus()
    end)
    settingsContainer:AddChild(importSettingsBtn)

    local scanOrReportActive = PowerRaid.tabsScanActive[tabId] or PowerRaid.tabsReportActive[tabId]

    local scanBtn = AceGUI:Create("Button")
    scanBtn:SetText(scanOrReportActive and L["loading"] or L["Scan for versions"])
    scanBtn:SetDisabled(scanOrReportActive)
    scanBtn:SetWidth(400)
    if not (IsInGroup() or IsInRaid()) then
        scanBtn:SetDisabled(true)
        scanBtn:SetText(L["Can't scan, not in a group"])
    end
    scanBtn:SetCallback("OnClick", function()
        SettingsTab.playerVersions = {}
        PowerRaid.tabsScanActive[tabId] = true
        PowerRaid:ScanVersion()
        PowerRaidGUI:ReloadCurrentTab()
        PR_wait(10, function()
            if PowerRaid.tabsScanActive[tabId] or PowerRaid.tabsReportActive[tabId] then
                PowerRaid.tabsScanActive[tabId] = false
                PowerRaid.tabsReportActive[tabId] = false
                if PowerRaid.db.char.currentTab == tabId then
                    PowerRaidGUI:ReloadCurrentTab()
                end
            end
        end, tabId .. "_timeout")
    end)
    container:AddChild(scanBtn)

    local raidContainer = AceGUI:Create("SimpleGroup")
    raidContainer:SetFullWidth(true)
    raidContainer:SetLayout("Flow")

    local ColumnContainers = {}
    for i = 1, 4 do
        local containerCol = AceGUI:Create("SimpleGroup")
        containerCol:SetWidth(195)
        containerCol:SetLayout("Flow")
        table.insert(ColumnContainers, containerCol)
    end

    for i = 1, MAX_RAID_MEMBERS do
        local playerContainer = AceGUI:Create("SimpleGroup")
        playerContainer:SetLayout("Flow")
        playerContainer:SetFullWidth(true)

        local tempPlayerName, _, _, _, class, englishClass, _, online = GetRaidRosterInfo(i)
        if tempPlayerName ~= nil and class ~= nil then
            local currPlayerName, _ = UnitName(tempPlayerName)
            local curr_name = AceGUI:Create("Label")
            curr_name:SetText("|c" .. RAID_CLASS_COLORS[englishClass].colorStr .. currPlayerName .. "|r")
            curr_name:SetWidth(130)
            curr_name:SetHeight(14)

            local status = AceGUI:Create("Label")
            if not online then
                status:SetText(format("|cff6a6a6a%s|r", L["OFFLINE"]))
            elseif SettingsTab.playerVersions[currPlayerName] == nil then
                status:SetText(format("|cffff0000%s|r", L["MISSING"]))
            elseif SettingsTab.playerVersions[currPlayerName] == PowerRaid.version then
                status:SetText("|cff00b300" .. SettingsTab.playerVersions[currPlayerName] .. "|r")
            else
                status:SetText("|cffffff00" .. SettingsTab.playerVersions[currPlayerName] .. "|r")
            end
            status:SetWidth(60)
            status:SetHeight(14)
            playerContainer:AddChildren(curr_name, status)
        else
            local curr_name = AceGUI:Create("Label")
            curr_name:SetText(" ")
            curr_name:SetHeight(14)
            playerContainer:AddChild(curr_name)
        end
        ColumnContainers[((i - 1) % 4) + 1]:AddChild(playerContainer)
    end

    raidContainer:AddChildren(unpack(ColumnContainers))
    container:AddChild(raidContainer)
end
