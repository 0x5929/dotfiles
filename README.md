# Clone

To clone `git clone --recurse-submodules <your-dotfiles-repo-url>`

# After clone

`git submodule update --init --recursive`

# NOTE To commit

The best we can do when copying over certain dirs controlled by other programs
is to add a pre-commit hook that will copy the contents of source to dest dir

**So Remember to** `git status` even after `git add .`
