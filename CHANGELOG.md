## [0.5.112] - 2026-03-29
- Widok zamówienia: usunięte duplikaty produktów w wynikach wyszukiwania przy ponownym łączeniu pozycji z katalogiem PrestaShop.

## [0.5.111] - 2026-03-29
- Widok zamówienia: ponowne połączenie produktu podmienia istniejącą pozycję zamiast dodawać nową i zachowuje jej ilość oraz cenę.

## [0.5.110] - 2026-03-29
- Widok zamówienia: pole wagi w popupie edycji produktu jest połączone ze standardową wagą produktu i kombinacji w PrestaShop.
- Widok zamówienia: dla niepowiązanych pozycji dodana ikonka ponownego połączenia produktu z katalogiem PrestaShop.
- Widok zamówienia: dodane potwierdzenia usuwania dla zamówień, plików i produktów w zamówieniu.

## [0.5.109] - 2026-03-29
- Lista zamówień: dodana wyszukiwarka po numerze zamówienia, dostawcy, numerze przesyłki i numerze faktury.
- Lista zamówień: sortowanie według ID malejąco, najnowsze zamówienia na górze.
- Podgląd zamówienia: nawigacja poprzednie/następne działa po najbliższym niższym i wyższym ID, także przy lukach w numeracji.
- Tabela produktów w zamówieniu: waga pozycji jest pobierana z aktualnej wagi produktu i kombinacji zamiast z pustej lub nieaktualnej wartości rekordu zamówienia.

## [0.5.108] - 2026-03-29
- Nowe zamówienia zakupowe są tworzone bez przykładowych produktów.
- Nawigacja w podglądzie zamówienia pozwala przechodzić do starszego i nowszego zamówienia przyciskami obok powrotu do listy.
- Importer zamówień CRM poprawnie mapuje status zaksięgowane na status zakończone zgodnie z konfiguracją modułu.

## [0.5.107] - 2026-03-29
- Dodany webowy importer dostawców CRM z ręcznym zatwierdzaniem rekordów i mapowaniem kraju.
- Dodany webowy importer zamówień CRM z importem pojedynczym i zbiorczym oraz kontrolą istnienia dostawcy.
- Importer zamówień uzupełnia mapowanie statusów, produktów, zdjęć, przewoźników i pól nagłówka zamówienia.
- Podgląd zamówienia otrzymał przyciski poprzednie/następne obok przycisku Powrót do listy.

## [0.5.106] - 2026-03-29
- Dostawcy w module są teraz niezależni od dostawców PrestaShop i używają własnej tabeli modułu.
- Zamówienia zakupowe korzystają z listy dostawców modułu zamiast z danych `ps_supplier`.

## [0.5.105] - 2026-03-29
- Wyrównane przyciski w formularzu dodawania plików do zamówienia.
- Zmniejszona domyślna wysokość przycisków w formularzu dodawania plików dla lżejszego wyglądu.

## [0.5.104] - 2026-03-29
- Poprawiony podgląd PDF w zamówieniach przez ładowanie dokumentu do modala z użyciem blob URL.
- Ujednolicony układ formularza dodawania plików: pola i przyciski w jednej linii oraz spójna wysokość inputa i selecta.
- Bardziej czytelna, wypełniona ikona PDF w widoku produktów.

## [0.5.103] - 2026-03-29
- Naprawiony podgląd PDF w zamówieniach zakupowych bez błędu 404 w modalu.
- Poprawiony układ formularza dodawania plików w zamówieniach.
- Przyciski Dodaj i Anuluj przy wybranym pliku ustawione w jednej linii.

## [0.5.102] - 2026-03-29
- Powiększone nagłówki sekcji w menu filtrów.
- Etykiety filtrów kolumn i opcji skrócone oraz ujednolicone z nazwami w interfejsie.
- Miniatury produktów na liście nie są już ściskane przy wąskim oknie i dużej liczbie kolumn.

## [0.5.101] - 2026-03-28
- Modal Edytuj na stronie Produkty: zawartość przebudowana wizualnie w stylu modala Rentowność.
- Dane produktu, logistyki i pola dodatkowe pokazują się teraz w kartach z liniowym układem wartości, zachowując szybką edycję po kliknięciu.

