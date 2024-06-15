extends Area3D

var slowing_down = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _on_body_entered(body):
	if body.is_in_group("car"):
		print(body.get_speed())
		if body.get_speed() < 30.0:  
			body.get_node("Hud").hide()
			body.get_node("RepairShopPanel").show()
			body.get_node("RepairShopPanel").get_node("VBC").get_node("ScrapCount").text = "Scrap: " + str(body.get_scrap_count())
			slowing_down = true

func _physics_process(delta):
	if slowing_down:
		var car = get_tree().get_nodes_in_group("car")[0]  
		var linear_velocity = car.linear_velocity
		linear_velocity -= linear_velocity * delta * 2  
		car.linear_velocity = linear_velocity
		
		if linear_velocity.length_squared() < 0.1:
			slowing_down = false

func _on_body_exited(body):
	body.get_node("RepairShopPanel").hide()
	body.get_node("Hud").show()
