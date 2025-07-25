extends Node2D

@export var width: float = 1024.0
@export var height: float = 24.0

func _draw():
	draw_rect(Rect2(-Vector2(width/2, height/2), Vector2(width, height)), Color(0.4, 0.4, 0.4))
