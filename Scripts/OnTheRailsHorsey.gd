extends PathFollow2D

var the_state_of_this_fucking_horse
var la_horse_danse
@export var horse_ui: Control 
var remove_from_rail = false
@onready var horse: CharacterBody2D = $Test_Horse
@onready var new_parent: Node2D = get_node("/root/Test Course")
@onready var camera: Camera2D = $Camera2D
@export var loop_counter: int = 1
@export var loop_position: String = "off loop"
@export var horse_stats: Dictionary = {
	"base speed": .0001,
	"speed": .0001,
	"acceleration": .0001,
	"max speed": .15,
}
@export var loop_stats: Dictionary = {
	"off loop": .0,#from here
	"loop climb": .000005,#
	"loop ceiling": .00001,#
	"loop complete": -.000015,# to here - Decay rates for horse speed while traversing the loop
	"speed threshold": .02  #Speed Threshold to stay on loop
}
@export var loop_difficulty: Dictionary = {
	2: {
		"loop climb": .00001,
		"loop ceiling": .00002,
		"loop complete": -.00003,
		"speed threshold": .05
	},
	3: {
		"loop climb": .00002,
		"loop ceiling": .00004,
		"loop complete": -.00005,
		"speed threshold": .095
	},
	4: {
		"loop climb": .000005,
		"loop ceiling": .00001,
		"loop complete": -.0001,
		"speed threshold": .125
	}
}

func _ready():
	la_horse_danse = $Test_Horse/AnimatedSprite2D
	state_change("idle")

func _input(event: InputEvent) -> void: #During my looking around I learned you 
	#can have functions that run on events like input.
	pass
func horse_fall():
	#Solution 1 - Reparent and assign old world transforms
	#if Input.is_action_just_pressed("Down") and !remove_from_rail:
	#	var global_position = horse.global_position #preserve world position
	#	var global_rotation = horse.global_rotation #and rotation
	#	remove_child(horse)
	#	new_parent.add_child(horse)
	#	horse.global_position = global_position
	#	horse.global_rotation = global_rotation
	#	remove_from_rail=true
	#	print(horse.get_parent())
	
	#Solution 2 - Replace with a clone
	#var horse_transform = horse.global_transform
	#var new_horse = horse.duplicate()
	#new_parent.add_child(new_horse)
	#new_horse.global_transform = horse_transform
	#horse.queue_free()
	
	#Solution 3 - Hybrid, use clone to hide jitter (Prevents animation hijinks post-swap).
	var horse_transform = horse.global_transform
	var new_horse = horse.duplicate()
	new_parent.add_child(new_horse)
	new_horse.global_transform = horse_transform
	remove_child(horse)
	new_parent.add_child(horse)
	horse.global_transform = horse_transform
	remove_child(camera)
	new_horse.queue_free()
	horse.add_child(camera)
	state_change("falling")
	horse.falling = true
func _process(delta):
	if the_state_of_this_fucking_horse != "falling": #When Falling the horse should be free of player influence
		if Input.is_action_just_pressed("Down"): #manual control to fall off of the loop for testing
			horse_fall()
			print("Function Called")
		if loop_position == "off loop": #Standard run
			if Input.is_action_pressed("Boost"):
				horse_run(delta)
				accelerate_horse()
			else:
				reset_speed(delta)
		elif loop_position != "off loop": #Running while on the loop
			var loop_decay = loop_stats[loop_position] #Assign loop position flag to a variable 
			if horse_stats["speed"] < loop_stats["speed threshold"]:
				print(horse_stats["speed"]," ",loop_stats["speed threshold"])
				horse_fall()
				print("Not fast enough bucko!")
			elif Input.is_action_pressed("Boost"):
				horse_run(delta)
				accelerate_horse()
				apply_loop_decay(loop_decay)
			else:
				reset_speed(delta)
		else:
			reset_speed(delta)
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
	horse_ui.current_horsepower  = horse_stats["speed"]
	horse_ui.horsepower = horse_stats["speed"]
	#print("Horsepower = ", horse_ui.horsepower)
func accelerate_horse():
	if horse_stats["speed"] < horse_stats["max speed"]:
		horse_stats["speed"] += horse_stats["acceleration"]
	if horse_stats["speed"] > horse_stats["max speed"]:
		horse_stats["speed"] = horse_stats ["max speed"]
	horse_ui.horsepower = horse_stats["speed"]
func apply_loop_decay(loop_decay):
	horse_stats["speed"] -= loop_decay
	horse_ui.horsepower = horse_stats["speed"]
func reset_speed(delta):
	if horse_stats["speed"] > horse_stats["base speed"]:
		horse_run(delta)
		horse_stats["speed"] -= horse_stats["acceleration"] * 2
		if horse_stats["speed"] <= horse_stats["base speed"]:
			state_change("idle")
			print(the_state_of_this_fucking_horse)
		horse_ui.horsepower = horse_stats["speed"]

#func loop_complete():
#	horse_stats["loop counter"]+=1
#	for stat in loop_stats:
#		if loop_stats["off loop"]:
#			continue
#		loop_stats[stat] = loop_difficulty[horse_stats["loop counter"]["stat"]]
#		print(loop_difficulty[horse_stats["loop Counter"]["stat"]])

func horse_upgrade(): #incomplete
	
	#acceleration += .00001
	#max_speed += .1
	pass
