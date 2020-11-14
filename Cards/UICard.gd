extends MarginContainer


# Declare member variables here. Examples:
onready var CardDatabase = preload("res://Cards/CardsDatabase.gd")
var cardName = "Bunker"
onready var cardInfo = CardDatabase.DATA[CardDatabase.get(cardName)]
onready var cardImagePath = cardInfo[2]

# Called when the node enters the scene tree for the first time.
func _ready():
	var cardSize = rect_size
	# Scale card back to current card scene size
	$CardBack.scale *= cardSize/$CardBack.texture.get_size()
	# Scale image on card to current size of margin container
	$Image.texture = load(cardImagePath)
	$Image.position = Vector2(cardSize.x/2, cardSize.y/3)
	$Image.scale *= cardSize/$Image.texture.get_size()/2
	
	$CardLabel.text = cardInfo[0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
