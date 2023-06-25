extends RigidBody2D

@export var new_scale: Vector2

func _ready():
	$ColorRect.scale = new_scale
	$CollisionShape2D.scale = new_scale
