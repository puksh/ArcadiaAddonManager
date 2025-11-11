--[[
AddonManager by Alleris.
Maintained by McBen

AddonManager helps you keep track of your addons and provides easy ways to access them.

For users:
- Type /addons to see all your registered addons
- Alternatively, click on the AddonManager button in the "Mini Addons" bar


For addon developers:
- Add a call to AddonManager.RegisterAddonTable in your VARIABLES_LOADED event
- I recommend not printing out that your addon has loaded if you use addon manager,
  since the user will be able to see it in the addon manager list.


- The only things you should change here are the Button's name and the two textures.
- Note that you can't have a MiniButton if your addon is passive (because what should happen
  when the user clicks on it?). A passive addon is one that has no config frame and no
  custom onClickScript.

--]]


local Sol = LibStub("Sol")
local Nyx = LibStub("Nyx")
local WaitTimer = LibStub("WaitTimer")

local DEFAULT_ICON = "interface/icons/reci_car_001"
local TAB_ICON_PATH = "Interface/Addons/AddonManager/Textures/"

local AddonManager = {}
_G.AddonManager = AddonManager

AddonManager.Addons = {}
AddonManager.VERSION = "v7.0.2"
AddonManager.DEFAULT_ICON = DEFAULT_ICON


AddonManager.L = Nyx.LoadLocalesAuto("interface/addons/AddonManager/locales/","en")

AddonManager.Categories = {
    "Development",
    "Economy",
    "Information",
    "Interface",
    "Inventory",
    "Leveling",
    "Map",
    "PvP",
    "Social",
    "Crafting",
    "Other"
}

local DefaultSettings = {
    MovePassiveToBack = true,
    ShowMiniBar = true,
    ShowOnlyNamesInMiniBar = true,
    ShowSlashCmdInsteadOfCat = false,
    ShowMiniBarBorder = true,
    AutoHideMiniBar = false,
    LockMiniBar = false,
    CharBasedEnable = true,
}

AddonManager_UncheckedAddons = {}
AddonManager_DisabledAddons = {}
AddonManager_MinimapButtons = {}

local AddonManager_Loaded = false
local current_tab = nil

local function FindAddon(name)
    for _, v in ipairs(AddonManager.Addons) do
        if v.name==name then
            return v
        end
    end
end

local function GetKeyName()
    local realm =  Nyx.GetCurrentRealm()
    local mainClass, secondClass = "",""
    if AddonManager_Settings.CharBasedEnable then
        mainClass, secondClass = UnitClass("player")
    end
    return string.format("%s:%s:%s",tostring(realm),tostring(mainClass),tostring(secondClass))
end

function AddonManager.SetAddonEnabled(name, enabled)
    if type(name) ~= "string" or name == "" then return end
    if type(enabled) ~= "boolean" then enabled = not not enabled end
    
    local key = GetKeyName()
    if enabled then
        if AddonManager_DisabledAddons[key] then
            AddonManager_DisabledAddons[key][name] = nil
            if next(AddonManager_DisabledAddons[key])==nil then
                AddonManager_DisabledAddons[key]=nil
            end
        end
    else
        AddonManager_DisabledAddons[key] = AddonManager_DisabledAddons[key] or {}
        AddonManager_DisabledAddons[key][name] =  true
    end
end

local function CheckDisabledState()
    local key = GetKeyName()
    local isdisabled = AddonManager_DisabledAddons[key] or {}

    for _, addon in pairs(AddonManager.Addons) do

        if isdisabled[addon.name] then
            if addon.disableScript and not addon.isdisabled then
                addon.isdisabled=true
                addon.disableScript()
            end
        else
            if addon.enableScript and addon.isdisabled then
                addon.isdisabled=nil
                addon.enableScript()
            end
        end
    end
end

local function CleanupOrphanedDisabledAddons()
    -- Remove disabled addons that no longer exist from saved variables
    for key, disabledAddons in pairs(AddonManager_DisabledAddons) do
        local toRemove = {}
        for addonName, _ in pairs(disabledAddons) do
            local exists = false
            for _, addon in pairs(AddonManager.Addons) do
                if addon.name == addonName then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(toRemove, addonName)
            end
        end
        for _, addonName in ipairs(toRemove) do
            disabledAddons[addonName] = nil
        end
        if next(disabledAddons) == nil then
            AddonManager_DisabledAddons[key] = nil
        end
    end
