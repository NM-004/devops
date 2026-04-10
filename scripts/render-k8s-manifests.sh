#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <acr-login-server>"
  exit 1
fi

ACR_LOGIN_SERVER="$1"
WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$WORKDIR/k8s/generated"
sed "s|REPLACE_ACR_LOGIN_SERVER|$ACR_LOGIN_SERVER|g" "$WORKDIR/k8s/base/deployment.yaml" > "$WORKDIR/k8s/generated/deployment.yaml"
cp "$WORKDIR/k8s/base/service.yaml" "$WORKDIR/k8s/generated/service.yaml"
cp "$WORKDIR/k8s/base/namespace.yaml" "$WORKDIR/k8s/generated/namespace.yaml"

echo "Rendered manifests in $WORKDIR/k8s/generated"
