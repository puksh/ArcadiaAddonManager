-- coding: utf-8

local lang={}
lang["AnchorFrame_Addition"] = [=[.
Przytrzymaj CTRL, aby zadokować.]=]
lang["But_Enable"] = "Włączony"
lang["But_Show"] = "Pokaż"
lang["description"] = "Zarządzaj swoimi addonami... Właśnie z niego korzystasz :)"
lang["SETTING_AutoHideMiniBar"] = "Automatyczne ukrywaj mini-pasek"
lang["SETTING_LockMiniBar"] = "Zablokuj mini-pasek"
lang["SETTING_LegacyMinimapSearch"] = "Użyj prostego skanowania minimapy"
lang["SETTING_MainCategory"] = "Główne"
lang["SETTING_MiniCategory"] = "Mini-pasek"
lang["SETTING_MovePassiveToBack"] = "Umieść pasywne addony na końcu listy"
lang["SETTING_ShowMiniBar"] = "Pokaż mini-pasek"
lang["SETTING_ShowMiniBarBorder"] = "Pokaż obwódkę mini-paska"
lang["SETTING_ShowOnlyNamesInMiniBar"] = "Pokazuj na mini-pasku tylko nazwy"
lang["SETTING_ShowSlashCmdInsteadOfCat"] = "Pokazuj komendy zamiast kategorii"
lang["SETTING_CharBasedEnable"] = "Aktywacja zależna od klasy"

-- Tooltips for settings
lang["TOOLTIP_MovePassiveToBack"] = "Gdy włączone, addony bez okna konfiguracji lub akcji po kliknięciu będą sortowane na koniec listy addonów."
lang["TOOLTIP_ShowSlashCmdInsteadOfCat"] = "Pokazuje komendę slash dla każdego addona na liście zamiast jego kategorii."
lang["TOOLTIP_CharBasedEnable"] = "Gdy włączone, stan aktywności/wyłączenia addonów jest zapisywany osobno dla każdej kombinacji klas. Gdy wyłączone, ustawienia są współdzielone przez wszystkie kombinacje."
lang["TOOLTIP_ShowMiniBar"] = "Pokazuje lub ukrywa mini-pasek addonów, który zapewnia szybki dostęp do Twoich addonów."
lang["TOOLTIP_ShowOnlyNamesInMiniBar"] = "Gdy włączone, po najechaniu na addona na mini-pasku tylko jego nazwa będzie pokazana."
lang["TOOLTIP_ShowMiniBarBorder"] = "Pokazuje lub ukrywa dekoracyjną obwódkę wokół mini-paska."
lang["TOOLTIP_AutoHideMiniBar"] = "Gdy włączone, mini-pasek będzie automatycznie ukrywany gdy nie jest używany i pokazywany gdy najedziesz na niego myszką."
lang["TOOLTIP_LockMiniBar"] = "Zapobiega przesuwaniu lub zmianie pozycji mini-paska."
lang["TOOLTIP_LegacyMinimapSearch"] = "Włącza proste skanowanie minimapy. Wyłącz jeżeli brakuje niektórych przycisków minimapy."

lang["TAB_Addons"] = "Wszystkie addony"
lang["TAB_MinimapButtons"] = "Przyciski Minimapy"
lang["TAB_Setup"] = "Ustawienia"

-- Tutorial tooltip for minimap buttons tab
lang["TUTORIAL_MinimapButtons_Title"] = "Przyciski Minimapy"
lang["TUTORIAL_MinimapButtons_Desc"] = "Ta zakładka wyświetla wszystkie przyciski zakotwiczone do Twojej minimapy."
lang["TUTORIAL_MinimapButtons_Line1"] = "- Kliknij wpis, aby wywołać domyślną akcję tego przycisku."
lang["TUTORIAL_MinimapButtons_Line2"] = "- Użyj lewego checkboxa, aby pokazać lub ukryć go na minimapie."
lang["TUTORIAL_MinimapButtons_Note"] = "Uwaga: Przyciski minimapy CoA są zarządzane w grze:"
lang["TUTORIAL_MinimapButtons_NotePath"] = "Ustawienia → Interfejs Użytkownika → Elementy"

lang["TIP_CMD"] = "Komenda: "
lang["TIP_DEVS"] = "Stworzone przez "
lang["TIP_MinimapButton"] = "Przycisk Minimapy"
lang["TIP_TRANSLATOR"] = "Przetłumaczone przez "
lang["NoCommand"] = "Brak komendy"

-- Refresh button
lang["BTN_Refresh"] = "Odśwież"
lang["TOOLTIP_Refresh"] = "Odśwież przyciski minimapy"

lang.CAT = {
	Crafting = "Rzemiosło",
	Development = "Zarządzanie",
	Economy = "Ekonomia",
	Information = "Informacja",
	Interface = "Interfejs",
	Inventory = "Inwentarz",
	Leveling = "Poziomowanie",
	Map = "Mapa",
	Other = "Inne",
	PvP = "Walka",
	Social = "Społeczne",
}


return lang