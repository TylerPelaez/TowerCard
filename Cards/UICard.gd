extends MarginContainer
class_name UICard

onready var image = $ImageRect

var card_data

# Called when the node enters the scene tree for the first time.
func _ready():
	# For debugging
	if Utils.is_main_scene(self):
		initialize(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
	
func initialize(cardData: Card) -> void:
	card_data = cardData
	image.texture = load(card_data.image)
