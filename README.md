This is a modified version of AddonManager for the Chronicles of Arcadia.
Original addon by Alleris, maintained by McBen - based on ver 6.0.7 - 2014-03-20.

### Added

- **Tooltips for Settings** - all setting checkboxes now have helpful tooltips explaining what they do
- **Mouse Wheel Scrolling** - use mouse wheel to scroll through addon pages
- **Instant Settings Application** - settings now apply immediately when toggled and are automatically saved

### Removed

- **Save Button** - no longer needed since settings are applied and saved instantly when changed

### Fixed

- **Category Filtering** - categories now properly filter addons in the Addons tab
- **Addon Enable/Disable** - addon enabling and disabling now works correctly
- **Pagination** - made it hide when there are no pages to switch from and made it actually hide itself when they are not needed
- **Settings Tab Icon** - resized settings tab icon to no longer be stretched
- **Slash Command** - some addons used singular form of SlashCommand instead of SlashCommands, now its shown in the list and in tooltips
- **Minimap Tab refreshing** - fix for the freeze that happened when switching to this tab, no longer pulls a group of elements, now just checks the static list

### Changed

- **Minimap Button Management** - moved AddonManager's own minimap button to the Minimap Buttons tab instead of being placed as a toggle in the settings (like, why?)
- **UI Layout - Minimap Tab** - Bigger text area for button names for better readability
- **Updated Minimap Buttons list**:
- CombatEngine (CE_BUTTON)
- ItemPreview2 (IP2_Minimap)
- PetInfo (PetInfoStartButton) - it's broken due to it being correctly implemented into the XBar (but still, yipee!)
- LackBuffs (LB_Minimap)
- DungeonLoots (DL_Minimap)
