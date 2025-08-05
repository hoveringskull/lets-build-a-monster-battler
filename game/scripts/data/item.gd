class_name Item

var resource: ItemResource
var quantity: int

var name: String:
	get: return resource.name

var use_message: String:
	get: return resource.use_message
