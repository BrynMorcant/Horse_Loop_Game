extends PathFollow2D
@export var horsey_upgrades: Node2D
var the_state_of_this_fucking_horse = "idle"
@export var la_horse_danse: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var horse_ui: Control 
var remove_from_rail = false
@onready var horse: CharacterBody2D = $Test_Horse
@onready var new_parent: TextureRect = get_node("/root/Test Course/Background")
@onready var camera: Camera2D = $Camera2D
@export var loop_counter: int = 1
@export var horse_speed_change: bool = false
@export var loop_position: String = "off loop"
@export var horse_stats: Dictionary
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
		"speed threshold": .035
	},
	3: {
		"loop climb": .00002,
		"loop ceiling": .00004,
		"loop complete": -.00005,
		"speed threshold": .06
	},
	4: {
		"loop climb": .000005,
		"loop ceiling": .00001,
		"loop complete": -.0001,
		"speed threshold": .1
	}
}
@export var victory_button: Button 
var victory_timer
var fail_timer
var beyblade = false
var victory_speed = 4.0
func _ready():
	#la_horse_danse = $Test_Horse/AnimatedSprite2D
	#la_horse_danse.play("idle")
	set_horse_speed()
	the_state_of_this_fucking_horse = "idle"
	horsey_upgrades = get_node("%horse_upgrades")
	animation_player = get_node("Test_Horse/AnimatedSprite2D/AnimationPlayer")
	if animation_player != null:
		print("Animation player assigned")
	animation_player.play("Idle")
	state_change("idle")
	print("I Should be idle right now.")
	victory_timer = get_node("/root/Test Course/Victory_Timer")
	fail_timer = get_node("/root/Test Course/Fail_Timer")
	victory_button = get_node("/root/Test Course/Halftime_Show/Victory")
	victory_button.visible = false
func set_horse_speed():
	if Global.upgrade_state == "default":
		horse_stats = {
			"base speed": .001,
			"speed": .001,
			"acceleration": .0005,
			"max speed": .0200075,
		}
		pass
	elif Global.upgrade_state == "fan":
		horse_stats = {
			"base speed": .001,
			"speed": .001,
			"acceleration": .001,
			"max speed": .035001,
		}
		pass
	elif Global.upgrade_state == "skates":
		horse_stats = {
			"base speed": .001,
			"speed": .001,
			"acceleration": .005,
			"max speed": .06003,
		}
		pass
	elif Global.upgrade_state == "rocket":
		horse_stats = {
			"base speed": .001,
			"speed": .001,
			"acceleration": .01,
			"max speed": .15,
		}
func _process(delta):
	if horse_speed_change == true:
		set_horse_speed()
		horse_speed_change = false
	if the_state_of_this_fucking_horse != "falling" and progress_ratio < 1.0: #When Falling the horse should be free of player influence
		#if Input.is_action_just_pressed("Down"): #manual control to fall off of the loop for testing
		#	horse_fall()
		#	print("Function Called")
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
	elif the_state_of_this_fucking_horse == "victory":
		rotation -= victory_speed * delta
func state_change(state_name):
	if the_state_of_this_fucking_horse != "falling":
		if state_name == "victory":
			the_state_of_this_fucking_horse = "victory"
			beyblade = true
			horsey_upgrades.animation_state = "falling"
			horsey_upgrades.state_changed = true
		else:
			the_state_of_this_fucking_horse = state_name
			horsey_upgrades.animation_state = the_state_of_this_fucking_horse
			horsey_upgrades.state_changed = true
			#if state_name == "idle":
			#	la_horse_danse.play(state_name)
			#elif state_name == "trotting":
			#	la_horse_danse.play(state_name)
			#elif state_name == "galloping":
			#	la_horse_danse.play(state_name)
			#elif state_name == "falling":
		#	la_horse_danse.play(state_name)
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
	fail_timer.start()
	horsey_upgrades.backup = true
func horse_run(delta):
	if horse_stats["speed"] < 0.015:
		if the_state_of_this_fucking_horse != "trotting":
			state_change("trotting")
			print(the_state_of_this_fucking_horse)
	else:
		if the_state_of_this_fucking_horse != "galloping":
			state_change("galloping")
			print(the_state_of_this_fucking_horse)
	if progress_ratio + delta * horse_stats["speed"] >= 1.0:
		progress_ratio = 1.0
		state_change("victory")
		victory_timer.start()
	else:
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
func loop_complete():
	horsey_upgrades.loop_complete+=1
	for stat in loop_stats:
		if loop_stats["off loop"]:
			continue
		loop_stats[stat] = loop_difficulty[horse_stats["loop counter"]["stat"]]
		print(loop_difficulty[horse_stats["loop Counter"]["stat"]])

func _on_victory_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/horse_looper_1.tscn")
func _on_victory_timer_timeout() -> void:
	victory_button.visible = true
func _on_fail_timer_timeout() -> void:
	get_tree().reload_current_scene()
