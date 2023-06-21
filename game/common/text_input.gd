extends Control

@export var max_length = 5
@export var low_bound = 97
@export var upper_bound = 122
@export var text_color = Color.WHITE

var enabled = false
var stopped = false
var displayed = true
var char_int = low_bound
var queued_char = '_'
var input_string = ""

func _ready():
	$Text.add_theme_color_override("font_color", text_color)

func enable():
	enabled = true
	if stopped: return
	
	$CharBlink.start()
	$Text.text = "%s%s" % [input_string, queued_char]

func disable():
	enabled = false
	$CharBlink.stop()
	displayed = false
	$Text.text = input_string

func _process(delta):
	if not enabled:
		return
	
	if not stopped and Input.is_action_just_pressed("enter") and queued_char != '_':
		input_string = "%s%s" % [input_string, queued_char]
		
		if input_string.length() >= max_length:
			$CharBlink.stop()
			$Text.text = input_string
			stopped = true
			return
		
		queued_char = "_"
		$Text.text = "%s%s" % [input_string, queued_char]
		
	if Input.is_action_just_pressed("backspace"):
		input_string = input_string.substr(0, input_string.length() - 1)
		$Text.text = input_string
		queued_char = "_"
		if stopped:
			$CharBlink.start()
			stopped = false
			
	if Input.is_action_just_pressed("cycle_letter_forward"):
		if queued_char == '_' or char_int == upper_bound:
			char_int = low_bound
		else:
			char_int += 1
		
		queued_char = String.chr(char_int)
		$Text.text = "%s%s" % [input_string, queued_char]
		
	if Input.is_action_just_pressed("cycle_letter_backward"):
		if queued_char == '_' or char_int == low_bound:
			char_int = upper_bound
		else:
			char_int -= 1
		
		queued_char = String.chr(char_int)
		$Text.text = "%s%s" % [input_string, queued_char]

func _on_char_blink_timeout():
	if displayed:
		$Text.text = input_string
		displayed = false
	else:
		$Text.text = "%s%s" % [input_string, queued_char]
		displayed = true
