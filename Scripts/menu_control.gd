extends Control

@export var main_menu: Control
@export var credits: Control
@export var options: Control
@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SFXBus = AudioServer.get_bus_index("SFX")
@onready var Click: AudioStreamPlayer = $Click
@onready var Hover: AudioStreamPlayer = $Hover

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
	


func _on_game_start_pressed() -> void:
	Click.play()
	get_tree().change_scene_to_file("res://Scenes/test_course.tscn")

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

func _on_back_mouse_entered() -> void:
	Hover.play()
