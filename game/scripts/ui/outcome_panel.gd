extends PanelContainer

# A simple panel that we can pop up to select quit/restart after a game.

@export var restart: Button
@export var quit: Button
@export var label: Label

func _ready():
	Events.on_game_over.connect(game_over)
	quit.pressed.connect(func(): Events.request_quit.emit())
	restart.pressed.connect(func(): Events.request_restart_game.emit())
	Events.on_new_game_state_created.connect(hide)
	hide()
	
func game_over(win: bool):
	show()
	label.text = "You win" if win else "You lose"
