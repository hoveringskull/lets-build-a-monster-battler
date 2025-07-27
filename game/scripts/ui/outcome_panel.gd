extends PanelContainer

# A simple panel that we can pop up to select quit/restart after a game.

@export var restart: Button
@export var quit: Button
@export var label: Label

func _ready():
	# Connect signals
	Events.on_game_over.connect(game_over)
	Events.on_new_game_state.connect(hide)
	restart.pressed.connect(Events.request_restart.emit)
	quit.pressed.connect(Events.request_quit.emit)
	
	hide()
	
func game_over(win: bool):
	show()
	label.text = "You win" if win else "You lose"
