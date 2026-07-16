#!/bin/bash

# Script pour concaténer tous les fichiers JS dans compiled_source.txt
# Usage: ./compile_js.sh

OUTPUT_FILE="compiled_source.txt"
JS_DIR="js"

# Supprimer le fichier de sortie s'il existe
rm -f "$OUTPUT_FILE"

# En-tête du fichier
echo "╔═══════════════════════════════════════════════════════════════════╗" >> "$OUTPUT_FILE"
echo "║                                                                   ║" >> "$OUTPUT_FILE"
echo "║              BILLARD MASTER 3D - CODE SOURCE COMPLET              ║" >> "$OUTPUT_FILE"
echo "║                                                                   ║" >> "$OUTPUT_FILE"
echo "║  Système UI complet avec menu, pause, détection de victoire      ║" >> "$OUTPUT_FILE"
echo "║  Date: $(date '+%d/%m/%Y %H:%M:%S')                                        ║" >> "$OUTPUT_FILE"
echo "║                                                                   ║" >> "$OUTPUT_FILE"
echo "╚═══════════════════════════════════════════════════════════════════╝" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Liste des fichiers dans l'ordre logique
FILES=(
    "index.html"
    "css/style.css"
    "js/constants.js"
    "js/gameState.js"
    "js/ball.js"
    "js/table.js"
    "js/physics.js"
    "js/ui.js"
    "js/menuManager.js"
    "js/main.js"
)

# Compteur
file_count=0
total_lines=0

# Parcourir chaque fichier
for file in "${FILES[@]}"; do
    filepath="$file"
    
    if [ -f "$filepath" ]; then
        file_count=$((file_count + 1))
        lines=$(wc -l < "$filepath")
        total_lines=$((total_lines + lines))
        
        echo "═══════════════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"
        echo "  FICHIER $file_count/10 : $file" >> "$OUTPUT_FILE"
        echo "  Lignes : $lines" >> "$OUTPUT_FILE"
        echo "═══════════════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        
        # Ajouter le contenu du fichier
        cat "$filepath" >> "$OUTPUT_FILE"
        
        echo "" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        
        echo "✓ Ajouté: $file ($lines lignes)"
    else
        echo "✗ Fichier non trouvé: $filepath"
    fi
done

# Pied de page
echo "═══════════════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"
echo "  FIN DE LA COMPILATION" >> "$OUTPUT_FILE"
echo "═══════════════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Statistiques:" >> "$OUTPUT_FILE"
echo "  - Fichiers compilés : $file_count/10" >> "$OUTPUT_FILE"
echo "  - Lignes totales    : $total_lines" >> "$OUTPUT_FILE"
echo "  - Date              : $(date '+%d/%m/%Y %H:%M:%S')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo ""
echo "✅ Compilation terminée !"
echo "📁 Fichier créé : $OUTPUT_FILE"
echo "📊 Statistiques :"
echo "   - Fichiers : $file_count/10"
echo "   - Lignes   : $total_lines"
