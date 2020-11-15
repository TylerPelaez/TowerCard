extends Node

enum LevelConfig {
	TestLevel
}

enum {
	Basic,
	Fast
}

const DATA = {
	LevelConfig.TestLevel: [
		[
			{Basic: 5},
		],
		[
			{Basic: 15}
		],
		[
			{Basic: 15},
			{Fast: 5}
		]
	]
}

var CONFIGS_TO_SCENES = { 
	Basic: preload("res://Enemies/BasicEnemy.tscn"),
	Fast: preload("res://Enemies/FastEnemy.tscn")
}
