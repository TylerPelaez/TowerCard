extends Node2D
class_name PlayerController

signal card_played
signal card_deselected
signal heal_core(amount)

enum STATE {
	DEFAULT,
	PLACING_TOWER,
	CASTING
}

const BasicTowerResource: PackedScene = preload("res://Towers/BasicTower.tscn")

export var max_mana: int = 3
onready var current_mana = max_mana

var ui_state = STATE.DEFAULT
var held_tower
var selected_card
var selected_spell
var tower_that_was_being_upgraded


var level_placement_area

func _process(delta):
	# Force a draw call
	update()

func _draw():
	if ui_state == STATE.CASTING and selected_spell != null:
		draw_circle(get_local_mouse_position(), selected_spell.aoe, Color(0, 1, 0, 0.5))

func _physics_process(delta: float) -> void:
	if tower_that_was_being_upgraded != null:
		tower_that_was_being_upgraded.set_regular_color()
		tower_that_was_being_upgraded = null
	
	if ui_state == STATE.PLACING_TOWER:
		if held_tower == null:
			print("ERROR: state is PLACING_TOWER, but held_tower is null")
			return
		
		held_tower.global_position = held_tower.get_global_mouse_position()
			
		if !can_place_held_tower():
			var upgradable_tower = get_upgradable_tower()
			
			if upgradable_tower != null:
				held_tower.visible = false
				upgradable_tower.set_can_upgrade_color()
				tower_that_was_being_upgraded = upgradable_tower
			else:
				held_tower.visible = true
				held_tower.set_cant_place_color()
		else:
			held_tower.visible = true
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
				if !can_place_held_tower():
					print (held_tower.get_overlapping_areas())
					var upgradable_tower = get_upgradable_tower()
					if upgradable_tower != null:
						_spend_tower_on_upgrade(upgradable_tower)
				else:
					print("test")
					_place_tower()
		elif event.is_pressed() and event.is_action("cancel_tower_placement"):
			if selected_card == null:
				print("ERROR: selected card is null")
				return
			cancel_card_play()
	elif event.is_pressed() and event.is_action("rotate") and ui_state == STATE.PLACING_TOWER and held_tower != null:
		if held_tower.can_rotate():
			held_tower.rotate_tower()
			

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

func _spend_tower_on_upgrade(towerToUpgrade: BaseTower) -> void:
	held_tower.queue_free()
	held_tower = null
	towerToUpgrade.upgrade()
	ui_state = STATE.DEFAULT
	play_card()

func _start_casting_spell(spell: SpellCard) -> void:
	ui_state = STATE.CASTING
	selected_spell = spell.spell

func _cast_spell() -> void:
	if selected_spell.spell_name == "Heal Core":
		emit_signal("heal_core", selected_spell.damage)
	else:
		selected_spell.cast(get_global_mouse_position())
	selected_spell = null
	ui_state = STATE.DEFAULT
	play_card()

func can_place_held_tower() -> bool:
	if held_tower == null || level_placement_area == null:
		return false
	
	return held_tower.overlaps_area(level_placement_area) && held_tower.get_overlapping_areas().size() == 1

func get_upgradable_tower():
	if held_tower == null:
		return null
	
	var overlapping = held_tower.get_overlapping_areas()
	
	for area in overlapping:
		if area is BaseTower and area.get_class_name() == held_tower.get_class_name():
			return area
	
	return null

func cancel_card_play() -> void:
	if held_tower != null:
		held_tower.queue_free()
	ui_state = STATE.DEFAULT
	held_tower = null
	selected_card = null
	selected_spell = null
	emit_signal("card_deselected")

func reset_mana():
	current_mana = max_mana

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
	current_mana -= selected_card.mana_cost
	selected_card = null
	emit_signal("card_played")
