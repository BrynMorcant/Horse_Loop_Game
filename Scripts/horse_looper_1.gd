extends PathFollow2D

@onready var ui
@onready var ui2
@onready var ui3

var the_state_of_this_fucking_horse
var la_horse_danse
@export var horse_ui: Control 
var remove_from_rail = false
@onready var horse: CharacterBody2D = $Test_Horse
@onready var fallen = false
@onready var buried = false
var timer
@export var horse_stats: Dictionary = {
	"base speed": .001,
	"speed": .001,
	"acceleration": .0075,
	"max speed": .125,
}
func _ready():
	la_horse_danse = $Test_Horse/AnimatedSprite2D1
	state_change("galloping")
	ui = get_node("/root/Menu/Canvas/Main Menu")
	ui2 = get_node("/root/Menu/Canvas/Credits")
	ui3 = get_node("/root/Menu/Canvas/Options")
 
	if ui == null:
		print("oops")
	else:
		ui.visible = false
		ui2.visible = false
		ui3.visible = false

	timer = get_node("/root/Menu/MyTimer")
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
			
			timer.start()
	elif progress_ratio != 1.0:
		progress_ratio += delta*horse_stats["speed"]
	#print("Horsepower = ", horse_ui.horsepower)
func accelerate_horse():
	if horse_stats["speed"] < horse_stats["max speed"]:
		horse_stats["speed"] += horse_stats["acceleration"]
	if horse_stats["speed"] > horse_stats["max speed"]:
		horse_stats["speed"] = horse_stats ["max speed"]
func _on_timer_timeout() -> void:
	ui.visible=true