end

function AddonManager.MinimapTutorial_OnEnter(this)
    if not GameTooltip or not this then return end
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT", 10, 0)
    GameTooltip:SetText("Minimap Buttons", 1, 1, 0)
    if GameTooltip.AddSeparator then GameTooltip:AddSeparator() end
    GameTooltip:AddLine("This tab lists all buttons anchored to your minimap.", 1, 1, 1)
    GameTooltip:AddLine("- Click an entry to trigger that button's default action.", 1, 1, 1)
    GameTooltip:AddLine("- Use the left checkbox to show or hide it on the minimap.", 1, 1, 1)
    if GameTooltip.AddSeparator then GameTooltip:AddSeparator() end
    GameTooltip:AddLine("Note: CoA minimap buttons are managed under:", 0.9, 0.9, 0.9)
    GameTooltip:AddLine("Settings → User Interface → Elements", 0, 0.75, 0.95)
    GameTooltip:Show()
end

function AddonManager.MinimapTutorial_OnLeave()
    if GameTooltip then GameTooltip:Hide() end
end


-- Tooltip: Standard settings tooltip for checkboxes (title + description)
-- @param frame (table) The UI element the tooltip is attached to
-- @param description (string) The descriptive text to show under the title
function AddonManager.ShowSettingsTooltip(frame, description)
    if type(GameTooltip) ~= "table" or type(GameTooltip.SetOwner) ~= "function" then return end
    if type(frame) ~= "table" then return end

    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 4, 0)

    -- Derive a title from the checkbox label if available
    local title = ""
    local label = _G[frame:GetName() .. "Label"]
    if type(label) == "table" and type(label.GetText) == "function" then
        title = label:GetText() or ""
    elseif type(frame.GetText) == "function" then
        title = frame:GetText() or ""
    end
    if title == "" then title = "Settings" end

    GameTooltip:SetText(title, 1, 1, 0)
    if GameTooltip.AddSeparator then GameTooltip:AddSeparator() end

    if type(description) == "string" and description ~= "" then
        -- Body text in standard tooltip color
        GameTooltip:AddLine(description, 1, 1, 1)
    end

    GameTooltip:Show()
end


--[[
 !! OBSOLETE: use AddonManager.RegisterAddonTable instead !!
--]]
AddonManager.RegisterAddon = function(name, description, icon, category, configFrame, slashCommands,
    miniButton, onClickScript, version, author, disableScript, enableScript)

    local addon = {
        name = name,
        description = description,
        icon = icon,
        category = category,
        configFrame = configFrame,
        slashCommands = slashCommands,
        miniButton = miniButton,
        onClickScript = onClickScript,
        version = version,
        author = author,
        disableScript,
        enableScript,
    }

    AddonManager.RegisterAddonTable(addon)
end


