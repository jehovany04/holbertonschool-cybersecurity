#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  cat <<'EOF'
Usage: ./task0_run.sh <IP>
Example: ./task0_run.sh 10.0.2.15

Ce script :
1) rend exécutable 0-its_me.sh
2) copie 0-its_me.sh sur student@<IP>:/home/student/
3) lance une connexion SSH pour exécuter ./0-its_me.sh
4) télécharge le fichier 0-flag.txt si il existe

Attention : la machine distante doit déjà contenir le flag dans /home/student/0-flag.txt.
EOF
  exit 1
fi

IP="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

SCRIPT="0-its_me.sh"
REMOTE_USER="student"
REMOTE_PATH="/home/student"
REMOTE_HOST="${REMOTE_USER}@${IP}"

chmod +x "$SCRIPT"

echo "Copie de $SCRIPT vers ${REMOTE_HOST}:${REMOTE_PATH}/"
scp "$SCRIPT" "${REMOTE_HOST}:${REMOTE_PATH}/"

echo "Connexion SSH vers ${REMOTE_HOST}"
ssh "${REMOTE_HOST}" <<'SSH_CMDS'
cd /home/student
./0-its_me.sh
if [ -f 0-flag.txt ]; then
  echo
  echo '----- CONTENU DE 0-flag.txt -----'
  cat 0-flag.txt
  echo '---------------------------------'
else
  echo
  echo '0-flag.txt non trouvé. Créez-le avec :'
  echo 'echo "<FLAG>" > 0-flag.txt'
fi
SSH_CMDS

echo
if scp "${REMOTE_HOST}:${REMOTE_PATH}/0-flag.txt" .; then
  echo '0-flag.txt téléchargé localement.'
else
  echo 'Impossible de télécharger 0-flag.txt. Vérifiez que le fichier existe sur la machine distante.'
fi
