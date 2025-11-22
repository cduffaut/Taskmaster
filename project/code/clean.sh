#!/bin/bash

# ==========================
# Nettoyage des fichiers Python
# ==========================

DOSSIER_CIBLE="${1:-.}"   # Si aucun argument, on nettoie le dossier courant
DATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$DATE] 🔍 Début du nettoyage dans : $DOSSIER_CIBLE"

COMPTE_PYCACHE=0
COMPTE_VENV=0
COMPTE_LOGS=0

# Suppression des dossiers __pycache__
while IFS= read -r -d '' dossier; do
    rm -rf "$dossier"
    ((COMPTE_PYCACHE++))
    echo "   ➤ Dossier __pycache__ supprimé : $dossier"
done < <(find "$DOSSIER_CIBLE" -type d -name "__pycache__" -print0)

# Suppression des dossiers venv
while IFS= read -r -d '' dossier; do
    rm -rf "$dossier"
    ((COMPTE_VENV++))
    echo "   ➤ Dossier venv supprimé : $dossier"
done < <(find "$DOSSIER_CIBLE" -type d -name "venv" -print0)

# Suppression des dossiers logs
while IFS= read -r -d '' dossier; do
    rm -rf "$dossier"
    ((COMPTE_LOGS++))
    echo "   ➤ Dossier logs supprimé : $dossier"
done < <(find "$DOSSIER_CIBLE" -type d -name "logs" -print0)

DATE_FIN=$(date +"%Y-%m-%d %H:%M:%S")

echo ""
echo "[$DATE_FIN] 🧹 Nettoyage terminé."
echo "   📌 Total __pycache__ supprimés : $COMPTE_PYCACHE"
echo "   📌 Total venv supprimés        : $COMPTE_VENV"
echo "   📌 Total logs supprimés        : $COMPTE_LOGS"