--[[
Registers an addon with AddonManager. Adds the addon to the addons list and potentially also to the mini-addons-frame.

Parameters:
+ addon - A table of key-value pairs, with the keys being the parameters to AddonManager.RegisterAddonTable
          Except "name" all parameters are optional!

Example:
    if AddonManager and AddonManager.RegisterAddonTable then
        local addon = {
            -- Information
            name = "MyAddonName",
            icon = "Interface/Addons/MyAddon/myAddon32.tga",
            version = "v0.01",
            author = "Me",
            translators = "Guy",
            description = "My addon makes you awesome",
            category = "Other",
            slashCommand = "/myaddon",

            -- Config-Frames
            configFrame = MyAddonConfigFrame,
            disableScript = MyAddon_Disable,
            enableScript = MyAddon_Enable,
            onClickScript= MyAddon_Config,

            -- Mini Button
            mini_icon = "Interface/Addons/MyAddon/myAddon32.tga",
            mini_icon_pushed = "Interface/Addons/MyAddon/myAddon32.tga",
            mini_onClickScript= MyAddon_Action,
            -- miniButton = MyAddonMiniButton, ! OBSOLETE !
        }
        AddonManager.RegisterAddonTable(addon)
    end


Description:
+ name          - Your addon's name.
+ description   - A brief (one or two sentence) description of your addon. Something that fits in a tooltip.
+ icon          - Path to a 32x32 image icon (e.g., "Interface/Addons/AddonManager/Textures/addonManagerIcon32.tga").
                  If no icon is specified, will use default "recipe" icon.
+ category      - One of AddonManager.Categories; will be used for filtering the addons list. Default is "Other".
+ configFrame   - If your addon has a config frame or other frame you want to show when your addon is clicked, use this.
+ slashCommands - Specify any slash commands you've registered so that the user doesn't have to remember them.
+ miniButton    - If you want to display a minimap-style button on the AddonManager "Mini Addons" frame, specify it here.
                  Note that you must have a valid minimap button created in your xml and your addon must not be passive
                  for this to work. See above for details.
+ onClickScript - If you need to special handling when your addon's button is clicked, you can specify a script for it.
                  If this parameter is specified, configFrame is ignored.
                  Function call is  "MyAddon_Config(frame,key)"
+ version       - Your addon's version. To be displayed in the tooltip.
+ author        - Who made this addon.
+ disableScript - A script that can be used to disable your addon. Adds the disable option in the AddonManager list if
                  both disableScript and enableScript are specified
+ enableScript  - A script that can be used to re-enable your addon

--]]
function AddonManager.RegisterAddonTable(addon)

    if type(addon) ~= "table" then
        error("AddonManager: table expected got "..tostring(addon),2)
    end

    if not addon.name then
        local errtxt = "AddonManager: addon.name required"
        DEFAULT_CHAT_FRAME:AddMessage(errtxt)
        error(errtxt,2)
    end

    if FindAddon(addon.name) then
        local errtxt = "AddonManager: addon "..addon.name.." already exists"
        DEFAULT_CHAT_FRAME:AddMessage(errtxt)
        error(errtxt,2)
    end

    if not addon.category or not Nyx.TableIndexOf(AddonManager.Categories, addon.category) then
        addon.category = "Other"
    end

    if type(addon.onClickScript)~="function" then
        addon.onClickScript=nil
    end

    if type(addon.mini_onClickScript)~="function" then
        addon.mini_onClickScript=nil
    end

    if type(addon.disableScript)~="function" then
        addon.disableScript=nil
    end

    if type(addon.enableScript)~="function" then
        addon.enableScript=nil
    end

    local inserted = false
    for i, v in ipairs(AddonManager.Addons) do
        if AddonManager.AddonSortFn(addon, v) then
            inserted = true
            table.insert(AddonManager.Addons, i, addon)
            break
        end
    end
    if not inserted then
        table.insert(AddonManager.Addons, addon)
    end

    if AddonManager_Loaded then

        if AddonManagerFrame:IsVisible() then
            AddonManager.Update()
        end

        if AddonManager.HasMiniButton(addon) then
            AddonManager.Mini.AddIcon(addon)
        end

        if AddonManager.IsAddonDisabled(addon.name) and addon.disableScript then
            addon.isdisabled=true
            addon.disableScript()
        end
    end
end

local function LocalizeSettingPage()
    AddonManagerFramePageSettingsMainCategoryLabel:SetText(AddonManager.L["SETTING_MainCategory"])
    AddonManagerFramePageSettingsMiniCategoryLabel:SetText(AddonManager.L["SETTING_MiniCategory"])
    AddonManagerFramePageSettingsMinimapCategoryLabel:SetText(AddonManager.L["TAB_MinimapButtons"])
    AddonManagerConfig_ToggleMovePassiveToBackLabel:SetText(AddonManager.L["SETTING_MovePassiveToBack"])
    AddonManagerConfig_ToggleShowSlashCmdInsteadOfCatLabel:SetText(AddonManager.L["SETTING_ShowSlashCmdInsteadOfCat"])
    AddonManagerConfig_ToggleClassBasedEnableLabel:SetText(AddonManager.L["SETTING_CharBasedEnable"])

    AddonManagerConfig_ToggleShowMiniBarLabel:SetText(AddonManager.L["SETTING_ShowMiniBar"])
    AddonManagerConfig_ToggleShowOnlyNamesInMiniBarLabel:SetText(AddonManager.L["SETTING_ShowOnlyNamesInMiniBar"])
    AddonManagerConfig_ToggleShowMiniBarBorderLabel:SetText(AddonManager.L["SETTING_ShowMiniBarBorder"])
    AddonManagerConfig_ToggleAutoHideMiniBarLabel:SetText(AddonManager.L["SETTING_AutoHideMiniBar"])
    AddonManagerConfig_ToggleLockMiniBarLabel:SetText(AddonManager.L["SETTING_LockMiniBar"])
    AddonManagerConfig_ToggleLegacyMinimapSearchLabel:SetText(AddonManager.L["SETTING_LegacyMinimapSearch"])
