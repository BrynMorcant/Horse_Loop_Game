extends CanvasLayer
var gui_components = ["res://Scenes/Main_Menu.tscn", "res://Scenes/test_course.tscn"]
@onready var resolutions_option_button: OptionButton = $MarginContainer/VBoxContainer/GridContainer/OptionButton




var resolutions = {
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
	func add_resolutions():
		for r in GUI.options:
		resolutions_option_button.additem(r)
		
	
func _ready():
	for i in gui_components:
		var new_scene = load(i).instantiate()
		add_child(new_scene)
		new_scene.hide()

	func _input(_event):
		if Input.is_action_just_pressed("toggle_settings"):
			var settings_menu = get_node("Menu")
			settings_menu.visible = !settings_menu.visible
			
			

		
