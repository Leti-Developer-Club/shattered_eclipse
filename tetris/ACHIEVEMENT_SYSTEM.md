# Achievement System - Chronicles of the Sun Kings

## Overview
The game now features a level-based achievement system that unlocks story content as players progress through Tetris levels.

## Achievement Structure

### 3 Main Quests (Level-Based)
1. **The Golden Courts of Wagadugu** (Level 0-10)
   - Unlocks at Level 10
   - Theme: Fair exchange and trade

2. **The Libraries of the North** (Level 11-20)
   - Unlocks at Level 20
   - Theme: Math and architecture (pyramids)

3. **The Stone Fortresses of the South** (Level 21-30)
   - Unlocks at Level 30
   - Theme: Unity and engineering

### Master Achievement
4. **The Sankofa Bird**
   - Unlocks when all 3 main quests are completed
   - Represents full restoration of the Sun-Scrolls

## How It Works

### Level Progression
- Every 10 lines cleared = 1 level up
- Level 0 → 10 = First achievement
- Level 11 → 20 = Second achievement
- Level 21 → 30 = Third achievement + Sankofa Bird

### Achievement Tracking
- Achievements are saved automatically to `user://achievements.save`
- Progress persists across game sessions
- Highest level reached is tracked

### In-Game Notifications
- When a level milestone is reached, a gold notification appears
- Shows achievement name for 3 seconds
- Fades out automatically

### Achievements Screen
- Accessible from main menu
- Shows all 4 achievements with checkboxes
- Displays progress percentage
- Shows requirements for each achievement

## Game Modes

### Story Mode
- Same Tetris gameplay
- Achievement system active
- Unlocks narrative content

### Classic Mode
- Pure Tetris experience
- No achievement tracking
- No story elements

## Files Created
- `scripts/achievement_manager.gd` - Singleton for managing achievements
- `scripts/achievements_screen.gd` - UI for displaying achievements
- `scenes/achievements_screen.tscn` - Achievement screen layout
- `scripts/mode_select.gd` - Mode selection logic
- `scenes/mode_select.tscn` - Mode selection UI

## Next Steps (Future Development)
- Add story cutscenes/dialogue when achievements unlock
- Theme tetrominoes per region
- Add background art for each achievement tier
- Implement different Tetris challenges per quest
- Add sound effects for achievement unlocks
