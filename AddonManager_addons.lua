local Nyx = LibStub("Nyx")

local AddonManager = _G.AddonManager
local tab_addons = {}

-- Ensure saved variables exist and provide defaults/migration fields
function AddonManager.InitSavedVars()
    AddonManager_Settings = AddonManager_Settings or {}
    AddonManager_UncheckedAddons = AddonManager_UncheckedAddons or {}
    AddonManager_MinimapButtons = AddonManager_MinimapButtons or {}

    if type(AddonManager_Settings.version) ~= "number" then
        AddonManager_Settings.version = 1
    end

    if AddonManager_Settings.ShowSlashCmdInsteadOfCat == nil then
        AddonManager_Settings.ShowSlashCmdInsteadOfCat = false
    end

    if AddonManager_Settings.debug == nil then
        AddonManager_Settings.debug = false
    end
end

AddonManager.InitSavedVars()

AddonManager.tabs = {}
AddonManager.tabs[1]=tab_addons

function AddonManager.GetAddonAtIndex(index)
    -- index is already the calculated position (page * items_per_page + slot)
    -- so we don't need to recalculate it
    if type(index) ~= "number" or index < 1 then
        return nil
    end

    local filter = UIDropDownMenu_GetSelectedID(AddonManagerCategoryFilter) or 1
    if filter == 1 then  -- All
        return AddonManager.Addons[index]
    else
        filter = AddonManager.Categories[filter - 1]
        local count = 0
        for _, addon in pairs(AddonManager.Addons) do
            if addon.category == filter then
                count = count + 1
                if count == index then
                    return addon
                end
            end
        end
    end
end

function tab_addons.GetCount()
    local filter = UIDropDownMenu_GetSelectedID(AddonManagerCategoryFilter)
    if filter == 1 then  -- All
        return #AddonManager.Addons
    else
        filter = AddonManager.Categories[filter - 1]
        local count = 0
        for _, addon in pairs(AddonManager.Addons) do
            if addon.category == filter then
                count = count + 1
            end
        end
        return count
    end
end

function tab_addons.OnShow()
    table.sort(AddonManager.Addons, AddonManager.AddonSortFn)
    AddonManager.UpdateButtons()
    AddonManagerFramePageAddons:Show()
    Nyx.SetVisible(AddonManagerCategoryFilter, true)
end

function tab_addons.OnHide()
    AddonManagerFramePageAddons:Hide()
    Nyx.SetVisible(AddonManagerCategoryFilter, false)
end

function tab_addons.ShowButton(index, basename)
    -- Validate args
    if type(index) ~= "number" or index < 1 then
        return false
    end
    if basename ~= nil and type(basename) ~= "string" then
        basename = tostring(basename)
    end

    -- Get the addon using the filtered index
    local addon = AddonManager.GetAddonAtIndex(index)
    if not addon then 
        -- No addon at this index
        return false
    end

    local catname = AddonManager.L.CAT[addon.category]
    if AddonManager_Settings.ShowSlashCmdInsteadOfCat then
        -- Check both slashCommands (plural) and slashCommand (singular)
        local cmd = addon.slashCommands or addon.slashCommand
        if cmd and cmd ~= "" then
            catname = cmd
        else
            catname = AddonManager.L.NoCommand
        end
    end

    local minibutton= nil
    if addon.miniButton then
        minibutton = AddonManager.ShowAddonInMini(addon.name)==true
    end

    local enablebutton= nil
    if addon.disableScript and addon.enableScript then
        enablebutton = not AddonManager.IsAddonDisabled(addon.name)
    end


    AddonManager.SetButtons(basename, addon.name, catname,
        addon.icon or DEFAULT_ICON, nil,
        minibutton, enablebutton,
        AddonManager.IsActive(addon) )
end

