;;; compat.el --- Emacs Lisp Compatibility Library -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2023 Free Software Foundation, Inc.

;; Author: Philip Kaludercic <philipk@posteo.net>, Daniel Mendler <mail@daniel-mendler.de>
;; Maintainer: Daniel Mendler <mail@daniel-mendler.de>, Compat Development <~pkal/compat-devel@lists.sr.ht>
;; Version: 29.1.2.0
;; URL: https://github.com/emacs-compat/compat
;; Package-Requires: ((emacs "24.4"))
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; To allow for the usage of Emacs functions and macros that are
;; defined in newer versions of Emacs, compat.el provides definitions
;; that are installed ONLY if necessary.  If Compat is installed on a
;; recent version of Emacs, all of the definitions are disabled at
;; compile time, such that no negative performance impact is incurred.
;; These reimplementations of functions and macros are at least
;; subsets of the actual implementations.  Be sure to read the
;; documentation string to make sure.
;;
;; Not every function provided in newer versions of Emacs is provided
;; here.  Some depend on new features from the core, others cannot be
;; implemented to a meaningful degree.  Please consult the Compat
;; manual for details.  The main audience for this library are not
;; regular users, but package maintainers.  Therefore commands and
;; user options are usually not implemented here.

;;; Code:

(when (eval-when-compile (< emacs-major-version 29))
  (require 'compat-29))

;;;; Macros for explicit compatibility function calls

(defmacro compat-function (fun)
  "Return compatibility function symbol for FUN.

If the Emacs version provides a sufficiently recent version of
FUN, the symbol FUN is returned itself. Otherwise the macro
returns the symbol of a compatibility function which supports the
behavior and calling convention of the current stable Emacs
version. For example Compat 29.1 will provide compatibility
functions which implement the behavior and calling convention of
Emacs 29.1."
  (let ((compat (intern (format "compat--%s" fun))))
    `#',(if (fboundp compat) compat fun)))

(defmacro compat-call (fun &rest args)
  "Call compatibility function or macro FUN with ARGS.

See `compat-function' for the compatibility function resolution."
  (let ((compat (intern (format "compat--%s" fun))))
    `(,(if (fboundp compat) compat fun) ,@args)))

(provide 'compat)
;;; compat.el ends here