extends HBoxContainer
class_name Hand

const UICardScene: PackedScene = preload("res://Cards/UICard.tscn")

export var hand_limit: int = 5

func _ready() -> void:
	if Utils.is_main_scene(self):
		add_card(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
		add_card(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
		add_card(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))

func add_card(cardData: Card) -> bool:
	if _is_at_hand_limit():
		return false
	
	var uiCard = UICardScene.instance()
	add_child(uiCard)
	uiCard.initialize(cardData)
	return true
	
	
func _is_at_hand_limit() -> bool:
	return get_child_count() >= hand_limit
