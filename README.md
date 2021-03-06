# bin

My ~/bin directory.

## Setup

Assuming you don't have a ~/bin dir:

```
cd
git clone https://github.com/alb-i986/bin.git
echo "export PATH=~/bin:$PATH" >> ~/.bashrc
```

## Git tasks

### git_pull_safe

```
git_pull_safe [remote_name]
```

Updates master in the current dir by pulling from origin or the given remote.

It is basically an advanced `git pull origin master`, allowing you to update master while you are in the middle of some work.
In fact:

- before pulling, it [stashes](https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning) any work in progress
- after pulling, it checks out the branch you were previously working on, and stashes back your non-committed changes, keeping the index as it was, thus restoring the original state of your working directory, including any files added to the index.

It can handle git submodules: it will run itself for each one of them.

Can also transparently handle git repos cloned with `git-svn`: instead of pulling it will run `git svn rebase`.

It handles any "abnormal" termination like CTRL-C: in such cases it will restore the original state of your working directory by checking out the original branch, and by stash-popping back.


Detailed sequence of steps:

- stash
- co master
- pull $REMOTE master (or `svn rebase`, if the repo was cloned from SVN)
- co $ORIGINAL_BRANCH
- stash pop
- repeat all of the above steps for each git submodule (if any)


### git_pull_safe_all

```
git_pull_safe_all [PROJECTS_ROOT_1] [PROJECTS_ROOT_2] .. [PROJECTS_ROOT_n]
```

Updates (by pulling) master for each project under each of the given project roots.
By default (i.e. if no args are given), it updates all of the projects under `~/workspace`.

At the end, it will print out a summary with the projects for which the operation failed, if any.

It wraps `git_pull_safe`: see the corresponding paragraph for more details.


### git_rebase_branches

```
git_rebase_branches [base_branch]
```

Rebases each local branch on top of master or the given base branch.

The user can actually choose which branches to rebase at run-time.
In fact, before performing each rebase, it will ask the user for a confirmation.

### git_reset_author_all

Reset the author (see `man git-commit`, reset-author) for all of the commits starting from master (or `$1`) up to HEAD.

Usage:

    git_reset_author_all [base_branch]
    
Warning: this is actually a rebase.

### git_deploy2stash

Pushes the current branch to origin and opens a Pull Request on Atlassian Stash.

Before that:

- update master by pulling from origin
- rebase the current branch on top of the updated master
- run `mvn install` to check that the build is good

Pre-reqs: [Atlassian Stash Command Line Tools](http://blogs.atlassian.com/2012/11/stash-pull-requests-from-the-command-line/) needs to be installed.
