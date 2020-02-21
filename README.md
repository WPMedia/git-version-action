
<p align="center">
  <a href="https://github.com/WPMedia/git-version-action/actions"><img alt="git-version-action status" src="https://github.com/WPMedia/git-version-action/workflows/units-test/badge.svg"></a>
</p>

# git-version-action

## Automatic Versioning

Use this action to generate automatic versions based on the git history. The action combines
tag, branch, and distance from tag information to build a version that conforms to semver
(assuming the last tag is in the form `v?\d.\d\.d`). This makes it easier to run automated
builds based on commits and building feature branches.

## Output of this action

Click the `Use this Template` and provide the new repo details for your action

    git_author=Robert Cannon
    git_author_email=dev@test.com
    git_branch=master
    git_branch_clean=master
    git_commit=23b5639c2958851c59597102bfbddecc671fe485
    git_commit_short=23b5639
    git_commit_timestamp=2020-02-21 09:11:46 -0500
    git_commit_epoch=1582294306
    git_commit_message=Removed the unused 'inputs' from the action.yml
    git_tag=0.1.0
    git_tag_long=0.1.0-1-g23b5639

    git_version=0.1.0-master.1

## Usage

_:construction: Better examples needed :construction:_

You can consume the action by referencing the v1 branch

```yaml
uses: WPMedia/git-version-action@v1
```

See the [actions tab](https://github.com/WPMedia/git-version-action/actions) for runs of this action! :rocket:

## Developing this action

### Setup

Install the dependencies
```bash
$ npm install
```

Run the tests :heavy_check_mark:
```bash
$ npm test

 PASS  ./index.test.js

...
```

### Package for distribution

GitHub Actions will run the entry point from the action.yml. Packaging assembles the code into one file that can be checked in to Git, enabling fast and reliable execution and preventing the need to check in node_modules.

Actions are run from GitHub repos.  Packaging the action will create a packaged action in the dist folder.

Run package

```bash
npm run package
```

Since the packaged index.js is run from the dist folder.

```bash
git add dist
```

## Create a release branch

Users shouldn't consume the action from master since that would be latest code and actions can break compatibility between major versions.

Checkin to the v1 release branch

```bash
$ git checkout -b v1
$ git commit -a -m "v1 release"
```

```bash
$ git push origin v1
```

Your action is now published! :rocket:

See the [versioning documentation](https://github.com/actions/toolkit/blob/master/docs/action-versioning.md)
