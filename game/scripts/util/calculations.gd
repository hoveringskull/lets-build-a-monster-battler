class_name Calculations

static func get_crit_chance(monster: Monster) -> float:
	return clamp(monster.speed / 100.0, 0.01, 0.5)
