local L = LibStub("AceLocale-3.0"):NewLocale("PowerRaid", "enUS", true, true);
L = L or {}
L["Power Raid"] = true
L["PowerRaid"] = true
L["optionsDesc"] = "You can type /%s %s to open main Power Raid window."
L["Open Power Raid"] = true
L["Open the main Power Raid window."] = true
L["Left Click"] = true
L["Show GUI"] = true
L["loading"] = "Loading . . ."
L["Can't scan, not in a group"] = true
L["Can't report, not in a group"] = true
L["scanForTab"] = "Scan for %s" -- %s=tab
L["reportForTab"] = "Report %s" -- %s=tab
L["checkForTabTitle"] = "Check for these %s:" -- %s=tab
L["Everyone in the raid needs the addon to be shown here."] = true
L["Spec"] = true
L["Class"] = true
L["Unknown Spec"] = true

-- Console
L["pr"] = true
L["window"] = true
L["report"] = true
L["windowConsole"] = "Open/close Power Raid window."
L["reportConsole"] = "Scan and report tab. Choose a tab to see which channels and report types are available."
L["reportConsoleExample"] = "/%s %s (%s) (channel) (report_type)"
L["invalidTab"] = "|cFFFF0000Invalid tab!|r Valid tabs: %s"
L["invalidChannel"] = "|cFFFF0000Invalid channel!|r Valid channels: %s"
L["invalidReportType"] = "|cFFFF0000Invalid report type!|r Valid report types: %s"

-- Report Channels
L["Say"] = true
L["Party"] = true
L["Guild"] = true
L["Officer"] = true
L["Raid"] = true
L["BG"] = true
L["Whisper"] = true
L["Export"] = true

-- Tabs
L["Raid Buffs"] = true
L["World Buffs"] = true
L["Paladin Buffs"] = true
L["Raid Items"] = true
L["Consumables"] = true
L["Talents"] = true
L["Settings"] = true

-- Consumables Tab
L["Choose Item or Buff and Class to Check for:"] = true
L["Item"] = true
L["Items"] = true
L["Buff"] = true
L["Buffs"] = true
L["scanForConsumesSpec"] = "Scan %s" -- %s=spec
L["addRemoveForSpec"] = "Add/remove for %s" -- %s=spec
L["addToSpec"] = "Add to %s:" -- %s=spec
L["removeFromSpec"] = "Remove from %s:" -- %s=spec
L["specConsumables"] = "%s Consumables:" -- %s=spec
L["Clear Selected"] = true
L["Lesser"] = true
L["lesserDescription"] = "Allow lesser potions/items/buffs to count in place of greater ones.\nExample: Fire Protection Potion item count/buff will count towards Greater Fire Protection Potion"

-- Talents Tab
L["specClass"] = "Spec Class:"
L["specName"] = "Spec Name:"
L["specAddEditBoxLabel"] = "Spec Data (classic.wowhead.com/talent-calc):"
L["talentDeleteLabel"] = "Select talent to delete:"

-- Settings Tab
L["Settings:"] = true
L["Smart Buff Filtering"] = true
L["Show Minimap Icon"] = true
L["Export Power Raid Settings"] = true
L["Import Power Raid Settings"] = true
L["Scan for versions"] = true
L["MISSING"] = true
L["OFFLINE"] = true
L["exportFailed"] = "EXPORT FAILED! Your Power Raid settings are corrupted and cannot be exported."
L["importFailed"] = "IMPORT FAILED! Invalid settings data for Power Raid."
L["Copy text below:"] = true
L["Paste settings below:"] = true
L["Import Settings String"] = true

-- Reporting
L["Report Settings"] = true
L["%s Assignments"] = true -- %s=tab
L["This will scan before reporting!"] = true
L["Channel"] = true
L["Type"] = true
L["reportOutputting"] = "Outputting %s" -- %s=report type
L["reportMissingWhisper"] = "%s missing that you are assigned" -- %s=tab
L["Unknown"] = true
L["Raid Report"] = true
L["Example"] = true
L["reportExampleRaidGroupDesc"] = "The [NUMBER] indicates the raid group that the player is in"
L["reportExamplePlayer"] = "Player%d" -- %d=1-4
L["assignmentsDialogDesc"] = "This is where %s assignments can be set. When choosing the \"Whisper\" report channel, only the players with group assignments will be whispered. The whisper will contain a list of players that are missing the %s that the whispered player is assigned." -- %s=tab
L["showUnknownLabel"] = "Report Players With Unknown Status"
L["showUnknownDesc"] = "A player will have an unknown status if they don't have the addon installed or an error has occurred"

-- Report Dialog
L["ReportDialogSettingsTitle"] = "%s Report Settings" -- %s=tab
L["ReportDialogSettingsTypeLabel"] = "The report type for %s" -- %s=tab
L["ReportDialogSettingsChannelLabel"] = "The report channel for %s" -- %s=tab

-- Report Types
L["missing_all"] = "|cFFFF0000Players Missing All|r %s" -- %s=tab
L["missing_any"] = "|cFFFF7F00Players Missing One or More|r %s" -- %s=tab
L["missing_each"] = "%s that |cFFFF0000Each Player is Missing|r" -- %s=tab
L["has_all"] = "|cFF40FF40Players Having All|r %s" -- %s=tab
L["has_any"] = "|cFFFFC400Players Having One or More|r %s" -- %s=tab
L["has_each"] = "%s that |cFF40FF40Each Player Has|r" -- %s=tab
L["invalid"] = "Players with |cFFFF0000Invalid|r %s" -- %s=tab
L["valid"] = "Players with |cFF40FF40Valid|r %s" -- %s=tab

-- Buffs Short
L["Fort"] = true
L["Spirit"] = true
L["MoTW"] = true
L["Int"] = true
L["ShadowProt"] = true
L["Kings"] = true
L["Might"] = true
L["Wisdom"] = true
L["Salvation"] = true
L["Sanctuary"] = true
L["Light"] = true

-- World Buffs Short
L["Ony/Nef"] = true
L["Songflower"] = true
L["Rend"] = true
L["DMF"] = true
L["DMT"] = true
L["ZG"] = true
L["UBRS"] = true

-- Raid Items Short
L["Quint"] = true
L["Ony Key"] = true
L["Ony Cloak"] = true
L["Equipped"] = true -- ex: Ony Cloak (Equipped)
L["UBRS Key"] = true
L["Sand"] = true

-- Specs Short
L["All Classes"] = true
L["Ele"] = true
L["Enh"] = true
L["Feral DPS"] = true
L["Moonkin"] = true
L["Feral Tank"] = true
L["Healing"] = true
L["Holy"] = true
L["Prot"] = true
L["Resto"] = true
L["Ret"] = true
L["Shadow"] = true
L["DPS"] = true

-- Bosses
L["General"] = true
L["PVP"] = true
L["Azuregos"] = true
L["Lord Kazzak"] = true
L["Emeriss"] = true
L["Lethon"] = true
L["Taerar"] = true
L["Ysondre"] = true
L["Lucifron"] = true
L["Magmadar"] = true
L["Gehennas"] = true
L["Garr"] = true
L["Shazzrah"] = true
L["Baron Geddon"] = true
L["Golemagg the Incinerator"] = true
L["Sulfuron Harbinger"] = true
L["Majordomo Executus"] = true
L["Ragnaros"] = true
L["Razorgore the Untamed"] = true
L["Vaelastrasz the Corrupt"] = true
L["Broodlord Lashlayer"] = true
L["Firemaw"] = true
L["Ebonroc"] = true
L["Flamegor"] = true
L["Chromaggus"] = true
L["Nefarian"] = true
