extends Control
#horsepower = speed. OnTheRailsHorsey Updates in the 'horse_run' function.
@export var Horsepower: float = 0 
#progress variables represent progression along the rail, will update as above.
@export var pixel_progress: float = 0
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

func _ready():
	pass

func _process(delta):
	pass