function tab_addons.OnAddonClicked(btn, index)
    if type(index) ~= "number" or index < 1 then return end
    if not btn then return end

    local addon = AddonManager.GetAddonAtIndex(index)
    if not addon then return end

    if addon.onClickScript then
        -- Pass the button frame to the addon's click script
        -- PetInfo is currently the cause of this error
        local success, err = pcall(addon.onClickScript, btn, index)
        if not success then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000AddonManager: Error calling onClickScript for " .. tostring(addon.name) .. ": " .. tostring(err) .. "|r")
        end

    elseif addon.configFrame then
        ToggleUIFrame(addon.configFrame)
        GameTooltip:Hide()
    end
end

function tab_addons.OnAddonEntered(btn, index)
    if type(index) ~= "number" or index < 1 then return end
    if not btn then return end

    local addon = AddonManager.GetAddonAtIndex(index)
    if not addon then return end

    AddonManager.ShowTooltipOfAddon(btn,addon)
end

function tab_addons.OnCheckMiniBtn(index, is_checked)
    if type(index) ~= "number" or index < 1 then return end
    if type(is_checked) ~= "boolean" then is_checked = not not is_checked end

    local addon = AddonManager.GetAddonAtIndex(index)
    if not addon then return end
    if is_checked then
        for i,name in ipairs(AddonManager_UncheckedAddons) do
            if name==addon.name then
                table.remove(AddonManager_UncheckedAddons,i)
                break
            end
        end
    else
        table.insert(AddonManager_UncheckedAddons, addon.name)
    end

    AddonManager.Mini.UpdateState()
end

function tab_addons.OnCheckEnableBtn(index, is_checked)
    if type(index) ~= "number" or index < 1 then return end
    if type(is_checked) ~= "boolean" then is_checked = not not is_checked end

    local addon = AddonManager.GetAddonAtIndex(index)
    if not addon then return end

    if is_checked then
        AddonManager.SetAddonEnabled(addon.name, true)
        if type(addon.enableScript) == "function" then
            addon.enableScript()
        end
    else
        AddonManager.SetAddonEnabled(addon.name, false)
        if type(addon.disableScript) == "function" then
            addon.disableScript()
        end
    end
end

-----------------------------------------
local tab_minimap = {}
AddonManager.tabs[2]=tab_minimap

local FIXED_NAMES={
    ["MinimapFramePlusButton"] = "Minimap Zoom+",
    ["MinimapFrameMinusButton"] = "Minimap Zoom-",
    ["MinimapFrameTopupButton"] = "Dia-Shop",
    ["AddonManagerMinimapButton"] = "AddonManager",
    ["CE_BUTTON"] = "CombatEngine",
    ["PetInfoStartButton"] = "PetInfo",
    ["LB_Minimap"] = "LackBuffs",
    ["IP2_Minimap"] = "ItemPreview2",
    ["DL_Minimap"] = "DungeonLoots",
    ["AR_MinimapButton"] = "AutoRefine",
}

local MANUAL_FRAMES={
    -- ROM
    ["MinimapFrameBugGartherButton"] = false,
    ["PlayerFramePetButton"] = true,
    ["PlayerFramePartyBoardButton"] = true,
    ["PlayerFrameWorldBattleGroundButton"] = true,
    ["PetBookFrameButton"] = true,
    ["MinimapFramePlusButton"] = true,
    ["MinimapFrameMinusButton"] = true,
    ["MinimapFrameTopupButton"] = true,

    -- Addons
    ["AddonManagerMinimapButton"] = true,
    ["LootIt_MinimapButton"] = true,
    ["Ikarus_MinimapButton"] = true,
    ["TitleSelectMinimapButton"] = true,
    ["SummonMyPet_Minimap"] = true,
    ["kwSpeedUpButton"] = true,
    ["afStayWithMe_Minimap_Switch"] = true,
    ["CE_BUTTON"] = true,
    ["PetInfoStartButton"] = true,
    ["LB_Minimap"] = true,
    ["IP2_Minimap"] = true,
    ["DL_Minimap"] = true,
    ["AR_MinimapButton"] = true,
    ["ComeOnInFrame_Minimap_Shout"] = false,
    ["ComeOnInFrame_Minimap_Config"] = false,
}

