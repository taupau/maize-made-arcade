extends Control

var color = true

var maize = Color.from_string("#ffcb05", Color.WHITE)
var blue = Color.from_string("#00274c", Color.WHITE)

var games = ["pong", "asteroids"]
var displayed = 0
	
func _display_game(name):
	match name:
		"pong":
			$PlayContainer/Title.text = "Pong"
			$PlayContainer/Desc.text = "One of the earliest arcade games ever created, play the mma rendition of the 1972 classic: PONG!"
			displayed = 0
		"asteroids":
			$PlayContainer/Title.text = "Asteroids"
			$PlayContainer/Desc.text = "Navigate through a perilous asteroid field, blasting space rocks to smithereens in this classic arcade shooter."
			displayed = 1

func _display(right):
	displayed = posmod(displayed + 1 if right else -1, games.size())
	_display_game(games[displayed])

func _ready():
	$PlayContainer/Play.grab_focus()
	
	if User.logged_in != null:
		$Player.text = User.logged_in
		$Login.text = "Logout"
	else:
		$Player.text = "Player"
		$Login.text = "Login"
		
func _process(delta):
	if Input.is_action_just_pressed("right"):
		_display(true)
	elif Input.is_action_just_pressed("left"):
		_display(false)
		
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


func _on_play_pressed():
	Global.change_scene("res://games/%s/%s.tscn" % [games[displayed], games[displayed]])
