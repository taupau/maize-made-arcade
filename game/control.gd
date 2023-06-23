extends Control

func _ready():
	$GameList.grab_focus()
	$GameList.select(0)

var color = true

var maize = Color.from_string("#ffcb05", Color.WHITE)
var blue = Color.from_string("#00274c", Color.WHITE)

func _on_flicker_timeout():
	if color:
		$MMA.remove_theme_color_override("font_color")
		$MMA.add_theme_color_override("font_color", maize)
	else:
		$MMA.remove_theme_color_override("font_color")
		$MMA.add_theme_color_override("font_color", blue)
		
	color = !color
