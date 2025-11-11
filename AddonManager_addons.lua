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
    -- LegacyMinimapSearch: true = only use FIXED_NAMES list, false = scan all globals for minimap buttons
    if AddonManager_Settings.LegacyMinimapSearch == nil then
        AddonManager_Settings.LegacyMinimapSearch = false
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
    ["AddonManagerMinimapButton"] = "AddonManager",
    ["CE_BUTTON"] = "CombatEngine",
    ["LB_Minimap"] = "LackBuffs",
    ["IP2_Minimap"] = "ItemPreview2",
    ["DL_Minimap"] = "DungeonLoots",
    ["AR_MinimapButton"] = "AutoRefine",
    ["KittyMinimap"] = "KittyCombo",
    ["Lootomatic_Minimap"] = "Lootomatic",
    ["Helperswitch"] = "[CoA Helper] Helper",
    ["ResetIni"] = "[InviteTool] Reset Instance",
    ["ExitIni"] = "[InviteTool] Leave Instance",
    ["Invite"] = "[InviteTool] Invite",
    ["Hammerhead"] = "[CoA Helper] Remove Debuff",
    ["ComeOnInFrame_Minimap"] = "ComeOnIn",
    ["ComeOnInFrame_Minimap_Start"] = "[COI] Start",
    ["ComeOnInFrame_Minimap_Reload"] = "[COI] Reload",
    ["ComeOnInFrame_Minimap_Shout"] = "[COI] Shout",
    ["ComeOnInFrame_Minimap_Config"] = "[COI] Config",
}

AddonManager.COA_BLACKLIST = {
    -- CoA native UI buttons (managed elsewhere in game settings)
    MinimapFramePlusButton = true,
    MinimapFrameMinusButton = true,
    MinimapFrameTopupButton = true,
    MinimapNpcTrackButton = true,
    MinimapFrameWorldBossScheduleButton = true,
    MinimapFrameStoreButton = true,
    MinimapFrameBattleGroundButton = true,
    MinimapBeautyStudioButton = true,
    MinimapFrameOptionButton = true,
    MinimapFrameRestoreUIButton = true,
    PlayerFrameWeekInstancesButton = true,
    PerformSaveVariablesButton = true,
    OpenWikiButton = true,
    MinimapFrameBulletinButton = true,
    MinimapFrameQuestTrackButton = true,
    MinimapFrameBugGartherButton = true,
    PetInfoStartButton = true,
}

local minimap_frames

function AddonManager.ClearMinimapCache()
    minimap_frames = nil
    DEFAULT_CHAT_FRAME:AddMessage("[AddonManager] Minimap button cache cleared")
end

local function safe_GetParent(element)
    if type(element) ~= "table" or type(element.GetParent) ~= "function" then return nil end
    local success, parent = pcall(element.GetParent, element)
    return (success and parent) or nil
end

local function IsFrame(value)
    if type(value) ~= "table" then return false end
    local mt = getmetatable(value)
    local mtmt = getmetatable(mt)
    if mt and mtmt and mt.GetID and mt.SetID and mtmt.GetHeight and mtmt.GetParent then
        return true
    end
    return false
end

local function IsUIParentChild(frame)
    if type(frame) ~= "table" then return false end
    return safe_GetParent(frame) == UIParent
end

