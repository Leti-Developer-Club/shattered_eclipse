extends Node

# Audio players for different music tracks
var title_player: AudioStreamPlayer
var gameplay_player: AudioStreamPlayer
var gameover_player: AudioStreamPlayer

# Audio players for sound effects
var level_up_player: AudioStreamPlayer
var line_clear_player: AudioStreamPlayer

# Track what's currently playing
var current_track: String = ""

func _ready() -> void:
	# Create audio players for music
	title_player = AudioStreamPlayer.new()
	gameplay_player = AudioStreamPlayer.new()
	gameover_player = AudioStreamPlayer.new()
	
	# Create audio players for sound effects
	level_up_player = AudioStreamPlayer.new()
	line_clear_player = AudioStreamPlayer.new()
	
	add_child(title_player)
	add_child(gameplay_player)
	add_child(gameover_player)
	add_child(level_up_player)
	add_child(line_clear_player)
	
	# Load audio files
	title_player.stream = load("res://assets/sound/01 Title.mp3")
	gameplay_player.stream = load("res://assets/sound/02 A-Type Music (version 1.1).mp3")
	gameover_player.stream = load("res://assets/sound/08 Game Over.mp3")
	level_up_player.stream = load("res://assets/sound/level_upgrade.mp3")
	line_clear_player.stream = load("res://assets/sound/line_clear.mp3")
	
	# Set all music to Music bus
	title_player.bus = "Music"
	gameplay_player.bus = "Music"
	gameover_player.bus = "Music"
	
	# Set sound effects to SFX bus
	level_up_player.bus = "SFX"
	line_clear_player.bus = "SFX"
	
	# Start with title music
	play_title_music()

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
	if gameplay_player.stream:
		gameplay_player.play()

func play_gameover_music() -> void:
	if current_track == "gameover":
		return
	
	stop_all()
	current_track = "gameover"
	if gameover_player.stream:
		gameover_player.play()

func stop_all() -> void:
	title_player.stop()
	gameplay_player.stop()
	gameover_player.stop()

func set_volume(volume_db: float) -> void:
	title_player.volume_db = volume_db
	gameplay_player.volume_db = volume_db
	gameover_player.volume_db = volume_db

# Sound effects
func play_level_up_sfx() -> void:
	if level_up_player.stream:
		level_up_player.play()

func play_line_clear_sfx() -> void:
	if line_clear_player.stream:
		line_clear_player.play()
