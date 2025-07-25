extends Area2D

@export var obstacle_speed: float = 400.0

#@export var size: Vector2 = Vector2(32, 64)

func _ready() -> void:
	scale = Vector2(1,1) * randf_range(0.5, 2.0)

func _physics_process(delta: float) -> void:
	position.x -= obstacle_speed * delta
