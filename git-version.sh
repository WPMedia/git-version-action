#!/bin/bash
##############################################################
# git-version.sh
#

BRANCH_PRIORITY_LIST=("main" "master" "develop" "dev" "sandbox" "staging")

get_branch() {
  branch_list=$(
    git branch -a --contains HEAD \
      | grep -v '\(.*detached.*\)' \
      | grep -v '\(no branch\)' \
      | cut -c 3- \
      | sed s,^remotes/[^/]*/,,
  )

  # Backwards from what you might think, this takes the list of git branches and tests if
  # any appear in the priority list. This allows the priority list to set the order, but
  # may return nothing.
  priority_branch=$(printf '%s\n' "${BRANCH_PRIORITY_LIST[@]}" | grep -wEm1 "$branch_list")
  # Fallback to the first in the list
  first_branch=$(printf '%s\n' "${branch_list[@]}" | head -1)

  if [ "$priority_branch" = "" ]; then
    echo $first_branch
  else
    echo $priority_branch
  fi
}

BUILD_GIT_BRANCH=$(get_branch)
BUILD_GIT_BRANCH_CLEAN=$(echo "${BUILD_GIT_BRANCH}" | sed s/[^0-9A-Za-z-]/-/g)
BUILD_GIT_MESSAGE=`git log -1 --pretty=%B`
BUILD_GIT_AUTHOR=`git log -1 --pretty=%an`
BUILD_GIT_AUTHOR_EMAIL=`git log -1 --pretty=%ae`
BUILD_GIT_COMMIT=`git log -1 --pretty=%H`
BUILD_GIT_COMMIT_SHORT=`git rev-parse --short HEAD`
BUILD_GIT_COMMIT_TIMESTAMP=`git show -s --format=%ci`
BUILD_GIT_COMMIT_EPOCH=`git show -s --format=%ct`
# TODO: Think there is another version of this that validates tags
BUILD_GIT_TAG=`git describe --tags --abbrev=0 | sed 's/^v//g'`
BUILD_GIT_TAG_LONG=`git describe --tag | sed 's/^v//g'`

BUILD_GIT_TAG_DISTANCE=`echo ${BUILD_GIT_TAG_LONG} | awk -F '-' '{print $2}'`

REGEX_VERSION='^(.*\/)?[0-9]+\.[0-9]+(\.[0-9]+)?$'

if [ "$BUILD_GIT_TAG_LONG" = "" ]; then
  # Without a tag, we can't get the distance from describe so making it up here with time and hash

  # note this is not compatible with OSX, so fallback to epoch
  timestamp=$(date --date="@${BUILD_GIT_COMMIT_EPOCH}" +%Y%m%d.%H%M%S)
  export BUILD_VERSION=0.0.0-${BUILD_GIT_BRANCH_CLEAN}.t${timestamp:-$BUILD_GIT_COMMIT_EPOCH}-g${BUILD_GIT_COMMIT_SHORT}
elif [ "$BUILD_GIT_TAG_LONG" = "$BUILD_GIT_TAG" ]; then
  export BUILD_VERSION=${BUILD_GIT_TAG}
else
  if [ -z "$BUILD_GIT_TAG_DISTANCE" ]; then
      ver_end=g${BUILD_GIT_COMMIT_SHORT}
  else
      ver_end=${BUILD_GIT_TAG_DISTANCE}
  fi

  # Test that the branch matches the version pattern
  echo "${BUILD_GIT_BRANCH}" | grep -qE "${REGEX_VERSION}"
  retval=$?
  if [ ${retval} -eq 0 ]; then
    export BUILD_VERSION=${BUILD_GIT_TAG}-rc.${ver_end}
  else
    export BUILD_VERSION=${BUILD_GIT_TAG}-${BUILD_GIT_BRANCH_CLEAN}.${ver_end}
  fi
fi

echo "author=$BUILD_GIT_AUTHOR"
echo "author_email=$BUILD_GIT_AUTHOR_EMAIL"
echo "branch=$BUILD_GIT_BRANCH"
echo "branch_clean=$BUILD_GIT_BRANCH_CLEAN"
echo "commit=$BUILD_GIT_COMMIT"
echo "commit_short=$BUILD_GIT_COMMIT_SHORT"
echo "commit_timestamp=$BUILD_GIT_COMMIT_TIMESTAMP"
echo "commit_epoch=$BUILD_GIT_COMMIT_EPOCH"
echo "commit_message=$BUILD_GIT_MESSAGE"
echo "tag=$BUILD_GIT_TAG"
echo "tag_long=$BUILD_GIT_TAG_LONG"
echo "version=$BUILD_VERSION"

export BUILD_GIT_BRANCH
export BUILD_GIT_BRANCH_CLEAN
export BUILD_GIT_MESSAGE
export BUILD_GIT_AUTHOR
export BUILD_GIT_AUTHOR_EMAIL
export BUILD_GIT_COMMIT
export BUILD_GIT_COMMIT_SHORT
export BUILD_GIT_COMMIT_TIMESTAMP
export BUILD_GIT_COMMIT_EPOCH
export BUILD_GIT_TAG
export BUILD_GIT_TAG_LONG