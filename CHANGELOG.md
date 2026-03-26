# Changelog

## [0.3.95] - 2026-03-26
- Ikony podglądu i pobierania pliku w tabeli plików zamówienia
- Podgląd obrazów w oknie modalnym; PDF i inne pliki w iframe modalnym
- Pobieranie bezpośrednio na dysk (atrybut `download`)
- Szybka edycja typu dokumentu inline w tabeli plików (klik → select → zmiana = zapis AJAX)
- Edycja inline nazw przewoźników i rodzajów dokumentów w ustawieniach (klik → input, Enter = zapis, Esc = anuluj)
- Usunięto przycisk „Zapisz" z wierszy listy przewoźników i rodzajów dokumentów

## [0.3.94] - 2026-03-26
- Pliki zamówień zapisywane w katalogu modułu (`uploads/purchase_orders/`) zamiast w `upload/` PrestaShop, który blokuje dostęp HTTP
- Poprawka pobierania / podglądu pliku po uploadzie

## [0.3.93] - 2026-03-26
- Poprawka: JS zarządzania przewoźnikami i rodzajami dokumentów nie ładował się w nowoczesnym layoucie (blok w warunkowym `{if}`)

## [0.3.92] - 2026-03-26
- Poprawka: bindowanie paneli CRUD nie działało gdy DOMContentLoaded już wystąpił

## [0.3.91] - 2026-03-26
- Drag & drop upload plików w zamówieniu
- Selektor rodzaju dokumentu przy uploadzie
- Pole przewoźnika zmienione z tekstowego na select (lista z ustawień)
- Zarządzanie przewoźnikami i rodzajami dokumentów w ustawieniach (dodaj / edytuj / usuń, AJAX)
- Poprawka kolorów plakietek statusów (usunięto klasę `badge` kolidującą z Bootstrap)

## [0.3.90] - 2026-03-26
- Kod waluty wyświetlany w podsumowaniu wartości tabeli pozycji zamówienia

## [0.3.89] - 2026-03-26
- Usunięto kolumnę „Waga kartonu brutto" z tabeli
- Poprawka kolorów etykiet statusów zamówień (pełne tło + biały tekst)
- Ikona kosza z domyślnego zestawu PS w ustawieniach

## [0.3.88] - 2026-03-26
- Zmiana etykiety kolumny objętości jednostkowej na „Objętość"

## [0.3.87] - 2026-03-26
- Dodano pole „Sztuk w kartonie" w formularzu danych logistycznych produktu

## [0.3.86] - 2026-03-26
- Poprawka stylu pola stawki celnej (%)
- Formatowanie liczb z separatorem tysięcy w podsumowaniu

## [0.3.85] - 2026-03-26
- Wymiary w cm, pole masy brutto, stawka celna %, dwuwierszowa nazwa produktu, wiersz podsumowania pozycji

## [0.3.84] - 2026-03-26
- Hover i link na wierszach listy zamówień
- Hover na tabeli pozycji
- Kompaktowy układ wiersza objętości

## [0.3.72] – [0.3.83]
- Kolejne poprawki i usprawnienia UI zamówień zakupu, tabeli produktów i panelu ustawień
