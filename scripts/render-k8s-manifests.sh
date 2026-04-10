#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <container-registry-url>"
  exit 1
fi

CONTAINER_REGISTRY="$1"
WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$WORKDIR/k8s/generated"
sed "s|REPLACE_CONTAINER_REGISTRY|$CONTAINER_REGISTRY|g" "$WORKDIR/k8s/base/deployment.yaml" > "$WORKDIR/k8s/generated/deployment.yaml"
cp "$WORKDIR/k8s/base/service.yaml" "$WORKDIR/k8s/generated/service.yaml"
cp "$WORKDIR/k8s/base/namespace.yaml" "$WORKDIR/k8s/generated/namespace.yaml"

echo "Rendered manifests in $WORKDIR/k8s/generated"
