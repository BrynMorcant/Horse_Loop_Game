extends Node2D
@export var horse: PathFollow2D
@export var horse_animation: AnimatedSprite2D
@export var new_horse_animation: AnimationPlayer
@export var greg_chat: RichTextLabel
@export var state_changed: bool = false
@export var animation_state = "idle"
var upgrade_state = "default"
var upgraded = false
@export var loops_complete:int = 0

var load_upgrade_stats = {
	"fan":{
		"max_speed": 0.05,
		"acceleration": .001
	},
	"skates":{
		"max_speed": 0.075,
		"acceleration": .005
	},
	"rocket":{
		"max_speed": 0.15,
		"acceleration": .01
	},
}
var load_upgrade_animation = {
	"default": {
		"idle": "Idle",
		"trotting": "Trot",
		"galloping": "Gallop",
	},
	"fan": {
		"idle": "Idle_Fan",
		"trotting": "Trot_Fan",
		"galloping": "Gallop_Fan",
	},
	"skates": {
		"idle": "Idle_Fan+Roller",
		"trotting": "Trot_Fan+Roller",
		"galloping": "Gallop_Fan+Roller",
	},
	"rocket": {
		"idle": "Idle_Rocket",
		"trotting": "Trot_Rocket",
		"galloping": "Gallop_Rocket",
	}
}
func _ready():
	horse = get_node("/root/Test Course/Path2D/PathFollow2D")
	greg_chat = get_node("/root/Test Course/Gregthemerchant/RichTextLabel")
	if greg_chat == null:
		print("you a dumb bitch")
	#horse_animation = horse.la_horse_danse
	#horse_animation.play("Idle")
	new_horse_animation = horse.animation_player
	animation_state = "idle"
	update_horse_animation()

func _process(delta):
	if state_changed:
		update_horse_animation()
		state_changed = false

func update_horse_animation():
	if animation_state != "falling":
		if animation_state == "trot":
			if upgrade_state == "rocket":
				new_horse_animation.play("Gallop_Rocket")
		else:
			#horse_animation.play(load_upgrade_animation[upgrade_state][animation_state])
			new_horse_animation.play(load_upgrade_animation[upgrade_state][animation_state])
	else:
		new_horse_animation.play("Fall")
	pass

func check_if_current(upgrade_name):
	print("checking if current")
	var available = false
	if upgrade_name == upgrade_state:
		available = true
	print("current: ", available)
	return available
func check_if_previous(upgrade_name):
	print("checking if previous")
	var quick_ref = {
		"fan":"default",
		"skates":"fan",
		"rocket":"skates"
	}
	var next_in_line = false
	if upgrade_state==quick_ref[upgrade_name]:
		next_in_line = true
	print("previous ", next_in_line)
	return next_in_line

func upgrade_checks(upgrade_name, progress):
	var upgrade = upgrade_name 
	var progcheck = loops_complete
	print("performing upgrade checks")
	
	var current = check_if_current(upgrade)
	if current:
		greg_chat.set_text("You 'avin a bubble m8? U just brought that.")
	else:
		var previous = check_if_previous(upgrade)
		if !previous:
			greg_chat.set_text("Bruvvaaa, don't try to look before you can leap.")
		else:
			if loops_complete < progcheck:
				greg_chat.set_text("pfft, you aint even done enuff loops for that.")
			else:
				upgrade_state = upgrade
				update_horse_animation()
				print("You should have the new upgrade.")

func _on_fan_pressed() -> void:
	upgrade_checks("fan", 1)

func _on_skates_pressed() -> void:
	
	upgrade_checks("skates", 2)

func _on_rocket_pressed() -> void:
	upgrade_checks("rocket", 3)
