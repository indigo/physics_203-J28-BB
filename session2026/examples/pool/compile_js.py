#!/usr/bin/env python3
"""
Script pour concaténer tous les fichiers JS dans compiled_source.txt
Usage: python3 compile_js.py
"""

import os
from datetime import datetime

# Configuration
OUTPUT_FILE = "compiled_source.txt"

# Liste des fichiers dans l'ordre logique
FILES = [
    "index.html",
    "css/style.css",
    "js/constants.js",
    "js/gameState.js",
    "js/ball.js",
    "js/table.js",
    "js/physics.js",
    "js/ui.js",
    "js/menuManager.js",
    "js/main.js"
]

def count_lines(filepath):
    """Compte le nombre de lignes dans un fichier"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return len(f.readlines())
    except:
        return 0

def compile_sources():
    """Compile tous les fichiers JS dans un seul fichier"""
    
    file_count = 0
    total_lines = 0
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as output:
        # En-tête
        output.write("╔═══════════════════════════════════════════════════════════════════╗\n")
        output.write("║                                                                   ║\n")
        output.write("║              BILLARD MASTER 3D - CODE SOURCE COMPLET              ║\n")
        output.write("║                                                                   ║\n")
        output.write("║  Système UI complet avec menu, pause, détection de victoire      ║\n")
        output.write(f"║  Date: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}                                        ║\n")
        output.write("║                                                                   ║\n")
        output.write("╚═══════════════════════════════════════════════════════════════════╝\n")
        output.write("\n\n")
        
        # Parcourir chaque fichier
        for i, filename in enumerate(FILES, 1):
            filepath = filename
            
            if os.path.exists(filepath):
                file_count += 1
                lines = count_lines(filepath)
                total_lines += lines
                
                # En-tête du fichier
                output.write("═══════════════════════════════════════════════════════════════════\n")
                output.write(f"  FICHIER {i}/{len(FILES)} : {filename}\n")
                output.write(f"  Lignes : {lines}\n")
                output.write("═══════════════════════════════════════════════════════════════════\n")
                output.write("\n")
                
                # Contenu du fichier
                with open(filepath, 'r', encoding='utf-8') as f:
                    output.write(f.read())
                
                output.write("\n\n")
                
                print(f"✓ Ajouté: {filename} ({lines} lignes)")
            else:
                print(f"✗ Fichier non trouvé: {filepath}")
        
        # Pied de page
        output.write("═══════════════════════════════════════════════════════════════════\n")
        output.write("  FIN DE LA COMPILATION\n")
        output.write("═══════════════════════════════════════════════════════════════════\n")
        output.write("\n")
        output.write("Statistiques:\n")
        output.write(f"  - Fichiers compilés : {file_count}/{len(FILES)}\n")
        output.write(f"  - Lignes totales    : {total_lines}\n")
        output.write(f"  - Date              : {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}\n")
        output.write("\n")
    
    # Résumé
    print("\n✅ Compilation terminée !")
    print(f"📁 Fichier créé : {OUTPUT_FILE}")
    print("📊 Statistiques :")
    print(f"   - Fichiers : {file_count}/{len(FILES)}")
    print(f"   - Lignes   : {total_lines}")

if __name__ == "__main__":
    compile_sources()
