#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/bash/common.sh"

UPSTREAM_REMOTE="upstream"
UPSTREAM_URL="git@github.com:github/spec-kit.git"
TARGET_BRANCH="main"
MODE="merge"
DO_PUSH=false

usage() {
    cat <<'EOF'
Usage: sync-spec-kit-main.sh [OPTIONS]

Sync the local main branch with github/spec-kit upstream.

Options:
  --rebase             Rebase local main on top of upstream/main instead of merging
  --push               Push the synced branch to origin after updating local main
  --no-push            Do not push after syncing (default)
  --upstream-remote X  Upstream remote name to use (default: upstream)
  --upstream-url X     Upstream repository URL (default: git@github.com:github/spec-kit.git)
  --branch X           Target branch to sync (default: main)
  --help, -h           Show this help message

Examples:
  ./tools/sync-spec-kit-main.sh
  ./tools/sync-spec-kit-main.sh --push
  ./tools/sync-spec-kit-main.sh --rebase --push
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --rebase)
            MODE="rebase"
            ;;
        --push)
            DO_PUSH=true
            ;;
        --no-push)
            DO_PUSH=false
            ;;
        --upstream-remote)
            shift
            if [ "$#" -eq 0 ]; then
                echo "ERROR: --upstream-remote requires a value" >&2
                exit 1
            fi
            UPSTREAM_REMOTE="$1"
            ;;
        --upstream-url)
            shift
            if [ "$#" -eq 0 ]; then
                echo "ERROR: --upstream-url requires a value" >&2
                exit 1
            fi
            UPSTREAM_URL="$1"
            ;;
        --branch)
            shift
            if [ "$#" -eq 0 ]; then
                echo "ERROR: --branch requires a value" >&2
                exit 1
            fi
            TARGET_BRANCH="$1"
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option '$1'. Use --help for usage information." >&2
            exit 1
            ;;
    esac
    shift
done

REPO_ROOT="$(get_repo_root)" || exit 1
cd "$REPO_ROOT"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "ERROR: Not inside a git repository: $REPO_ROOT" >&2
    exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
    echo "ERROR: Working tree is dirty. Commit or stash changes before syncing main." >&2
    exit 1
fi

if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
    echo "ERROR: Local branch '$TARGET_BRANCH' does not exist." >&2
    exit 1
fi

if git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
    current_upstream_url="$(git remote get-url "$UPSTREAM_REMOTE")"
    if [ "$current_upstream_url" != "$UPSTREAM_URL" ]; then
        echo "Updating $UPSTREAM_REMOTE URL to $UPSTREAM_URL"
        git remote set-url "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
    fi
else
    echo "Adding upstream remote: $UPSTREAM_REMOTE -> $UPSTREAM_URL"
    git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
fi

echo "Fetching $UPSTREAM_REMOTE ..."
git fetch "$UPSTREAM_REMOTE"

echo "Checking out $TARGET_BRANCH ..."
git checkout "$TARGET_BRANCH"

if [ "$MODE" = "rebase" ]; then
    echo "Rebasing $TARGET_BRANCH onto $UPSTREAM_REMOTE/$TARGET_BRANCH ..."
    git rebase "$UPSTREAM_REMOTE/$TARGET_BRANCH"
else
    echo "Merging $UPSTREAM_REMOTE/$TARGET_BRANCH into $TARGET_BRANCH ..."
    git merge "$UPSTREAM_REMOTE/$TARGET_BRANCH"
fi

if [ "$DO_PUSH" = true ]; then
    if [ "$MODE" = "rebase" ]; then
        echo "Pushing rebased $TARGET_BRANCH to origin with lease ..."
        git push --force-with-lease origin "$TARGET_BRANCH"
    else
        echo "Pushing merged $TARGET_BRANCH to origin ..."
        git push origin "$TARGET_BRANCH"
    fi
else
    echo "Local sync complete. Use --push if you want to update origin/$TARGET_BRANCH too."
fi
