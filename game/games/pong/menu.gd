extends CanvasGroup

signal start(difficulty)


func _ready():
	$Difficulty/Easy.grab_focus()


func _on_easy_pressed():
	start.emit(0)


func _on_medium_pressed():
	start.emit(1)


func _on_hard_pressed():
	start.emit(2)
