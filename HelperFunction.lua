-- local HelperFunction = {}
-- _G["HelperFunction"] = HelperFunction

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PowerRaid")

local specIndexTotal = {
    [1] = 0, 
    [2] = 0, 
    [3] = 0
}
local talents = {}

local classes = FillLocalizedClassList({})

local specToLocalizedName = {
    ["All Classes"] = L["All Classes"],
    ["Shaman (Ele)"] = format("%s (%s)", classes["SHAMAN"], L["Ele"]),
    ["Shaman (Enh)"] = format("%s (%s)", classes["SHAMAN"], L["Enh"]),
    ["Druid (Feral DPS)"] = format("%s (%s)", classes["DRUID"], L["Feral DPS"]),
    ["Druid (Moonkin)"] = format("%s (%s)", classes["DRUID"], L["Moonkin"]),
    ["Druid (Feral Tank)"] = format("%s (%s)", classes["DRUID"], L["Feral Tank"]),
    ["Priest (Healing)"] = format("%s (%s)", classes["PRIEST"], L["Healing"]),
    ["Paladin (Holy)"] = format("%s (%s)", classes["PALADIN"], L["Holy"]),
    ["Hunter"] = classes["HUNTER"],
    ["Mage"] = classes["MAGE"],
    ["Paladin (Prot)"] = format("%s (%s)", classes["PALADIN"], L["Prot"]),
    ["Warrior (Prot)"] = format("%s (%s)", classes["WARRIOR"], L["Prot"]),
    ["Druid (Resto)"] = format("%s (%s)", classes["DRUID"], L["Resto"]),
    ["Shaman (Resto)"] = format("%s (%s)", classes["SHAMAN"], L["Resto"]),
    ["Paladin (Ret)"] = format("%s (%s)", classes["PALADIN"], L["Ret"]),
    ["Rogue"] = classes["ROGUE"],
    ["Priest (Shadow)"] = format("%s (%s)", classes["PRIEST"], L["Shadow"]),
    ["Warlock"] = classes["WARLOCK"],
    ["Warrior (DPS)"] = format("%s (%s)", classes["WARRIOR"], L["DPS"]),
}

local specs = {
    ['PRIEST'] = {
        ['Priest (Healing)'] = {
            ['index'] = {1, 2},
            ['talent'] = nil
        },
        ['Priest (Shadow)'] = {
            ['index'] = {3},
            ['talent'] = nil
        },
    },
    ['PALADIN'] = {
        ['Paladin (Holy)'] = {
            ['index'] = {1},
            ['talent'] = nil
        },
        ['Paladin (Prot)'] = {
            ['index'] = {2},
            ['talent'] = nil
        },
        ['Paladin (Ret)'] = {
            ['index'] = {3},
            ['talent'] = nil
        },
    },
    ['ROGUE'] = "Rogue",
    ['SHAMAN'] = {
        ['Shaman (Enh)'] = {
            ['index'] = {2},
            ['talent'] = nil
        },
        ['Shaman (Ele)'] = {
            ['index'] = {1},
            ['talent'] = nil
        },
        ['Shaman (Resto)'] = {
            ['index'] = {3},
            ['talent'] = nil
        },
    },
    ['HUNTER'] = "Hunter",
    ['MAGE'] = "Mage",
    ['WARLOCK'] = "Warlock",
    ['WARRIOR'] = {
        ['Warrior (Prot)'] = {
            ['index'] = {3},
            ['talent'] = nil
        },
        ['Warrior (DPS)'] = {
            ['index'] = {1, 2},
            ['talent'] = nil
        }
    },
    ['DRUID'] = {
        ['Druid (Resto)'] = {
            ['index'] = {3},
            ['talent'] = {
                {
                    ["talentName"] = "Heart of the Wild",
                    ['talentRank'] = 5
                },
                {
                    ["talentName"] = "Nature's Swiftness",
                    ['talentRank'] = 1
                }
            }
        },
        ['Druid (Moonkin)'] = {
            ['index'] = {1},
            ['talent'] = nil
        },
        ['Druid (Feral Tank)'] = {
            ['index'] = {2},
            ['talent'] = {
                {
                    ["talentName"] = "Primal Fury",
                    ['talentRank'] = 2
                },
            }
        },
        ['Druid (Feral DPS)'] = {
            ['index'] = {2},
            ['talent'] = nil
        }
    }
}

