-- coding: utf-8

local lang={}
lang["AnchorFrame_Addition"] = "자동 붙이기를 멈추려면 CTRL 키를 누른 상태 유지"
lang["But_Enable"] = "활성화"
lang["But_Show"] = "보여주기"
lang["description"] = "당신의 애드온들을 관리하세요...You're looking at it right now ;)"
lang["SETTING_AutoHideMiniBar"] = "미니 애드온 바 자동 감추기"
lang["SETTING_LockMiniBar"] = "미니 애드온 바 위치 잠금"
lang["SETTING_MainCategory"] = "메인"
lang["SETTING_MiniCategory"] = "미니 애드온 바"
lang["SETTING_MovePassiveToBack"] = "패시브 애드온을 목록 뒤로 정리"
lang["SETTING_ShowMiniBar"] = "미니 애드온 바 보여주기"
lang["SETTING_ShowMiniBarBorder"] = "미니 애드온 바 테두리 보여주기"
lang["SETTING_ShowOnlyNamesInMiniBar"] = "미니 애드온 바에 이름만 보여주기"
lang["SETTING_ShowSlashCmdInsteadOfCat"] = "종류별 분류대신 슬래쉬 명령어 보여주기"
lang["SETTING_CharBasedEnable"] = "클래스 기반 '활성화' 플래그"
lang["SETTING_LegacyMinimapSearch"] = "간단한 미니맵 스캔 사용"

-- Tooltips for settings
lang["TOOLTIP_MovePassiveToBack"] = "활성화하면 설정 창이나 클릭 가능한 동작이 없는 애드온이 애드온 목록 맨 아래로 정렬됩니다."
lang["TOOLTIP_ShowSlashCmdInsteadOfCat"] = "목록의 각 애드온에 대해 카테고리 대신 슬래시 명령을 표시합니다."
lang["TOOLTIP_CharBasedEnable"] = "활성화하면 애드온의 활성/비활성 상태가 각 클래스 조합별로 별도로 저장됩니다. 비활성화하면 모든 조합에서 설정이 공유됩니다."
lang["TOOLTIP_ShowMiniBar"] = "애드온에 빠르게 액세스할 수 있는 미니 애드온 바를 표시하거나 숨깁니다."
lang["TOOLTIP_ShowOnlyNamesInMiniBar"] = "활성화하면 미니 애드온 바의 툴팁에 애드온 이름만 표시됩니다."
lang["TOOLTIP_ShowMiniBarBorder"] = "미니 애드온 바 주변의 장식 테두리를 표시하거나 숨깁니다."
lang["TOOLTIP_AutoHideMiniBar"] = "활성화하면 미니 애드온 바가 사용하지 않을 때 자동으로 숨겨지고 마우스를 올리면 표시됩니다."
lang["TOOLTIP_LockMiniBar"] = "미니 애드온 바가 이동하거나 위치가 변경되는 것을 방지합니다."
lang["TOOLTIP_LegacyMinimapSearch"] = "간단한 미니맵 스캔을 활성화합니다. 미니맵 버튼이 누락된 경우 토글을 끕니다."

lang["TAB_Addons"] = "모든 애드온들"
lang["TAB_MinimapButtons"] = "미니맵 버튼"
lang["TAB_Setup"] = "설정"

-- Tutorial tooltip for minimap buttons tab
lang["TUTORIAL_MinimapButtons_Title"] = "미니맵 버튼"
lang["TUTORIAL_MinimapButtons_Desc"] = "이 탭은 미니맵에 고정된 모든 버튼을 나열합니다."
lang["TUTORIAL_MinimapButtons_Line1"] = "- 항목을 클릭하여 해당 버튼의 기본 작업을 트리거합니다."
lang["TUTORIAL_MinimapButtons_Line2"] = "- 왼쪽 체크박스를 사용하여 미니맵에 표시하거나 숨깁니다."
lang["TUTORIAL_MinimapButtons_Note"] = "참고: CoA 미니맵 버튼은 게임 내에서 관리됩니다:"
lang["TUTORIAL_MinimapButtons_NotePath"] = "설정 → 사용자 인터페이스 → 요소"

lang["TIP_CMD"] = "슬래쉬 명령어:"
lang["TIP_DEVS"] = "제작: " -- Needs review
lang["TIP_MinimapButton"] = "미니맵 버튼"
lang["TIP_TRANSLATOR"] = "번역: " -- Needs review
lang["NoCommand"] = "명령 없음"
lang.CAT = {
	Crafting = "제조",
	Development = "개발",
	Economy = "경제",
	Information = "정보",
	Interface = "화면",
	Inventory = "가방",
	Leveling = "레벨",
	Map = "지도",
	Other = "기타",
	PvP = "대전",
	Social = "사회",
}


return lang