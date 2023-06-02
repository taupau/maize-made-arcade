extends CanvasGroup

signal start

func _on_start_pressed():
	start.emit()
