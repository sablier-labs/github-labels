#!/bin/sh

# Strict mode: https://gist.github.com/vncsna/64825d5609c146e80de8b1fd623011ca
set -euo pipefail

# Function to reuse code
sync_labels() {
  github-label-sync --access-token $GITHUB_TOKEN --allow-added-labels --labels ./labels.yml "$1"
}

# Repositories
REPOS=(
  "sablier-labs/airdrops"
  "sablier-labs/benchmarks"
  "sablier-labs/branding"
  "sablier-labs/business-contracts"
  "sablier-labs/command-center"
  "sablier-labs/deployments"
  "sablier-labs/docs"
  "sablier-labs/evm-examples"
  "sablier-labs/evm-token-list"
  "sablier-labs/flow"
  "sablier-labs/flow-integration-template"
  "sablier-labs/interfaces"
  "sablier-labs/legacy-contracts"
  "sablier-labs/legacy-interfaces"
  "sablier-labs/legacy-subgraph"
  "sablier-labs/lockup"
  "sablier-labs/lockup-integration-template"
  "sablier-labs/merkle-api"
  "sablier-labs/multi-gitter-scripts"
  "sablier-labs/multichain-deployer"
  "sablier-labs/onchain-analytics"
  "sablier-labs/policies"
  "sablier-labs/sablier-labs.github.io"
  "sablier-labs/sandbox"
  "sablier-labs/scripts"
  "sablier-labs/solsab"
  "sablier-labs/solsab-ui"
  "sablier-labs/solana-subgraphs"
  "sablier-labs/solana-token-list"
  "sablier-labs/subgraphs"
)

# Safety confirmation
echo "This will sync GitHub labels across ${#REPOS[@]} repositories."
echo "Do you want to continue? (y/n)"
read -r confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Operation canceled."
  exit 0
fi

# Loop through and sync each repository
for repo in "${REPOS[@]}"; do
  sync_labels "$repo"
done
