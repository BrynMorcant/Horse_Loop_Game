extends CharacterBody2D

@export var gravity: float = 1200.0
@onready var my_daddy_is = get_node("Path2D")

func _physics_process(delta: float) -> void:
	if get_parent() != :
		print("I'm trying to fall!")
		if not is_on_floor():
			print("Seriously I should be falling rn.")
			velocity.y += gravity * delta
		else:
			print("JK, I will never fall.")
			velocity.y = 0.0
		move_and_slide()
