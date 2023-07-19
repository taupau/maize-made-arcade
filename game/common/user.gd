extends Node

var logged_in = null

func logout():
	logged_in = null

func login_or_create(username: String, pin: int):
	if not logged_in == null:
		logout()
	
	if not Global.db.query_with_bindings(
		"SELECT * FROM users WHERE name = ?;"
	, [username]): push_error("Could not get user from database!")
	
	var res: Array[Dictionary] = Global.db.query_result
	if res.size() == 0:
		if not Global.db.query_with_bindings(
			"INSERT INTO users (name, pin) VALUES (?, ?);"
		, [username, pin]): push_error("Could not add user to database!")
		return true
		
	if res[0]["pin"] == pin:
		logged_in = res[0]["name"]
		return true;
	else:
		return false;

