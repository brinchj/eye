#!/bin/zsh
emacs -nw --eval "(htmlize-file \"`pwd`/$1\")" --eval "(kill-emacs)"