end

function AddonManager.OnLoad(frame)
	frame:RegisterEvent("VARIABLES_LOADED")
	frame:RegisterEvent("LOADING_END")
    frame:RegisterEvent("UNIT_CLASS_CHANGED")
    LocalizeSettingPage()
end


local function RegisterMySelf()
    local addonMgr = {
        name = "AddonManager",
        version = AddonManager.VERSION,
        author = "McBen, Alleris",
        description = AddonManager.L.description,
        icon = TAB_ICON_PATH .. "addonManagerIcon32",
        category = "Information",
        configFrame = AddonManagerFrame,
        slashCommands = "/addons",
        mini_icon ="Interface/AddOns/AddonManager/Textures/addonManagerMiniIcon",
        mini_icon_pushed ="Interface/AddOns/AddonManager/Textures/addonManagerMiniIconInv",
    }
    AddonManager.RegisterAddonTable(addonMgr)
end

function AddonManager.OnEvent(_, event)
    AddonManager[event]()
end

function AddonManager.VARIABLES_LOADED()

    AddonManager_Settings = Nyx.TableMerge(AddonManager_Settings, DefaultSettings)
    
    -- Remove obsolete settings that have been moved elsewhere
    AddonManager_Settings.ShowMinimapButton = nil
    
    SaveVariables("AddonManager_Settings")
    SaveVariables("AddonManager_UncheckedAddons")
    SaveVariables("AddonManager_MinimapButtons")
    SaveVariablesPerCharacter("AddonManager_DisabledAddons")


    local categories = {C_ALL}
    for _,cat in ipairs(AddonManager.Categories) do
        table.insert(categories, AddonManager.L.CAT[cat])
    end

    -- Setup main dialog
    Sol.config.SetupDropdown(AddonManagerCategoryFilter, categories, 1, 110, AddonManager.Update)

    PanelTemplates_IconTabInit(AddonManagerFrameTabAddons, TAB_ICON_PATH .. "addonsTab2", AddonManager.L.TAB_Addons)
    PanelTemplates_IconTabInit(AddonManagerFrameTabMapButtons, TAB_ICON_PATH .. "minimaptab", AddonManager.L.TAB_MinimapButtons)
    PanelTemplates_IconTabInit(AddonManagerFrameTabSettings, TAB_ICON_PATH .. "settingsTab", AddonManager.L.TAB_Setup)
    SkillTab_SetActiveState(AddonManagerFrameTabAddons, true)
    SkillTab_SetActiveState(AddonManagerFrameTabMapButtons, false)
    SkillTab_SetActiveState(AddonManagerFrameTabSettings, false)

    AddonManagerFrame.tab = AddonManagerFrameTabAddons
    AddonManager.SelectTab(AddonManagerFrameTabAddons)

    -- Hey, this is an addon, too =D
    RegisterMySelf()

    AddonManager_Loaded = true

    -- Update the frame title to include the addon version
    local titleText = "AddonManager " .. tostring(AddonManager.VERSION or "")
    if _G["AddonManagerFrameTitleFrameText"] and type(AddonManagerFrameTitleFrameText.SetText) == "function" then
        AddonManagerFrameTitleFrameText:SetText(titleText)
    end

    -- Add mini buttons now
    for _, addon in pairs(AddonManager.Addons) do
        if AddonManager.HasMiniButton(addon) then
            AddonManager.Mini.AddIcon(addon)
        end
    end

    AddonManager.RecheckSettings()

    CleanupOrphanedDisabledAddons()
    CheckDisabledState()

    AddonManager.SetMinimapButtons()
end

function AddonManager.LOADING_END()
    WaitTimer.Delay(0.1, AddonManager.SetMinimapButtons)
end

local ori_OnClick_SetMinimapVisible = OnClick_SetMinimapVisible
function OnClick_SetMinimapVisible(this)
    ori_OnClick_SetMinimapVisible( this )
    AddonManager.SetMinimapButtons()
end

function AddonManager.UNIT_CLASS_CHANGED()
    CheckDisabledState()
