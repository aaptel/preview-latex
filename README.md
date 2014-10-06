
px.el is an Emacs Lisp library that provides functions to preview
LaTeX codes like $x^2$ in any buffer/mode.

Most of this code comes from weechat-latex.el which in turn uses
org-mode previewer.

Installation
============

Place px.el somewhere on your load-path and load it.

Usage
=====

- Use `px-preview-region` to preview LaTeX codes delimited by $ pairs
  in the region.
- Use `px-preview` to process the whole buffer.
- Use `px-remove` to remove all images and restore the text back.
- Use `px-toggle` to toggle between images and text on the whole
  buffer.
