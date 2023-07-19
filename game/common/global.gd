extends Node

var scene = null
var db: SQLite
var db_name = "user://data.db"


func _ready():
	var root = get_tree().root
	scene = root.get_child(root.get_child_count() - 1)
	
	db = SQLite.new()
	db.path = db_name
	if not db.open_db():
		push_error("Could not connect to DB!")
	_setup_db()
		
func _setup_db():
	db.query("DROP TABLE asteroids_scores;")
	db.query("DROP TABLE pong_scores;")
	db.query("DROP TABLE users;")
	
	if (
		not db.query("CREATE TABLE IF NOT EXISTS users (
			id INTEGER PRIMARY KEY AUTOINCREMENT, 
			name VARCHAR(8) NOT NULL, pin INTEGER NOT NULL);") or 

		not db.query("CREATE TABLE IF NOT EXISTS pong_scores (
			id INTEGER PRIMARY KEY AUTOINCREMENT, 
			user_id INTEGER NOT NULL, 
			easy_score INTEGER DEFAULT 0, 
			medium_score INTEGER DEFAULT 0, 
			high_score INTEGER DEFAULT 0, 
			FOREIGN KEY (user_id) REFERENCES users (id));") or

		not db.query("CREATE TABLE IF NOT EXISTS asteroids_scores (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			user_id INTEGER NOT NULL,
			score INTEGER DEFAULT 0,
			FOREIGN KEY (user_id) REFERENCES users (id));")
	): push_error("Could not create database tables!")


func change_scene(path):
	call_deferred("_change_scene", path)


func _change_scene(path):
	scene.free()
	scene = ResourceLoader.load(path).instantiate()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
