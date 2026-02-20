extends Node

# Audio players for different music tracks
var title_player: AudioStreamPlayer
var gameplay_players: Array[AudioStreamPlayer] = []
var current_gameplay_index: int = 0
var gameover_player: AudioStreamPlayer
var stage_clear_player: AudioStreamPlayer

# Audio players for sound effects
var level_up_player: AudioStreamPlayer
var line_clear_player: AudioStreamPlayer
var button_click_players: Array[AudioStreamPlayer] = []
var current_click_index: int = 0

# Track what's currently playing
var current_track: String = ""

func _ready() -> void:
	# Create audio players for music
	title_player = AudioStreamPlayer.new()
	gameover_player = AudioStreamPlayer.new()
	stage_clear_player = AudioStreamPlayer.new()
	
	# Create three gameplay music players
	for i in range(3):
		var player = AudioStreamPlayer.new()
		gameplay_players.append(player)
		add_child(player)
	
	# Create audio players for sound effects
	level_up_player = AudioStreamPlayer.new()
	line_clear_player = AudioStreamPlayer.new()
	
	# Create multiple button click players for polyphony
	for i in range(5):
		var player = AudioStreamPlayer.new()
		button_click_players.append(player)
		add_child(player)
	
	add_child(title_player)
	add_child(gameover_player)
	add_child(stage_clear_player)
	add_child(level_up_player)
	add_child(line_clear_player)
	
	# Load audio files
	title_player.stream = load("res://assets/sound/leti_sounds/musicloop1.mp3")
	gameplay_players[0].stream = load("res://assets/sound/leti_sounds/musicloop.wav")
	gameplay_players[1].stream = load("res://assets/sound/leti_sounds/musicloop.wav")
	gameplay_players[2].stream = load("res://assets/sound/leti_sounds/musicloop.wav")
	stage_clear_player.stream = load( "res://assets/sound/leti_sounds/musicloop1.mp3" )
	gameover_player.stream = load("res://assets/sound/leti_sounds/Timebound_Sfx_On Death.wav")
	level_up_player.stream = load( "res://assets/sound/leti_sounds/Timebound_Sfx_Collectible Diamond.wav" )
	line_clear_player.stream = load( "res://assets/sound/leti_sounds/Timebound_Sfx_Collectible Gold.wav" )
	
	# Load button click sound for all button click players
	for player in button_click_players:
		player.stream = load( "res://assets/sound/leti_sounds/MenuNavigate2.wav" )
	
	# Set all music to Music bus
	title_player.bus = "Music"
	for player in gameplay_players:
		player.bus = "Music"
	gameover_player.bus = "Music"
	stage_clear_player.bus = "Music"
	
	# Set sound effects to SFX bus
	level_up_player.bus = "SFX"
	line_clear_player.bus = "SFX"
	for player in button_click_players:
		player.bus = "SFX"
	
	# Connect finished signals for looping
	title_player.finished.connect(_on_title_finished)
	for i in range(gameplay_players.size()):
		gameplay_players[i].finished.connect(_on_gameplay_finished)
	
	# Start with title music
	play_title_music()

func _on_title_finished() -> void:
	if current_track == "title":
		title_player.play()

func _on_gameplay_finished() -> void:
	if current_track == "gameplay":
		# Move to next track in the cycle
		current_gameplay_index = (current_gameplay_index + 1) % gameplay_players.size()
		gameplay_players[current_gameplay_index].play()

func play_title_music() -> void:
	if current_track == "title":
		return
	
	stop_all()
	current_track = "title"
	if title_player.stream:
		title_player.play()

func play_gameplay_music() -> void:
	if current_track == "gameplay":
		return
	
	stop_all()
	current_track = "gameplay"
	current_gameplay_index = 0  # Start with A-Type
	if gameplay_players[current_gameplay_index].stream:
		gameplay_players[current_gameplay_index].play()

func play_gameover_music() -> void:
	if current_track == "gameover":
		return
	
	stop_all()
	current_track = "gameover"
	if gameover_player.stream:
		gameover_player.play()

func stop_all() -> void:
	title_player.stop()
	for player in gameplay_players:
		player.stop()
	gameover_player.stop()
	stage_clear_player.stop()

func set_volume(volume_db: float) -> void:
	title_player.volume_db = volume_db
	for player in gameplay_players:
		player.volume_db = volume_db
	gameover_player.volume_db = volume_db
	stage_clear_player.volume_db = volume_db

func play_stage_clear_music() -> void:
	if current_track == "stage_clear":
		return
	
	stop_all()
	current_track = "stage_clear"
	if stage_clear_player.stream:
		stage_clear_player.play()

# Sound effects
func play_level_up_sfx() -> void:
	if level_up_player.stream:
		level_up_player.play()

func play_line_clear_sfx() -> void:
	if line_clear_player.stream:
		line_clear_player.play()

func play_button_click_sfx() -> void:
	# Use round-robin to play on different players for polyphony
	if button_click_players.size() > 0 and button_click_players[current_click_index].stream:
		button_click_players[current_click_index].play()
	
	# Move to next player for next click
	current_click_index = (current_click_index + 1) % button_click_players.size()
