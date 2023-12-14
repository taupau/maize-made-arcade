extends Area2D

signal score


func _on_body_entered(body):
	score.emit()
