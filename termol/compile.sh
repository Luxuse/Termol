#!/bin/bash

CONFIG_FILE="./compile.conf"

# ============================================================
#  Chargement de la configuration
# ============================================================
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[ERROR] Missing configuration file: $CONFIG_FILE"
    exit 1
fi

# Lecture du fichier de conf
while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    eval "${key}=\"${value}\""
done < "$CONFIG_FILE"

# ============================================================
#  Couleurs (après chargement du fichier)
# ============================================================
C_SUCCESS="\033[1;${COLOR_SUCCESS}m"
C_WARN="\033[1;${COLOR_WARNING}m"
C_INFO="\033[1;${COLOR_INFO}m"
C_ERROR="\033[1;${COLOR_ERROR}m"
C_TIME="\033[0;${COLOR_TIME}m"
C_RESET="\033[0m"

# Split des étapes
IFS=',' read -r -a BUILD_STEPS <<< "$STEPS"

# ============================================================
#  Fonctions utilitaires
# ============================================================
log() {
    local msg="$1"
    local delay=${2:-$SPEED}
    echo -e "${C_TIME}[$(date +%H:%M:%S)]${C_RESET} $msg"
    sleep "$delay"
}

compile_step() {
    local step="$1"
    local files=$((RANDOM % 30 + 10))
    local warnings=0
    echo -e "\n${C_INFO}==>${C_RESET} Compiling ${step}..."

    for ((i=1; i<=files; i++)); do
        sleep "$(awk "BEGIN {print $SPEED/3 + ($RANDOM % 2)/10}")"
        echo -ne "  ${C_SUCCESS}✔${C_RESET} file_$i.cpp\r"
        if (( RANDOM % 25 == 0 )) && (( warnings < MAX_WARNINGS )); then
            echo -e "  ${C_WARN}⚠ Warning:${C_RESET} file_$i.cpp:$((RANDOM%200)): unused variable 'tmp_${RANDOM}'"
            warnings=$((warnings + 1))
        fi
    done
    echo -e "  ${C_SUCCESS}✔ Done${C_RESET}"
}

progress_bar() {
    local width=40
    local progress=0
    echo -ne "${C_INFO}==>${C_RESET} Linking: ["
    while [ $progress -lt $width ]; do
        echo -ne "${C_SUCCESS}#${C_RESET}"
        sleep "$(awk "BEGIN {print $SPEED/4}")"
        ((progress++))
    done
    echo -e "] ${C_SUCCESS}OK${C_RESET}\n"
}

maybe_error() {
    if [[ "$RANDOM_ERRORS" == "yes" ]] && (( RANDOM % 15 == 0 )); then
        echo -e "${C_ERROR}✖ ERROR:${C_RESET} Build failed — ${RANDOM} errors detected."
        sleep "$SPEED"
        echo -e "${C_INFO}==>${C_RESET} Retrying..."
        compile_step "recovery module"
        echo
    fi
}

# ============================================================
#  Boucle principale
# ============================================================
run_build() {
    clear
    echo -e "${C_INFO}==>${C_RESET} Starting build..."
    log "${C_INFO}Target:${C_RESET} x86_64-unknown-linux-gnu"
    log "${C_INFO}Mode:${C_RESET} Release"
    log "${C_INFO}Jobs:${C_RESET} $((RANDOM % 6 + 2))"
    echo

    for step in "${BUILD_STEPS[@]}"; do
        compile_step "$step"
        maybe_error
    done

    progress_bar
    log "${C_INFO}Running checks...${C_RESET}"
    log "${C_INFO}Generating docs...${C_RESET}"
    echo
    echo -e "${C_SUCCESS}==> Build successful!${C_RESET}"
    echo -e "${C_INFO}Output:${C_RESET} ./build/my_app"
    echo -e "${C_INFO}Size:${C_RESET} $((RANDOM % 50 + 30)) MB"
    echo -e "${C_INFO}Duration:${C_RESET} $((RANDOM % 3 + 1))m$((RANDOM % 60))s"
    echo
}

# Boucle si demandé
if [[ "$LOOP" == "yes" ]]; then
    while true; do
        run_build
        sleep 2
    done
else
    run_build
fi
