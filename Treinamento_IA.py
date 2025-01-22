import torch
import random
import numpy as np
from collections import deque

class CombatAI:
    def __init__(self, input_size, hidden_size, output_size, lr=0.001, gamma=0.9):
        self.model = Linear_QNet(input_size, hidden_size, output_size)
        self.trainer = QTrainer(self.model, lr, gamma)
        self.memory = deque(maxlen=100_000)
        self.epsilon = 80  # Para controle de exploração
        self.n_games = 0

    def get_state(self, player_health, ai_health, time_left):
        return np.array([
            player_health / 100,
            ai_health / 100,
            time_left / 60
        ], dtype=np.float32)

    def remember(self, state, action, reward, next_state, done):
        self.memory.append((state, action, reward, next_state, done))

    def train_short_memory(self, state, action, reward, next_state, done):
        self.trainer.train_step(state, action, reward, next_state, done)

    def train_long_memory(self):
        if len(self.memory) > 1000:
            batch = random.sample(self.memory, 1000)
        else:
            batch = self.memory
        states, actions, rewards, next_states, dones = zip(*batch)
        self.trainer.train_step(states, actions, rewards, next_states, dones)

    def get_action(self, state):
        self.epsilon = max(10, 80 - self.n_games)
        if random.randint(0, 200) < self.epsilon:
            return random.randint(0, 2)  # Aleatório: ataque, defesa ou dash
        state_tensor = torch.tensor(state, dtype=torch.float)
        prediction = self.model(state_tensor)
        return torch.argmax(prediction).item()
