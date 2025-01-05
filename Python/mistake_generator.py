import string

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

    # Replace a letter with another
    for i in range(len(word)):
        for replacement in string.ascii_lowercase:
            if replacement != word[i]:  # Avoid replacing a letter with itself
                typo = word[:i] + replacement + word[i+1:]
                typos.append(typo)
    
    return typos

while True:
    word = input("Provide word: ")
    if word.lower() == "exit":
        break

    mistakes = generate_mistakes(word)
    for mistake in mistakes:
        print(f"- {mistake}")