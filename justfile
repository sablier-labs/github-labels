set shell := ["bash", "-euo", "pipefail", "-c"]
set unstable

# ---------------------------------------------------------------------------- #
#                                 DEPENDENCIES                                 #
# ---------------------------------------------------------------------------- #

# https://github.com/Financial-Times/github-label-sync
github-label-sync := require("github-label-sync")

# ---------------------------------------------------------------------------- #
#                                   CONSTANTS                                  #
# ---------------------------------------------------------------------------- #

ORG := "sablier-labs"
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
[confirm("This will sync GitHub labels across all repositories. Continue? y/N")]
@apply-all:
    just apply-all-impl

# Apply default labels to a specific repository, preserving existing labels
[confirm("This will sync GitHub labels to the specified repository. Continue? y/N")]
apply-repo repo:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --allow-added-labels \
        --labels {{ LABELS_DEFAULT }} \
        {{ ORG }}/{{ repo }}

# Apply default labels to a specific repository, overwriting existing labels
[confirm("WARNING: This will delete any labels not listed in labels.yml! Continue? y/N")]
apply-repo-overwrite repo:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --labels {{ LABELS_DEFAULT }} \
        {{ ORG }}/{{ repo }}

# Apply labels to the command-center repository
[confirm("This will sync GitHub labels to command-center. Continue? y/N")]
apply-command-center:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --allow-added-labels \
        --labels {{ LABELS_COMMAND_CENTER }} \
        {{ ORG }}/command-center

# Apply labels to the monorepo repository
# TODO: rename `sablier-labs/lockup` to `sablier-labs/evm-monorepo`
[confirm("This will sync GitHub labels to lockup (monorepo). Continue? y/N")]
apply-monorepo:
    github-label-sync \
        --access-token {{ GITHUB_TOKEN }} \
        --allow-added-labels \
        --labels {{ LABELS_MONOREPO }} \
        {{ ORG }}/lockup

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
[script]
apply-all-impl:
    repos=(
        "airdrops"
        "benchmarks"
        "branding"
        "business-contracts"
        "command-center"
        "docs"
        "evm-examples"
        "evm-token-list"
        "flow"
        "flow-integration-template"
        "indexers"
        "interfaces"
        "legacy-contracts"
        "legacy-interfaces"
        "legacy-subgraph"
        "github-labels"
        "gh-searcher"
        "investors"
        "lockup"
        "lockup-integration-template"
        "merkle-api"
        "multi-gitter-scripts"
        "multichain-deployer"
        "onchain-analytics"
        "policies"
        "sablier-labs.github.io"
        "sandbox"
        "sdk"
        "scripts"
        "solsab"
        "solana-indexers"
        "solana-token-list"
        "team-setup"
    )

    for repo in "${repos[@]}"; do
        echo "Syncing labels for {{ ORG }}/$repo..."
        github-label-sync \
            --access-token {{ GITHUB_TOKEN }} \
            --allow-added-labels \
            --labels {{ LABELS_DEFAULT }} \
            "{{ ORG }}/$repo"
    done
