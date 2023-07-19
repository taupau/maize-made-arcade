extends Control

var selected = 0
var green = false
@onready var games = [{
	"button": $GameContainer/Pong,
	"title": "Pong",
	"desc": "A pinoneer of classic gaming, Pong stands as a testament to the captivating power of simplicity. With its timeless gameplay and iconic paddle-and-ball mechanics, it continues to charm players of all ages.",
	"path": "res://games/pong/pong.tscn"
},
{
	"button": $GameContainer/Asteroids,
	"title": "Asteroids",
	"desc": "Navigate your ship through this space-themed shooter, but make sure to destroy all of the asteroids and alien ships in your path!",
	"path": "res://games/asteroids/asteroids.tscn"
},
{
	"button": $GameContainer/VCrossing,
	"title": "VCrossing",
	"desc": "desc",
	"path": "res://games/asteroids/asteroids.tscn"
}]


func _ready():
	$GameContainer/Play.grab_focus()
	$GameContainer/GameTitle.text = games[selected]["title"]
	$GameContainer/GameDesc.text = games[selected]["desc"]


func _process(delta):
	if Input.is_action_just_pressed("j_down"):
		$SelectionBlinker.stop()
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.WHITE)
		selected = posmod(selected + 1, 3)
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.LIME_GREEN)
		print(selected)
		$GameContainer/GameTitle.text = games[selected]["title"]
		$GameContainer/GameDesc.text = games[selected]["desc"]
		$SelectionBlinker.start()
	elif Input.is_action_just_pressed("j_up"):
		$SelectionBlinker.stop()
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.WHITE)
		selected = posmod(selected - 1, 3)
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.LIME_GREEN)
		$GameContainer/GameTitle.text = games[selected]["title"]
		$GameContainer/GameDesc.text = games[selected]["desc"]
		$SelectionBlinker.start()


var colored = false
func _on_blinker_timeout():
	if colored:
		$"Filled-name-logo".hide()
	else:
		$"Filled-name-logo".show()
		
	colored = !colored


func _on_selection_blinker_timeout():
	if green:
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.LIME_GREEN)
	else:
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.WHITE)
	green = !green


func _on_play_pressed():
	Global.change_scene(games[selected]["path"])
