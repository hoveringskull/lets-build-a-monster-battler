class_name Monster

var species: SpeciesResource
var hp: int
var nickname: String
var moves: Array[Move]

var max_hp: int:
	get: return species.max_hp

var image: Texture2D:
	get: return species.image
	
var name: String:
	get: return nickname if nickname else species.name
