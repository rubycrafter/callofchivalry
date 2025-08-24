from PIL import Image
import os

icons = {
    "sword": (192, 192, 192),  # Silver
    "shield": (139, 69, 19),   # Brown
    "bow_arrows": (139, 69, 19),  # Saddle Brown
    "horse": (184, 134, 11),   # Dark Goldenrod
    "rope": (222, 184, 135),   # Burlywood
    "torch": (255, 69, 0),     # Orange Red
    "food": (0, 100, 0),       # Dark Green
    "water_flask": (30, 144, 255),  # Dodger Blue
    "warm_cloak": (72, 61, 139),    # Dark Slate Blue
    "map": (245, 245, 220)     # Beige
}

os.makedirs("game/assets/items", exist_ok=True)

for name, color in icons.items():
    img = Image.new('RGBA', (32, 32), color + (255,))
    img.save(f"game/assets/items/{name}_icon.png")
    print(f"Created {name}_icon.png")

print("All placeholder icons created!")