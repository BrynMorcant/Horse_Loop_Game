extends Node2D
@export var horse: PathFollow2D
@export var horse_animation: AnimatedSprite2D
@export var state_changed: bool = false
@export var animation_state = "idle"
var upgrade_state = "default"
var upgraded = false

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
	"Fan+Roller": {
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
	if horse == null:
		print("you a dumb bitch")
	horse_animation = horse.la_horse_danse

func _process(delta):
	if state_changed:
		update_horse_animation()
		state_changed = false
	
func update_horse_stats():
	pass
func update_horse_animation():
	if animation_state != "falling":
		horse_animation.play(load_upgrade_animation[upgrade_state][animation_state])
