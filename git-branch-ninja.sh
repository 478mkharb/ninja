#!/bin/bash
# Git Branch Management Script (flag-based)

set -e  # Exit if any command fails

usage() {
  echo "Usage:"
  echo "  $0 -l"
  echo "  $0 -b <branch_name>"
  echo "  $0 -d <branch_name>"
  echo "  $0 -m -1 <branch1> -2 <branch2>   # merge branch1 into branch2"
  echo "  $0 -r -1 <branch1> -2 <branch2>   # rebase branch1 onto branch2"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

case "$1" in
  -l)
    echo "Listing branches..."
    git branch
    ;;

  -b)
    if [ -z "$2" ]; then usage; fi
    branch=$2
    echo "Creating branch: $branch"
    git checkout -b "$branch"
    ;;

  -d)
    if [ -z "$2" ]; then usage; fi
    branch=$2
    echo "Deleting branch: $branch"
    git branch -d "$branch" || git branch -D "$branch"
    ;;

  -m)
    if [ "$2" != "-1" ] || [ "$4" != "-2" ]; then usage; fi
    branch1=$3
    branch2=$5
    echo "Merging $branch1 into $branch2"
    git checkout "$branch2"
    git merge --no-ff "$branch1" -m "Merge $branch1 ===>--- $branch2"
    ;;

  -r)
    if [ "$2" != "-1" ] || [ "$4" != "-2" ]; then usage; fi
    branch1=$3
    branch2=$5
    echo "Rebasing $branch1 onto $branch2"
    git checkout "$branch1"
    git rebase "$branch2"
    ;;

  *)
    usage
    ;;
esac
