extends Node


enum LevelConfig {
	TestLevel,
	Level2,
	Level3
}


enum {
	Basic,
	Fast,
	Tank
}

const DATA = {
	LevelConfig.TestLevel: [
		[
			{Basic: 1},
		],
		[
			{Basic: 5}
		],
		[
			{Basic: 5},
			{Fast: 3}
		],
		[
			{Basic: 7},
			{Fast: 4}
		],
		[
			{Fast:20}
		],
		[
			{Basic: 15},
			{Fast: 10}
		],
		[
			{Basic:10},
			{Fast: 5},
			{Basic:10},
			{Fast: 5},
			{Basic:10},
			{Fast: 5},
			{Basic:10},
			{Fast: 5},
		],
		[
			{Basic:30},
			{Fast: 10},
			{Basic:30},
			{Fast: 10},			
		],
		[
			{Tank:6},
			{Fast: 5},
			{Tank:6},
			{Fast: 5},
		]
	],
	LevelConfig.Level2: [
		[
			{Basic: 1},
		],
		[
			{Basic: 5}
		],
		[
			{Basic: 5},
			{Fast: 3}
		],
		[
			{Basic: 7},
			{Fast: 4}
		],
		[
			{Fast:20}
		],
		[
			{Basic: 15},
			{Fast: 10}
		],
		[
			{Basic:10},
			{Fast: 5},
			{Basic:10},
			{Fast: 5},
			{Basic:10},
			{Fast: 5},
			{Basic:10},
			{Fast: 5},
		],
		[
			{Basic:30},
			{Fast: 10},
			{Basic:30},
			{Fast: 10},			
		],
		[
			{Tank:3},
			{Fast: 5},
			{Tank:3},
			{Fast: 5},
		]
	],

	LevelConfig.Level3: [
		
	]	
}

var CONFIGS_TO_SCENES = { 
	Basic: preload("res://Enemies/BasicEnemy.tscn"),
	Fast: preload("res://Enemies/FastEnemy.tscn"),
	Tank: preload("res://Enemies/TankEnemy.tscn")
}
