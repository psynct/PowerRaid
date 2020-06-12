local RaidFramesRenderer =  {}
_G["RaidFramesRenderer"] = RaidFramesRenderer

RaidFramesRenderer.EMPTY_RAID_POSITION = "EMPTY_RAID_POSITION"

local AceGUI = LibStub("AceGUI-3.0")

function RaidFramesRenderer:Render(subgroups, iconSize, showIconsOffline)
    -- fill out empty positions
    for i = 1, NUM_RAID_GROUPS do
        while #subgroups[i] < 5 do
            table.insert(subgroups[i], RaidFramesRenderer.EMPTY_RAID_POSITION)
        end
    end

    local raidContainer = AceGUI:Create("SimpleGroup")
    raidContainer:SetFullWidth(true)
    raidContainer:SetLayout("Flow")

    local groupContainers = {}
    for subgroupIndex, subgroup in pairs(subgroups) do
        local groupContainer = AceGUI:Create("InlineGroup")
        groupContainer:SetTitle("Group " .. subgroupIndex .. ":")
        groupContainer:SetLayout("List")
        groupContainer:SetWidth(195)

        local playerContainers = {}
        for groupIndex, playerData in pairs(subgroup) do
            local playerContainer = AceGUI:Create("SimpleGroup")
            playerContainer:SetLayout("Flow")
            playerContainer:SetFullWidth(true)
            if playerData ~= RaidFramesRenderer.EMPTY_RAID_POSITION then
                local nameLabel = AceGUI:Create("Label")
                nameLabel:SetText("|c" .. RAID_CLASS_COLORS[playerData["class"]].colorStr .. playerData["name"] .. "|r")

                local icons = {}
                if playerData["online"] or showIconsOffline then
                    for _, iconData in pairs(playerData["icons"]) do
                        local icon = AceGUI:Create("Icon")
                        icon:SetImage(iconData["path"])
                        icon.image:SetVertexColor(1, 1, 1, iconData["opacity"])
                        icon:SetImageSize(iconSize, iconSize)
                        icon.image:SetAllPoints()
                        icon:SetWidth(iconSize)
                        icon:SetHeight(iconSize)
                        icon:SetCallback("OnEnter", iconData["OnEnter"])
                        icon:SetCallback("OnLeave", iconData["OnLeave"])
                        table.insert(icons, icon)
                    end
                end

                if #icons > 0 then
                    nameLabel:SetWidth(170 - iconSize * #icons - 1)
                    nameLabel:SetHeight(iconSize)
                    nameLabel:SetPoint("LEFT")

                    local iconsContainer = AceGUI:Create("SimpleGroup")
                    iconsContainer:SetLayout("Flow")
                    iconsContainer:SetWidth(iconSize * #icons + 1)
                    iconsContainer:SetHeight(iconSize)
                    iconsContainer:SetPoint("RIGHT")

                    iconsContainer:AddChildren(unpack(icons))
                    playerContainer:AddChildren(nameLabel, iconsContainer)
                else
                    nameLabel:SetWidth(170)
                    nameLabel:SetHeight(iconSize + 2)
                    nameLabel:SetPoint("LEFT")

                    playerContainer:AddChildren(nameLabel)
                end
            else
                local nameLabel = AceGUI:Create("Label")
                nameLabel:SetText(" ")
                nameLabel:SetHeight(iconSize + 2)

                playerContainer:AddChild(nameLabel)
            end
            table.insert(playerContainers, playerContainer)
        end
        groupContainer:AddChildren(unpack(playerContainers))
        table.insert(groupContainers, groupContainer)
    end
    raidContainer:AddChildren(unpack(groupContainers))
    return raidContainer
end
