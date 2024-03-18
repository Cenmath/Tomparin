extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const UPGRADES = {
	"flecha1": {
		"icon": WEAPON_PATH + "Flecha.png",
		"displayname": "Flecha",
		"details": "Puedes disparar flechas contra el enemigo",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"flecha2": {
		"icon": WEAPON_PATH + "Flecha.png",
		"displayname": "Flecha",
		"details": "Disparas mas rápido aun, por fin has conseguido la dactilera",
		"level": "Level: 2",
		"prerequisite": ["flecha1"],
		"type": "weapon"
	},
	"flecha3": {
		"icon": WEAPON_PATH + "Flecha.png",
		"displayname": "Flecha",
		"details": "Has conseguido terminar de mejorar la herreria, Espero que Kotone siga tu ejemplo",
		"level": "Level: 3",
		"prerequisite": ["flecha2"],
		"type": "weapon"
	},
	"flecha4": {
		"icon": WEAPON_PATH + "Flecha.png",
		"displayname": "Flecha",
		"details": "Has logrado graduarte de la escuela de Kipchak",
		"level": "Level: 4",
		"prerequisite": ["flecha3"],
		"type": "weapon"
	},
	"jinetompa1": {
		"icon": WEAPON_PATH + "JinetompaA.png",
		"displayname": "Jinetompa",
		"details": "Por fin lograste llegar a la edad de los castillos, obtienes un Jinetompa",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"jinetompa2": {
		"icon": WEAPON_PATH + "JinetompaA.png",
		"displayname": "Jinetompa",
		"details": "Has completado las mejoras del Jinetompa, recuerda siempre usar la herreria",
		"level": "Level: 2",
		"prerequisite": ["jinetompa1"],
		"type": "weapon"
	},
	"jinetompa3": {
		"icon": WEAPON_PATH + "JinetompaA.png",
		"displayname": "Jinetompa",
		"details": "Parece que los Jinetompas van motivados al ataque, suelen atacar mas antes de volver",
		"level": "Level: 3",
		"prerequisite": ["jinetompa2"],
		"type": "weapon"
	},
	"jinetompa4": {
		"icon": WEAPON_PATH + "JinetompaA.png",
		"displayname": "Jinetompa",
		"details": "El Jinetompa ha upgradeado a Caballero, lastimosamente no tenemos mejora de Paladin",
		"level": "Level: 4",
		"prerequisite": ["jinetompa3"],
		"type": "weapon"
	},
	"tompa1": {
		"icon": WEAPON_PATH + "Tompa.png",
		"displayname": "Tompa",
		"details": "Un Tompa acude al llamado de la oveja",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tompa2": {
		"icon": WEAPON_PATH + "Tompa.png",
		"displayname": "Tompa",
		"details": "parece que los tompas se multiplican con agua",
		"level": "Level: 2",
		"prerequisite": ["tompa1"],
		"type": "weapon"
	},
	"tompa3": {
		"icon": WEAPON_PATH + "Tompa.png",
		"displayname": "Tompa",
		"details": "Los tompas han logrado hacerse con las mejoras de herreria",
		"level": "Level: 3",
		"prerequisite": ["tompa2"],
		"type": "weapon"
	},
	"tompa4": {
		"icon": WEAPON_PATH + "Tompa.png",
		"displayname": "Tompa",
		"details": "Gracias al Sujeto hemos logrado hacernos con la Movilización de los Godos",
		"level": "Level: 4",
		"prerequisite": ["tompa3"],
		"type": "weapon"
	},
	"armadura1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduce el daño recibido en 1, por desgracia no somos romanos",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armadura2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduce el daño recibido en 1 nuevamente, que alegria que no somos Tártaros",
		"level": "Level: 2",
		"prerequisite": ["armadura1"],
		"type": "upgrade"
	},
	"armadura3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reducimos aun mas el daño recibido, parece que tenemos todas las mejoras de herreria",
		"level": "Level: 3",
		"prerequisite": ["armadura2"],
		"type": "upgrade"
	},
	"armadura4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "¡Aun mas reducción de daño! logramos conseguir la mejora de Gambeson",
		"level": "Level: 4",
		"prerequisite": ["armadura3"],
		"type": "upgrade"
	},
	"velocidad1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Aumenta la velocidad de movimiento de la Kotone, corre cachulo",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"velocidad2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Por fin desarrollamos Escuderos.. ¡Squires!",
		"level": "Level: 2",
		"prerequisite": ["velocidad1"],
		"type": "upgrade"
	},
	"velocidad3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Parece que al ser mitad animal, la Koto tambien recibe mejora de Ganadería",
		"level": "Level: 3",
		"prerequisite": ["velocidad2"],
		"type": "upgrade"
	},
	"velocidad4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "¡Ha llegado la Kotocelta!",
		"level": "Level: 4",
		"prerequisite": ["velocidad3"],
		"type": "upgrade"
	},
	"doujin1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Doujin",
		"details": "Parte de los escritos secretos de Kotone, aumenta su cerebro asi como el tamaño de sus ataques",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"doujin2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Doujin",
		"details": "Primera parte del Doujin de Hetalia, hace aun mas grandes los ataques",
		"level": "Level: 2",
		"prerequisite": ["doujin1"],
		"type": "upgrade"
	},
	"doujin3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Doujin",
		"details": "Segunda parte del Doujin de Hetalia, coming soon",
		"level": "Level: 3",
		"prerequisite": ["doujin2"],
		"type": "upgrade"
	},
	"doujin4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Doujin",
		"details": "Ultima parte del Doujin de Hetalia, el cerebro de Kotone crecio en un 10% como sus ataques",
		"level": "Level: 4",
		"prerequisite": ["doujin3"],
		"type": "upgrade"
	},
	"escrituras1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Escrituras",
		"details": "Escrituras de Kotone para aprender Japones, gracias a desbloquear parte de su potencial usa ataques mas rápido",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"escrituras2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Escrituras",
		"details": "Kotone llega a desbloquear la mitad de su potencial de transjaponesa, haciendo ataques aun mas rápido",
		"level": "Level: 2",
		"prerequisite": ["escrituras1"],
		"type": "upgrade"
	},
	"escrituras3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Escrituras",
		"details": "Kotone a punto de desbloquear el 100% de su potencial, puede jugar cualquier juego en Japones",
		"level": "Level: 3",
		"prerequisite": ["escrituras2"],
		"type": "upgrade"
	},
	"escrituras4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Escrituras",
		"details": "Kotone 100% transjaponesa, debido a esto la Kotone ataca tan rapido como campeón japones",
		"level": "Level: 4",
		"prerequisite": ["escrituras3"],
		"type": "upgrade"
	},
	"agecito1": {
		"icon": ICON_PATH + "AoE2.png",
		"displayname": "Agecito",
		"details": "¿Sale un age? aumenta el numero de tompas, jinetes y flechas",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"agecito2": {
		"icon": ICON_PATH + "AoE2.png",
		"displayname": "Agecito",
		"details": "¿Qué mejor que una partida de age? dos partidas de age, aumenta el numero de tompas, jinetes y flechas",
		"level": "Level: 2",
		"prerequisite": ["agecito1"],
		"type": "upgrade"
	},
	"croissant": {
		"icon": ICON_PATH + "Croissant.png",
		"displayname": "Croissant",
		"details": "Nom nom, te cura 20 de vida",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
