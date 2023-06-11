extends Node2D

@export var AI_EASY_SPEED = 100
@export var AI_MEDIUM_SPEED = 250
@export var AI_HARD_SPEED = 500

@export var PLAYER_EASY_SPEED = 200
@export var PLAYER_MEDIUM_SPEED = 300
@export var PLAYER_HARD_SPEED = 400

@export var BALL_EASY_SPEED = 200
@export var BALL_MEDIUM_SPEED = 300
@export var BALL_HARD_SPEED = 400

var player_speed
var ai_speed
var ball_linear_speed

var ball_speed

var left_score = 0
var right_score = 0

func _ready():
	set_physics_process(false)
	
func _process(delta):
	if not is_physics_processing():
		return
	
	if Input.is_action_pressed("p1_up"):
		$AI.position.y += -1 * ai_speed * delta
	if Input.is_action_pressed("p1_down"):
		$AI.position.y += ai_speed * delta
	if Input.is_action_pressed("p2_up"):
		$Player.position.y += -1 * player_speed * delta
	if Input.is_action_pressed("p2_down"):
		$Player.position.y += player_speed * delta
	
	var left_height = $AI/Sprite2D.texture.get_size().y * $AI.scale.y
	var right_height = $Player/Sprite2D.texture.get_size().y * $Player.scale.y
	
	$AI.position.y = clamp($AI.position.y, 5 + (left_height / 2), 995 - (left_height / 2))
	$Player.position.y = clamp($Player.position.y, 5 + (right_height / 2), 995 - (right_height / 2))
		
func _physics_process(delta):
	var collision = $Ball.move_and_collide(ball_speed * delta)
	if collision:
		var name = collision.get_collider().name
		if name.contains("Wall"):
			ball_speed.y *= -1
			return
		
		var y_percent
		var left_height = $AI/Sprite2D.texture.get_size().y * $AI.scale.y
		var right_height = $Player/Sprite2D.texture.get_size().y * $Player.scale.y
		
		if name == "AI":
			y_percent = abs(($Ball.position.y - ($AI.position.y + (left_height / 2)))) / left_height
		else:
			y_percent = abs(($Ball.position.y - ($Player.position.y + (right_height / 2)))) / right_height
		ball_speed.y = -800 * y_percent + ball_linear_speed
		ball_speed.x *= -1
		ball_speed = ball_speed.normalized() * ball_linear_speed
		
func check_score_and_end(score, player):
	if score == 10:
		$Ball.hide()
		set_physics_process(false)

func _on_player_1_goal_score():
	left_score += 1
	$Score/LeftScore.text = "%s" % left_score
	$Ball.position.x = 500
	$Ball.position.y = 500
	ball_speed = Vector2(-1 * ball_linear_speed, 0)

func _on_player_2_goal_score():
	right_score += 1
	$Score/RightScore.text = "%s" % right_score
	$Ball.position.x = 500
	$Ball.position.y = 500
	ball_speed = Vector2(ball_linear_speed, 0)

func _on_menu_start(difficulty):
	match difficulty:
		0:
			player_speed = PLAYER_EASY_SPEED
			ai_speed = AI_EASY_SPEED
			ball_linear_speed = BALL_EASY_SPEED
		1:
			player_speed = PLAYER_MEDIUM_SPEED
			ai_speed = AI_MEDIUM_SPEED
			ball_linear_speed = BALL_MEDIUM_SPEED
		2:
			player_speed = PLAYER_HARD_SPEED
			ai_speed = AI_HARD_SPEED
			ball_linear_speed = BALL_HARD_SPEED
			
	ball_speed = Vector2(ball_linear_speed, 0)

	$Menu.hide()
	$Score.show()
	set_physics_process(true)
