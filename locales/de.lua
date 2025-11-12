-- coding: utf-8

local lang={}
lang["AnchorFrame_Addition"] = [=[.
Strg halten um Andocken zu verhinden.]=]
lang["But_Enable"] = "Aktiv"
lang["But_Show"] = "Zeigen"
lang["description"] = "Verwaltet deine Addons... Du siehst es gerade an;)"
lang["SETTING_AutoHideMiniBar"] = "Automatisch ausblenden"
lang["SETTING_CharBasedEnable"] = "'Aktiv'-Flag Klassen abhängig"
lang["SETTING_LockMiniBar"] = "Fixiere Position"
lang["SETTING_MainCategory"] = "Haupt"
lang["SETTING_MiniCategory"] = "Mini-Addon Leiste"
lang["SETTING_MovePassiveToBack"] = "Sortiere passive Addons ans Ende"
lang["SETTING_ShowMiniBar"] = "Zeige Mini-Addon-Leiste"
lang["SETTING_ShowMiniBarBorder"] = "Zeige Rahmen"
lang["SETTING_ShowOnlyNamesInMiniBar"] = "Zeige nur Namen"
lang["SETTING_ShowSlashCmdInsteadOfCat"] = "Zeige Slash Kommando anstelle der Kategorie"
lang["SETTING_LegacyMinimapSearch"] = "Verwende einfaches Minimap-Scannen"

-- Tooltips for settings
lang["TOOLTIP_MovePassiveToBack"] = "Wenn aktiviert, werden Addons ohne Konfigurations-Fenster oder anklickbare Aktion ans Ende der Addon-Liste sortiert."
lang["TOOLTIP_ShowSlashCmdInsteadOfCat"] = "Zeigt für jedes Addon in der Liste den Slash-Befehl anstelle der Kategorie."
lang["TOOLTIP_CharBasedEnable"] = "Wenn aktiviert, wird der aktiv/deaktiviert-Status von Addons separat für jede Klassenkombination gespeichert. Wenn deaktiviert, werden Einstellungen über alle Kombinationen geteilt."
lang["TOOLTIP_ShowMiniBar"] = "Zeigt oder verbirgt die Mini-Addon-Leiste, die schnellen Zugriff auf Ihre Addons bietet."
lang["TOOLTIP_ShowOnlyNamesInMiniBar"] = "Wenn aktiviert, werden in den Tooltips der Mini-Addon-Leiste nur die Addon-Namen angezeigt."
lang["TOOLTIP_ShowMiniBarBorder"] = "Zeigt oder verbirgt den dekorativen Rahmen um die Mini-Addon-Leiste."
lang["TOOLTIP_AutoHideMiniBar"] = "Wenn aktiviert, wird die Mini-Addon-Leiste automatisch ausgeblendet, wenn sie nicht verwendet wird, und angezeigt, wenn Sie mit der Maus darüber fahren."
lang["TOOLTIP_LockMiniBar"] = "Verhindert das Verschieben oder Neupositionieren der Mini-Addon-Leiste."
lang["TOOLTIP_LegacyMinimapSearch"] = "Aktiviert einfaches Minimap-Scannen. Deaktivieren, falls Minimap-Buttons fehlen."

lang["TAB_Addons"] = "Alle Addons"
lang["TAB_MinimapButtons"] = "Minimap Buttons"
lang["TAB_Setup"] = "Einstellungen"

-- Tutorial tooltip for minimap buttons tab
lang["TUTORIAL_MinimapButtons_Title"] = "Minimap Buttons"
lang["TUTORIAL_MinimapButtons_Desc"] = "Dieser Tab listet alle Buttons auf, die an Ihrer Minimap verankert sind."
lang["TUTORIAL_MinimapButtons_Line1"] = "- Klicken Sie auf einen Eintrag, um die Standardaktion dieses Buttons auszulösen."
lang["TUTORIAL_MinimapButtons_Line2"] = "- Verwenden Sie die linke Checkbox, um ihn auf der Minimap anzuzeigen oder auszublenden."
lang["TUTORIAL_MinimapButtons_Note"] = "Hinweis: CoA-Minimap-Buttons werden im Spiel verwaltet:"
lang["TUTORIAL_MinimapButtons_NotePath"] = "Einstellungen → Benutzeroberfläche → Elemente"

lang["TIP_CMD"] = "Slash Kommando: "
lang["TIP_DEVS"] = "Entwickelt von "
lang["TIP_MinimapButton"] = "Minimap Button"
lang["TIP_TRANSLATOR"] = "Übersetzung von "
lang["NoCommand"] = "Kein Befehl"
lang.CAT = {
	Crafting = "Berufe",
	Development = "Entwicklung",
	Economy = "Wirtschaft",
	Information = "Information",
	Interface = "Interface",
	Inventory = "Inventory",
	Leveling = "Leveling",
	Map = "Karten",
	Other = "anderes",
	PvP = "PvP",
	Social = "Soziales",
}





return lang

