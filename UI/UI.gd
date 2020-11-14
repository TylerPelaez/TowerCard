extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Hand.connect("show_tooltip", self, "_on_ShowTooltip")
	$Hand.connect("hide_tooltip", self, "_on_HideTooltip")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ShowTooltip(tooltip_text):
	$Tooltip.text = tooltip_text
	$Tooltip.visible = true
	
func _on_HideTooltip():
	$Tooltip.text = "Hidden"
	$Tooltip.visible = false
