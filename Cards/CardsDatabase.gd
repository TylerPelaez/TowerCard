extends Node

# Card format: [cardName, cardType, image, text, trashes]
enum {Bunker, LightningCard, Missile, RepulsorTowerCard, EMPCard}

const DATA = {
	Bunker:	
		["Bunker", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/BunkerCard.png", "Basic Bunker", false, preload("res://Towers/BasicTower.tscn")],
	Missile:
		["Missile", Card.CARD_TYPE.SPELL, "res://Cards/Card Images/MissileCard.png", "Missile Strike", false, Missile],
	LightningCard:
		["Lightning", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/LightningTowerCard.png", "Lightning Tower", false, preload("res://Towers/LightningTower.tscn")],
	RepulsorTowerCard:
		["Repulsor", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/RepulsorTowerCard.png", "Repulsor Tower", false, preload("res://Towers/RepulsorTower.tscn")],
	EMPCard:
		["EMP", Card.CARD_TYPE.SPELL, "res://Cards/Card Images/EMPCard.png", "Electro-Magnetic Pulse", false, EMPCard]
}

# Too lazy to move this to another class.
# spell format: [name, aoe radius, damage, single target, scene]
const SPELL_DATA = {
	Missile:
		["Missile", 50, 5, false, preload("res://Spells/MissileProjectile.tscn")],
	EMPCard:
		["EMP", Card.CARD_TYPE.SPELL, 100, 0, false, preload("res://Spells/EMPSpell.tscn")]
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
