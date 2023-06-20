extends Node

func get_data(user: String):
	var file_name = "user://user_%s.json" % user
	
	if not FileAccess.file_exists(file_name):
		return {}
	
	var file = FileAccess.open(file_name, FileAccess.READ)
	var data = file.get_line()
	file.close()
	var json = JSON.new()
	
	json.parse(data)
	return json.get_data()
	
func get_or_create_field(data: Dictionary, field_name: String, default: Variant):
	if not data.has(field_name):
		data[field_name] = default
		return default
	else:
		return data[field_name]
		
func save_data(user: String, data: Dictionary):
	var file_name = "user://user_%s.json" % user
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
	
