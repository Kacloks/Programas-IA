extends Node2D

# Variáveis principais
var player_health = 100
var ai_health = 100
var cooldowns = {"attack": 0.5, "defense": 1.0, "dash": 0.2}
var ai_action = null
var time_left = 60  # Tempo limite em segundos

# Referências aos personagens
onready var player = $Player
onready var ai = $AI

func _ready():
    start_game()

func _process(delta):
    update_cooldowns(delta)
    if time_left > 0:
        time_left -= delta
        process_ai_action(delta)
        check_end_conditions()
    else:
        end_game("timeout")

func start_game():
    player_health = 100
    ai_health = 100
    time_left = 60
    ai_action = null

func update_cooldowns(delta):
    for key in cooldowns.keys():
        if cooldowns[key] > 0:
            cooldowns[key] -= delta

func process_ai_action(delta):
    if ai_action:
        match ai_action:
            "attack":
                player_health -= ai.perform_attack()
            "defense":
                ai.perform_defense()
            "dash":
                ai.perform_dash()
        ai_action = null

func check_end_conditions():
    if player_health <= 0:
        end_game("ai_win")
    elif ai_health <= 0:
        end_game("player_win")

func end_game(result):
    if result == "ai_win":
        print("AI venceu!")
    elif result == "player_win":
        print("Jogador venceu!")
    elif result == "timeout":
        if ai_health > player_health:
            print("AI venceu por maior vida!")
        elif player_health > ai_health:
            print("Jogador venceu por maior vida!")
        else:
            print("Empate!")
    get_tree().quit()