end


SLASH_AddonManager1="/addonmanager"
SLASH_AddonManager2="/addons"
function SlashCmdList.AddonManager(cmd)
    ToggleUIFrame(AddonManagerFrame)
end


function AddonManager.OnSettingChanged(settingName, newValue)
    -- Apply the setting change immediately
    AddonManager_Settings[settingName] = newValue
    
    -- Apply specific updates based on the setting changed
    if settingName == "ShowMiniBar" then
        AddonManager.Mini.Show(newValue)
    elseif settingName == "ShowOnlyNamesInMiniBar" then
        AddonManager.Mini.UpdateState()
    elseif settingName == "ShowMiniBarBorder" then
        AddonManager.Mini.UpdateState()
    elseif settingName == "AutoHideMiniBar" then
        AddonManager.Mini.Show(AddonManager_Settings.ShowMiniBar)
    elseif settingName == "LockMiniBar" then
        AddonManager.Mini.UpdateState()
    elseif settingName == "MovePassiveToBack" or settingName == "CharBasedEnable" then
        CheckDisabledState()
        table.sort(AddonManager.Addons, AddonManager.AddonSortFn)
        -- Only update if current tab supports it (has GetCount function)
        if current_tab and current_tab.GetCount then
            AddonManager.Update()
        end
    elseif settingName == "ShowSlashCmdInsteadOfCat" then
        -- Only update if current tab supports it (has GetCount function)
        if current_tab and current_tab.GetCount then
            AddonManager.Update()
        end
    end
    
    -- Save to persistent storage immediately
    SaveVariables("AddonManager_Settings")
end

function AddonManager.RecheckSettings()
    AddonManager.Mini.Show(AddonManager_Settings.ShowMiniBar)

    -- AddonManagerMinimapButton visibility is now controlled via the Minimap-Buttons tab
    -- cleanup code for updating
    local isVisible = AddonManager_MinimapButtons["AddonManagerMinimapButton"]
    if isVisible == nil then
        isVisible = false  -- Default to hidden
    end
    -- end of cleanup code
    Nyx.SetVisible(AddonManagerMinimapButton, isVisible)
end

function AddonManager.MinimapButton_OnClick(this)
	ToggleUIFrame(AddonManagerFrame)
end

function AddonManager.ButtonTemplateLoad(this)
    _G[this:GetName().."EnabledCheckLabel"]:SetText(AddonManager.L.But_Enable)
    _G[this:GetName().."MiniCheckLabel"]:SetText(AddonManager.L.But_Show)
end

-- If addonA should come before addonB in the addons list, returns true; else false
function AddonManager.AddonSortFn(addonA, addonB)
    if type(addonA) ~= "table" or type(addonB) ~= "table" then return false end
    if not addonA.name or not addonB.name then return false end
    
    if AddonManager_Settings and not AddonManager_Settings.MovePassiveToBack then
        return addonA.name:lower() < addonB.name:lower()
    else
        local aIsActive = AddonManager.IsActive(addonA)
        local bIsActive = AddonManager.IsActive(addonB)

        if aIsActive and not bIsActive then
            -- addonA > addonB
            return true
        elseif not aIsActive and bIsActive then
            -- addonA < addonB
            return false
        else
            return addonA.name:lower() < addonB.name:lower()
        end
    end
end

function AddonManager.IsAddonDisabled(name)
    if type(name) ~= "string" or name == "" then return false end
    local key = GetKeyName()
    return AddonManager_DisabledAddons[key] and AddonManager_DisabledAddons[key][name]
end

function AddonManager.IsActive(addon)
    if type(addon) ~= "table" then return false end
    return addon.mini_onClickScript or addon.configFrame or addon.onClickScript
end
function AddonManager.HasMiniButton(addon)
    if type(addon) ~= "table" then return false end
    return (addon.miniButton or addon.mini_icon or addon.mini_onClickScript) and AddonManager.IsActive(addon)
end