function determineSpec(class)
    if(type(specs[class]) == "string") then
        return specs[class]
    end
    for i = 1, 3 do
        for j = 1, GetNumTalents(i) do
            local name, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(i, j)
            if(currentRank ~= 0) then
                specIndexTotal[i] = specIndexTotal[i] + currentRank
                talents[name] = currentRank
            end
        end
    end

    local maxKey, maxValue = 0, 0
    for k, v in pairs(specIndexTotal) do
        if specIndexTotal[k] > maxValue then
            maxKey, maxValue = k, v
        end
    end
    
    for key, value in pairs(specs[class]) do
        local hasAllTalents = true
        if(value['talent'] ~= nil) then
            for _, talent in pairs(value['talent']) do
                if hasAllTalents then
                    talentName = talent['talentName']
                    talentRank = talent['talentRank']
                    if(talents[talentName] ~= talentRank) then
                        hasAllTalents = false
                    end
                end
            end
            if(hasAllTalents and value['talent'] ~= nil) then
                return key
            end
        end
        if(value['index'] ~= nil) then
            for _, index in pairs(value['index']) do
                if(index == maxKey) then
                    return key
                end
            end
        end
    end

    return "Unknown Spec"
end

function GetLocalizedSpecName(spec)
    return specToLocalizedName[spec]
end

local baseMessages = {
    ["SAY"] = format("|cFFFFFFFF%s|r", L["Say"]),
    ["PARTY"] = format("|cFFAAAAFF%s|r", L["Party"]),
    ["GUILD"] = format("|cFF40FF40%s|r", L["Guild"]),
    ["OFFICER"] = format("|cFF40C040%s|r", L["Officer"]),
    ["RAID"] = format("|cFFFF7F00%s|r", L["Raid"]),
    ["INSTANCE_CHAT"] = format("|cFFFF7F00%s|r", L["BG"]),
    ["WHISPER"] = format("|cFFFF80FF%s|r", L["Whisper"]),
}

local exportChannels = {
    ["EXPORT"] = format("|cFF40C7EB%s|r", L["Export"]),
}

function GetReportTypeExample(tabId, type, channel, showUnknown)
    local shouldShowGroup = tabId == PowerRaidGUI.RaidBuffsTabId or
            tabId == PowerRaidGUI.WorldBuffsTabId or
            tabId == PowerRaidGUI.PaladinBuffsTabId

    local items = {"Thing1", "Thing2"}
    if tabId == PowerRaidGUI.RaidBuffsTabId then
        items = {L["Int"], L["Spirit"]}
    elseif tabId == PowerRaidGUI.WorldBuffsTabId then
        items = {L["ZG"], L["Ony/Nef"]}
    elseif tabId == PowerRaidGUI.PaladinBuffsTabId then
        items = {L["Kings"], L["Might"]}
    elseif tabId == PowerRaidGUI.RaidItemsTabId then
        items = {L["Sand"], L["Ony Cloak"]}
    elseif tabId == PowerRaidGUI.ConsumablesTabId then
        items = {GetItemName(5634), GetItemName(13457)}
    end

    if channel == "WHISPER" then
        local example = format("\n%s:\n%s\n-------------------------\n\n%s",
                L["Example"],
                (shouldShowGroup and format("(%s)", L["reportExampleRaidGroupDesc"]) or ""),
                format("[%s] %s: ", L["Power Raid"], format(L["reportMissingWhisper"], PowerRaidGUI.tabIdsToTabNames[tabId])))
        local players = {}
        for i = 1,4 do
            table.insert(players, format(L["reportExamplePlayer"], i) .. " [" .. items[1] .. "][" .. random(1,8) .. "]")
        end
        return example .. table.concat(players, ", ")
    else
        local example = format("\n%s:\n%s\n-------------------------\n\n%s",
                L["Example"],
                (shouldShowGroup and format("(%s)", L["reportExampleRaidGroupDesc"]) or ""),
                format("[%s] %s: ", L["Power Raid"], format(L["reportOutputting"], GetReportTypes(tabId, PowerRaidGUI.tabIdsToTabNames[tabId])[type])))
        local players = {}
        for i = 1,4 do
            table.insert(players, format(L["reportExamplePlayer"], i))
        end
        if shouldShowGroup then
            for i, player in pairs(players) do
                players[i] = player .. " [" .. random(1,8) .. "]"
            end
        end
        if type == "missing_all" or type == "missing_any" or type == "has_all" or type == "has_any" or type == "invalid" or type == "valid" then
            local allPlayers = table.concat(players, ", ")
            example = example .. allPlayers
        elseif type == "missing_each" or type == "has_each" then
            local players1 = players[1] .. ", " .. players[2]
            local players2 = players[1] .. ", " .. players[3]
            example = format("%s\n%s: %s\n%s: %s", example, items[1], players1, items[2], players2)
        end
        if showUnknown then
            example = format("%s\n%s: %s", example, L["Unknown"], players[4])
        end
        return example
    end
    return ""
