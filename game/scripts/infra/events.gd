extends Node

# Events sent from UI
signal request_option_selected
signal request_restart
signal request_quit
signal request_menu_fight
signal request_menu_monsters
signal request_menu_back
signal request_menu_items

# Events sent from controllers 
signal on_battle_is_setup
signal on_ui_ready
signal on_new_game_state
signal on_game_over
signal on_menu_fight
signal on_menu_select_monster
signal on_menu_items

# Events sent internally
signal request_log
