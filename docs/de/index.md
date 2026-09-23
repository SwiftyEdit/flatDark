---
title: SwiftyEdit - flatDark Theme
description: Übersicht - Das flatDark Theme
btn: Übersicht
group: themes
priority: 500
---

# Das flatDark Theme

Ein dunkles, flaches Theme auf Basis der Templates des default-Themes. Gleiche
Funktionen wie das default Theme (Shop, Blog, Events, Kommentare, Wunschliste, ...),
gebaut mit Bootstrap 5 und Bootstrap Icons.

Dieses Theme enthält nur die dunkle Variante - es gibt keinen Light/Dark-Switch.
Ein passendes helles Theme ("flatLight") soll ein eigenes Theme werden, keine
Laufzeit-Option dieses Themes.

## Design-Regeln

Was dieses Theme von Standard-Bootstrap unterscheidet:

- Keine abgerundeten Ecken irgendwo (`$enable-rounded: false` in
  `_variables.scss`).
- Flächen teilen sich meist den Hintergrund der Seite, statt eine eigene
  Füllfarbe zu bekommen (Cards, Dropdowns, Modals, ... nutzen in Bootstrap
  schon von Haus aus `var(--bs-body-bg)`) - getrennt nur durch eine dünne
  Trennlinie. Zwei bewusste, dezente Ausnahmen: Die Navbar wirkt ganz leicht
  "erhöht", `#pageTeaser` ganz leicht "abgesenkt" (`$surface-raised-bg` /
  `$surface-sunken-bg`, beide per `color-mix()` von `$body-bg` abgeleitet
  statt als fester Hex-Wert, damit sie im Verhältnis dazu immer stimmen).
- Kontextfarben (secondary, success, warning, danger, info) färben nur Text,
  Icons und Rahmen, nie eine Fläche - siehe `_flat.scss`: Alerts bekommen
  eine dünne Linie links statt eines Hintergrunds, Badges eine Kontur statt
  einer Füllung, List-Group-/Tabellen-Kontextvarianten dieselbe
  "Linie statt Füllung"-Behandlung.
- Buttons sind die eine bewusste Ausnahme von dieser Regel: Ein gefüllter
  Button bekommt eine dünne Linie unten *und* eine dezente, dunkle,
  farbgetönte Füllung (gerade genug, um wie eine Fläche zu wirken, nie
  Bootstraps kräftige Standard-Füllung). Outline-Buttons und Pill-Buttons
  (`.rounded-pill`) behalten stattdessen eine volle Kontur - eine einzelne
  Linie unten an einer runden Pille oder an einem Button, dessen ganzer
  Sinn die Kontur ist, liest sich gar nicht erst als Rahmen.

## Skins (Farbvarianten)

Das Theme bringt neben dem Standard-Pink eine zusätzliche Farbvariante mit,
Cyan - auswählbar unter Admin -> Addons -> Themes -> Stylesheet (wie dieser
Mechanismus grundsätzlich funktioniert, steht in
`docs/v2/*/09-01-00-themes.md` im Core). `--bs-primary` ist das Einzige, was
eine Skin ändert; alle anderen Kontextfarben bleiben fest.

Eine weitere Skin hinzufügen:

1. Eine neue Datei in `src/scss/skins/` anlegen, z.B. `sunset.scss`:
   ```scss
   @import "skin-tokens";
   @include skin-tokens(#ff7a32);
   ```
2. `npm run build` - `discoverSkinEntries()` in `vite.config.js` erkennt sie
   automatisch und baut sie nach `dist/skins/sunset.css`. Nirgendwo sonst
   muss etwas registriert werden; das Stylesheet-Dropdown im ACP listet
   einfach, welche `.css`-Dateien in `dist/skins/` liegen.

Da die meisten eigenen primärfarbenen Elemente dieses Themes (Buttons, das
Preis-Badge, die Linie der Buy-Box, ...) zur Laufzeit `var(--bs-primary)`
lesen statt einen fest einkompilierten Hex-Wert - dafür in
`_skin-compat.scss` extra umgebogen - färbt eine Skin das ganze Theme um,
nicht nur Bootstraps eigene Komponenten. Wer später ein neues primärfarbenes
Element ergänzt, sollte prüfen, ob es dieselbe Behandlung braucht.

## Hinweise zum Shop-Layout

- **Produktübersicht** (`products-list.tpl`): ein zweispaltiges Karten-Raster
  (eine Spalte auf schmalen Bildschirmen), nicht die einspaltige Liste des
  default-Themes. Der Preis sitzt als Badge auf der rechten unteren Ecke des
  Produktbilds (gefüllt mit Primary, Text in body-bg - eine zweite bewusste
  "Füllung"-Ausnahme). Es gibt hier kein "In den Warenkorb" - "More
  Informations" ist der primäre Call-to-Action (`btn-outline-primary`); in
  den Warenkorb legen passiert auf der Produktseite selbst. Der
  Wunschlisten-Button zeigt nur das Icon, sein Label steckt in
  `title`/`aria-label` statt sichtbarem Text.
- **Produktdetailseite** (`products-display.tpl`): drei Bereiche - Bild /
  Titel+Teaser / eine schmale "Buy Box" (Preis, Lieferzeit, Warenkorb-
  Formular, Wunschliste), per `order-md-*` statt nach DOM-Reihenfolge
  angeordnet, damit die Buy Box mobil direkt nach dem Bild kommt, ab `md`
  aber zur rechten Spalte wird. Die Buy Box selbst ist transparent mit einer
  dünnen Primary-Linie links, dieselbe Sprache wie bei Alerts.
- Die alte Tab-Leiste für Produkttext/Features/Mengenrabatte/Zusatztexte/
  Lieferumfang ist jetzt ein Stapel unabhängiger Bootstrap-Collapses -
  bewusst *kein* echtes Accordion (kein `data-bs-parent`), damit das Öffnen
  eines Eintrags nicht plötzlich einen anderen zuklappt, den man gerade
  liest. Der erste startet offen.
- Varianten, Zubehör und ähnliche Produkte (`.related-scroller` in
  `_shop.scss`) sind ein horizontal scrollbarer Streifen aus fest
  dimensionierten Karten statt eines Rasters, das mit jedem weiteren Eintrag
  in die Höhe wächst - die Anzahl ändert nur noch, wie weit man scrollen
  kann.

Alle verwendeten Frameworks und Tools findest Du in der Datei `package.json`,
den SCSS/JS Quellcode findest Du im Ordner `src`. Geplante nächste Schritte
stehen in `todo.md` in diesem Theme-Ordner.

## Build

```
npm install
npm run build   # einmaliger Produktions-Build nach dist/
npm run dev     # baut bei jeder Dateiänderung neu nach dist/
```
