-- coding: utf-8

local lang={}
lang["AnchorFrame_Addition"] = "Зажми CTRL, чтобы претащить."
lang["But_Enable"] = "Включено"
lang["But_Show"] = "Показать"
lang["description"] = "Управляет твоими плагинами... Ты видишь это прямо сейчас ;)"
lang["SETTING_AutoHideMiniBar"] = "Автоскрытие минипанели"
lang["SETTING_LockMiniBar"] = "Зафиксировать минипанель"
lang["SETTING_MainCategory"] = "Главные"
lang["SETTING_MiniCategory"] = "Минипанель"
lang["SETTING_MovePassiveToBack"] = "Пассивные плагины в конце списка"
lang["SETTING_ShowMiniBar"] = "Минипанель"
lang["SETTING_ShowMiniBarBorder"] = "Граница минипанели"
lang["SETTING_ShowOnlyNamesInMiniBar"] = "Только имена в минипанели"
lang["SETTING_ShowSlashCmdInsteadOfCat"] = "Слеш комманды вместо категории"
lang["SETTING_CharBasedEnable"] = "Флаг 'Активен' зависит от класса"
lang["SETTING_LegacyMinimapSearch"] = "Использовать простое сканирование миникарты"

-- Tooltips for settings
lang["TOOLTIP_MovePassiveToBack"] = "Когда включено, плагины без окна настроек или кликабельного действия будут отсортированы в конец списка плагинов."
lang["TOOLTIP_ShowSlashCmdInsteadOfCat"] = "Показывает слеш-команду для каждого плагина в списке вместо его категории."
lang["TOOLTIP_CharBasedEnable"] = "Когда включено, состояние активности/выключения плагинов сохраняется отдельно для каждой комбинации классов. Когда выключено, настройки общие для всех комбинаций."
lang["TOOLTIP_ShowMiniBar"] = "Показывает или скрывает минипанель плагинов, которая обеспечивает быстрый доступ к вашим плагинам."
lang["TOOLTIP_ShowOnlyNamesInMiniBar"] = "Когда включено, в подсказках минипанели показываются только имена плагинов."
lang["TOOLTIP_ShowMiniBarBorder"] = "Показывает или скрывает декоративную границу вокруг минипанели."
lang["TOOLTIP_AutoHideMiniBar"] = "Когда включено, минипанель будет автоматически скрываться когда не используется и показываться при наведении мыши."
lang["TOOLTIP_LockMiniBar"] = "Предотвращает перемещение или изменение позиции минипанели."
lang["TOOLTIP_LegacyMinimapSearch"] = "Включает простое сканирование миникарты. Отключите если отсутствуют некоторые кнопки миникарты."

lang["TAB_Addons"] = "Все плагины"
lang["TAB_MinimapButtons"] = "Кнопки миникарты"
lang["TAB_Setup"] = "Настройки"

-- Tutorial tooltip for minimap buttons tab
lang["TUTORIAL_MinimapButtons_Title"] = "Кнопки миникарты"
lang["TUTORIAL_MinimapButtons_Desc"] = "Эта вкладка перечисляет все кнопки, прикрепленные к вашей миникарте."
lang["TUTORIAL_MinimapButtons_Line1"] = "- Нажмите на запись, чтобы вызвать действие по умолчанию для этой кнопки."
lang["TUTORIAL_MinimapButtons_Line2"] = "- Используйте левый чекбокс, чтобы показать или скрыть её на миникарте."
lang["TUTORIAL_MinimapButtons_Note"] = "Примечание: Кнопки миникарты CoA управляются в игре:"
lang["TUTORIAL_MinimapButtons_NotePath"] = "Настройки → Пользовательский интерфейс → Элементы"

lang["TIP_CMD"] = "Слеш комманда:"
lang["TIP_DEVS"] = "Сделано " -- Needs review
lang["TIP_MinimapButton"] = "Кнопка миникарты"
lang["TIP_TRANSLATOR"] = "Переведено " -- Needs review
lang["NoCommand"] = "Нет команды"

-- Refresh button
lang["BTN_Refresh"] = "Обновить"
lang["TOOLTIP_Refresh"] = "Обновить кнопки миникарты"
lang.CAT = {
	Crafting = "Ремесло", -- Needs review
	Development = "Развитие",
	Economy = "Экономика",
	Information = "Информация",
	Interface = "Интерфейс",
	Inventory = "Рюкзак",
	Leveling = "Прогресс",
	Map = "Карта",
	Other = "Остальное",
	PvP = "ПвП",
	Social = "Общение", -- Needs review
}


return lang