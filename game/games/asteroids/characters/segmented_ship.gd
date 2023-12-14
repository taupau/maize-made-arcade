extends Node2D

signal destroyed

var max_force = 15000
var max_torque = 15000

func _ready():
	var rng = RandomNumberGenerator.new()
	for c in get_children():
		if c.name.contains("Seg"):
			c = c as RigidBody2D
			c.apply_force(Vector2.from_angle(rng.randf_range(0, 6.28) * rng.randf_range(0, max_force)))
			c.apply_torque(rng.randf_range(-max_torque, max_torque))


func _on_start_fade_timeout():
	$IncFade.start()

func _on_inc_fade_timeout():
	for c in get_children():
		if c.name.contains("Seg"):
			var rect = c.find_child("ColorRect") as ColorRect
			rect.color = rect.color.darkened(0.05)
			if rect.color.r < 0.1:
				destroyed.emit()
				queue_free()
