# Inventory Report — moduł PrestaShop

Moduł Back Office do zarządzania zamówieniami zakupu, raportem magazynowym i danymi logistycznymi produktów.

**Wersja:** 0.5.13 · **Kompatybilność:** PrestaShop 8.2+

---

## Funkcjonalności

### Raport magazynowy

- Tabela wszystkich produktów i wariantów z kolumnami: ID, zdjęcie, nazwa, EAN, stan aktywności, cena zakupu, cena detaliczna netto/brutto
- **Edycja inline** cen zakupu i detalicznych bezpośrednio w tabeli (AJAX, bez przeładowania strony)
- Dane logistyczne produktu: waga (kg), objętość (m³), sztuki w kartonie, wymiary kartonu (cm), waga brutto
- Edycja danych logistycznych przez modal — pola MODEL, HS Code, materiał, opis, stawka celna, wymiary z jednostką cm
- Filtry: tylko aktywne, tylko dostępne (stan > 0), brak ceny zakupu, brak wagi
- Wyszukiwanie w tabeli po nazwie lub ID
- Sortowanie po każdej kolumnie
- Paginacja z wyborem liczby wierszy (20 / 50 / 100 / 200)
- Hover na miniaturze zdjęcia → podgląd większego obrazka (medium, z-index ponad wszystkie elementy PS BO)
- Ukrywanie produktów z raportu; przywracanie z listy ukrytych w ustawieniach
- Eksport tabeli do PDF
- Wykres sprzedaży i kalkulacja rentowności per produkt/wariant

---

### Dostawcy

- Lista dostawców z kolumnami: nazwa, adres, telefon, miasto, kraj, status
- Dodawanie, edycja i usuwanie dostawców (AJAX)
- Pola: nazwa, opis, telefon, adres, kod pocztowy, miasto, kraj, status aktywności
- Dostawcy dostępni jako opcje w zamówieniach zakupu

---

### Zamówienia zakupu

#### Lista zamówień
- Tabela z referencją, dostawcą, statusem, wartością i datą
- Kliknięcie wiersza otwiera szczegóły zamówienia

#### Szczegóły zamówienia
Sekcja **Szczegóły** z edycją inline (AJAX) wszystkich pól:

| Pole | Opis |
|------|------|
| Warunki dostawy | Select z kodami Incoterms 2020; tooltip z opisem po najechaniu |
| Data zamówienia | Datepicker |
| Data dostawy | Datepicker |
| Przewoźnik | Select z listy; plakietki UPS / DHL / inne |
| Numer faktury | Tekst |
| Koszt transportu | Liczba; walidacja ≥ 0 |
| Waluta | Kod waluty (np. EUR, USD) |
| Kurs waluty | Liczba > 0; 4 miejsca dziesiętne |
| Nr śledzenia | Tekst; automatyczny link do UPS / DHL Express |

#### Linia czasowa statusów
- Wizualna oś czasu z postępem zamówienia
- Zmiana statusu kliknięciem (AJAX)
- Kolory statusów konfigurowalne w ustawieniach

#### Produkty w zamówieniu
- Tabela pozycji: miniatura, nazwa, model, EAN, ilość, cena zakupu, wartość, waga, objętość, akcje
- Edycja inline: ilość i cena zakupu
- Przycisk **i** → popup z danymi produktu i kalkulatorem kosztów:
  - Cena zakupu × kurs waluty + transport na szt. = koszt netto
  - Koszt netto × (1 + narzut%) = cena detaliczna netto / brutto
  - Narzut edytowalny inline, zapisywany w localStorage
  - Marża obliczana dynamicznie
- Dodawanie produktu przez modal (wyszukiwanie, domyślna ilość = szt. w kartonie, ostatnia cena zakupu)
- Suma wartości zamówienia widoczna w nagłówku sekcji

#### Dokumenty
- Upload drag & drop (PDF, obrazy, XLS, ZIP — maks. 20 MB)
- Selektor rodzaju dokumentu
- Tabela plików: nazwa, typ, opis (edycja inline), podgląd, pobieranie, usuwanie
- Podgląd fullscreen (PDF w iframe, obrazy) z rozmyciem tła; zamknięcie kliknięciem tła lub klawiszem Escape

#### Generowanie PDF zamówienia
- Nagłówek z numerem referencji
- Sekcje: **Sprzedawca** (dostawca), **Nabywca** (adres dostawy), **Szczegóły** (meta-dane)
- Tabela produktów z miniaturami (small_default), modelem, EAN, ceną i wartością
- Nagłówki sekcji: biały tekst na ciemnym tle

---

### Ustawienia

| Sekcja | Opis |
|--------|------|
| Adres dostawy | Adres Nabywcy widoczny we wszystkich zamówieniach i PDF |
| Statusy zamówień | Dodawanie, edycja nazwy inline, zmiana koloru (color picker), usuwanie |
| Przewoźnicy | Lista przewoźników do selectów w zamówieniach |
| Rodzaje dokumentów | Typy plików do uploadu dokumentów |
| Incoterms 2020 | Tabela referencyjna z opisami kodów (EXW, FCA, FOB, CIF…) |
| Produkty ukryte | Lista ukrytych produktów z możliwością przywrócenia |
| Informacje o module | Wersja, status licencji, przycisk aktualizacji |

---

## Aktualizacje

Moduł obsługuje automatyczne aktualizacje przez Back Office PrestaShop:
- Sprawdzanie dostępności nowej wersji z podpisanego manifestu JSON
- Weryfikacja sumy kontrolnej SHA256 i podpisu RSA przed instalacją
- Przycisk **Dostępna aktualizacja X.Y.Z** pojawia się automatycznie gdy GitHub zawiera nowszą wersję
- Po aktualizacji: OPcache reset, aktualizacja wersji w bazie danych

---

## Instalacja

1. Pobierz najnowszy plik ZIP z zakładki [**Releases**](https://github.com/hejsiri/prestashopinventory-builds/releases/latest)
2. W panelu Back Office PrestaShop: **Moduły → Menedżer modułów → Wgraj moduł**
3. Wgraj ZIP — moduł zainstaluje się automatycznie
4. Po instalacji przejdź do: **Back Office → Raport magazynowy**

> Moduł wymaga ważnej licencji przypisanej do domeny sklepu.

---

## Wymagania

- PrestaShop 8.2 lub nowszy
- PHP 8.1+
- Rozszerzenia PHP: `pdo_mysql`, `openssl`, `zip`, `gd`
- Biblioteka [mPDF](https://mpdf.github.io/) (dołączona w paczce)
