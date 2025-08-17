extends Node2D
var current_loop: String
@export var bg_music_player: AudioStreamPlayer
@export var loop_state = "off loop"
@export var rail_control: PathFollow2D = null
@export var horse_animation: Node2D = null


func _ready():
	rail_control = get_node("/root/Test Course/Path2D/PathFollow2D")
	horse_animation = get_node("%horse_upgrades")

func process(delta):
	pass
	
func cycle_loop_state():
	if loop_state == "off loop":
		loop_state = "loop climb"
		print(loop_state)
	elif loop_state == "loop climb":
		loop_state = "loop ceiling"
		print(loop_state)
	elif loop_state == "loop ceiling":
		loop_state = "loop complete"
		print(loop_state)
	elif loop_state == "loop complete":
		loop_state = "off loop"
		loop_complete()
		
		print(loop_state)

func update_horse():
	rail_control.loop_position = loop_state
	
func loop_complete():
	rail_control.loop_counter += 1
	horse_animation.loops_complete += 1
	print("Next Loop")
	#print_loop_stats()
	
	for stat in rail_control.loop_stats:
		if rail_control.loop_counter > 3:
			break 
		if stat == "off loop":
			print("skipping 'off loop'")
			continue
		print("updating: ", stat)
		print("loop counter is: ", rail_control.loop_counter)
		print("so new threshold is: ", rail_control.loop_difficulty[rail_control.loop_counter]["speed threshold"])
		rail_control.loop_stats[stat] = rail_control.loop_difficulty[rail_control.loop_counter][stat]
	#print_loop_stats()
	
func print_loop_stats():
	for stat in rail_control.loop_stats:
		print(stat, ", ", rail_control.loop_stats[stat])

func _on_area_2d_body_entered(body: Node2D):
	cycle_loop_state()
	update_horse()
	pass # Replace with function body.


func _on_music_trigger_1_body_entered(body: Node2D) -> void:
	current_loop = "LoopB"
	bg_music_player["parameters/switch_to_clip"] = current_loop
 #	$"Synchronised Music/Success Stinger1".play()
	print ("LoopB")
func _on_music_trigger_2_body_entered(body: Node2D) -> void:
	current_loop = "LoopC"
	bg_music_player["parameters/switch_to_clip"] =  current_loop
 #	$"Synchronised Music/Success Stinger2".play()
	print ("LoopC")
func _on_music_trigger_3_body_entered(body: Node2D) -> void:
	current_loop = "LoopD"
 #	$"Synchronised Music/Success Stinger3".play()
	bg_music_player["parameters/switch_to_clip"] =  current_loop
	print ("LoopD")
