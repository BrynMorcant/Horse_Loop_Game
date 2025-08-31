extends Control
@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SFXBus = AudioServer.get_bus_index("SFX")
@export var SFXSound: AudioStreamPlayer
@onready var Click: AudioStreamPlayer = $Click
@onready var Hover: AudioStreamPlayer = $Hover
@onready var Resolutions_button: OptionButton = $MarginContainer/VBoxContainer/GridContainer2/WindowModeOptions as OptionButton
@onready var FullscreenOptionButton: OptionButton = $MarginContainer/VBoxContainer/GridContainer2/FullscreenOptionButton as OptionButton

@export var main_menu: Control
@export var options: Control


const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless FullScreen"
	]
	
const RESOLUTION_DICTIONARY : Dictionary = {
	"1152x648" : Vector2i(1152,648),
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}

		
func _ready() -> void:
	update_button_values()
	main_menu = get_node("/root/Menu/Canvas/Main Menu")
	options = get_node("/root/Menu/Canvas/Options")
	FullscreenOptionButton.item_selected.connect(on_window_mode_selected)
	Resolutions_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()
	add_window_mode_items()
	
func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		Resolutions_button.add_item(resolution_size_text)
		pass

func on_resolution_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
		
func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		FullscreenOptionButton.add_item(window_mode)

func on_window_mode_selected(index: int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


		
func update_button_values():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(value))
	AudioServer.set_bus_mute(MusicBus, value < .05)

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(value))
	AudioServer.set_bus_mute(MasterBus, value < .05)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFXBus, linear_to_db(value))
	AudioServer.set_bus_mute(SFXBus, value < .05)
	
func _on_sfx_slider_drag_started() -> void:
	SFXSound.play()

func _on_sfx_slider_drag_ended() -> void:
	SFXSound.stop()
	
func _on_back_pressed() -> void:
	Click.play()
	options.visible = false
	main_menu.visible = true