## [0.5.100] - 2026-03-28
- Poprawiono regresję ikony Edytuj w Safari: usunięto błąd setSharedScannerState is not defined.
- Dodano stabilne aliasy window.prestashopInventorySetScannerState i window.prestashopInventoryGetScannerState dla współdzielonego stanu modala.

## [0.5.98] - 2026-03-28
- Modal Edytuj na stronie Produkty: poprawione wczytywanie pełnych danych i sekcji szybkiej edycji.
- Ujednolicono stan modala przez współdzielony storage window.prestashopInventoryScannerState, aby zapobiec rozjazdom danych między scope skryptów.

## [0.5.97] - 2026-03-28
- Poprawiono ikonę Edytuj na stronie Produkty: usunięto błąd renderScannerState is not defined blokujący otwieranie popupu.
- Funkcje modala skanera (open/render) wystawione przez aliasy na window dla stabilnego działania w Safari.

## [0.5.96] - 2026-03-28
- Poprawiono ikonę edycji produktu w Safari: usunięto błąd toInt is not defined blokujący otwarcie popupu.
- Parsery wartości liczbowych dla danych przycisku edycji działają lokalnie w handlerze kliknięcia.

## [0.5.95] - 2026-03-28
- Poprawiono ikonę edycji produktu w tabeli Produkty: usunięto błąd JS renderScannerEan is not defined blokujący otwarcie popupu.
- Dodano fallback renderowania EAN w popupie, gdy renderer kodu kreskowego nie jest dostępny.

## [0.5.94] - 2026-03-28
- Doprecyzowano wygląd strzałek paginacji (< >) na stronie Produkty, aby odpowiadał docelowemu wzorcowi UI.
- Ujednolicono style przycisków paginacji (stan normalny, hover i disabled) pod tabelą produktów.

## [0.5.93] - 2026-03-28
- Dodano ikonę edycji produktu w kolumnie Akcje, otwierającą popup z danymi modułowymi.
- Lista produktów przekazuje do popupu pełne dane dodatkowe (model modułowy, materiał, HS code, cło, opis, wymiary, waga kartonu).
- Poprawiono paginację pod tabelą produktów: usunięto podwójne strzałki i wyśrodkowano pasek.

## [0.5.87] - 2026-03-28
- Skaner: poprawka odczytu statusu baterii „Dump Energy” (np. 42%) — znak % nie jest już zamieniany na cyfrę 5, więc poziom nie zawyża się do 100%.

## [0.5.19] - 2026-03-27
- Tabela produktów: kolumna „Szt. / karton" przemianowana na „Ilość w kartonie"

## [0.5.18] - 2026-03-27
- Tabela produktów: szybka edycja inline dla kolumn Materiał, HS Code, Cło % (klik → input, Enter=zapis, Esc=anuluj)

## [0.5.17] - 2026-03-27
- Tabela produktów: ikony akcji (bar_chart, calculate, visibility_off) bez gradientu — styl identyczny jak w tabeli zamówień
- Filtry: badge liczy tylko aktywne filtry „Pokaż tylko", nie ukryte kolumny
- Nagłówki grup filtrów: kolor PS BO, linia separatora, lepiej czytelne

## [0.5.16] - 2026-03-27
- Tabela produktów: nowe kolumny Materiał, HS Code, Cło % (toggleowalne, domyślnie widoczne)
- Filtry podzielone na 2 kolumny: „Pokaż kolumny" i „Pokaż tylko"
- Ikony akcji w tabeli produktów: bar_chart, calculate, visibility_off (Material Icons)
- Ikona kalkulatora kosztów w zamówieniu zmieniona na calculate (Material Icons)
- Naprawa licznika filtrów: badge zlicza dynamicznie przez data-filter-type

## [0.5.15] - 2026-03-27
- PDF zamówienia: nagłówki sekcji — padding renderowany poprawnie (zamiana div→table, mPDF fix)

