extends Node
class_name Card

enum CARD_TYPE {
	TOWER,
	SPELL
}

var card_name
var card_type
var image
var text

# Cards should discard, not trash by default
var trashes = false

func initialize(cardName: String, cardType: int, imagePath: String, cardText: String, trash: bool ) -> void:
	card_name = cardName
	card_type = cardType
	image = imagePath
	text = cardText
	trashes = trash
