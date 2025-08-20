extends Control

@export var main_menu: Control
@export var credits: Control
@export var options: Control
@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SFXBus = AudioServer.get_bus_index("SFX")
@onready var SFXSound: AudioStreamPlayer = $SFXSound
@onready var Click: AudioStreamPlayer = $Click
@onready var Hover: AudioStreamPlayer = $Hover

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
	
func _ready() -> void:
	main_menu = get_node("/root/Menu/Canvas/Main Menu")
	credits = get_node("/root/Menu/Canvas/Credits")
	options = get_node("/root/Menu/Canvas/Options")
	
func _on_link_button_pressed() -> void:
	Click.play()
	OS.shell_open("https://soundcloud.com/messedup-murphy")

func _on_back_button_pressed() -> void:
	Click.play()
	credits.visible = false
	main_menu.visible = true
	pass # Replace with function body.
	
func _on_back_pressed() -> void:
	Click.play()
	options.visible = false
	main_menu.visible = true
	pass # Replace with function body.

func _on_game_start_pressed() -> void:
	Click.play()
	get_tree().change_scene_to_file("res://Scenes/test_course.tscn")
	pass # Replace with function body.

func _on_game_start_mouse_entered() -> void:
	Hover.play()
	
func _on_credits_pressed() -> void:
	Click.play()
	main_menu.visible = false
	credits.visible = true

func _on_credits_mouse_entered() -> void:
	Hover.play()

	
func _on_quit_pressed() -> void:
	Click.play()
	get_tree().quit()


func _on_quit_mouse_entered() -> void:
	Hover.play()


func _on_back_button_mouse_entered() -> void:
	Hover.play()



func _on_options_pressed() -> void:
	Click.play()
	main_menu.visible = false
	options.visible = true


func _on_options_mouse_entered() -> void:
	Hover.play()
	pass # Replace with function body.
	


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.
	SFXSound.stop()


func _on_back_mouse_entered() -> void:
	Hover.play()
