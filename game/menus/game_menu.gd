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
	"desc": "desc",
	"path": "res://games/asteroids/asteroids.tscn"
}]


func _ready():
	$GameContainer/Play.grab_focus()
	$GameContainer/GameTitle.text = games[selected]["title"]
	$GameContainer/GameDesc.text = games[selected]["desc"]


func _process(delta):
	if Input.is_action_just_pressed("j_down"):
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.WHITE)
		selected = posmod(selected - 1, 1)
		$GameContainer/GameTitle.text = games[selected]["title"]
		$GameContainer/GameDesc.text = games[selected]["desc"]
	elif Input.is_action_just_pressed("j_up"):
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.WHITE)
		selected = posmod(selected + 1, 1)
		$GameContainer/GameTitle.text = games[selected]["title"]
		$GameContainer/GameDesc.text = games[selected]["desc"]


func _on_blinker_timeout():
	pass # Replace with function body.


func _on_selection_blinker_timeout():
	if green:
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.LIME_GREEN)
	else:
		(games[selected]["button"] as Label).add_theme_color_override("font_color", Color.WHITE)
	green = !green


func _on_play_pressed():
	Global.change_scene(games[selected]["path"])
