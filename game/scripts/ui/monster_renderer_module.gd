class_name MonsterRendererModule extends Control

@export 
var your_pov: bool

@export 
var frame: Control

@export
var data_panel: Control

@export
var name_label: Label

@export
var hp_label: Label

@export 
var hp_bar: ProgressBar

@export
var status_label: Label

@export
var sprite: Sprite2D

func _ready() -> void:
	# TODO: listen for events ot connect and update the monster
	return
