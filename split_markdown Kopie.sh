## Shell Script zum Aufteilen der Dissertation in Kapiteldateien
```sh
#!/bin/bash

# Überprüfen, ob die Datei dissertation.md im aktuellen Verzeichnis existiert
if [ ! -f "dissertation.md" ]; then
  echo "Fehler: dissertation.md nicht gefunden!"
  exit 1
fi

# Erstelle ein Ausgabeverzeichnis für die Kapitel
output_dir="chapters"
mkdir -p "$output_dir"

# Splitte die Datei dissertation.md an jeder Kapitelüberschrift, die dem Muster "# Kapitel [Nummer]: [Titel]" entspricht.
# Das Muster geht von zwei Ziffern aus (z.B. "01", "02", …)
gcsplit -k -f "$output_dir/chapter_" dissertation.md '/^# Kapitel [0-9][0-9]: /' '{*}'

# Durchlaufe alle erzeugten Split-Dateien und benenne sie anhand der Kapitelnummer und des Titels um.
for file in "$output_dir"/chapter_*; do
  header=$(grep -m1 '^# Kapitel [0-9][0-9]: ' "$file")
  if [[ $header =~ ^#\ Kapitel\ ([0-9][0-9]):\ (.+)$ ]]; then
    chap_num=${BASH_REMATCH[1]}
    chap_title=${BASH_REMATCH[2]}
    # Entferne problematische Zeichen aus dem Kapitel-Titel (ersetze Leerzeichen und Schrägstriche durch Unterstriche)
    safe_title=$(echo "$chap_title" | tr ' /' '__')
    chapter_dir="$output_dir/$chap_num"
    mkdir -p "$chapter_dir"
    new_file="$chapter_dir/${chap_num} - ${safe_title}.md"
    mv "$file" "$new_file"
    echo "Erstellt: $new_file"
  fi
done
```