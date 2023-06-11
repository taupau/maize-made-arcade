extends Node2D

var bar_speed = 500
var ball_linear_speed = 400
var ball_speed = Vector2(ball_linear_speed, 0)

var left_score = 0
var right_score = 0

func _ready():
	set_physics_process(false)
	
func _process(delta):
	if not is_physics_processing():
		return
	
	if Input.is_action_pressed("p1_up"):
		$LeftPlayer.position.y += -1 * bar_speed * delta
	if Input.is_action_pressed("p1_down"):
		$LeftPlayer.position.y += bar_speed * delta
	if Input.is_action_pressed("p2_up"):
		$RightPlayer.position.y += -1 * bar_speed * delta
	if Input.is_action_pressed("p2_down"):
		$RightPlayer.position.y += bar_speed * delta
	
	var left_height = $LeftPlayer/Sprite2D.texture.get_size().y * $LeftPlayer.scale.y
	var right_height = $RightPlayer/Sprite2D.texture.get_size().y * $RightPlayer.scale.y
	
	$LeftPlayer.position.y = clamp($LeftPlayer.position.y, 5 + (left_height / 2), 995 - (left_height / 2))
	$RightPlayer.position.y = clamp($RightPlayer.position.y, 5 + (right_height / 2), 995 - (right_height / 2))
		
func _physics_process(delta):
	var collision = $Ball.move_and_collide(ball_speed * delta)
	if collision:
		var name = collision.get_collider().name
		if name.contains("Wall"):
			ball_speed.y *= -1
			return
		
		var y_percent
		var left_height = $LeftPlayer/Sprite2D.texture.get_size().y * $LeftPlayer.scale.y
		var right_height = $RightPlayer/Sprite2D.texture.get_size().y * $RightPlayer.scale.y
		
		if name == "LeftPlayer":
			y_percent = abs(($Ball.position.y - ($LeftPlayer.position.y + (left_height / 2)))) / left_height
		else:
			y_percent = abs(($Ball.position.y - ($RightPlayer.position.y + (right_height / 2)))) / right_height
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

func _on_menu_start():
	$Menu.hide()
	$Score.show()
	set_physics_process(true)
