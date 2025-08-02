extends PathFollow2D

var the_state_of_this_fucking_horse
var la_horse_danse
@export var horse_ui: Control 
var remove_from_rail = false
@onready var horse: CharacterBody2D = $Test_Horse
@onready var camera: Camera2D = $Camera2D
@export var loop_position: String = "off loop"
@onready var fallen = false
@onready var buried = false
@export var horse_stats: Dictionary = {
	"base speed": .001,
	"speed": .001,
	"acceleration": .005,
	"max speed": .1,
}
func _ready():
	la_horse_danse = $Test_Horse/AnimatedSprite2D
	state_change("galloping")
	

func _process(delta):
	horse_run(delta)
	accelerate_horse()
	if progress_ratio > .75 and !fallen:
		la_horse_danse.play("trotting")
		fallen = true
	
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
	
	if progress_ratio + delta*horse_stats["speed"] > 1.0:
		progress_ratio = 1.0
		if !buried:
			la_horse_danse.play("idle")
			buried = true
	elif progress_ratio != 1.0:
		progress_ratio += delta*horse_stats["speed"]
	#print("Horsepower = ", horse_ui.horsepower)
func accelerate_horse():
	if horse_stats["speed"] < horse_stats["max speed"]:
		horse_stats["speed"] += horse_stats["acceleration"]
	if horse_stats["speed"] > horse_stats["max speed"]:
		horse_stats["speed"] = horse_stats ["max speed"]
