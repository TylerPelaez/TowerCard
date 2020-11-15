extends Node

# Card format: [cardName, cardType, image, text, trashes, {towerprefab or enum for spell lookup}, mana cost]
enum {Bunker, LightningCard, Missile, RepulsorTowerCard, EMPCard, HealCore}

const DATA = {
	Bunker:	
		["Bunker", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/BunkerCard.png", "MG Bunker\nShoots bullet at foes", false, preload("res://Towers/BasicTower.tscn"), 2],
	Missile:
		["Missile", Card.CARD_TYPE.SPELL, "res://Cards/Card Images/MissileCard.png", "Missile Strike\nDoes AOE damage", false, Missile, 0],
	LightningCard:
		["Lightning", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/LightningTowerCard.png", "Lightning Tower\nChains lightning\nto multiple foes", false, preload("res://Towers/LightningTower.tscn"), 2],
	RepulsorTowerCard:
		["Repulsor", Card.CARD_TYPE.TOWER, "res://Cards/Card Images/RepulsorTowerCard.png", "Repulsor Tower\nR to rotate\nSlows foes", false, preload("res://Towers/RepulsorTower.tscn"), 1],
	EMPCard:
		["EMP", Card.CARD_TYPE.SPELL, "res://Cards/Card Images/EMPCard.png", "Electro-Magnetic\nPulse\nStuns foes", false, EMPCard, 1],
	HealCore:
		["Heal Core", Card.CARD_TYPE.SPELL, "res://Cards/Card Images/HealCoreCard.png", "Heals 30\nCore Damage\nSingle Use", true, HealCore, 1]
}

# Too lazy to move this to another class.
# spell format: [name, aoe radius, damage, single target, scene]
const SPELL_DATA = {
	Missile:
		["Missile", 50, 7, false, preload("res://Spells/MissileProjectile.tscn")],
	EMPCard:
		["EMP", 75, 0, false, preload("res://Spells/EMPProjectile.tscn")],
	HealCore:
		["Heal Core", 0, 30, false, null] # Damage is the heal amount
}

func create_card_from_data(cardData: Array) -> Card:
	var card
	# Truly the epitome of OOP
	match cardData[1]:
		Card.CARD_TYPE.SPELL:
			card = SpellCard.new()
			card.initialize(cardData[0], cardData[1], cardData[2], cardData[3], cardData[4], cardData[6])
			var entry = SPELL_DATA[cardData[5]]
			var spell = Spell.new()
			spell.initialize(entry[0], entry[1], entry[2], entry[3], entry[4])
			card.spell = spell
		Card.CARD_TYPE.TOWER:
			card = TowerCard.new()
			card.initialize(cardData[0], cardData[1], cardData[2], cardData[3], cardData[4], cardData[6])
			card.tower = cardData[5]
	return card
