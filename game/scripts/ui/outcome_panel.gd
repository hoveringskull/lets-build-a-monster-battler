extends PanelContainer

# A simple panel that we can pop up to select quit/restart after a game.

@export var restart: Button
@export var quit: Button
@export var label: Label

func _ready():
	# TODO: Connect up listeners here to show and bind events
	hide()
	
func game_over(win: bool):
	show()
	label.text = "You win" if win else "You lose"
