extends Control

var l_maize = true

func _ready():
	$Login.grab_focus()

func _on_login_pressed():
	Global.change_scene("res://menus/login.tscn")

func _on_guest_pressed():
	Global.change_scene("res://menus/game_menu.tscn")
