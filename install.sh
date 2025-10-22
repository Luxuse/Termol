#!/bin/bash
# ==========================================================
#  Termol - Install Script
# ==========================================================

APP_NAME="termol.sh"
REPO_URL="https://github.com/Luxuse/Termol.git"
INSTALL_DIR="/opt/${APP_NAME}"
BIN_PATH="/usr/local/bin/${APP_NAME}"

# ----------------------------------------------------------
#  Couleurs
# ----------------------------------------------------------
C_RESET='\033[0m'
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_GRAY='\033[0;37m'

# ----------------------------------------------------------
#  Vérification des droits root
# ----------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo -e "${C_RED}❌ Erreur:${C_RESET} Ce script doit être exécuté avec ${C_YELLOW}sudo${C_RESET}."
    echo -e "   Exemple : ${C_BLUE}sudo bash install.sh${C_RESET}"
    exit 1
fi

# ----------------------------------------------------------
#  Vérifie la présence de Git
# ----------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
    echo -e "${C_RED}❌ Git n'est pas installé.${C_RESET}"
    echo -e "   Installez-le d'abord : ${C_YELLOW}sudo apt install git${C_RESET}"
    exit 1
fi

# ----------------------------------------------------------
#  Clonage du dépôt
# ----------------------------------------------------------
echo -e "${C_BLUE}▶ Clonage du dépôt...${C_RESET}"
if [[ -d "$INSTALL_DIR" ]]; then
    echo -e "${C_YELLOW}⚠ Le dossier ${INSTALL_DIR} existe déjà.${C_RESET}"
    read -p "Voulez-vous le remplacer ? (y/n) " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        rm -rf "$INSTALL_DIR"
    else
        echo -e "${C_RED}Installation annulée.${C_RESET}"
        exit 1
    fi
fi

git clone --depth=1 "$REPO_URL" "$INSTALL_DIR" || {
    echo -e "${C_RED}❌ Échec du clonage du dépôt.${C_RESET}"
    exit 1
}

# ----------------------------------------------------------
#  Installation du binaire
# ----------------------------------------------------------
echo -e "\n${C_BLUE}▶ Installation du binaire...${C_RESET}"

if [[ ! -f "$INSTALL_DIR/${APP_NAME}" ]]; then
    echo -e "${C_RED}❌ Le fichier ${APP_NAME} n'existe pas dans le dépôt.${C_RESET}"
    exit 1
fi

chmod +x "$INSTALL_DIR/${APP_NAME}"
cp "$INSTALL_DIR/${APP_NAME}" "$BIN_PATH"

# ----------------------------------------------------------
#  Vérification
# ----------------------------------------------------------
if [[ ! -x "$BIN_PATH" ]]; then
    echo -e "${C_RED}❌ Erreur : le binaire n'a pas été copié dans /usr/local/bin.${C_RESET}"
    exit 1
fi

# ----------------------------------------------------------
#  Message final
# ----------------------------------------------------------
echo
echo -e "${C_GREEN}✅ Installation terminée avec succès !${C_RESET}"
echo -e "${C_GRAY}----------------------------------------------------------${C_RESET}"
echo -e "  📁 Application installée dans : ${C_BLUE}${INSTALL_DIR}${C_RESET}"
echo -e "  ⚙️  Commande disponible : ${C_YELLOW}${APP_NAME}${C_RESET}"
echo -e "${C_GRAY}----------------------------------------------------------${C_RESET}"
echo

# ----------------------------------------------------------
#  Affichage de l’aide
# ----------------------------------------------------------
echo -e "${C_BLUE}▶ Test de la commande:${C_RESET} ${C_YELLOW}${APP_NAME} -help${C_RESET}"
echo
sleep 1
"${APP_NAME}" -help || echo -e "${C_YELLOW}⚠ Impossible d'exécuter ${APP_NAME} -help (vérifiez le PATH)${C_RESET}"
echo
