extends Node2D

## Main scene script for a simple Geometry Dash-like game in Godot 4

## The points you have gotten
var score : int = 0:
	set(value):
		score = value
		$Score.text = str(score)

var max_score : int = 0

@onready var player = $Player
@onready var obstacles = $Obstacles
@onready var ground = $Ground


func _ready():
	%StartGame.grab_focus()


# Helper to load obstacle scene
var ObstacleScene: PackedScene = preload("res://obstacle.tscn")

func spawn_obstacle():
	print("Spawn new obstacle")
	var obstacle: Area2D = ObstacleScene.instantiate()
	obstacle.position = $ObstacleSpawnPosition.global_position
	obstacle.body_entered.connect(_on_obstacle_body_entered)
	obstacles.add_child(obstacle)


func start_game():
	score = 0
	$Menu.hide()
	$ScoreTimer.start()
	$SpawnTimer.start()
	$Parallax2D.autoscroll = Vector2(-50, 0)


func game_over():
	if score > max_score:
		max_score = score
		%MaxScore.text = "Rekord: %d poeng" % max_score

	$ScoreTimer.stop()
	$SpawnTimer.stop()
	$Parallax2D.autoscroll = Vector2(0, 0)
	$Menu.show()
	#get_tree().reload_current_scene()
	for obstacle in obstacles.get_children():
		obstacle.queue_free()

## Return when the next obstacle should spawn, based on the level
func get_spawn_seconds() -> float:
	var ret: float = 1.0 / (1.0 + 0.01 * score)
	ret = ret * randf_range(0.9, 1.1)
	return max(0.01, ret)


func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()
	$SpawnTimer.wait_time = get_spawn_seconds()
	$SpawnTimer.start()


func _on_obstacle_body_entered(body: Node2D) -> void:
	if body is not Player:
		printerr("Not player that the Obstacle collisioned with")
	else:
		game_over()


func _on_score_timer_timeout() -> void:
	score += 1
	$Score.text = "%d" % score


func _on_start_game_pressed() -> void:
	start_game()
