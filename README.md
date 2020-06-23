
<p align="center">
  <a href="https://github.com/WPMedia/git-version-action/actions"><img alt="git-version-action status" src="https://github.com/WPMedia/git-version-action/workflows/units-test/badge.svg"></a>
</p>

# git-version-action

## Automatic Versioning

Use this action to generate automatic versions based on the git history. The action combines
tag, branch, and distance from tag information to build a version that conforms to semver
(assuming the last tag is in the form `v?\d.\d\.d`).

When the commit is the same as as the latest tag, then the version is the tag.

    1.0.1

For commits past the tag, the version is a combination of the tag, branch name, and number of commits since the last tag.

    1.0.1-main.1

Any branch can have a version with a unique version.

    1.0.1-hostfix-fix-the-bug.3

The action looks for a tag on the current branch that has the pattern `v?\d.\d\.d`. If it doesn't find one it will fallback to using the timestamp and short commit hash.

   0.0.0-main.t1592915661-g23b5639

This makes it easier to run automated builds with versions that are semver compatible and contain a sequential build number.

## Output of this action

    git_author=Robert Cannon
    git_author_email=dev@test.com
    git_branch=main
    git_branch_clean=main
    git_commit=23b5639c2958851c59597102bfbddecc671fe485
    git_commit_short=23b5639
    git_commit_timestamp=2020-02-21 09:11:46 -0500
    git_commit_epoch=1582294306
    git_commit_message=Removed the unused 'inputs' from the action.yml
    git_tag=0.1.0
    git_tag_long=0.1.0-1-g23b5639

    git_version=0.1.0-main.1

## Usage

You can consume the action by referencing the `v0.1.9` tag

```yaml
steps:
  - uses: WPMedia/git-version-action@v0.1.9
```

See the [actions tab](https://github.com/WPMedia/git-version-action/actions) for runs of this action! :rocket:

## Example

```yaml
# test action works running with actions/checkout@v1
test-v1:
  runs-on: ubuntu-latest
  steps:
  - uses: actions/checkout@v1
  - id: git_metadata
    uses: WPMedia/git-version-action@v0.1.9
  # example usage
  - env:
      version: ${{steps.git_metadata.outputs.git_version}}
    run: |-
      echo "This is my version: ${version}"
```

## Example with actions/checkout@v2

Note that `actions/checkout@v2` does not fetch the entire branch and tag history. Use the following to make it work with `v2`

```yaml
steps:
  # ...
  - uses: actions/checkout@v2
    with:
      # Required to get the full history for git_metadata
      fetch-depth: 0
  - run: git fetch --depth=1 origin +refs/tags/*:refs/tags/*
```
