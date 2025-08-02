extends CharacterBody2D

@export var gravity: float = 1200.0
@export var falling = false

@export var radius: float = 50.0
@export var color: Color = Color(1, 0, 0)

#func _draw():
#	draw_circle(Vector2.ZERO, radius, color)

func _physics_process(delta: float) -> void:
	if falling:
		print("I'm trying to fall!")
		if not is_on_floor():
			print("Seriously I should be falling rn.")
			velocity.y += gravity * delta
		else:
			print("JK, I will never fall.")
			velocity.y = 0.0
			falling = false
		
		move_and_slide()
