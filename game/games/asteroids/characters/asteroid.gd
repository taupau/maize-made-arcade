extends CharacterBody2D

func _ready():
	rotation = RandomNumberGenerator.new().randf_range(0, 6.28)
