extends PathFollow2D

var the_state_of_this_fucking_horse
var la_horse_danse
@export var horse_ui: Control 
var remove_from_rail = false
@onready var horse: CharacterBody2D = $Test_Horse
@onready var camera: Camera2D = $Camera2D
@export var loop_position: String = "off loop"
@export var horse_stats: Dictionary = {
	"base speed": .0001,
	"speed": .0001,
	"acceleration": .0001,
	"max speed": .15,
}
func _ready():
	la_horse_danse = $Test_Horse/AnimatedSprite2D
	state_change("galloping")

func _process(delta):
	horse_run(delta)
	accelerate_horse()
func state_change(state_name):
	if the_state_of_this_fucking_horse != "falling":
		the_state_of_this_fucking_horse = state_name
	
		if state_name == "idle":
			la_horse_danse.play(state_name)
		elif state_name == "trotting":
			la_horse_danse.play(state_name)
		elif state_name == "galloping":
			la_horse_danse.play(state_name)
		elif state_name == "falling":
			la_horse_danse.play(state_name)

func horse_run(delta):
	if horse_stats["speed"] < 0.015:
		if the_state_of_this_fucking_horse != "trotting":
			state_change("trotting")
			print(the_state_of_this_fucking_horse)
	else:
		if the_state_of_this_fucking_horse != "galloping":
			state_change("galloping")
			print(the_state_of_this_fucking_horse)
			progress_ratio += delta*horse_stats["speed"]
	#print("Horsepower = ", horse_ui.horsepower)
func accelerate_horse():
	if horse_stats["speed"] < horse_stats["max speed"]:
		horse_stats["speed"] += horse_stats["acceleration"]
	if horse_stats["speed"] > horse_stats["max speed"]:
		horse_stats["speed"] = horse_stats ["max speed"]
