extends Node2D

var AI_EASY_P = 0.04
var AI_MEDIUM_P = 0.08
var AI_HARD_P = 0.1

var AI_EASY_MAX = 150
var AI_MEDIUM_MAX = 200
var AI_HARD_MAX = 400

var PLAYER_EASY_SPEED = 400
var PLAYER_MEDIUM_SPEED = 500
var PLAYER_HARD_SPEED = 600

var BALL_EASY_SPEED = 400
var BALL_MEDIUM_SPEED = 500
var BALL_HARD_SPEED = 600

var player_speed
var ai_p
var ai_max
var ball_linear_speed

var ball_speed

var left_score = 0
var right_score = 0


func _ready():
	set_physics_process(false)


func _process(delta):
	if not is_physics_processing():
		return

	if Input.is_action_pressed("j_up"):
		$Player.position.y += -1 * player_speed * delta
	if Input.is_action_pressed("j_down"):
		$Player.position.y += player_speed * delta

	var left_height = $AI/Sprite2D.texture.get_size().y * $AI.scale.y
	var right_height = $Player/Sprite2D.texture.get_size().y * $Player.scale.y

	$AI.position.y = clamp($AI.position.y, 5 + (left_height / 2), 995 - (left_height / 2))
	$Player.position.y = clamp($Player.position.y, 5 + (right_height / 2), 995 - (right_height / 2))


func _physics_process(delta):
	ai_track(delta)

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
			y_percent = abs($Ball.position.y - ($AI.position.y + (left_height / 2))) / left_height
		else:
			y_percent = (
				abs($Ball.position.y - ($Player.position.y + (right_height / 2))) / right_height
			)

		ball_speed.y = -800 * y_percent + ball_linear_speed
		ball_speed.x *= -1
		ball_speed = ball_speed.normalized() * ball_linear_speed


func check_score_and_end(score, player):
	if score == 10:
		$Ball.hide()
		$Player.hide()
		$AI.hide()
		if player == 0:
			$GameOver/Winner.text = "AI wins"
		else:
			$GameOver/Winner.text = "You win"
		$GameOver.show()
		set_physics_process(false)
		$EndGame.start()


func _on_ai_score():
	left_score += 1
	$Score/LeftScore.text = "%s" % left_score
	$Ball.position.x = 500
	$Ball.position.y = 500
	ball_speed = Vector2(-1 * ball_linear_speed, 0)
	check_score_and_end(left_score, 0)


func _on_player_score():
	right_score += 1
	$Score/RightScore.text = "%s" % right_score
	$Ball.position.x = 500
	$Ball.position.y = 500
	ball_speed = Vector2(ball_linear_speed, 0)
	check_score_and_end(left_score, 1)


func ai_track(delta):
	var out = ($Ball.position.y - $AI.position.y) * 0.04
	var sign = sign(out)
	out = clamp(abs($AI.position.y - out), 0, ai_max * delta)
	$AI.position.y += sign * out


func _on_menu_start(difficulty):
	match difficulty:
		0:
			player_speed = PLAYER_EASY_SPEED
			ai_p = AI_EASY_P
			ai_max = AI_EASY_MAX
			ball_linear_speed = BALL_EASY_SPEED
		1:
			player_speed = PLAYER_MEDIUM_SPEED
			ai_p = AI_MEDIUM_P
			ai_max = AI_MEDIUM_MAX
			ball_linear_speed = BALL_MEDIUM_SPEED
		2:
			player_speed = PLAYER_HARD_SPEED
			ai_p = AI_HARD_P
			ai_max = AI_HARD_MAX
			ball_linear_speed = BALL_HARD_SPEED

	ball_speed = Vector2(ball_linear_speed, 0)

	$Menu.hide()
	$Score.show()
	set_physics_process(true)


func _on_end_game_timeout():
	$AI.position.y = 500
	$Player.position.y = 500
	$Player.show()
	$AI.show()
	left_score = 0
	right_score = 0
	$Score/LeftScore.text = "0"
	$Score/RightScore.text = "0"
	$Score.hide()
	$GameOver.hide()
	$Menu.show()
	$Ball.position.x = 500
	$Ball.position.y = 500
	$Ball.show()
