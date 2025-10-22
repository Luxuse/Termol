#!/bin/bash

# Chemin vers le fichier de configuration
CONFIG_FILE="hexo.conf"

# Valeurs par défaut
DEFAULT_CHAR_DELAY=0.005
DEFAULT_REFRESH_DELAY=0.5
DEFAULT_COLORS=('\033[0;32m' '\033[0;36m' '\033[0;35m' '\033[0;33m' '\033[1;31m' '\033[1;34m')
DEFAULT_COLS=0
DEFAULT_ROWS=0

# Fonction pour lire la configuration
read_config() {
    if [ -f "$CONFIG_FILE" ]; then
        while IFS='=' read -r key value; do
            case "$key" in
                char_delay) CHAR_DELAY="$value" ;;
                refresh_delay) REFRESH_DELAY="$value" ;;
                colors)
                    IFS=',' read -ra color_pairs <<< "$value"
                    COLORS=()
                    for pair in "${color_pairs[@]}"; do
                        IFS=':' read -r name code <<< "$pair"
                        COLORS+=("$code")
                    done
                    ;;
                cols) COLS="$value" ;;
                rows) ROWS="$value" ;;
            esac
        done < <(grep -v '^#' "$CONFIG_FILE" | grep -v '^$')
    fi
    CHAR_DELAY=${CHAR_DELAY:-$DEFAULT_CHAR_DELAY}
    REFRESH_DELAY=${REFRESH_DELAY:-$DEFAULT_REFRESH_DELAY}
    COLORS=${COLORS:-$DEFAULT_COLORS}
    COLS=${COLS:-$DEFAULT_COLS}
    ROWS=${ROWS:-$DEFAULT_ROWS}
}

# Initialisation
read_config
NC='\033[0m'

# Fonction qui choisit une couleur aléatoire
random_color() {
    local index=$((RANDOM % ${#COLORS[@]}))
    echo -e "${COLORS[$index]}"
}

# Fonction pour afficher un caractère avec un délai
type_char() {
    local char="$1"
    local color="$2"
    echo -ne "${color}${char}${NC}"
    sleep "$CHAR_DELAY"
}

# Fonction principale de génération de l'art HEX
generate_hex_art() {
    clear
    local rows cols
    rows=$(tput lines)
    cols=$(tput cols)
    [ "$ROWS" -gt 0 ] && rows=$ROWS
    [ "$COLS" -gt 0 ] && cols=$COLS
    local usable_rows=$((rows - 2))
    local usable_cols=$((cols / 3))

    for ((i = 0; i < usable_rows; i++)); do
        for ((j = 0; j < usable_cols; j++)); do
            hex=$(openssl rand -hex 1)
            rot13=$(echo "$hex" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
            color=$(random_color)
            type_char "${rot13}" "$color"
            echo -n " "
        done
        echo
    done
}

# Boucle d'animation
while true; do
    generate_hex_art
    sleep "$REFRESH_DELAY"
done