end

function GetReportTypesOrder(tabId)
    if tabId == PowerRaidGUI.TalentsTabId then
        return {"invalid", "valid"}
    elseif tabId == PowerRaidGUI.RaidBuffsTabId or tabId == PowerRaidGUI.PaladinBuffsTabId then
        return {"missing_each"}
    else
        return {"has_all", "has_any", "missing_any", "missing_all", "has_each", "missing_each"}
    end
end

function GetReportTypes(tabId, tabDisplayName)
    if tabId == PowerRaidGUI.TalentsTabId then
        return {
            ["invalid"] = format(L["invalid"], tabDisplayName),
            ["valid"] = format(L["valid"], tabDisplayName),
        }
    elseif tabId == PowerRaidGUI.RaidBuffsTabId or tabId == PowerRaidGUI.PaladinBuffsTabId then
        return {
            ["missing_each"] = format(L["missing_each"], tabDisplayName),
        }
    else
        return {
            ["missing_all"] = format(L["missing_all"], tabDisplayName),
            ["missing_any"] = format(L["missing_any"], tabDisplayName),
            ["missing_each"] = format(L["missing_each"], tabDisplayName),
            ["has_all"] = format(L["has_all"], tabDisplayName),
            ["has_any"] = format(L["has_any"], tabDisplayName),
            ["has_each"] = format(L["has_each"], tabDisplayName),
        }
    end
end

function GetChatChannels(tabId)
    local order = {}
    local channels = {}
    for k, v in orderedPairs(baseMessages) do
        if k == "WHISPER" then
            if tabId == PowerRaidGUI.RaidBuffsTabId or tabId == PowerRaidGUI.PaladinBuffsTabId then
                table.insert(order, k)
                channels[k] = v
            end
        else
            table.insert(order, k)
            channels[k] = v
        end
    end

    for k, v in orderedPairs(exportChannels) do
        table.insert(order, k)
        channels[k] = v
    end

    return channels, order
end

function GetExportDialog()
    if exportDialogFrame then
        return exportDialogFrame
    end
    exportDialogFrame = AceGUI:Create("Frame")
    exportDialogFrame:SetWidth(500)
    exportDialogFrame:SetHeight(550)
    exportDialogFrame:SetTitle("")
    exportDialogFrame:EnableResize(false)

    local editBox = AceGUI:Create("MultiLineEditBox")
    editBox:SetLabel(L["Copy text below:"])
    editBox:SetText("")
    editBox:SetFullWidth(true)
    editBox:SetNumLines(30)
    editBox:SetMaxLetters(0)
    editBox:DisableButton(true)

    exportDialogFrame.editBox = editBox
    exportDialogFrame:AddChild(editBox)

    return exportDialogFrame;
end

function PR_SendChatMessage(message, channel, target)
    if channel:find("^EXPORT") == nil then
        if baseMessages[channel] ~= nil then
            SendChatMessage(message, channel, nil, target)
        else
            SendChatMessage(message, "CHANNEL", nil, channel)
        end
    end
end

function ConvertTruthyDictToList(dict)
    local list = {}
    for k, v in orderedPairs(dict) do
        if v then
            table.insert(list, k)
        end
    end
    return list
end

