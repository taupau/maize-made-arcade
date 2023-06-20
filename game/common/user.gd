extends Node

var logged_in = null
var last_saved = null

var data = {}:
	set(value):
		_save_data(value)

func login_or_create(name: String, pin: int):
	var file = FileAccess.open("user://logins.json", FileAccess.READ)
	var data = file.get_line()
	file.close()
	
	var json = JSON.new()
	json.parse(data)
	
	var json_data: Dictionary = json.get_data()
	if json_data == null:
		json_data = {}
	
	if not json_data.has(name):
		json_data[name] = pin
		var write_file = FileAccess.open("user://logins.json", FileAccess.WRITE)
		write_file.store_line(JSON.stringify(json_data))
		write_file.close()
	
	if json_data[name] != pin:
		return false
	
	logged_in = name
	data = _get_data()
	return true

func _get_data():
	if logged_in == null:
		return null
	
	var file_name = "user://user_%s.json" % logged_in
	
	if not FileAccess.file_exists(file_name):
		return {}
	
	var file = FileAccess.open(file_name, FileAccess.READ)
	var data = file.get_line()
	file.close()
	var json = JSON.new()
	
	json.parse(data)
	return json.get_data()
	
func _get_or_create(data: Dictionary, field_name: String, default: Variant):
	if not data.has(field_name):
		data[field_name] = default
		return default
	else:
		return data[field_name]
		
func _save_data(data: Dictionary):
	var file_name = "user://user_%s.json" % logged_in
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
	
