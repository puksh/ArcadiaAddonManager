-- coding: utf-8

local lang={}
lang["AnchorFrame_Addition"] = "Maintenir CTRL pour déplacer."
lang["But_Enable"] = "Activé"
lang["But_Show"] = "Afficher"
lang["description"] = "Gérez vos Addons en toute simplicité ;) "
lang["SETTING_AutoHideMiniBar"] = "Cacher Automatiquement la Mini-barre"
lang["SETTING_LockMiniBar"] = "Verrouiller la Mini-Barre"
lang["SETTING_MainCategory"] = "Principale"
lang["SETTING_MiniCategory"] = "Mini-Barre"
lang["SETTING_MovePassiveToBack"] = "Trier les addons passifs à la fin de la liste."
lang["SETTING_ShowMiniBar"] = "Afficher la Mini-Barre"
lang["SETTING_ShowMiniBarBorder"] = "Afficher contour Mini-Barre"
lang["SETTING_ShowOnlyNamesInMiniBar"] = "Afficher uniquement les noms dans la Mini-Barre"
lang["SETTING_ShowSlashCmdInsteadOfCat"] = "Afficher commande slash au lieu des catégories"
lang["SETTING_CharBasedEnable"] = "'Actif'-Flag basé sur la classe"
lang["SETTING_LegacyMinimapSearch"] = "Utiliser le scan simple de la minimap"

-- Tooltips for settings
lang["TOOLTIP_MovePassiveToBack"] = "Lorsque activé, les addons sans fenêtre de configuration ou action cliquable seront triés en bas de la liste des addons."
lang["TOOLTIP_ShowSlashCmdInsteadOfCat"] = "Affiche la commande slash pour chaque addon dans la liste au lieu de sa catégorie."
lang["TOOLTIP_CharBasedEnable"] = "Lorsque activé, l'état actif/désactivé des addons est sauvegardé séparément pour chaque combinaison de classes. Lorsque désactivé, les paramètres sont partagés entre toutes les combinaisons."
lang["TOOLTIP_ShowMiniBar"] = "Affiche ou masque la Mini-Barre d'addons qui offre un accès rapide à vos addons."
lang["TOOLTIP_ShowOnlyNamesInMiniBar"] = "Lorsque activé, seuls les noms des addons sont affichés dans les info-bulles de la Mini-Barre."
lang["TOOLTIP_ShowMiniBarBorder"] = "Affiche ou masque la bordure décorative autour de la Mini-Barre."
lang["TOOLTIP_AutoHideMiniBar"] = "Lorsque activé, la Mini-Barre se masquera automatiquement lorsqu'elle n'est pas utilisée et s'affichera lorsque vous passez la souris dessus."
lang["TOOLTIP_LockMiniBar"] = "Empêche la Mini-Barre d'être déplacée ou repositionnée."
lang["TOOLTIP_LegacyMinimapSearch"] = "Active le scan simple de la minimap. Désactiver si des boutons de minimap manquent."

lang["TAB_Addons"] = "Tous les Addons"
lang["TAB_MinimapButtons"] = "Boutons Minimap"
lang["TAB_Setup"] = "Configuration"

-- Tutorial tooltip for minimap buttons tab
lang["TUTORIAL_MinimapButtons_Title"] = "Boutons Minimap"
lang["TUTORIAL_MinimapButtons_Desc"] = "Cet onglet liste tous les boutons ancrés à votre minimap."
lang["TUTORIAL_MinimapButtons_Line1"] = "- Cliquez sur une entrée pour déclencher l'action par défaut de ce bouton."
lang["TUTORIAL_MinimapButtons_Line2"] = "- Utilisez la case à cocher de gauche pour l'afficher ou le masquer sur la minimap."
lang["TUTORIAL_MinimapButtons_Note"] = "Note: Les boutons minimap CoA sont gérés dans le jeu:"
lang["TUTORIAL_MinimapButtons_NotePath"] = "Paramètres → Interface Utilisateur → Éléments"

lang["TIP_CMD"] = "Commande slash:"
lang["TIP_DEVS"] = "Créer par"
lang["TIP_MinimapButton"] = "Bouton Minimap"
lang["TIP_TRANSLATOR"] = "Traduit par:"
lang["NoCommand"] = "Aucune commande"

-- Refresh button
lang["BTN_Refresh"] = "Actualiser"
lang["TOOLTIP_Refresh"] = "Actualiser les boutons de la minimap"
lang.CAT = {
	Crafting = "Crafting",
	Development = "Développement",
	Economy = "Economie",
	Information = "Information",
	Interface = "Interface",
	Inventory = "Inventaire",
	Leveling = "Leveling",
	Map = "Carte",
	Other = "Autre",
	PvP = "PvP",
	Social = "Social",
}


return lang
