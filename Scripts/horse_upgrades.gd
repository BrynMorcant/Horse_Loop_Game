extends Node2D
@export var horse: PathFollow2D
@export var horse_animation: AnimatedSprite2D
@export var new_horse_animation: AnimationPlayer
@export var greg_chat: RichTextLabel
@export var state_changed: bool = false
@export var animation_state = "idle"
@export var bg_music_player: AudioStreamPlayer
var upgrade_state = "default"
var upgraded = false
@export var backup: bool = false
@export var loops_complete:int = 0
var current_loop: String

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
	if Global.first_run == false:
		upgrade_state = Global.upgrade_state
		loops_complete = Global.loops_complete
	horse = get_node("/root/Test Course/Path2D/PathFollow2D")
	greg_chat = get_node("/root/Test Course/Gregthemerchant/RichTextLabel")
	if greg_chat == null:
		print("you a dumb bitch")
	#horse_animation = horse.la_horse_danse
	#horse_animation.play("Idle")
	new_horse_animation = horse.animation_player
	animation_state = "idle"
	update_horse_animation()
	Global.first_run = false
func _process(delta):
	if state_changed:
		update_horse_animation()
		state_changed = false
	if backup:
		data_backup()
		backup = false

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
		current_loop = "LoopE"
		bg_music_player["parameters/switch_to_clip"] =  current_loop
	pass
func data_backup():
	Global.loops_complete = loops_complete
	Global.upgrade_state = upgrade_state
	pass
func check_if_current(upgrade_name):
	
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
func check_if_next(upgrade_name):
	var upgrade = upgrade_name
	print("are your: ", upgrade_state, " better than", upgrade,"?")
	var newer_tech = false
	if upgrade_state == "rocket":
		if upgrade == "skates" or upgrade == "fan":
			print("they are")
			newer_tech = true
	if upgrade_state == "skates":
		if upgrade == "fan":
			print("they are")
			newer_tech = true
	return newer_tech
func upgrade_checks(upgrade_name, progress):
	var upgrade = upgrade_name 
	var progcheck = progress
	print("performing upgrade checks")
	
	var current = check_if_current(upgrade)
	if current:
		greg_chat.set_text("You 'avin a bubble m8? U just brought that.")
	else:
		
		var next = check_if_next(upgrade)
		if next:
				greg_chat.set_text("No refunds.")
		else:
			var previous = check_if_previous(upgrade)
			if !previous:
				greg_chat.set_text("Bruv, you're lookin a gift you in the mouth. Do more loops")
			else:
				if loops_complete < progcheck:
					greg_chat.set_text("pfft, you 'avn't even done enough loops for that.")
				else:
					upgrade_state = upgrade
					Global.upgrade_state = upgrade
					update_horse_animation()
					horse.horse_speed_change = true
					greg_chat.set_text("Enjoy your new upgrade 'orse.")
					print("Should 'ave the new upgrade.")

func _on_fan_pressed() -> void:
	upgrade_checks("fan", 0)

func _on_skates_pressed() -> void:
	
	upgrade_checks("skates", 1)

func _on_rocket_pressed() -> void:
	upgrade_checks("rocket", 2)
