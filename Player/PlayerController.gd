extends Node2D
class_name PlayerController

signal card_played
signal card_deselected

enum STATE {
	DEFAULT,
	PLACING_TOWER,
	CASTING
}

const BasicTowerResource: PackedScene = preload("res://Towers/BasicTower.tscn")

var ui_state = STATE.DEFAULT
var held_tower
var selected_card
var selected_spell

var level_placement_area

func _physics_process(delta: float) -> void:
	if ui_state == STATE.PLACING_TOWER:
		if held_tower == null:
			print("ERROR: state is PLACING_TOWER, but held_tower is null")
			return
		
		held_tower.global_position = held_tower.get_global_mouse_position()
			
		if !can_place_held_tower():
			held_tower.set_cant_place_color()
		else:
			held_tower.set_can_place_color()

func _unhandled_input(event):
	if ui_state == STATE.DEFAULT:
		return
	
	if event is InputEventMouseButton:
		if event.is_pressed() and event.is_action("place_tower"):
			if selected_card == null:
				print("ERROR: selected_card is null")
				return
			
			if ui_state == STATE.CASTING and selected_spell != null:
				_cast_spell()
			elif ui_state == STATE.PLACING_TOWER and held_tower != null:
				_place_tower()
		elif event.is_pressed() and event.is_action("cancel_tower_placement"):
			if selected_card == null:
				print("ERROR: selected card is null")
				return
			
			cancel_card_play()

func set_level_placement_area(area: Node) -> void:
	level_placement_area = area

func _start_placing_tower(tower: PackedScene) -> void:
	ui_state = STATE.PLACING_TOWER
	var instance = tower.instance()
	get_tree().current_scene.add_child(instance)
	instance.global_position = instance.get_global_mouse_position()
	held_tower = instance
	
func _place_tower() -> void:
	held_tower.build_tower()
	held_tower = null
	ui_state = STATE.DEFAULT
	play_card()

func _start_casting_spell(spell: SpellCard) -> void:
	ui_state = STATE.CASTING
	selected_spell = spell.spell

func _cast_spell() -> void:
	selected_spell.cast(get_global_mouse_position())
	selected_spell = null
	ui_state = STATE.DEFAULT
	play_card()

func can_place_held_tower() -> bool:
	if held_tower == null || level_placement_area == null:
		return false
	
	return held_tower.overlaps_area(level_placement_area) && held_tower.get_overlapping_areas().size() == 1

func cancel_card_play() -> void:
	if held_tower != null:
		held_tower.queue_free()
	ui_state = STATE.DEFAULT
	held_tower = null
	selected_card = null
	selected_spell = null
	emit_signal("card_deselected")

func select_card(card: Card) -> void:
	if selected_card != null:
		print("ERROR: Selected card is not null, but new card was selected")
		return
	
	selected_card = card
	if card.card_type == Card.CARD_TYPE.TOWER:
		_start_placing_tower(card.tower)
	else:
		_start_casting_spell(card)

func play_card() -> void:
	selected_card = null
	emit_signal("card_played")
