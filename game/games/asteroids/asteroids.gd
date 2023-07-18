extends Node2D

var rotation_speed = 1500
var thrust = 2
var asteroid_speed = 80
var bullet_speed = 400

var velocity = Vector2(0, 0)
var score = 0:
	set(value):
		$Menu/Score.text = "%s" % value
		score = value

var lives = 3

@onready var ship_size = _get_scene_size($Ship)
@onready var viewport_size = get_viewport().size

@onready var asteroid = preload("res://games/asteroids/characters/asteroid.tscn")
@onready var bullet = preload("res://games/asteroids/characters/bullet.tscn")
@onready var segmented_ship = preload("res://games/asteroids/characters/segmented_ship.tscn")

@onready var rng = RandomNumberGenerator.new()

@onready var v_size = $VectorBox.size
@onready var v_pos = $VectorBox.position

func _ready():
	_spawn_asteroids(6)
	
func _physics_process(delta):
	if Input.is_action_pressed("j_left"):
		$Ship.rotate(1500 * delta)
	elif Input.is_action_pressed("j_right"):
		$Ship.rotate(-1500 * delta)
		
	if Input.is_action_just_pressed("left"):
		_fire_bullet()
	
	if Input.is_action_pressed("up"):
		var thrust_vector = $Ship.transform.y * thrust * delta * -1
		velocity += thrust_vector
		
	var ship_collision = $Ship.move_and_collide(velocity) as KinematicCollision2D
	if ship_collision and $Ship.visible:
		var segmented = segmented_ship.instantiate()
		segmented.position = $Ship.position
		segmented.rotation = $Ship.rotation
		segmented.destroyed.connect(_on_ship_destroyed)
		add_child(segmented)
		if ship_collision.get_collider().get("name").contains("Asteroid"):
			_destroy_asteroid(ship_collision.get_collider())
		$Ship.hide()
		
		lives -= 1
		if lives == 2:
			$Menu/Life3.hide()
		elif lives == 1:
			$Menu/Life2.hide()
		elif lives == 0:
			$Menu/Life1.hide()
			$GameOverDelay.start()
	
	for a in get_children():
		if a.name.contains("Asteroid"):
			a = a as CharacterBody2D
			if a.move_and_slide():
				var collision = a.get_last_slide_collision()
				if collision.get_collider().get("name").contains("Bullet"):
					_destroy_asteroid(a)
					collision.get_collider().queue_free()
					continue
		elif a.name.contains("Bullet"):
			a.move_and_slide()
					
		if a.name.contains("Asteroid") or a.name.contains("Bullet") or a.name.contains("Ship") and not a.name.contains("Segmented"):
			a.position = _teleport_within_bounds(a.position, _get_scene_size(a))
			
func _destroy_asteroid(a):
	match a.scale.x:
		1.0: score += 25
		0.5: score += 100
		0.25: score += 250

	_spawn_children(a)
	a.queue_free()

func _spawn_asteroids(count: int):
	for i in count:
		var roid_inst = asteroid.instantiate()
		var roid_size = _get_scene_size(roid_inst)
		add_child(roid_inst)
		
		match rng.randi_range(0, 3):
			0: roid_inst.position = Vector2(-1 * roid_size.x / 2, rng.randi_range(v_pos.y, v_pos.y + v_size.y))
			1: roid_inst.position = Vector2(viewport_size.x + roid_size.x / 2, rng.randi_range(v_pos.y, v_pos.y + v_size.y))
			2: roid_inst.position = Vector2(rng.randi_range(v_pos.x, v_pos.x + v_size.x), -1 * roid_size.y / 2)
			3: roid_inst.position = Vector2(rng.randi_range(v_pos.x, v_pos.x + v_size.x), viewport_size.y + roid_size.y / 2)
				
		roid_inst.velocity = _random_box_unit_vector(roid_inst.position) * asteroid_speed
	
func _spawn_children(a: CharacterBody2D):
	var new_scale = a.scale / 2
	if new_scale.x < 0.25:
		return
		
	for i in 2:
		var roid_inst = asteroid.instantiate() as CharacterBody2D
		if new_scale.x == 0.25: print("!!spawn!!")
		roid_inst.scale = new_scale
		roid_inst.position = a.position
		roid_inst.velocity = (Vector2.from_angle(rng.randf_range(0, 6.28)) * asteroid_speed) / new_scale
		add_child(roid_inst)
		
func _teleport_within_bounds(position: Vector2, size: Vector2):
	if position.y < -1 * size.y:
		position.y = viewport_size.y + size.y / 2
	elif position.y > viewport_size.y + size.y / 2:
		position.y = -1 * size.y / 2
	elif position.x < -1 * size.y / 2:
		position.x = viewport_size.x + size.y / 2
	elif position.x > viewport_size.x + size.y / 2:
		position.x = -1 * size.y / 2
		
	return position
	
	
func _fire_bullet():
	var bullet_inst = bullet.instantiate() as CharacterBody2D
	add_child(bullet_inst)
	
	bullet_inst.position = $Ship.position - $Ship.transform.y * ship_size.y / 2
	bullet_inst.spawn_point = bullet_inst.position
	bullet_inst.velocity = $Ship.transform.y * bullet_speed * -1
		
### !!! HELPER FUNCTIONS !!! ###
	
func _random_box_unit_vector(position: Vector2):
	var target = Vector2(v_pos.x + rng.randf_range(0, v_size.x), v_pos.y + rng.randf_range(0, v_size.y))
	return Vector2(target.x - position.x, target.y - position.y).normalized()
	
func _get_scene_size(a):
	var sprite = a.find_child("Sprite2D") as Sprite2D
	var rect = sprite.get_rect()
	return a.scale * (rect.size * sprite.scale)
	

### !!! SIGNALS !!! ###
func _on_ship_destroyed():
	if lives == 0:
		return
		
	$Ship.position = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	velocity = Vector2(0, 0)
	$Ship.rotation = 0
	$Ship.show()


func _on_game_over_blink_timeout():
	if lives == 0: $GameOver.visible = !$GameOver.visible


func _on_game_over_delay_timeout():
	pass
