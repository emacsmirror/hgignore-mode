;;; hgignore-mode.el --- a major mode for editing hgignore files

;;; Copyright (C) 2014 Omair Majid

;; Author: Omair Majid <omair.majid@gmail.com>
;; URL: http://github.com/omajid/hgignore-mode
;; Keywords: convenience vc hg
;; Version: 0.1.20141026

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A major mode for editing hgignore files.  Adds basic syntax
;; highlighting and commenting support for scripts.

;;; Code:

(require 'newcomment)

(defconst hgignore-mode-keywords
  (list
   (cons (regexp-opt '("syntax" "regexp" "glob")) 'font-lock-keyword-face))
  "Keywords recognized by font-lock for `hgignore-mode'.")

(defun hgignore-completion-at-point ()
  "`completion-at-point' support for hgignore-mode."
  (let* ((line-start (save-excursion
                       (beginning-of-line)
                       (point)))
         (line-end (save-excursion
                     (end-of-line)
                     (point)))
         (last-slash (save-excursion
                       (condition-case nil
                           (progn
                             (end-of-line)
                             (re-search-backward "/" line-start))
                         (error line-start))))
         (root-path (file-name-directory (buffer-file-name)))
         (base-path (buffer-substring-no-properties line-start last-slash))
         (path (concat root-path base-path "/"))
         (completions (directory-files path)))
    (list (1+ last-slash) (point) completions)))

;;;###autoload
(define-derived-mode hgignore-mode prog-mode "hgignore"
  "Major mode for editing .hgignore files."
  ;; set up font-lock
  (setq font-lock-defaults (list hgignore-mode-keywords))
  ;; syntax table
  (let (table hgignore-mode-syntax-table)
    (modify-syntax-entry ?\# "<" table)
    (modify-syntax-entry ?\n ">" table))
  ;; comment/uncomment correctly
  (setq comment-start "#")
  (setq comment-end "")
  ;; auto completion
  (add-hook 'completion-at-point-functions #'hgignore-completion-at-point nil t))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.hgignore\\'" . hgignore-mode))

(provide 'hgignore-mode)
;;; hgignore-mode.el ends here
