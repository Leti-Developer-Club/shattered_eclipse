extends Node

# Singleton for managing achievements across the game
const SAVE_PATH = "user://achievements.save"
const STORY_PROGRESS_PATH = "user://story_progress.save"

var achievements = {
	"anufo_tribe": {
		"name": "Anufo Tribe",
		"description": "Discover the smithing village of the Anufo tribe",
		"level_requirement": 1,
		"unlocked": false,
		"pages": [
			"The Anufo or Chakosi are an Akan people who live in the Dapaong and (Sansanné-)Mango areas of Togo, as well as in Ghana. They trace their origin to a place called Anou or Ano on the Komoé River in the Ivory Coast. Thus, they refer to themselves Anoufou \"people of Anu\".",
			"The Anufor hardly ambushed any village they intended to attack. They would usually send a messenger to announce the possibility of war if the chief did not yield to the demands of supplying food and livestock to the army commanders of the Anou. The messenger thus presents pellets and corn, choosing the former meant they were prepared for war, the latter meant their demands will be met.",
			"The prefix (Na/Nam) has been added to each name of the military commanders to read Biemah and Somah. This is so because, in Anufor culture, one cannot mention the name of a grandfather without that prefix which often translates to 'Nana' or grandfather in several Akan dialects. The names of these commanders are still used throughout Anuforland and quite common with the descendants of the two commanders who form the only two recognised royal families/gates in Anuforland that ascend to the skin of kingship in Nzara or SanSanne Mango."
		]
	},
	"ashanti_kingdom": {
		"name": "Ashanti Kingdom",
		"description": "Uncover the rich history of the Ashanti Kingdom",
		"level_requirement": 2,
		"unlocked": false,
		"pages": [
			"The Asante, are a major ethnic group within the Akan people, native to the Ashanti Region of modern-day Ghana, with significant populations also in Togo and Côte d'Ivoire. They are one of Ghana's largest and most influential ethnic groups, with an estimated population of over 4.7 million people.",
			"The Ashanti developed a powerful empire in the 17th century, centered in Kumasi, which became the capital in 1680 under Asantehene Osei Kofi Tutu I. The empire rose to prominence through control of gold mines and participation in the trans-Saharan and Atlantic slave trades, becoming a dominant force in West Africa by the 18th century.",
			"The Golden Stool is the most sacred symbol of the Ashanti nation, believed to contain the soul of the people and representing unity, spiritual authority, and national identity. It has never touched the ground and is never sat upon. Spiritually, the Ashanti practice a blend of traditional beliefs, including reverence for Nyame, the Supreme Being, abosom (nature spirits), and ancestors."
		]
	},
	"ga_tribe": {
		"name": "The Ga Tribe",
		"description": "Learn about the Ga people and their resilience",
		"level_requirement": 3,
		"unlocked": false,
		"pages": [
			"Ga people are believed to have migrated from the eastern regions of West Africa, possibly from Lake Chad, through the Niger River basin, and into present-day Ghana by the 17th century. Oral traditions recount a long migration journey, including stops in Nigeria, Togo, and Benin, with some legends suggesting origins in ancient Israel, linking them to the tribes of Dan and Gad—though this is not supported by mainstream historical or archaeological evidence.",
			"They maintain a strong cultural identity, celebrated annually through the Homowo Festival, a harvest celebration that commemorates their survival after a famine. The Ga practice matrilineal descent for property inheritance and patrilineal descent for public office, reflecting a complex social structure.",
			"Around the turn of the twentieth century Accra experienced a series of disasters, including famines, a fire in 1894, an earthquake in 1906, bubonic plague, and the influenza pandemic of 1918-1919, as well as continuous emigration of skilled laborers. A severe earthquake in 1939 destroyed much of Central Accra and gave added impetus to settle in new suburban settlements such as Kaneshie and Adabraka."
		]
	},
	"fante_people": {
		"name": "The Fantes - Coastal Region",
		"description": "Explore the coastal traditions of the Fante",
		"level_requirement": 4,
		"unlocked": false,
		"pages": [
			"The Fante (Mfantsefo) are a major Akan subgroup primarily inhabiting the central coastal regions of Ghana, known for forming a powerful confederacy against the Ashanti Empire, their significant role in trade, and rich matrilineal traditions centered in Mankessim, their spiritual capital, with distinct Fante dialects and strong cultural ties to fishing and maritime history.",
			"Their traditional food includes Kenkey, Banku (Etsew) that is eaten with fish including Tilapia and other seafood, fresh pepper and vegetables. Many Fante's from the interior also traditionally eat yam and coco yams (ampesie) and fufu. The Oguaa Fetu Afahye (an annual traditional festival celebrated in Cape Coast) is actually a yam harvest festival that was previously celebrated in the Bono Kingdom and was brought to the coast during the exodus.",
			"Fetu Afahye Festival is one of the most important festivals celebrated by the Fante ethnic group. It is celebrated as a remembrance of a historic disease outbreak, to keep the towns clean and to prevent another epidemic befalling the Fante people."
		]
	},
	"sankofa_bird": {
		"name": "The Sankofa Bird",
		"description": "Master achievement - Restore all the Sun-Scrolls",
		"level_requirement": 5,
		"unlocked": false,
		"pages": [
			"The Sankofa symbol represents the Akan concept: 'Se wo were fi na wosankofa a yenkyi' - 'It is not taboo to go back and fetch what you forgot.' This wisdom teaches that we must look to the past to build a successful future.",
			"You have journeyed through the histories of the Anufo smiths, the Ashanti empire, the Ga migrations, and the Fante coastal traditions. Each piece of knowledge you've gathered represents a fragment of Africa's rich heritage that must never be forgotten.",
			"As a master Griot, you now carry the responsibility of preserving and sharing these stories. The Sun-Scrolls are restored, and the light of African history shines bright once more. Remember: learning from the past is not dwelling on it, but honoring it to create a better tomorrow."
		]
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
	
	# Check if Sankofa Bird should unlock at level 5
	if not achievements.sankofa_bird.unlocked:
		if highest_level_reached >= achievements.sankofa_bird.level_requirement:
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
			# Only load unlock status and level, not the achievement data itself
			if save_data.has("achievements"):
				var saved_achievements = save_data.achievements
				for key in achievements.keys():
					if saved_achievements.has(key):
						achievements[key].unlocked = saved_achievements[key].unlocked
			if save_data.has("highest_level"):
				highest_level_reached = save_data.highest_level
			save_file.close()

func reset_achievements() -> void:
	for achievement in achievements.values():
		achievement.unlocked = false
	highest_level_reached = 0
	save_achievements()

# DEBUG: Unlock all achievements for testing
func unlock_all_achievements() -> void:
	for achievement in achievements.values():
		achievement.unlocked = true
	highest_level_reached = 5
	save_achievements()

# Story Mode Progress Management
func save_story_progress(level: int, score: int, lines: int) -> void:
	var save_file = FileAccess.open(STORY_PROGRESS_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"level": level,
			"score": score,
			"lines_cleared": lines
		}
		save_file.store_var(save_data)
		save_file.close()

func load_story_progress() -> Dictionary:
	if FileAccess.file_exists(STORY_PROGRESS_PATH):
		var save_file = FileAccess.open(STORY_PROGRESS_PATH, FileAccess.READ)
		if save_file:
			var save_data = save_file.get_var()
			save_file.close()
			return save_data
	return {}

func has_story_progress() -> bool:
	return FileAccess.file_exists(STORY_PROGRESS_PATH)

func clear_story_progress() -> void:
	if FileAccess.file_exists(STORY_PROGRESS_PATH):
		DirAccess.remove_absolute(STORY_PROGRESS_PATH)
