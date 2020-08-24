;;; flycheck-janet.el --- Add janet linter to flycheck

;; This code borrows heavily from flycheck-clj-kondo:
;; https://github.com/borkdude/flycheck-clj-kondo
;;
;; Author: sogaiu
;; Created: 24 August 2020
;; Version: 2020.08.24
;; Homepage: https://github.com/sogaiu/flycheck-janet
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

(defmacro flycheck-janet--define-checker
    (name lang mode &rest extra-args)
  "Internal macro to define checker.
Argument NAME: the name of the checker.
Argument LANG: language string.
Argument MODE: the mode in which this checker is activated.
Argument EXTRA-ARGS: passes extra args to the checker."
  (let ((command
         (append
          (list "janet" "-k" "/dev/stdin")
          extra-args)))
    `(flycheck-define-checker ,name
       "See https://github.com/sogaiu/flycheck-janet"
       :command ,command
       :standard-input t
       :error-patterns
       ((error line-start
               "parse error in /dev/stdin around line " line
               ", column " column ": " (message)
               line-end))
       :modes (,mode)
       :predicate (lambda ()
                    (if buffer-file-name
                        ;; If there is an associated file with buffer, use file name extension
                        ;; to infer which language to turn on.
                        (string= ,lang (file-name-extension buffer-file-name))
                      ;; Else use the mode to infer which language to turn on.
                      ,(pcase lang
                         ("janet" `(equal 'janet-mode major-mode))))))))

(defmacro flycheck-janet-define-checkers (&rest extra-args)
  "Defines all janet checkers.
Argument EXTRA-ARGS: passes extra arguments to the checkers."
  `(progn
     (flycheck-janet--define-checker janet-janet "janet" janet-mode ,@extra-args)
     (flycheck-janet--define-checker janet-jdn "jdn" janet-mode ,@extra-args)
     (dolist (element '(janet-janet janet-jdn))
       (add-to-list 'flycheck-checkers element))))

(flycheck-janet-define-checkers)

(provide 'flycheck-janet)
;;; flycheck-janet.el ends here
