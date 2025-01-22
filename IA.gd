extends Node2D

func perform_attack() -> int:
    # Escolher entre ataque normal, baixo ou potente
    var attack_type = randi() % 3
    match attack_type:
        0:
            return 3  # Corte normal
        1:
            return 1.5  # Corte baixo
        2:
            return 7  # Corte potente

func perform_defense():
    # Implementar lógica de defesa (ex.: reduzir dano)
    pass

func perform_dash():
    # Implementar lógica de dash (ex.: desviar de ataque)
    pass
