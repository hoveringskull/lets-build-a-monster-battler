class_name GameState

var player: Trainer
var opponent: Trainer
var is_player_turn: bool

var player_monster: Monster:
	get: return player.current_monster

var opponent_monster: Monster:
	get: return opponent.current_monster
