extends Node

# Card format: [cardName, cardType, image, text, trashes]
enum {Bunker}

const CardData = preload("res://Cards/Card.gd")

const DATA = {
	Bunker:	
		["Bunker", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/BunkerCard.png", "Basic Bunker", false],
}

func create_card_from_data(cardData: Array) -> Card:
	var card = CardData.new()
	card.initialize(cardData[0], cardData[1], cardData[2], cardData[3], cardData[4])
	return card
