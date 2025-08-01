class_name Monster

var species: SpeciesResource
var hp: int
var nickname: String
var moves: Array[Move]

var image: Texture2D:
	get: return species.image
	
var name: String:
	get: return nickname if nickname else species.name

var type: MonsterType.Type:
	get: return species.type

var max_hp: int:
	get: return species.base_max_hp

var attack: int:
	get: return species.base_attack
	
var defence: int:
	get: return species.base_defence
	
var speed: int:
	get: return species.base_speed
	
func dump_state():
	return "Name: {name}\n Hp:({hp}/{max_hp})\n ATK: {attack} \n DEF: {defence} \n SPD: {speed}"\
		.format({
			"name": name,
			"attack": attack,
			"defence": defence,
			"speed": speed,
			"hp": hp,
			"max_hp": max_hp
		})
