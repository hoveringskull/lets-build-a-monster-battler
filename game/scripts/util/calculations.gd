class_name Calculations

static func get_crit_chance(monster: Monster) -> float:
	return clamp(monster.speed / 100.0, 0.01, 0.5)

static func calculate_monster_stat(base: int, growth: float, level: int, condition_bonus: int):
	return clamp(base + (level * growth * base / 10.0) + condition_bonus, 1, 999)
	
static func experience_for_level(level: int):
	return 200 * level

static func experience_value_of_monster(monster: Monster):
	return 600 * monster.level
