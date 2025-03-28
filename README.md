# GitHub Labels

Useful for synchronizing labels across GitHub repositories. See
[github-label-sync](https://github.com/Financial-Times/github-label-sync/).

## Pre Requisites

Install the following package with npm:

```sh
npm install --global github-label-sync
```

And have your GitHub token set in the environment variable `GITHUB_TOKEN`. The token must have the `repo` and
`public_repo` scopes.

## Usage

### Default

To apply the default labels to all repos:

```sh
$ ./apply.sh
```

To apply the default labels to one particular repo:

```sh
github-label-sync --access-token $GITHUB_TOKEN --allow-added-labels --labels ./default.yml sablier-labs/repo-name
```

Running these scripts will NOT overwrite any existing labels in the repo.

If you want to overwrite the labels, and also delete the labels that are not listed in the YAML files, remove the
`--allow-added-labels` flag.

```sh
github-label-sync --access-token $GITHUB_TOKEN --labels ./default.yml sablier-labs/repo-name
```

> [!WARNING]
>
> The last command will delete any labels that are not listed in the YAML files. Use with caution.

### Command Center

To apply the command center labels:

```sh
github-label-sync --access-token $GITHUB_TOKEN --allow-added-labels --labels ./command-center.yml sablier-labs/command-center
```
