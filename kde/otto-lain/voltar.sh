#!/usr/bin/env bash
# Volta ao visual que você tinha antes do ./instalar.sh (usa o mesmo backup do kde/mocha).
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../mocha/voltar.sh" "$@"
