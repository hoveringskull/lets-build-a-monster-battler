class_name MonsterType

enum Type {
	NORMAL,
	PURE,
	WATER,
	FIRE,
	PLANT
}

enum Effectiveness {
	NEUTRAL,
	WEAK,
	STRONG
}

const DAMAGE_MODIFIER_BY_EFFECT: Dictionary[Effectiveness, float] = {
	Effectiveness.NEUTRAL: 1.0,
	Effectiveness.WEAK: 0.5,
	Effectiveness.STRONG: 2.0
}

# Stores how effective moves of the first level type are against monsters of the inner type
const EFFECTIVENESS_BY_TYPE: Dictionary[Type, Dictionary] = {
	Type.NORMAL: {},
	Type.FIRE: {
		Type.PLANT: Effectiveness.STRONG,
		Type.WATER: Effectiveness.WEAK,
	},
	Type.WATER: {
		Type.FIRE: Effectiveness.STRONG,
		Type.PLANT: Effectiveness.WEAK,
	},
	Type.PLANT: {
		Type.FIRE: Effectiveness.WEAK,
		Type.WATER: Effectiveness.STRONG
	},
}

static func get_type_effectiveness(source_type: Type, target_type: Type):
	if !EFFECTIVENESS_BY_TYPE.has(source_type) or !EFFECTIVENESS_BY_TYPE[source_type].has(target_type):
		return Effectiveness.NEUTRAL
	return EFFECTIVENESS_BY_TYPE[source_type][target_type]

static func get_type_advantage_coefficient(source_type: Type, target_type: Type):
	var effectiveness = get_type_effectiveness(source_type, target_type)
	return DAMAGE_MODIFIER_BY_EFFECT[effectiveness]
