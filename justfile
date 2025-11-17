set shell := ["bash", "-euo", "pipefail", "-c"]

# ---------------------------------------------------------------------------- #
#                                 DEPENDENCIES                                 #
# ---------------------------------------------------------------------------- #

# https://github.com/Financial-Times/github-label-sync
github-label-sync := require("github-label-sync")

# ---------------------------------------------------------------------------- #
#                                   CONSTANTS                                  #
# ---------------------------------------------------------------------------- #

LABELS_DEFAULT := "./labels/default.yml"
LABELS_COMMAND_CENTER := "./labels/command-center.yml"
LABELS_MONOREPO := "./labels/monorepo.yml"
GITHUB_TOKEN := env("GITHUB_TOKEN")

# ---------------------------------------------------------------------------- #
#                                    RECIPES                                   #
# ---------------------------------------------------------------------------- #

# Show available commands
default:
    @just --list

# Apply default labels to all repositories, preserving existing labels
[confirm("This will sync GitHub labels across all repositories. Continue? y/n")]
@apply-all:
    just apply-all-impl

# Apply default labels to a specific repository, preserving existing labels
apply-repo repo:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --allow-added-labels \
        --labels {{ LABELS_DEFAULT }} \
        {{repo}}

# Apply default labels to a specific repository, overwriting existing labels
[confirm("WARNING: This will delete any labels not listed in labels.yml! Continue? y/n")]
apply-repo-overwrite repo:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --labels {{ LABELS_DEFAULT }} \
        {{repo}}

# Apply labels to the command-center repository
apply-command-center:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --allow-added-labels \
        --labels {{ LABELS_COMMAND_CENTER }} \
        sablier-labs/command-center

# Apply labels to the monorepo repository
# TODO: rename `sablier-labs/lockup` to `sablier-labs/evm-monorepo`
apply-monorepo:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --allow-added-labels \
        --labels {{ LABELS_MONOREPO }} \
        sablier-labs/lockup

# Show command center labels
show-command-center-labels:
    @echo "Command center labels configuration:"
    @cat {{ LABELS_COMMAND_CENTER }}

# Show monorepo labels
show-monorepo-labels:
    @echo "Monorepo labels configuration:"
    @cat {{ LABELS_MONOREPO }}

# Show default labels
show-labels:
    @echo "Default labels configuration:"
    @cat {{ LABELS_DEFAULT }}

# ---------------------------------------------------------------------------- #
#                               RECIPES: HELPERS                               #
# ---------------------------------------------------------------------------- #


# Apply default labels to all repositories
[private]
apply-all-impl:
    #!/usr/bin/env sh
    repos=(
        "sablier-labs/airdrops"
        "sablier-labs/benchmarks"
        "sablier-labs/branding"
        "sablier-labs/business-contracts"
        "sablier-labs/command-center"
        "sablier-labs/docs"
        "sablier-labs/evm-examples"
        "sablier-labs/evm-token-list"
        "sablier-labs/flow"
        "sablier-labs/flow-integration-template"
        "sablier-labs/indexers"
        "sablier-labs/interfaces"
        "sablier-labs/legacy-contracts"
        "sablier-labs/legacy-interfaces"
        "sablier-labs/legacy-subgraph"
        "sablier-labs/github-labels"
        "sablier-labs/github-searcher"
        "sablier-labs/lockup"
        "sablier-labs/lockup-integration-template"
        "sablier-labs/merkle-api"
        "sablier-labs/multi-gitter-scripts"
        "sablier-labs/multichain-deployer"
        "sablier-labs/onchain-analytics"
        "sablier-labs/policies"
        "sablier-labs/sablier-labs.github.io"
        "sablier-labs/sandbox"
        "sablier-labs/sdk"
        "sablier-labs/scripts"
        "sablier-labs/solsab"
        "sablier-labs/solana-indexers"
        "sablier-labs/solana-token-list"
        "sablier-labs/solsab-ui"
        "sablier-labs/team-setup"
    )

    for repo in "${repos[@]}"; do
        echo "Syncing labels for $repo..."
        github-label-sync \
            --access-token {{ GITHUB_TOKEN }} \
            --allow-added-labels \
            --labels {{ LABELS_DEFAULT }} \
            "$repo"
    done
