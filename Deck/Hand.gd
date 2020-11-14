extends HBoxContainer
class_name Hand

# This class instantiates UICards from Card objects
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
	
	var uiCard: UICard = UICardScene.instance()
	add_child(uiCard)
	uiCard.initialize(cardData)
	return true

# This calls queue free on the ui card, don't use the passed in card after calling this function
func discard_card(card: UICard) -> bool:
	for child in get_children():
		if child == card:
			remove_child(card)
			card.queue_free()
			return true
	return false
	
func _is_at_hand_limit() -> bool:
	return get_child_count() >= hand_limit
