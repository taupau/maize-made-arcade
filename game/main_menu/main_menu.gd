extends Control

func _ready():
	if User.logged_in != null:
		$PlayerName.text = User.logged_in
		$Login.text = "Logout"
	else:
		$PlayerName.text = "Player"
		$Login.text = "Login"


func _on_start_pong_pressed():
	Global.change_scene("res://games/pong/pong.tscn")


func _on_login_pressed():
	if $Login.text == "Logout":
		User.logout()
		$PlayerName.text = "Player"
		$Login.text = "Login"
		return

	Global.change_scene("res://main_menu/login.tscn")


func _on_login_blinker_timeout():
	pass # Replace with function body.
