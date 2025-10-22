#!/bin/bash


VERSION="1.0"
SCRIPTS_DIR="$(dirname "$0")"

# ----------------------------------------------------------
#  COULEURS
# ----------------------------------------------------------
C_RESET='\033[0m'
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_GRAY='\033[0;37m'

# ----------------------------------------------------------
#  AFFICHAGE DU LOGO / HELP
# ----------------------------------------------------------
show_help() {
    clear
    echo -e "${C_BLUE}"

    echo "║                Termol  ${VERSION}                ║"

    echo -e "${C_RESET}"
    echo -e "  ${C_YELLOW}Usage:${C_RESET} termol [option]"
    echo
    echo -e "  ${C_GREEN}-compile${C_RESET}     → Lance le simulateur de compilation"
    echo -e "  ${C_GREEN}-hexo${C_RESET}        → Lance le script Hexo"
    echo -e "  ${C_GREEN}-version${C_RESET}     → Affiche la version actuelle"
    echo -e "  ${C_GREEN}-help${C_RESET}        → Affiche cette aide"
    echo
    echo -e "${C_GRAY}  (Ajoutez vos modules dans le dossier du script)${C_RESET}"
    echo
}

# ----------------------------------------------------------
#  VÉRIFICATION DES ARGUMENTS
# ----------------------------------------------------------
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

case "$1" in
    -compile)
        SCRIPT="$SCRIPTS_DIR/compile.sh"
        ;;
    -hexo)
        SCRIPT="$SCRIPTS_DIR/hexo.sh"
        ;;
    -server)
        SCRIPT="$SCRIPTS_DIR/server.sh"
        ;;
    -version|--version)
        echo -e "${C_BLUE}Termol v${VERSION}${C_RESET}"
        exit 0
        ;;
    -help|--help|-h)
        show_help
        exit 0
        ;;
    *)
        echo -e "${C_RED}❌ Erreur:${C_RESET} Option inconnue '$1'"
        echo -e "Utilisez ${C_YELLOW}termol -help${C_RESET} pour la liste complète."
        exit 1
        ;;
esac

# ----------------------------------------------------------
#  LANCEMENT DU SCRIPT DEMANDÉ
# ----------------------------------------------------------
if [[ -f "$SCRIPT" ]]; then
    echo -e "${C_GREEN}▶ Lancement de:${C_RESET} $(basename "$SCRIPT")"
    echo
    bash "$SCRIPT"
else
    echo -e "${C_RED}❌ Le script '${SCRIPT}' est introuvable.${C_RESET}"
    exit 1
fi
