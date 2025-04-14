extends Node
signal dialogue_enabled
signal dialogue_disabled

signal game_won(ingame)
signal game_over(ingame)

signal hide_object(object_name)
signal show_object(object_name)

signal hide_npc(npc_name)
signal show_npc(npc_name)

signal enable_outside

var telephone_state: String = "start"
var lady_state: String = "start"
var churchhill_state: String = "start"
var bear_state: String = "start"
