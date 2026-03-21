;;; flycheck-janet.el --- Add janet linter to flycheck

;; Author: sogaiu
;; Created: 24 August 2020
;; Version: 2023.04.14
;; Package-Requires: ((flycheck "0.18"))

;;; Commentary:

;; This package integrates janet with Emacs via flycheck.  To use it, add to
;; your init.el:
;;
;;   (require 'flycheck-janet)
;;
;; likely something like:
;;
;;   (global-flycheck-mode)
;;
;; will be necessary too.

;; Make sure the janet binary is on your path.

;;; License:

;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(require 'flycheck)

;; sample janet -k output
;;
;; 1. each warning appears on one line:
;;
;;   sample.janet:1:1: compile warning (strict): ...
;;
;; 2. an error is followed by an indented stacktrace:
;;
;;   error: sample.janet:3:1: compile error: ...
;;     in ...

;; see `'flycheck-redefine-standard-error-levels' for calls to
;; `flycheck-define-error-level' which define the three levels: error,
;; warning, and info.  only warning and error are used atm in
;; :error-patterns below.

(flycheck-define-checker janet-janet
  "A checker for Janet using janet -k.

See URL `https://github.com/janet-lang/janet'."
  :command ("janet" "-k")
  :standard-input t
  :error-patterns
  ((warning line-start
            (one-or-more (not ":")) ":"
            line
            ":"
            column ": "
            (message)
            line-end)
   (error line-start
          "error: "
          (one-or-more (not ":")) ":"
          line
          ":"
          column ": "
          (message)
          line-end))
  :modes (janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

(flycheck-define-checker janet-relaxed
  "A checker for Janet using janet -k -w relaxed.

See URL `https://github.com/janet-lang/janet'."
  :command ("janet" "-k" "-w" "relaxed")
  :standard-input t
  :error-patterns
  ((warning line-start
            (one-or-more (not ":")) ":"
            line
            ":"
            column ": "
            (message)
            line-end)
   (error line-start
          "error: "
          (one-or-more (not ":")) ":"
          line
          ":"
          column ": "
          (message)
          line-end))
  :modes (janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

(flycheck-define-checker janet-normal
  "A checker for Janet using janet -k -w normal.

See URL `https://github.com/janet-lang/janet'."
  :command ("janet" "-k" "-w" "normal")
  :standard-input t
  :error-patterns
  ((warning line-start
            (one-or-more (not ":")) ":"
            line
            ":"
            column ": "
            (message)
            line-end)
   (error line-start
          "error: "
          (one-or-more (not ":")) ":"
          line
          ":"
          column ": "
          (message)
          line-end))
  :modes (janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

(flycheck-define-checker janet-strict
  "A checker for Janet using janet -k -w strict.

See URL `https://github.com/janet-lang/janet'."
  :command ("janet" "-k" "-w" "strict")
  :standard-input t
  :error-patterns
  ((warning line-start
            (one-or-more (not ":")) ":"
            line
            ":"
            column ": "
            (message)
            line-end)
   (error line-start
          "error: "
          (one-or-more (not ":")) ":"
          line
          ":"
          column ": "
          (message)
          line-end))
  :modes (janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

;; use a similar line in .emacs equivalent if one of the other
;; checkers, e.g. janet-relaxed, janet-normal, or janet-strict is
;; desired instead
(add-to-list 'flycheck-checkers 'janet-janet)

(provide 'flycheck-janet)
;;; flycheck-janet.el ends here
