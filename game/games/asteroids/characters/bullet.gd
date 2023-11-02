class_name Bullet
extends CharacterBody2D

@export var max_dist = 400
var spawn_point: Vector2
var travelled = 0

func _physics_process(delta):
	travelled += delta * velocity.length()
	if travelled > max_dist:
		queue_free()
