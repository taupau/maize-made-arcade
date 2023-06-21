extends Control

var stopped = false
var displayed = true
var char_int = 97
var queued_char = '_'
var input_string = ""
@onready var focus = $CredentialInput/Name

var flag = false

func _ready():
	$NameInput.enable()

func _process(delta):
	if not flag and $NameInput.input_string.length() == 3:
		$NameInput.disable()
		$PinInput.enable()
		flag = true
