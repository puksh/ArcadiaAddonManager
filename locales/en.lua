-- coding: utf-8

return {
    AnchorFrame_Addition=".\nHold CTRL to suspend docking.",
    TAB_Addons = "All Addons",
    TAB_MinimapButtons = "Minimap Buttons",
    TAB_Setup = "Settings",
    description = "Manages your addons... You're looking at it right now ;)",

    But_Show="Show",
    But_Enable="Enabled",
    
    TIP_MinimapButton = "Minimap Button",
    
    -- Tutorial tooltip for minimap buttons tab
    TUTORIAL_MinimapButtons_Title = "Minimap Buttons",
    TUTORIAL_MinimapButtons_Desc = "This tab lists all buttons anchored to your minimap.",
    TUTORIAL_MinimapButtons_Line1 = "- Click an entry to trigger that button's default action.",
    TUTORIAL_MinimapButtons_Line2 = "- Use the left checkbox to show or hide it on the minimap.",
    TUTORIAL_MinimapButtons_Note = "Note: CoA minimap buttons are managed in-game:",
    TUTORIAL_MinimapButtons_NotePath = "Settings → User Interface → Elements",

    SETTING_MainCategory = "Main",
    SETTING_MiniCategory = "Mini-Addon Bar",
    SETTING_MovePassiveToBack = "Sort passive addons to the back of the list",
    SETTING_ShowSlashCmdInsteadOfCat = "Show slash command instead of category",
    SETTING_ShowMiniBar = "Show the Mini-Addon bar",
    SETTING_ShowOnlyNamesInMiniBar = "Show only names in the Mini-Addon bar",
    SETTING_ShowMiniBarBorder = "Show Mini-Addon bar border",
    SETTING_AutoHideMiniBar = "Auto-hide Mini-Addon bar",
    SETTING_LockMiniBar = "Lock Mini-Addon bar in place",
    SETTING_LegacyMinimapSearch = "Use simple minimap scanning",
    SETTING_CharBasedEnable = "Class based 'Active'-Flag",

    -- Tooltips for settings
    TOOLTIP_MovePassiveToBack = "When enabled, addons without a config frame or clickable action will be sorted to the bottom of the addon list.",
    TOOLTIP_ShowSlashCmdInsteadOfCat = "Shows the slash command for each addon in the list instead of its category.",
    TOOLTIP_CharBasedEnable = "When enabled, the active/disabled state of addons is saved separately per class combination . When disabled, settings are shared across all combinations.",
    TOOLTIP_ShowMiniBar = "Shows or hides the Mini-Addon bar that provides quick access to your addons.",
    TOOLTIP_ShowOnlyNamesInMiniBar = "When enabled, only addon names are shown in the tooltips in the Mini-Addon bar.",
    TOOLTIP_ShowMiniBarBorder = "Shows or hides the decorative border around the Mini-Addon bar.",
    TOOLTIP_AutoHideMiniBar = "When enabled, the Mini-Addon bar will automatically hide when not in use and show when you mouse over it.",
    TOOLTIP_LockMiniBar = "Prevents the Mini-Addon bar from being moved or repositioned.",
    TOOLTIP_LegacyMinimapSearch = "Enables simple minimap scanning. Toggle off if there are any minimap buttons missing.",

    TIP_CMD = "Slash command: ",
    TIP_DEVS = "Made by ",
    TIP_TRANSLATOR = "Translated by ",
    
    NoCommand = "No command",
    
    -- Refresh button
    BTN_Refresh = "Refresh",
    TOOLTIP_Refresh = "Refresh Minimap Buttons",

    CAT=
    {
        ["Development"] = "Development",
        ["Economy"] = "Economy",
        ["Information"] = "Information",
        ["Interface"] = "Interface",
        ["Inventory"] = "Inventory",
        ["Leveling"] = "Leveling",
        ["Map"] = "Map",
        ["PvP"] = "PvP",
        ["Social"] = "Social",
        ["Crafting"] = "Crafting",
        ["Other"] = "Other",
    }
}

