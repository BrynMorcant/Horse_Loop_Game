extends Control
#horsepower = speed. OnTheRailsHorsey Updates in the 'horse_run' function.
@export var horsepower: float = 0.0
@export var current_horsepower: float = 0.0
#progress variables represent progression along the rail, will update as above.
@export var pixel_progress: float = 0.0
var pixel_progress_max = 16209.54
@export var ratio_progress: float = 0.0
var ratio_progress_max = 1.0
#milestones as named show where each loop apex is.
var progress_milestones = {
	1: "tbd",
	2: "tbd",
	3: "tbd",
	4: "tbd",
} 
var speed_output 
var max_speed_output

func _ready():
	speed_output = $VBoxContainer/Speed/speed_output
	max_speed_output = $VBoxContainer/Max_Speed/max_speed_output
	pass

func _process(delta):
	speed_output.set_text(str(horsepower))
	max_speed_output.set_text(str(current_horsepower))
	pass
