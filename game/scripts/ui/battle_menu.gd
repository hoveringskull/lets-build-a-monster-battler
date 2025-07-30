extends Control

@export var select_fight: Button
@export var select_run: Button
@export var select_mon: Button
@export var select_item: Button
@export var select_back: Button

@export var main_menu: Control
@export var fight_menu: OptionPanel
@export var item_menu: OptionPanel
@export var mon_menu: OptionPanel


func _ready():
	# Connect signal listeners
	select_fight.pressed.connect(Events.request_menu_fight.emit)
	select_mon.pressed.connect(Events.request_menu_monsters.emit)
	select_item.pressed.connect(Events.request_menu_items.emit)
	select_run.pressed.connect(handle_select_run)
	select_back.pressed.connect(handle_select_main)
	Events.on_menu_fight.connect(handle_select_fight)
	Events.on_menu_select_monster.connect(handle_select_monsters)
	Events.on_menu_items.connect(handle_select_items)

	# Activate the main menu 
	handle_select_main()

func is_interaction_blocked():
	# TODO: We will want to block interaction at some point. We can use this for that.
	return false

func hide_all():
	# Hides all menus. Useful since we only want one to show at a time.
	main_menu.hide()
	fight_menu.hide()
	select_back.hide()
	mon_menu.hide()
	item_menu.hide()

func handle_select_main():
	hide_all()
	main_menu.show()

func handle_select_fight(labels: Array[StringEnabled]):
	if is_interaction_blocked():
		return
	hide_all()
	fight_menu.show()
	select_back.show()
	
	fight_menu.populate(labels)


func handle_select_monsters(labels: Array[StringEnabled]):
	if is_interaction_blocked():
		return
	hide_all()
	mon_menu.show()
	select_back.show()
	
	mon_menu.populate(labels)


func handle_select_items(labels: Array[StringEnabled]):
	if is_interaction_blocked():
		return
	hide_all()
	item_menu.show()
	select_back.show()
	
	item_menu.populate(labels)


func handle_select_run():
	# Since we only have battles and no overworld in this prototype, running means quitting.
	if is_interaction_blocked():
		return
	
	Events.request_log.emit("You run away. Your cowardice will not be forgotten")
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.timeout.connect(func(): Events.request_menu_run.emit())
	timer.start()
