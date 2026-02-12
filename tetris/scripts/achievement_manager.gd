extends Node

# Singleton for managing achievements across the game
const SAVE_PATH = "user://achievements.save"

var achievements = {
	"golden_courts": {
		"name": "The Golden Courts of Wagadugu",
		"description": "Learn the value of fair exchange and trade",
		"level_requirement": 10,
		"unlocked": false
	},
	"northern_libraries": {
		"name": "The Libraries of the North",
		"description": "Rediscover the math and architecture that built the pyramids",
		"level_requirement": 20,
		"unlocked": false
	},
	"stone_fortresses": {
		"name": "The Stone Fortresses of the South",
		"description": "Learn how unity and engineering build walls that never fall",
		"level_requirement": 30,
		"unlocked": false
	},
	"sankofa_bird": {
		"name": "The Sankofa Bird",
		"description": "Master achievement - Restore all the Sun-Scrolls",
		"level_requirement": 30,
		"unlocked": false
	}
}

var highest_level_reached: int = 0

func _ready() -> void:
	load_achievements()

func check_and_unlock_achievements(current_level: int) -> Array:
	var newly_unlocked = []
	
	if current_level > highest_level_reached:
		highest_level_reached = current_level
	
	for key in achievements.keys():
		if key == "sankofa_bird":
			continue
		
		var achievement = achievements[key]
		if not achievement.unlocked and highest_level_reached >= achievement.level_requirement:
			achievement.unlocked = true
			newly_unlocked.append(achievement)
	
	# Check if all main achievements are unlocked for Sankofa Bird
	if not achievements.sankofa_bird.unlocked:
		if achievements.golden_courts.unlocked and \
		   achievements.northern_libraries.unlocked and \
		   achievements.stone_fortresses.unlocked:
			achievements.sankofa_bird.unlocked = true
			newly_unlocked.append(achievements.sankofa_bird)
	
	if newly_unlocked.size() > 0:
		save_achievements()
	
	return newly_unlocked

func get_all_achievements() -> Dictionary:
	return achievements

func get_achievement_progress() -> Dictionary:
	var unlocked_count = 0
	var total_count = achievements.size()
	
	for achievement in achievements.values():
		if achievement.unlocked:
			unlocked_count += 1
	
	return {
		"unlocked": unlocked_count,
		"total": total_count,
		"percentage": (float(unlocked_count) / float(total_count)) * 100.0
	}

func save_achievements() -> void:
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"achievements": achievements,
			"highest_level": highest_level_reached
		}
		save_file.store_var(save_data)
		save_file.close()

func load_achievements() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if save_file:
			var save_data = save_file.get_var()
			if save_data.has("achievements"):
				achievements = save_data.achievements
			if save_data.has("highest_level"):
				highest_level_reached = save_data.highest_level
			save_file.close()

func reset_achievements() -> void:
	for achievement in achievements.values():
		achievement.unlocked = false
	highest_level_reached = 0
	save_achievements()