local minimap_frames

local function ListOfMinimapButtons()

    if minimap_frames then
        return minimap_frames
    end

    minimap_frames={}
    
    -- Only scan frames that are explicitly in MANUAL_FRAMES
    -- This is much faster than scanning all of _G
    for framename, add in pairs(MANUAL_FRAMES) do
        local frame = _G[framename]
        if frame and add then
            table.insert(minimap_frames, frame)
        end
    end

    table.sort(minimap_frames, function(a,b) return a:GetName()<b:GetName() end)

    return minimap_frames
end

local function GetMinimapName(frame)
    local name = frame:GetName()
    local fname = FIXED_NAMES[name]
    if fname then
        return fname
    end

    name = string.gsub(name,"Minimap","")
    name = string.gsub(name,"Button","")
    name = string.gsub(name,"Frame","")
    name = string.gsub(name,"^[_ ]","")
    name = string.gsub(name,"[_ ]$","")
    return name
end

function tab_minimap.GetCount()
    local list = ListOfMinimapButtons()
    return #list
end

function tab_minimap.OnShow()
    -- Don't invalidate cache on every tab switch - it's too expensive
    -- The cache will be built once and reused until UI reload
    AddonManager.UpdateButtons()
    AddonManagerFramePageAddons:Show()
end

function tab_minimap.OnHide()
    AddonManagerFramePageAddons:Hide()
end

function tab_minimap.ShowButton(index, basename)

    local mapbtn = ListOfMinimapButtons()[index]
    if not mapbtn then 
        -- No minimap button at this index
        return false
    end

    AddonManager.SetButtons(basename, GetMinimapName(mapbtn) , "",
        nil, mapbtn.GetNormalTexture and mapbtn:GetNormalTexture(),
        mapbtn:IsVisible(), nil,
        true )
end

function tab_minimap.OnAddonClicked(btn, index)
    local mapbtn = ListOfMinimapButtons()[index]
    if not mapbtn then return end

    if mapbtn.__uiLuaOnClick__ then
        -- Pass the actual minimap button, not the AddonManager button
        -- PetInfo is currently the cause of this error
        local success, err = pcall(mapbtn.__uiLuaOnClick__, mapbtn)
        if not success then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000AddonManager: Error calling minimap button click for " .. tostring(mapbtn:GetName()) .. ": " .. tostring(err) .. "|r")
        end
    end
end

function tab_minimap.OnAddonEntered(btn, index)

    local mapbtn = ListOfMinimapButtons()[index]
    if not mapbtn then return end

    GameTooltip:ClearAllAnchors()
    GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 10, 0)
    GameTooltip:SetText(AddonManager.L.TIP_MinimapButton)

    if mapbtn.__uiLuaOnMouseEnter__ then
        mapbtn.__uiLuaOnMouseEnter__(btn)

        AddonManager.onitemleave = mapbtn.__uiLuaOnMouseLeave__

        GameTooltip:ClearAllAnchors()
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 10, 0)
    end


    GameTooltip:AddLine(mapbtn:GetName())
    GameTooltip:Show()
end

function tab_minimap.OnCheckMiniBtn(index, is_checked)
    local mapbtn = ListOfMinimapButtons()[index]
    if not mapbtn then return end
    
    Nyx.SetVisible(mapbtn, is_checked)
    AddonManager_MinimapButtons[mapbtn:GetName()] = is_checked
end

function tab_minimap.OnCheckEnableBtn(index, is_checked)
end


-----------------------------------------
local tab_settings = {}
AddonManager.tabs[3]=tab_settings

function tab_settings.OnShow()
    Sol.config.LoadConfig("AddonManager")
    AddonManagerFramePageSettings:Show()
end

function tab_settings.OnHide()
    AddonManagerFramePageSettings:Hide()
end

