extends Control

@onready var name_input = $CredentialInputLabels/NameRow/NameInput
@onready var pin_input = $CredentialInputLabels/PinRow/PinInput

var blink_count = 0
var red = false


func _ready():
	name_input.grab_focus()

func _on_login_pressed():
	var username = name_input.input_string
	var pin = pin_input.input_string
	
	var result = User.login_or_create(username, pin)
	if result:
		Global.change_scene("res://main_menu/main_menu.tscn")
		return
		
	$LoginBlinker.start()


func _on_login_blinker_timeout():
	if blink_count >= 10:
		$LoginBlinker.stop()
		blink_count = 0
		return
	
	if red:
		$Login.remove_theme_color_override("font_focus_color")
		red = false
	else:
		$Login.add_theme_color_override("font_focus_color", Color.RED)
		red = true
		
	blink_count += 1


func _on_back_pressed():
	Global.change_scene("res://main_menu/main_menu.tscn")
