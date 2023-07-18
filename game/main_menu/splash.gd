extends Control

var l_maize = true

func _ready():
	$Login.grab_focus()


func _on_login_pressed():
	Global.change_scene("res://main_menu/login.tscn")
