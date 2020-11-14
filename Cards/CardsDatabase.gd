extends Node

# Card format: [cardName, cardType, image, text, trashes]
enum {Bunker, Missile}

const DATA = {
	Bunker:	
		["Bunker", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/BunkerCard.png", "Basic Bunker", false, preload("res://Towers/BasicTower.tscn")],
	Missile:
		["Missile", Card.CARD_TYPE.SPELL, "res://Cards/Card Images/MissileCard.png", "Missile Strike", false, Missile]
}

# Too lazy to move this to another class.
# spell format: [name, aoe radius, damage, single target]
const SPELL_DATA = {
	Missile:
		["Missile", 30, 10, false, preload("res://Spells/MissileProjectile.tscn")]
}

func create_card_from_data(cardData: Array) -> Card:
	var card
	# Truly the epitome of OOP
	match cardData[1]:
		Card.CARD_TYPE.SPELL:
			card = SpellCard.new()
			card.initialize(cardData[0], cardData[1], cardData[2], cardData[3], cardData[4])
			var entry = SPELL_DATA[cardData[5]]
			var spell = Spell.new()
			spell.initialize(entry[0], entry[1], entry[2], entry[3], entry[4])
			card.spell = spell
		Card.CARD_TYPE.TOWER:
			card = TowerCard.new()
			card.initialize(cardData[0], cardData[1], cardData[2], cardData[3], cardData[4])
			card.tower = cardData[5]
	return card