## [0.5.14] - 2026-03-27
- PDF zamówienia: usunięto „Data dostawy" z sekcji Szczegóły
- PDF zamówienia: nagłówki sekcji — zwiększony padding (4pt 8pt)
- PDF zamówienia: etykiety pól (Data zamówienia, Przewoźnik itp.) — czarny kolor zamiast szarego

## [0.5.13] - 2026-03-27
- PDF zamówienia: „Dostawca" → „Sprzedawca", „Adres dostawy" → „Nabywca"
- PDF zamówienia: nagłówki sekcji — biały tekst na ciemnym tle (#2c2c2c), wyrównane do góry
- PDF zamówienia: usunięto pole „Status" z sekcji Szczegóły
- PDF zamówienia: obrazki produktów z miniatury (small_default) zamiast oryginału

## [0.5.12] - 2026-03-27
- Popup kalkulacji kosztów produktu: miniatura (small_default) zamiast oryginału 1600px

## [0.5.11] - 2026-03-27
- Tabela produktów: miniaturka (small_default) zamiast oryginału
- Hover preview: obrazek medium (home_default ~250px) zamiast oryginału 1600px
- Karta hover: position:fixed + z-index:99999 — nie chodzi pod żaden element PS BO
- Pozycja karty hover obliczana przez JS (getBoundingClientRect) — działa poprawnie dla pierwszego i ostatniego wiersza

## [0.5.10] - 2026-03-27
- Tabela produktów zamówienia: miniatury (small_default, ~98×98px) zamiast oryginałów 1600×1600
- Modal dodawania produktu: miniatury zamiast oryginałów
- Popup kosztu produktu nadal używa oryginalnego obrazka (wyświetlany w większym rozmiarze)

## [0.5.9] - 2026-03-27
- Modal danych modułowych: grid 4-kolumnowy zamiast 2-kolumnowego
- Pole Materiał i Stawka celna przeniesione do wiersza Objętości (obok wymiarów)
- HS Code i Szt. w kartonie w kolejnym wierszu (po pół szerokości)
- Wymiary: usunięto „cm" z placeholderów, dodano jeden wspólny suffix „cm" po trzecim wymiarze

## [0.5.8] - 2026-03-27
- PDF zamówienia: ujednolicony rozmiar czcionki 8pt dla całego dokumentu (poza tytułem h1)
- PDF zamówienia: zmniejszona czcionka tabeli produktów (8pt nagłówki i komórki, 7pt model)
- PDF zamówienia: poprawione formatowanie sekcji między tytułem a tabelą (sec-title z podkreśleniem, wyrównane kolumny meta)
- PDF zamówienia: usunięta górna linia hr pod h1, divider tylko przed tabelą produktów

## [0.5.7] - 2026-03-27
- Poprawka ikony „i" w tabeli produktów zamówienia: kolor dopasowany do pozostałych ikon
- Poprawka ikony PDF: zmiana `<i>` na `<span>` z `color:inherit` — kolor zgodny z przyciskiem
- Podgląd PDF: szerokość dopasowana do dokumentu (860px, wycentrowany), blur tła widoczny po bokach
- Podgląd PDF: zajmuje prawie całą wysokość okna przeglądarki (inset 2vh)

## [0.5.6] - 2026-03-27
- Panel Szczegóły zamówienia: pole „Waluta" (kod waluty, edycja inline AJAX)
- Panel Szczegóły zamówienia: pole „Kurs waluty" (edycja inline AJAX, walidacja > 0)
- Wartości obu pól odświeżają się dynamicznie po zapisaniu

## [0.5.5] - 2026-03-27
- Poprawka mechanizmu aktualizacji: wersja modułu aktualizowana w bazie danych (ps_module) po auto-aktualizacji
- Poprawka: OPcache resetowany po skopiowaniu nowych plików modułu
- Poprawka: porównanie wersji przy sprawdzaniu aktualizacji oparte na wersji z bazy danych (odporna na stały OPcache)
- Dodano katalog upgrade/ z wymaganymi skryptami dla aktualizacji przez Menedżer Modułów PrestaShop

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