local function ListOfMinimapButtons()
    if minimap_frames then
        return minimap_frames
    end

    minimap_frames = {}

    -- Seed with known buttons from FIXED_NAMES
    for framename, include in pairs(FIXED_NAMES) do
        if include and not (AddonManager.COA_BLACKLIST and AddonManager.COA_BLACKLIST[framename]) then
            local frame = _G[framename]
            if frame and type(frame.GetName) == "function" then
                table.insert(minimap_frames, frame)
            end
        end
    end

    -- If legacy mode is OFF, do comprehensive global scan to find more buttons
    if not AddonManager_Settings.LegacyMinimapSearch then
        local function IsLikelyMinimapButton(frame)
            if type(frame) ~= "table" or type(frame.GetName) ~= "function" then return false end
            
            local name = frame:GetName()
            if type(name) ~= "string" then return false end
            if AddonManager.COA_BLACKLIST and AddonManager.COA_BLACKLIST[name] then return false end

            -- Must have texture or click capability
            local hasTex = (frame.GetNormalTexture and frame:GetNormalTexture()) or 
                          (frame.GetHighlightTexture and frame:GetHighlightTexture()) or
                          (frame.GetTexture and frame:GetTexture())
            local hasClick = frame.__uiLuaOnClick__ or frame.__uiLuaOnMouseEnter__ or frame.func_OnClick or
                            (type(frame.RegisterForClicks) == "function") or (type(frame.SetScript) == "function")
            if not (hasTex or hasClick) then return false end

            -- Size check: 10-64px
            local w, h = 0, 0
            if type(frame.GetWidth) == "function" then 
                local success, width = pcall(frame.GetWidth, frame)
                if success and type(width) == "number" then w = width end
            end
            if type(frame.GetHeight) == "function" then 
                local success, height = pcall(frame.GetHeight, frame)
                if success and type(height) == "number" then h = height end
            end
            if w > 0 and h > 0 and (w < 10 or h < 10 or w > 64 or h > 64) then return false end

            -- Check if anchored to minimap or name suggests minimap button
            local anchoredToMinimap = false
            if type(frame.GetPoint) == "function" then
                local success, point, relativeTo = pcall(frame.GetPoint, frame)
                if success and type(relativeTo) == "table" and type(relativeTo.GetName) == "function" then
                    local relSuccess, relName = pcall(relativeTo.GetName, relativeTo)
                    if relSuccess and type(relName) == "string" and string.find(relName:lower(), "minimap") then
                        anchoredToMinimap = true
                    end
                end
            end
            
            if not anchoredToMinimap and type(frame.relativeTo) == "string" and string.find(frame.relativeTo:lower(), "minimap") then
                anchoredToMinimap = true
            end
            
            -- Name-based matching as fallback
            local lowerName = name:lower()
            if string.find(lowerName, "minimap") or string.find(lowerName, "_minimap") or string.find(lowerName, "minimapbutton") or
               (string.find(lowerName, "mini") and string.find(lowerName, "button")) then
                anchoredToMinimap = true
            end

            return anchoredToMinimap
        end

        -- Scan all globals for frames
        local seen = {}
        for _, f in ipairs(minimap_frames) do seen[f] = true end
        
        for globalName, globalValue in pairs(_G) do
            if type(globalName) == "string" and not seen[globalValue] then
                if IsFrame(globalValue) and IsUIParentChild(globalValue) then
                    local success, isMinimap = pcall(IsLikelyMinimapButton, globalValue)
                    if success and isMinimap then
                        table.insert(minimap_frames, globalValue)
                        seen[globalValue] = true
                    end
                end
            end
        end

        -- Backup: scan UIParent children
        if type(UIParent) == "table" and type(UIParent.GetChildren) == "function" then
            local success, children = pcall(UIParent.GetChildren, UIParent)
            if success and type(children) == "table" then
                for _, child in ipairs(children) do
                    if type(child) == "table" and child.GetName and not seen[child] then
                        local ok, isMini = pcall(IsLikelyMinimapButton, child)
                        if ok and isMini then
                            table.insert(minimap_frames, child)
                            seen[child] = true
                        end
                    end
                end
            end
        end
    end

    table.sort(minimap_frames, function(a,b) return a:GetName() < b:GetName() end)
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
    -- Check if we need to invalidate cache due to expected button count mismatch
    local expected = 0
    for k in pairs(FIXED_NAMES) do 
        if not (AddonManager.COA_BLACKLIST and AddonManager.COA_BLACKLIST[k]) then 
            expected = expected + 1 
        end 
    end
    
    -- Invalidate cache if button count doesn't match expectations or if scan mode was toggled
    if not minimap_frames or #minimap_frames < expected then
        minimap_frames = nil
    end
    
    -- If legacy mode is OFF and we only have FIXED_NAMES count, rescan to get more
    if not AddonManager_Settings.LegacyMinimapSearch and minimap_frames and #minimap_frames == expected then
        minimap_frames = nil
    end
    
    -- If legacy mode is ON and we have MORE than FIXED_NAMES count, rescan to reduce
    if AddonManager_Settings.LegacyMinimapSearch and minimap_frames and #minimap_frames > expected then
        minimap_frames = nil
    end

    AddonManager.UpdateButtons()
    AddonManagerFramePageAddons:Show()
    Nyx.SetVisible(AddonManagerMinimapRefreshButton, true)
    Nyx.SetVisible(AddonManagerMinimapTutorialButton, true)
    Nyx.SetVisible(AddonManagerCategoryFilter, false)
end

function tab_minimap.OnHide()
    AddonManagerFramePageAddons:Hide()
    Nyx.SetVisible(AddonManagerMinimapRefreshButton, false)
    Nyx.SetVisible(AddonManagerMinimapTutorialButton, false)
    Nyx.SetVisible(AddonManagerCategoryFilter, false)
end

function tab_minimap.ShowButton(index, basename)

    local mapbtn = ListOfMinimapButtons()[index]
    if not mapbtn then 
        -- No minimap button at this index
        return false
    end

    AddonManager.SetButtons(basename, GetMinimapName(mapbtn) , "",
        AddonManager.DEFAULT_ICON, mapbtn.GetNormalTexture and mapbtn:GetNormalTexture(),
        mapbtn:IsVisible(), nil,
        true )
end

function tab_minimap.OnAddonClicked(btn, index)
    if not btn then return end
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

    if not btn then return end
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
    if not is_checked then is_checked = false end
    local mapbtn = ListOfMinimapButtons()[index]
    if not mapbtn then return end
    
    local name = mapbtn:GetName()
    -- Do not record or manipulate CoA-native buttons
    if AddonManager.COA_BLACKLIST and AddonManager.COA_BLACKLIST[name] then
        return
    end
    Nyx.SetVisible(mapbtn, is_checked)
    AddonManager_MinimapButtons[name] = is_checked
end

-- Public: Refresh the minimap buttons list (invalidate cache and update UI)
function AddonManager.RefreshMinimapButtons()
    -- Invalidate cached list so next lookup rebuilds it
    minimap_frames = nil
    AddonManager.UpdateButtons()
    -- Ensure saved variables are persisted
    SaveVariables("AddonManager_MinimapButtons")
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

