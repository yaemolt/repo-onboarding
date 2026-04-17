#!/usr/bin/env sh

set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <repo-root>" >&2
  exit 1
fi

repo_root=$1
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
template_dir=$script_dir/../templates

if [ ! -d "$repo_root" ]; then
  echo "Repository root does not exist: $repo_root" >&2
  exit 1
fi

if [ ! -d "$template_dir" ]; then
  echo "Template directory does not exist: $template_dir" >&2
  exit 1
fi

learning_workspace_dir=$repo_root/RepoOnboarding
architecture_dir=$learning_workspace_dir/Architecture
modules_dir=$learning_workspace_dir/Modules
progress_dir=$learning_workspace_dir/Progress
architecture_file=$architecture_dir/architecture.md
progress_file=$progress_dir/progress.md
learning_path_file=$progress_dir/learning-path.md

mkdir -p "$architecture_dir" "$modules_dir" "$progress_dir"

if [ ! -f "$progress_file" ]; then
  cp "$template_dir/progress.md" "$progress_file"
fi

if [ ! -f "$learning_path_file" ]; then
  cp "$template_dir/learning-path.md" "$learning_path_file"
fi

if [ ! -f "$architecture_file" ]; then
  cp "$template_dir/architecture.md" "$architecture_file"
fi

printf 'Initialized repo-onboarding workspace at %s\n' "$learning_workspace_dir"