function GetOutputLinesFromList(intro, list, lines)
    if lines == nil then
        lines = {}
    end
    if #list > 0 then
        stringCompose = intro
        for _, item in pairs(list) do
            local stringToAdd = item .. ", "
            if ( string.len(stringCompose) + string.len(stringToAdd) ) >= 255 then
                table.insert(lines, stringCompose:sub(1, -3))
                stringCompose = ""
            end
            stringCompose = stringCompose .. " " .. stringToAdd
        end
        table.insert(lines, stringCompose:sub(1, -3))
    end
    return lines
end

function OutputLinesWithChannel(lines, channel, player)
    if channel:find("^EXPORT") ~= nil then
        local dialogString = ""
        for _, line in pairs(lines) do
            dialogString = dialogString .. line .. "\n"
        end
        local dialog = GetExportDialog();
        dialog:SetTitle(L["Raid Report"])
        dialog.editBox:SetText(dialogString)
        dialog.editBox:SetFocus()
        dialog.editBox:HighlightText()
        dialog:Show()
    else
        for _, line in pairs(lines) do
            local colorStart = "|c"
            for i = 1, 8 do
                colorStart = colorStart .. "[0-9a-fA-F]"
            end
            line = line:gsub(colorStart, "")
            line = line:gsub("|r", "")
            PR_SendChatMessage(line, channel, player)
        end
    end
end

function AddUnknownPlayersLines(knownPlayers, lines)
    local unknownPlayers = {}
    for i = 1, MAX_RAID_MEMBERS do
        local playerName, _, subgroup, _, class, englishClass = GetRaidRosterInfo(i)
        if(playerName ~= nil and class ~= nil) then
            if not knownPlayers[playerName] then
                table.insert(unknownPlayers, playerName)
            end
        end
    end
    if #unknownPlayers > 0 then
        lines = GetOutputLinesFromList(L["Unknown"] .. ": ", unknownPlayers, lines)
    end
    return lines
end

function OutputPlayersList(channel, intro, players, knownPlayers, showUnknown)
    local lines = GetOutputLinesFromList(intro, players)
    if #lines > 0 and showUnknown then
        lines = AddUnknownPlayersLines(knownPlayers, lines)
    end
    if #lines > 0 then
        OutputLinesWithChannel(lines, channel)
    end
end

function OutputItemToPlayers(channel, intro, itemToPlayers, knownPlayers, showUnknown)
    local lines = {intro}
    for item, players in pairs(itemToPlayers) do
        if #players > 0 then
            lines = GetOutputLinesFromList(item .. ": ", players, lines)
        end
    end
    if #lines > 1 and showUnknown then
        lines = AddUnknownPlayersLines(knownPlayers, lines)
    end
    if #lines > 1 then
        OutputLinesWithChannel(lines, channel)
    end
end

function GetClassColorFromEnglishClass(englishClass)
    if RAID_CLASS_COLORS[englishClass] then
        return RAID_CLASS_COLORS[englishClass].colorStr
    end
    return RAID_CLASS_COLORS["PRIEST"].colorStr
end

function CheckUnitForBuff(unit, buffId)
    local buffPos = 1
    while true do
        local buffName, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitAura(unit, buffPos)
        buffPos = buffPos + 1

        if(spellId == nil) then
            return false, nil, nil
        elseif(tostring(spellId) == buffId) then
            return true, duration, expirationTime
        end
    end
end

function GetItemName(itemId)
    local itemName = GetItemInfo(itemId)
    return itemName
end

function splitString(inputstr, sep)
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function removeKeyFromTable(t, k_to_remove)
    local new = {}
    for k, v in pairs(t) do
        if k ~= k_to_remove then
            new[k] = v
        end
    end
    return new
end

local functionIdentifiers = {}

function PR_wait(time, currFunction, identifierString)
    unique = math.random()
    functionIdentifiers[identifierString] = unique

    _PR_wait(time, function(t)
        unique = t[1]
        func = t[2]
        if(functionIdentifiers[identifierString] == unique) then
            func()
        end
    end, {unique, currFunction})
end

local waitTable = {};
local waitFrame = nil;

function _PR_wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end

--[[
Ordered table iterator, allow to iterate on the natural order of the keys of a table.
http://lua-users.org/wiki/SortedIteration
]]
function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end