function AddonManager.ShowTooltipOfAddon(btn,addon)

    if type(addon) ~= "table" or not addon.name then return end

    GameTooltip:ClearAllAnchors()
	GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 10, 0)

    local name = addon.name
    if addon.version then
        name = name .. " |cffaaaaaa"..addon.version.."|r"
    end
	GameTooltip:SetText(name)
    GameTooltip:AddLine(AddonManager.L.CAT[addon.category], 0.5, 0.5, 0.5)
    if addon.description then
        GameTooltip:AddLine(addon.description,0,0.66,1)
    end
    
    -- Check for slash commands (both plural and singular property names)
    local slashCmd = addon.slashCommands or addon.slashCommand
    
    if slashCmd or addon.author then
        GameTooltip:AddLine(" ")
        if slashCmd and slashCmd ~= "" then
            GameTooltip:AddLine(AddonManager.L.TIP_CMD.."|cff00ff00"..slashCmd.."|r",0,0.66,1)
        else
            GameTooltip:AddLine(AddonManager.L.TIP_CMD.."|cffaaaaaa"..AddonManager.L.NoCommand.."|r",0,0.66,1)
        end
        if addon.author then
            GameTooltip:AddLine(AddonManager.L.TIP_DEVS..addon.author, 0.5, 0.5, 0.5)
        end
        if addon.translators then
            GameTooltip:AddLine(AddonManager.L.TIP_TRANSLATOR..addon.translators, 0.5, 0.4, 0.5)
        end
    end
end

function AddonManager.ShowAddonInMini(addon_name)
    for i,name in ipairs(AddonManager_UncheckedAddons) do
        if name==addon_name then
            return false
        end
    end
    return true
end

function AddonManager.SetMinimapButtons()
    local to_remove={}
    for framename,newstate in pairs(AddonManager_MinimapButtons) do
        local frame = _G[framename]
        local framestate = frame and frame:IsVisible()
        if frame then
            Nyx.SetVisible(frame, newstate)
        else
            table.insert(to_remove,framename)
        end
    end

    for _,n in ipairs(to_remove) do
--        DEFAULT_CHAT_FRAME:AddMessage("AM: REMOVE: "..n)
        AddonManager_MinimapButtons[n]=nil
    end
end

------------------- Config Stuff -----------------
function AddonManager.OnShow()
    assert(current_tab)
    current_tab.OnShow()
end

function AddonManager.SelectTab(tab)
    SkillTab_SetActiveState(AddonManagerFrame.tab, false)
    SkillTab_SetActiveState(tab, true)
    AddonManagerFrame.tab = tab
    AddonManagerFrame.page = 1

    current_tab = AddonManager.tabs[ tab:GetID() ]
end

function AddonManager.OnTabClicked(tab)
    current_tab.OnHide()

    AddonManager.SelectTab(tab)

    current_tab.OnShow()
end

function AddonManager.Update()
    AddonManagerFrame.page = 1
    AddonManager.UpdateButtons()
end

function AddonManager.UpdateButtons()
    local count = current_tab.GetCount()
    local maxpage = math.ceil(count / DF_MAXPAGESKILL_SKILLBOOK)
    
    -- Only show pagination bar if there are multiple pages
    Nyx.SetVisible(AddonManagerFramePageAddonsPagingBar, maxpage > 1)
    
    -- Update pagination button visibility
    if maxpage > 1 then
        -- Show/hide left (back) button based on current page
        if AddonManagerFrame.page <= 1 then
            AddonManagerFramePageAddonsPagingBarLeftPage:Hide()
        else
            AddonManagerFramePageAddonsPagingBarLeftPage:Show()
        end
        
        -- Show/hide right (forward) button based on current page
        if AddonManagerFrame.page >= maxpage then
            AddonManagerFramePageAddonsPagingBarRightPage:Hide()
        else
            AddonManagerFramePageAddonsPagingBarRightPage:Show()
        end
    end

    for i = 1, DF_MAXPAGESKILL_SKILLBOOK do
        local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + i
        local basename = "AddonManagerAddonButton"..i

        if index <= count then
            local success = current_tab.ShowButton(index, basename)
            -- Only show the button if ShowButton successfully populated it
            if success ~= false then
                _G[basename]:Show()
            else
                _G[basename]:Hide()
            end
        else
            _G[basename]:Hide()
        end
    end
end

