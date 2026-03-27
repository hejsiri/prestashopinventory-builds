## [0.5.4] - 2026-03-27
- Kalkulacja kosztu produktu: przycisk „i" w kolumnie akcji tabeli pozycji zamówienia
- Popup z danymi produktu (model, EAN, HS Code, materiał, opis, waga, szt. w kartonie, objętość)
- Kalkulacja krok po kroku: cena × kurs → koszt całkowity → narzut → cena detaliczna netto/brutto
- Narzut edytowalny inline, zapisywany w localStorage
- Marża obliczana dynamicznie

## [0.5.3] - 2026-03-27
- Poprawka: paczka ZIP zawiera teraz folder `prestashopinventory/` (był błędny `prestashopinventory-source/`)
- Przycisk aktualizacji: zmieniono tekst na „Dostępna aktualizacja X.Y.Z"

## [0.5.2] - 2026-03-27
- Breadcrumb ujednolicony we wszystkich zakładkach: „Raport magazynowy > [sekcja]"

## [0.5.1] - 2026-03-27
- Panel „Pliki" przemianowany na „Dokumenty"
- Kolumna „Plik" w tabeli zmieniona na „Nazwa pliku"
- Lista plików wyświetlana przed uploaderem
- Ikona podglądu tylko dla PDF i obrazów (ukryta dla xls, zip itp.)
- Podgląd fullscreen z rozmyciem tła (backdrop-filter blur)
- Poprawka Safari: iframe PDF odtwarzany od zera przy każdym otwarciu (brak artefaktu zoomowania)
- Podgląd zamknięty klawiszem Escape lub kliknięciem tła

## [0.5.0] - 2026-03-26
- Modal dodawania produktu do zamówienia: domyślna ilość = szt. w kartonie (fallback 1)
- Modal dodawania produktu: usunięto kolumnę „Cena domyślna"
- Modal dodawania produktu: pole ceny zakupu wstępnie wypełnione ostatnią ceną z poprzednich zamówień

## [0.4.9] - 2026-03-27
- Poprawka: tooltip incoterm zakotwiczony do prawej krawędzi — nie wychodzi poza ekran

## [0.4.8] - 2026-03-27
- Tabela Incoterms w ustawieniach: kompaktowy dwukolumnowy grid, kody jako szare plakietki
- Tooltip incoterm: CSS-only (ciemne tło, biały tekst), pojawia się nad kodem po najechaniu

## [0.4.7] - 2026-03-27
- Opisy Incoterms 2020 dodane do każdego kodu warunków dostawy
- Ustawienia: tabela referencyjna Incoterms z opisami
- Zamówienie: tooltip z opisem po najechaniu na kod warunków dostawy
- Tooltip aktualizuje się dynamicznie po zmianie warunków przez edycję inline

## [0.4.6] - 2026-03-27
- Pole „Nr śledzenia" w sekcji Szczegóły zamówienia (edycja inline AJAX)
- Link śledzenia przesyłki: UPS i DHL Express podlinkowane automatycznie po wykryciu nazwy przewoźnika
- Kolorowe plakietki przewoźnika przy polu Przewoźnik (UPS brązowo-złoty, DHL żółto-czerwony, inne szare)
- Badge i link aktualizują się dynamicznie po zmianie przewoźnika lub numeru śledzenia

## [0.4.5] - 2026-03-27
- Przywrócono tekst „Wartość zamówienia:" przy czerwonej plakietce; wartość pogrubiona
- Przycisk PDF bardziej widoczny (btn-outline-secondary z ikoną i napisem „PDF")

## [0.4.4] - 2026-03-26
- Ustawienia > Informacje o module: uproszczony widok — zwykły tekst w tabeli zamiast kafelków
- Przycisk „Przywróć" w liście ukrytych produktów zastąpiony ikoną `replay` (styl jak ikona usuń)
- Przyciski „Dodaj przewoźnika", „Dodaj rodzaj", „Dodaj status" w stylu niebieskiego przycisku BO (`btn-primary` + ikona `add`)
- Podgląd pliku (PDF/obraz): pełnoekranowy modal bez paddingu, uproszczony (tylko przycisk zamknij)
- Suma kolumny Waga w tabeli produktów zamówienia: 1 miejsce po przecinku
- Suma kolumny Objętość w tabeli produktów zamówienia: 3 miejsca po przecinku
- Sekcja „Podsumowanie" w podglądzie zamówienia przemianowana na „Szczegóły"
- Wartość zamówienia wyświetlana jako czerwona plakietka w nagłówku sekcji Produkty
- Generowanie PDF zamówienia: ikona `picture_as_pdf` obok wartości, pobiera PDF z nr zamówienia, dostawcą, adresem dostawy, szczegółami i tabelą produktów

## [0.4.3] - 2026-03-26
- Cofnięto zmianę palety kolorów — przywrócono chromatic (czerwony→pomarańczowy→żółty→zielony→turkus→niebieski→fioletowy→szary→ciemny)

## [0.4.2] - 2026-03-26
- Paleta kolorów statusów dopasowana do kolorów plakietek z BO PrestaShop (wyciągnięte ze screenshotów)

## [0.4.1] - 2026-03-26
- Styl plakietek statusów oparty na natywnej klasie Bootstrap `.badge` (jak w BO PrestaShop)
- `background-color !important` zapewnia poprawny kolor bez konfliktu z motywem PS
- Paleta kolorów statusów odświeżona i ułożona chromatycznie (czerwony→pomarańczowy→żółty→zielony→turkus→niebieski→fioletowy→szary→ciemny)
- Usunięto martwy kod starego formularza statusów

## [0.4.0] - 2026-03-26
- Statusy zamówień: szybka edycja nazwy inline (klik → input, Enter=zapisz AJAX, Esc=anuluj)
- Statusy zamówień: zmiana koloru przez kliknięcie w swatch → zapis AJAX
- Usunięto przycisk „Zapisz" z sekcji statusów; adres dostawy ma własny przycisk zapisu
- Poprawka: plakietki statusów w kolumnie Podgląd mają teraz poprawny kolor (usunięto klasę `badge`)
- Ikona kosza w kolumnie Akcje statusów ujednolicona z poprzednimi tabelami

## [0.3.99] - 2026-03-26
- Poprawka: ponowna edycja numeru faktury wczytywała stare dane (błąd cache jQuery `.data()`)
- Poprawka: pole Przewoźnik używa teraz select z listy zdefiniowanych przewoźników
- Styl sekcji Dostawca ujednolicony z sekcją Adres dostawy (zwykły tekst, bez bold)
- Opis pliku skrócony w tabeli (ellipsis), pełna treść widoczna w tooltipie po najechaniu

## [0.3.98] - 2026-03-26
- Zmniejszone odstępy między wierszami w sekcji podsumowania podglądu zamówienia

## [0.3.97] - 2026-03-26
- Katalogi plików zamówień nazwane referencją zamówienia (np. `ZAK-001`) zamiast numerycznym ID

## [0.3.96] - 2026-03-26
- Szybka edycja opisu pliku inline w tabeli plików zamówienia (klik → input, Enter = zapis, Esc = anuluj)

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