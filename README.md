# flycheck-janet

This package integrates [janet](https://janet-lang.org)'s built-in
linter (`janet -k`) with Emacs via
[flycheck](https://www.flycheck.org).

## Setup

0. Ensure `janet` is installed and on your `PATH`.  Probably it makes
   sense if [janet-mode](https://github.com/ALSchwalm/janet-mode/) or
   [janet-ts-mode](https://github.com/sogaiu/janet-ts-mode) have been
   setup as well.

1. Clone this repository.  For the sake of concrete exposition,
   suppose the result ends up living under `~/src/flycheck-janet`.

2. Add the following to your `init.el` (or .emacs-equivalent):

    ```emacs-lisp
    (add-to-list 'load-path
                 (expand-file-name "~/src/flycheck-janet"))
    (require 'flycheck-janet)
    ```

3. If you don't already have some flycheck stuff setup, you might also
   want to add:
   
    ```emacs-lisp
    (global-flycheck-mode)
    ```

## Verify Operation

1. Open / create a `.janet` file with an error in it like:

    ```janet
    (def a
    ```
    
2. Assuming `janet-mode` or `janet-ts-mode` are active, `M-x
   flycheck-list-errors` should bring up a buffer showing an error,
   but there should also be visual evidence in the buffer with
   Janet code indicating a problem.

## Troubleshooting

If there are no errors displayed, one option that might help is to
check out the [troubleshooting section of the flycheck
docs](https://www.flycheck.org/en/latest/user/troubleshooting.html).

If the common issues section doesn't help, possibly one or both of the
following two commands ([mentioned later in flycheck's
docs](https://www.flycheck.org/en/latest/user/troubleshooting.html#verify-your-setup))
might help in diagnosing the situation:

* `M-x flycheck-verify-setup`
* `M-x flycheck-compile`

