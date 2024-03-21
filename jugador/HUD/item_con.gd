extends TextureRect

var upgrade = null
func _ready():
	if upgrade != null:
		$ItemTex.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
