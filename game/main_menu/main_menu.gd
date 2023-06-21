extends Control


func _on_start_pong_pressed():
	Global.change_scene("res://games/pong/pong.tscn")


func _on_login_pressed():
	Global.change_scene("res://main_menu/login.tscn")
