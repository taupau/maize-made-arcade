extends Node

var logged_in = null

var data = {}


func logout():
	logged_in = null
	data = {}


func _read_file_or_init(file_name: String):
	if not FileAccess.file_exists(file_name):
		var file = FileAccess.open(file_name, FileAccess.WRITE)
		file.store_line(JSON.stringify({}))
		file.close()

	return FileAccess.open(file_name, FileAccess.READ)


func login_or_create(username: String, pin: String):
	if not logged_in == null:
		logout()

	var file = _read_file_or_init("user://logins.json")
	var raw = file.get_line()
	file.close()

	var json = JSON.new()
	json.parse(raw)

	var json_data: Dictionary = json.get_data()
	if json_data == null:
		json_data = {}

	if not json_data.has(username):
		json_data[username] = pin
		var write_file = FileAccess.open("user://logins.json", FileAccess.WRITE)
		write_file.store_line(JSON.stringify(json_data))
		write_file.close()

	if json_data[username] != pin:
		return false

	logged_in = username
	_get_data()
	return true


func get_or_default(field: String, default: Variant):
	return default if not data.has(field) else data[field]


func _get_data():
	if logged_in == null:
		return null

	var file_name = "user://user_%s.json" % logged_in

	if not FileAccess.file_exists(file_name):
		return {}

	var file = _read_file_or_init(file_name)
	var user_data = file.get_line()
	file.close()
	var json = JSON.new()

	json.parse(user_data)
	data = json.get_data()


func save_data():
	if logged_in == null:
		return

	var file_name = "user://user_%s.json" % logged_in
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
