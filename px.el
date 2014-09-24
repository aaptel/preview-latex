;;; px.el --- preview inline latex -*- lexical-binding: t -*-

;; Most of this code comes from weechat-latex.el which in turn uses
;; org-mode previewer.

;; Copyright (C) 2014 Aurélien Aptel <aurelien.aptel@gmail.com>
;; Copyright (C) 2013 Rüdiger Sonderfeld <ruediger@c-plusplus.de>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(require 'org)

(defvar px-temp-file-prefix "px-"
  "Prefix for temporary files.")

(defvar px-temp-directory-prefix "px-"
  "Prefix for temporary directory.")

(defvar px-image-program org-latex-create-formula-image-program
  "Program to convert LaTeX fragments.
See `org-latex-create-formula-image-program'")

(defvar px-temp-dir nil
  "The temporary directory used for preview images.")

(defun px--create-preview (at)
  "Wrapper for `org-format-latex'.
The parameter AT should be nil or in (TYPE . POINT) format.  With TYPE being a
string showing the matched LaTeX statement (e.g., ``$'') and POINT being the
POINT to replace.  If AT is nil replace statements everywhere."
  (org-format-latex px-temp-file-prefix
                    px-temp-dir
                    'overlays
                    "Creating images...%s"
                    at 'forbuffer
                    px-image-program))

(defun px--set-temp-dir ()
  "Set `px-temp-dir' unless it is already set."
  (unless px-temp-dir
    (setq px-temp-dir
          (make-temp-file px-temp-directory-prefix
                          'directory))))

(defun px-preview ()
  "Preview LaTeX fragments."
  (interactive)
  (save-excursion
    (let ((inhibit-read-only t))
      (px--set-temp-dir)
      (org-remove-latex-fragment-image-overlays)
      (px--create-preview nil))))

(defun px-preview-region (beg end)
  "Preview LaTeX fragments in region."
  (interactive "r")
  (let* ((math-regex (assoc "$" org-latex-regexps))
         (regex (nth 1 math-regex))
         (n (nth 2 math-regex))
         matches)
    (save-excursion
      (goto-char beg)
      (while (re-search-forward regex end t)
        (setq matches (cons (cons "$" (match-beginning n)) matches)))
      (let ((inhibit-read-only t))
        (px--set-temp-dir)
        (dolist (i matches)
          (px--create-preview i))))))


(defun px-remove ()
  "Remove LaTeX preview images."
  (interactive)
  (let ((inhibit-read-only t))
    (org-remove-latex-fragment-image-overlays)))

(defun px-is-active? ()
  "Are LaTeX Previews currently displayed?"
  org-latex-fragment-image-overlays)

(defun px-toggle ()
  "Toggle display of LaTeX preview."
  (interactive)
  (if (px-is-active?)
      (px-remove)
    (px-preview)))


(provide 'px)