function AddonManager.SetButtons(basename, name, catname, icon, icontexture, minibutton, enablebutton, active)
    if type(basename) ~= "string" then return end
    if type(name) ~= "string" then name = tostring(name or "") end
    if type(catname) ~= "string" then catname = tostring(catname or "") end
    if type(icon) ~= "string" then icon = AddonManager.DEFAULT_ICON end
    -- icontexture can be nil or string
    if type(minibutton) ~= "boolean" and type(minibutton) ~= "nil" then minibutton = nil end
    if type(enablebutton) ~= "boolean" and type(enablebutton) ~= "nil" then enablebutton = nil end
    if type(active) ~= "boolean" then active = false end
    
    local categoryFrame = _G[basename.. "_AddonInfo_Category"]
    categoryFrame:SetText(catname)
    
    local nameFrame = _G[basename.. "_AddonInfo_Name"]
    nameFrame:SetText(name)
    
    -- Show category only if there's content (used in All Addons tab, hidden in Minimap Buttons tab)
    -- Adjust name box height accordingly
    if catname and catname ~= "" then
        categoryFrame:Show()
        nameFrame:SetHeight(14)  -- Smaller height to not overlap with category
    else
        categoryFrame:Hide()
        nameFrame:SetHeight(32)  -- Full height when no category
    end

    local iconFrame = _G[basename.. "ItemButton"]
    if icontexture then
        local iconFrameTexture = _G[basename.. "ItemButtonIcon"]
        iconFrameTexture:SetTexture(icontexture)
    else
        SetItemButtonTexture(iconFrame, icon)
    end

    local miniButtonCheck = _G[basename.. "MiniCheck"]
    local enabledCheck = _G[basename.. "EnabledCheck"]
    enabledCheck:ClearAllAnchors()

    if minibutton~=nil then
        miniButtonCheck:Show()
        miniButtonCheck:SetChecked(minibutton)
        enabledCheck:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", _G[basename], -35, 6)
    else
        miniButtonCheck:Hide()
        enabledCheck:SetAnchor("BOTTOMLEFT", "BOTTOMLEFT", _G[basename], -3, 6)
    end

    if active then
        iconFrame:Enable()
        nameFrame:SetColor(1,1,1)
    else
        iconFrame:Disable()
        nameFrame:SetColor(0.64,0.5,0.32)
    end

    if enablebutton~=nil then
        enabledCheck:Show()
        enabledCheck:SetChecked(enablebutton)
    else
        enabledCheck:Hide()
    end
end


function AddonManager.TurnPageBack(btn)
    AddonManagerFrame.page = AddonManagerFrame.page - 1
    if AddonManagerFrame.page < 1 then
        AddonManagerFrame.page = 1
    end
    AddonManager.UpdateButtons()
end

function AddonManager.TurnPageForward(btn)
    local maxpage = math.ceil(current_tab.GetCount() / DF_MAXPAGESKILL_SKILLBOOK)
    AddonManagerFrame.page = AddonManagerFrame.page + 1
    if AddonManagerFrame.page > maxpage then
        AddonManagerFrame.page = maxpage
    end
    AddonManager.UpdateButtons()
end

function AddonManager.OnMouseWheel(frame, delta)
    -- Don't handle mouse wheel if tab not initialized
    if not current_tab or not current_tab.GetCount then
        return
    end
    
    if delta and delta ~= 0 then
        if delta > 0 then
            -- Scroll up = previous page
            if AddonManagerFrame.page > 1 then
                AddonManager.TurnPageBack(frame)
            end
        else
            -- Scroll down = next page
            local count = current_tab.GetCount()
            local maxpage = math.ceil(count / DF_MAXPAGESKILL_SKILLBOOK)
            if AddonManagerFrame.page < maxpage then
                AddonManager.TurnPageForward(frame)
            end
        end
    end
end

function AddonManager.OnAddonClicked(btn, id)
    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnAddonClicked(btn, index)
end

function AddonManager.OnAddonEntered(btn, id)
    _G[btn:GetName() .. "Highlight"]:Show()

    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnAddonEntered(btn, index)
end

function AddonManager.OnAddonLeave(btn)
    _G[btn:GetName() .. "Highlight"]:Hide()
    GameTooltip:Hide()

    if AddonManager.onitemleave then
        AddonManager.onitemleave(btn)
        AddonManager.onitemleave = nil
    end
end

function AddonManager.OnAddonMiniChecked(checkBox, id)
    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnCheckMiniBtn(index, checkBox:IsChecked())
end

function AddonManager.OnAddonEnabledChecked(checkBox, id)
    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnCheckEnableBtn(index, checkBox:IsChecked())
end
