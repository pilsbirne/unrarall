#!/bin/bash

# Überprüfen, ob das erforderliche Programm 'unrar' installiert ist
command -v unrar >/dev/null 2>&1 || { echo >&2 "Das Skript benötigt das Programm 'unrar', bitte installieren Sie es."; exit 1; }

# Durchsuchen aller Unterordner nach RAR-Archiven und diese auflisten
rar_archiven=$(find . -type f -name "*.rar")

# Überprüfen, ob RAR-Archive vorhanden sind
if [ -z "$rar_archiven" ]; then
  echo "Keine RAR-Archive im aktuellen Verzeichnis und seinen Unterordnern gefunden."
  exit 1
fi

# Initialisieren von Zählern
erfolgreich_entpackt=0
fehler_beim_entpacken=0
nicht_entpackte_archive=()

# Schleife zum Entpacken und Löschen der RAR-Archive
for rar_archiv in $rar_archiven; do
  entpackt_verzeichnis=$(dirname "$rar_archiv")
  echo "Entpacke $rar_archiv nach $entpackt_verzeichnis..."
  if unrar x "$rar_archiv" "$entpackt_verzeichnis"; then
    ((erfolgreich_entpackt++))
    rm "$rar_archiv"
  else
    ((fehler_beim_entpacken++))
    nicht_entpackte_archive+=("$rar_archiv")
  fi
done

# Anzeigen der Statistik
echo -e "\n--- Statistik nach dem Entpacken ---"
echo "Erfolgreich entpackte Archive: $erfolgreich_entpackt"
echo "Fehler beim Entpacken: $fehler_beim_entpacken"

if [ $fehler_beim_entpacken -gt 0 ]; then
  echo -e "\n--- Nicht erfolgreich entpackte Archive ---"
  for nicht_entpacktes_archiv in "${nicht_entpackte_archive[@]}"; do
    echo "$nicht_entpacktes_archiv"
  done
fi

echo "Entpacken und Löschen abgeschlossen."
