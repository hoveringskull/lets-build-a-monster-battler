extends Node

# Events sent from UI
signal request_menu_fight
signal request_menu_monsters
signal request_menu_back
signal request_menu_items
signal request_menu_run

# Events sent from controllers 
signal on_game_over
signal on_menu_fight
signal on_menu_select_monster
signal on_menu_items
signal on_monster_added_to_battle
signal on_new_game_state_created

# Events sent internally
signal request_log
signal on_ui_ready
