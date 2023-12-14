class_name Asteroid
extends CharacterBody2D

enum Size {SMALL, MEDIUM, LARGE}
var size = Size.LARGE

func _ready():
	rotation = RandomNumberGenerator.new().randf_range(0, 6.28)
