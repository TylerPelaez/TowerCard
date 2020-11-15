extends Node
class_name Card

enum CARD_TYPE {
	TOWER,
	SPELL,
	STAT_UPGRADE
}

var card_name
var card_type
var image
var text
var mana_cost

# Cards should discard, not trash by default
var trashes = false

func initialize(cardName: String, cardType: int, imagePath: String, cardText: String, trash: bool, manaCost: int ) -> void:
	card_name = cardName
	card_type = cardType
	image = imagePath
	text = cardText
	trashes = trash
	mana_cost = manaCost
