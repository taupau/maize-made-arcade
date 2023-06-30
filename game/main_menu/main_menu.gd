extends Control

var color = true

var maize = Color.from_string("#ffcb05", Color.WHITE)
var blue = Color.from_string("#00274c", Color.WHITE)

func _ready():
	$PlayContainer/Play.grab_focus()
	
	if User.logged_in != null:
		$Player.text = User.logged_in
		$Login.text = "Logout"
	else:
		$Player.text = "Player"
		$Login.text = "Login"
		
var rainbow = [
	"#9400D3",
	"#00FF00",
	"#FFFF00",
	"#FF7F00",
	"#FF0000"
]

var last_index = 0

func _on_flicker_timeout():
	if last_index == rainbow.size():
		last_index = 0
	
	$PlayContainer/MaizeBG.color = Color.from_string(rainbow[last_index], Color.WHITE)
	$PlayContainer/Title.add_theme_color_override("font_color", Color.from_string(rainbow[last_index], Color.WHITE))
	last_index += 1
	
func _on_start_pong_pressed():
	Global.change_scene("res://games/asteroids/asteroids.tscn")


func _on_login_pressed():
	if $Login.text == "Logout":
		User.logout()
		$PlayerName.text = "Player"
		$Login.text = "Login"
		return

	Global.change_scene("res://main_menu/login.tscn")
