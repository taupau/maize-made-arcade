extends Control

func _ready():
	$Menu.grab_focus()

func _on_menu_pressed():
	Global.change_scene("res://menus/game_menu.tscn")
