import random

def generate_mistakes(word):
    typos = []

    # Missing a letter
    for i in range(len(word)):
        typo = word[:i] + word[i+1:] 
        typos.append(typo)

    # Doubling a letter
    for i in range(len(word)):
        typo = word[:i] + word[i] + word[i:]
        typos.append(typo)

    # Replace random letter
    index = random.randint(0, len(intent) - 1)
    random_char = chr(random.randint(97, 122))
    typos.append(intent[:index] + random_char + intent[index + 1:])

    return typos

while True:
    intent = input("Provide intent: ")
    if intent.lower() == "exit":
        break

    mistakes = generate_mistakes(intent)
    for mistake in mistakes:
        print(f"- {mistake}")