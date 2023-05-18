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

(flycheck-define-checker janet-janet
  "Flycheck for Janet"
  :command ("janet" "-k")
  :standard-input t
  :error-patterns
  ((error line-start
          (one-or-more (not ":")) ":"
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

(add-to-list 'flycheck-checkers 'janet-janet)

(provide 'flycheck-janet)
;;; flycheck-janet.el ends here
