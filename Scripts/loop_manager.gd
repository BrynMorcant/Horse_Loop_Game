extends Node2D

@export var loop_state = "off loop"
@export var rail_control: PathFollow2D = null

func _ready():
	rail_control = get_node("/root/Test Course/Path2D/PathFollow2D")
	if rail_control == null:
		print("Dumb Dumb you did it wrong.")
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
	print("Next Loop")
	print_loop_stats()
	
	for stat in rail_control.loop_stats:
		if rail_control.loop_counter > 4:
			break
		if stat == "off loop":
			print("skipping 'off loop'")
			continue
		print("updating: ", stat)
		
		rail_control.loop_stats[stat] = rail_control.loop_difficulty[rail_control.loop_counter][stat]
	print_loop_stats()

func print_loop_stats():
	for stat in rail_control.loop_stats:
		print(stat, ", ", rail_control.loop_stats[stat])

func _on_area_2d_body_entered(body: Node2D):
	cycle_loop_state()
	update_horse()
	pass # Replace with function body.
