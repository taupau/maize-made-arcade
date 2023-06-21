extends Control

@onready var name_input = $CredentialInputLabels/NameRow/NameInput
@onready var pin_input = $CredentialInputLabels/PinRow/PinInput


func _ready():
	name_input.enable()


func _process(_delta):
	if Input.is_action_just_pressed("down") and name_input.enabled:
		name_input.disable()
		pin_input.enable()
	elif Input.is_action_just_pressed("up") and pin_input.enabled:
		pin_input.disable()
		name_input.enable()
	elif Input.is_action_just_pressed("down") and pin_input.enabled:
		pin_input.disable()
		$Login.grab_focus()
	elif Input.is_action_just_pressed("up") and $Login.has_focus():
		$Login.release_focus()
		pin_input.enable()
