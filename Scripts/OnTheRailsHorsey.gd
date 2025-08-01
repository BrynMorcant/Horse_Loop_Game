extends PathFollow2D

var the_state_of_this_fucking_horse
var la_horse_danse
var gravity = 1.8

var remove_from_rail = false
@onready var horse: CharacterBody2D = $Test_Horse
@onready var new_parent: Node2D = get_node("/root/Test Course")

var horse_stats = {
	"base speed": .001,
	"speed": .001,
	"acceleration": .00005,
	"max speed": .1,
	"loop counter": 1,
	"loop position": "off loop"
}

var loop_stats = {
	"off loop": .0,#from here
	"loop climb": .000005,#
	"loop ceiling": .00001,#
	"loop complete": -.000015,# to here - Decay rates for horse speed while traversing the loop
	"speed threshold": .5 #Speed Threshold to stay on loop
}

var loop_difficulty = {
	1: {
		"loop climb": .000005,
		"loop ceiling": .00001,
		"loop complete": -.000015,
		"speed threshold": .5
	},
	2: {
		"loop climb": .00001,
		"loop ceiling": .00002,
		"loop complete": -.00003,
		"speed threshold": 1
	},
	3: {
		"loop climb": .00002,
		"loop ceiling": .00004,
		"loop complete": -.00005,
		"speed threshold": 1.5
	},
	4: {
		"loop climb": .000005,
		"loop ceiling": .00001,
		"loop complete": -.0001,
		"speed threshold": 2
	}
}

func _ready():
	la_horse_danse = $Test_Horse/AnimatedSprite2D
	state_change("idle")
	if new_parent == null:
		print("Error: Could not find Test Course")

func _input(event: InputEvent) -> void:
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
	#var global_transform = horse.global_transform
	#var new_horse = horse.duplicate()
	#new_parent.add_child(new_horse)
	#new_horse.global_transform = global_transform
	#horse.queue_free()
	
	#Solution 3 - Hybrid, use clone to hide jitter (Prevents animation hijinks post-swap).
	var global_transform = horse.global_transform
	var new_horse = horse.duplicate()
	new_parent.add_child(new_horse)
	new_horse.global_transform = global_transform
	remove_child(horse)
	new_parent.add_child(horse)
	horse.global_transform = global_transform
	new_horse.queue_free()
func _process(delta):
	if Input.is_action_just_pressed("Down"):
		horse_fall()
		print("Function Called")
	if horse_stats["loop position"] == "off loop" && the_state_of_this_fucking_horse != "falling":
		if Input.is_action_pressed("Boost"):
			horse_run(delta)
			accelerate_horse()
		else:
			reset_speed(delta)
	elif horse_stats["loop position"] != "off loop":
		var loop_decay = loop_stats["loop position"]
		if horse_stats["speed"] < loop_stats["speed threshold"]:
			state_change("falling")
			
			#detatch from parent
			#apply gravity
		elif Input.is_action_pressed("Boost"):
			horse_run(delta)
			accelerate_horse()
			apply_loop_decay(loop_decay)
		else:
			reset_speed(delta)
	pass

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
	if horse_stats["speed"] < 0.01:
		if the_state_of_this_fucking_horse != "trotting":
			state_change("trotting")
			print(the_state_of_this_fucking_horse)
	else:
		if the_state_of_this_fucking_horse != "galloping":
			state_change("galloping")
			print(the_state_of_this_fucking_horse)
	progress_ratio += delta*horse_stats["speed"]

func accelerate_horse():
	if horse_stats["speed"] < horse_stats["max speed"]:
		horse_stats["speed"] += horse_stats["acceleration"]
	if horse_stats["speed"] > horse_stats["max speed"]:
		horse_stats["speed"] = horse_stats ["max speed"]

func apply_loop_decay(loop_decay):
	horse_stats["speed"] -= loop_decay

func reset_speed(delta):
	if horse_stats["speed"] > horse_stats["base speed"]:
		horse_run(delta)
		horse_stats["speed"] -= horse_stats["acceleration"] * 3
		if horse_stats["speed"] <= horse_stats["base speed"]:
			state_change("idle")
			print(the_state_of_this_fucking_horse)

func loop_complete():
	horse_stats["loop counter"]+=1
	for stat in loop_stats:
		if loop_stats["off loop"]:
			continue
		loop_stats[stat] = loop_difficulty[horse_stats["loop counter"]["stat"]]
		print(loop_difficulty[horse_stats["loop Counter"]["stat"]])

func horse_upgrade(): #incomplete
	
	#acceleration += .00001
	#max_speed += .1
	pass
