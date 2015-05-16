Dotfiles
========

A bunch of configuration files for editors and other UNIX tools.

Installation
------------

Clone this repo into `~/.dotfiles`:

    $ git clone git@github.com:xqliang/dotfiles.git ~/.dotfiles

Then install the dotfiles:

    $ cd ~/.dotfiles
    $ make             # Or "make install" to create symblinks
    $ make uninstall   # Restore backups and remove symblinks

It will backup existing files as `<file>.dotfiles.bak`.

The dotfiles will be symlinked, e.g. `~/.bashrc` symlinked to `~/.dotfiles/dotfiles/bashrc`.
