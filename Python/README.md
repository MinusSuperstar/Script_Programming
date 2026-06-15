# Zadanie 5: 

:white_check_mark: 3.0 Czatbot z wytrenowaną umiejętnością (poprzez prompt) obsługi co
najmniej 3 sposobów sformułowania intencji (powitanie, menu,
zamówienie). [link do commita](https://github.com/MinusSuperstar/Script_Programming/commit/904367741ef195ef24a6bb26af5c13761cabf541)

:x: 3.5 Informacje o godzinach otwarcia i pozycjach w menu powinny być
pobierane z pliku konfiguracyjnego (JSON/YAML) i przekazywane do
modelu.

:x: 4.0 Czatbot musi przetworzyć zamówienie i potwierdzić zakupione
posiłki, a także obsłużyć dodatkowe prośby (np. alergie, modyfikacje
dań). Dane o alergiach, składzie, daniach ładowy z api aplikacji
webowej napisanej we Flasku
(https://flask.palletsprojects.com/en/stable/).

:x: 4.5 Czatbot musi potwierdzić, kiedy posiłek będzie dostępny do odbioru
w restauracji (estymacja czasu na podstawie zamówienia).

:x: 5.0 Czatbot powinien zapytać o adres dostawy i potwierdzić go, zamiast
opcji odbioru osobistego, weryfikując kompletność danych adresowych.
Zapisać zamówienie przez wywołanie api aplikacji we Flasku. We Flasku
zapisujemy dane zamówienia w bazie.


Kod [link do zadania 3](https://github.com/MinusSuperstar/Script_Programming/blob/main/Python/main.py)

### Instrukcja obsługi

Chatbot korzysta z modelu Ollama llama3.2, jest on wymagany do jego działania. Komendy pozwalające pobrać model (może chiwlę zająć):

'curl -fsSL https://ollama.ai/install.sh | sh
ollama pull llama3.2'

Po uruchomieniu użytkownik może wysyłać wiadomości i rozmawiać z chatbotem. Żeby zakończyć działanie program wpisz 'exit'.