;;; flycheck-janet.el --- janet flycheck -*- lexical-binding: t; -*-

;; Author: sogaiu
;; Created: 24 August 2020
;; Version: 2026.04.03
;; Package-Requires: ((flycheck "0.18"))

;;; Commentary:

;; This package integrates janet with Emacs via flycheck.  To use it,
;; add to your .emacs-equivalent (e.g. init.el):
;;
;;   (require 'flycheck-janet)
;;
;; likely something like:
;;
;;   (global-flycheck-mode)
;;
;; will be necessary too.

;; Make sure the janet binary is on your path.

;;; Development Notes:

;; General

;; * For inspiration, exploration, etc., consider examining
;;  `flycheck.el' itself.  Something along these lines is mentioned on
;;  the website docs...on the developer's guide page...in a note with
;;  small text...near the end of a page with a fair bit of text.  May
;;  be there was a Douglas Adams fan involved somehow...
;;
;;  In any case, the file has numerous actual examples of use of
;;  `flycheck-define-checker' and one can get a sense of how others
;;  have managed to get things to work.  A substantial portion of the
;;  "latter half" of the file seems to be dedicated to calling
;;  `flycheck-define-checker' for various programming language
;;  arrangements.  Search for the comment "Built-in checkers".

;; * Searching the issue tracker also turned up useful hints, so
;;  remember to give that a try as well.

;; Miscellaneous

;; * See `'flycheck-redefine-standard-error-levels' for calls to
;;  `flycheck-define-error-level' which define the three levels:
;;  error, warning, and info.  Only warning and error are used atm in
;;  :error-patterns in this file.

;; * The checkers in this file operate on stdin content so one may end
;;   up seeing `stdin' as the file name in many cases.

;; * Note that the linter reports issues with files that are not the
;;   "current file" as well.  These don't appear to show up via "Show
;;   all errors".  it may be that flycheck filters these out via
;;   `flycheck-relevant-error-p'.

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
;;
;; 3. when used with stdin (which happens here), can also have:
;;
;;   stdin:1:1: compile warning (strict): ...
;;
;;   error: stdin:3:1: compile error: ...
;;     in ...

(defun flycheck-janet--debug-error-filter (errors)
  "Debugging function for observing flycheck error objects.

Takes a single argument `ERRORS' of flycheck error objects.
Use with `:error-filter' portion of `flycheck-define-checker'.

At the moment, for each flycheck error object, it dumps all of the
flycheck error objects and reports filename, message, and/or level for
each if these are defined."
  (message "%S" errors)
  (dolist (err errors)
    (when (flycheck-error-filename err)
      (message "filename: %s" (flycheck-error-filename err)))
    (when (flycheck-error-message err)
      (message "message: %s" (flycheck-error-message err)))
    (when (flycheck-error-level err)
      (message "level: %s" (flycheck-error-level err))))
  errors)

(defun flycheck-janet-error-filter (errors)
  "Error filter for janet checkers.

Takes a single argument `ERRORS' of flycheck error objects.
Use with `:error-filter' portion of `flycheck-define-checker'.

At the moment, it just massages file names."
  (dolist (err errors)
    (when-let* ((fname (flycheck-error-filename err)))
      (if (and buffer-file-name (string-equal "stdin" fname))
          (setf (flycheck-error-filename err) buffer-file-name)
        (setf (flycheck-error-filename err) (expand-file-name fname)))))
  errors)

(defvar flycheck-janet-error-patterns
  '((warning line-start
             ;; XXX: gets fooled by "error: stdin"
             ;;(file-name)
             ;; better
             (file-name (one-or-more (not ":")))
             ":"
             line
             ":"
             column ": "
             (message)
             line-end)
    (error line-start
           "error: "
           ;; use via stdin causes the following to be stdin:
           (one-or-more (not ":")) ":"
           line
           ":"
           column ": "
           (message)
           line-end))
  "Error patterns for janet checkers.")

;; https://www.flycheck.org/en/latest/developer/developing.html

(flycheck-def-executable-var janet-janet "janet")
(flycheck-define-command-checker 'janet-janet
  "A checker for Janet using janet -n -k."
  :command '("janet" "-n" "-k")
  :standard-input t
  :error-filter #'flycheck-janet-error-filter
  :error-patterns flycheck-janet-error-patterns
  :modes '(janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

(flycheck-def-executable-var janet-relaxed "janet")
(flycheck-define-command-checker 'janet-relaxed
  "A checker for Janet using janet -n -k -w relaxed."
  :command '("janet" "-n" "-k" "-w" "relaxed")
  :standard-input t
  :error-filter #'flycheck-janet-error-filter
  :error-patterns flycheck-janet-error-patterns
  :modes '(janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

(flycheck-def-executable-var janet-normal "janet")
(flycheck-define-command-checker 'janet-normal
  "A checker for Janet using janet -n -k -w normal"
  :command '("janet" "-n" "-k" "-w" "normal")
  :standard-input t
  :error-filter #'flycheck-janet-error-filter
  :error-patterns flycheck-janet-error-patterns
  :modes '(janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

(flycheck-def-executable-var janet-strict "janet")
(flycheck-define-command-checker 'janet-strict
  "A checker for Janet using janet -n -k -w strict."
  :command '("janet" "-n" "-k" "-w" "strict")
  :standard-input t
  :error-filter #'flycheck-janet-error-filter
  :error-patterns flycheck-janet-error-patterns
  :modes '(janet-mode janet-ts-mode)
  :predicate (lambda ()
               (memq major-mode '(janet-mode
                                  janet-ts-mode))))

;; use a similar line in .emacs equivalent if one of the other
;; checkers, e.g. janet-relaxed, janet-normal, or janet-strict is
;; desired instead
(add-to-list 'flycheck-checkers 'janet-janet)

(provide 'flycheck-janet)
;;; flycheck-janet.el ends here
