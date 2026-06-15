import requests
import json
import time

MODEL = "llama3.2"
PORT = 11434
ENDPOINT = "chat"
ADDRESS = f"http://localhost:{PORT}/api/{ENDPOINT}"

# Dane chatbota

MENU = {
    "Ciasto": {"Szarlotka": 20, "Sernik": 14, "Makowiec": 16, "Piernik": 14, "Brownie": 18},
    "Kawa": {"Czarna": 10, "Espresso": 7, "Cafe Late": 13, "Mocha": 15, "Kawa Mrożona": 17},
    "Herbata": {"Earl Gray": 10, "Owocowa": 12, "z Mlekiem": 12},
    "Kanapka": {"z Szynką": 15, "z Kurczakiem": 15, "z Serem": 12}
}

SYSTEM_PROMPT = """Jesteś sprzedawcą w kawiarnii "Pora na kawę".
Obsługujesz 3 sposoby sformułowania intencji:
    1. Powitanie: gdy użytkownik wita się, przywitaj się z nim uprzejmie i zapytaj w czym możesz pomóc.
    
    2. Menu: gdy użytkownik pyta o menu, przedstaw dostępne kategorie i przykładowe opcje z tych kategorii wraz z cenami
    
    3. Zamówienie: gdy użytkownik chce zamówić, potwierdź zamówienie i podaj łączną kwotę wszystkich zamówionych produktów
    
Jeśli intencje jest INNA niż te 3, uprzejmie odmówi i powiedz, że możesz pomóc tylko w sprawach związanych z kawiarnią.
Aktualne menu: """ + json.dumps(MENU, ensure_ascii=False)

hist = []

def detect_intent(text):
    text = text.lower()
    greet = ["cześć", "hej", "dzień dobry", "witaj", "witam", "hi", "hello", "siema", "dobry wieczór", "czesc"]
    menu = ["menu", "karta", "cennnik", "co mogę zamówić", "co polecasz", "oferta", "wybór", "lista"]
    order = ["zamawiam", "chcę zamówić", "chcę", "poproszę", "wezmę", "daj mi", "przynieś mi", "chicałbym"]

    if any(word in text for word in greet):
        return "powitanie"
    if any(word in text for word in menu):
        return "menu"
    if any(word in text for word in order):
        return "zamówienie"

    return "inne"

def ask_llama(messages):
    for i in range(3):
        r = requests.post(ADDRESS, json={
            "model": MODEL,
            "messages": messages,
            "stream": False,
            "options": {"temperature": 0.6, "num_predict":400}
        })
        data = r.json()
        if data.get("done_reason") == "load" or not data["message"]["content"].strip():
            time.sleep(2)
            continue
        return data["message"]["content"]
    return "(model się ładuje, spróbuj ponownie)"


# pętla czatu
while True:
    user = input("Ty: ")
    if user.lower() == "exit":
        break
    if not user.strip():
        continue
    intent = detect_intent(user)
    prompt = f"Intencja użytkownika: {intent}\nWiadomość: {user}"
    hist.append({"role": "user", "content": prompt})
    messages = [{"role": "system", "content": SYSTEM_PROMPT}] + hist
    ans = ask_llama(messages)
    #print(hist)
    hist.append({"role": "assistant", "content": ans})
    print("Bot: ", ans)