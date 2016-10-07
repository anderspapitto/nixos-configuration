;;; bootstrap use-package

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;; Actual packages

(use-package avy
  :bind ("C-t" . avy-goto-char)
  :init
  (setq avy-keys
        (nconc (number-sequence ?a ?z)
               (number-sequence ?A ?Z)
               (number-sequence ?1 ?9)
               '(?0))))

(use-package calfw
  :init
  (setq org-gcal-down-days 30)
  (setq org-gcal-up-days 7)
  :config
  (require 'calfw-org)
  (use-package org-gcal))

(use-package company
  :init
  (setq company-global-modes '(not shell-mode gud-mode))
  :config
  (global-company-mode))

(use-package compile
  :init
  (setq compilation-always-kill t)
  (setq compilation-ask-about-save nil))

(use-package counsel)

(use-package elm-mode
  :init
  (setq elm-sort-imports-on-save t)
  (setq elm-format-on-save t)
  (add-to-list 'company-backends 'company-elm)
  (add-hook 'elm-mode-hook #'elm-oracle-setup-completion))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flycheck
  :init
  (setq flycheck-disabled-checkers '(emacs-lisp emacs-lisp-checkdoc))
  (setq flycheck-emacs-lisp-load-path 'inherit)
  :config
  (global-flycheck-mode))

(use-package flycheck-elm
  :init
  (add-hook 'flycheck-mode-hook 'flycheck-elm-setup))

(use-package ivy
  :bind (:map ivy-minibuffer-map
              ("<tab>" . ivy-next-line)
              ("<backtab>" . ivy-previous-line))
  :config
  (ivy-mode 1))

(use-package magit
  :init
  (setq magit-commit-show-diff nil)
  (setq magit-delete-by-moving-to-trash nil)
  (setq magit-diff-expansion-threshold 2.0)
  (setq magit-diff-use-overlays nil)
  (setq magit-revert-buffers t)
  (setq magit-use-overlays nil))

(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

(use-package nix-mode)

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb))
  :init
  (setq org-default-notes-file "~org/notes.org")
  (setq org-agenda-files '("~/org/todo.org" "~/org/schedule.org"))
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-window-setup 'current-window)
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?\n  %i")
          ("h" "Habit" entry
           (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?\n  %i\n  SCHEDULED:\n  :PROPERTIES:\n    :STYLE: habit\n  :END:")
          ("j" "Journal" entry
           (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i")
          ("n" "Note" entry
           (file+datetree "~/org/notes.org")
           "* %U %?")))
  (setq org-default-notes-file "~org/notes.org")
  (setq org-enforce-todo-dependencies t)
  (setq org-fast-tag-selection-single-key t)
  (setq org-from-is-user-regexp nil)
  (setq org-hide-leading-stars t)
  (setq org-journal-dir "~/org/journal")
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-modules
        '(org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m))
  (setq org-read-date-popup-calendar nil)
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "|" "DEFERRED(f!)" "CANCELLED(c!)" "DONE(d!)")
          (sequence "INVESTIGATE(i!)" "APPLY(a!)" "SENT(s!)" "IN-PROGRESS(p!)" "|" "REJECTED(r!)" "OFFER(o!)"))))

(use-package projectile
  :init
  (setq projectile-keymap-prefix (kbd "M-t"))
  (setq projectile-mode-line ''(:eval (format "Projectile[%s]" default-directory)))
  (setq projectile-switch-project-action 'projectile-vc)
  (setq projectile-use-git-grep t)
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-global-mode))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package real-auto-save)

(use-package shackle
  :init
  (setq shackle-rules '(("\\*input/output of.*\\*" :regexp t :ignore t))))

(use-package subword
  :config
  (global-subword-mode))

(use-package swiper)

(use-package tramp
  :init
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin")
  (setq tramp-default-method "ssh")
  (setq tramp-use-ssh-controlmaster-options nil))

(use-package undo-tree
  :init
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "/tmp/undo-tree")))
  :config
  (global-undo-tree-mode))

(use-package vimish-fold
  :config
  (vimish-fold-global-mode 1))

(use-package whitespace
  :init
  (setq whitespace-style '(face lines-tail))
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace))

;;; Miscellaneous

(global-set-key "\C-z" nil)
(global-set-key (kbd "M-o") 'mode-line-other-buffer)
(setenv "MANWIDTH" "72")
(setq Man-notify-method 'pushy)
(setq auto-save-file-name-transforms '((".*" "/tmp/" t)))
(setq backup-directory-alist '((".*" . "/tmp/")))
(setq gdb-display-io-nopopup t)
(setq indent-tabs-mode nil)
(setq kill-do-not-save-duplicates t)
(setq recenter-positions '(bottom middle top))
(setq select-enable-clipboard nil)
(setq select-enable-primary t)
(setq view-read-only t)

;;; Window management

(setq frame-auto-hide-function 'delete-frame)
(setq help-window-select t)
(setq pop-up-windows nil)
(setq same-window-buffer-names '("Calendar"))
(setq special-display-regexps '("(.*)"))
(defun skip-set-window-dedicated-p (orig-fun &rest args) nil)
(advice-add 'set-window-dedicated-p :around #'skip-set-window-dedicated-p)

;;; Looks

(set-scroll-bar-mode nil)
(setq tool-bar-mode nil)
(setq menu-bar-mode nil)
(setq initial-scratch-message nil)

(set-face-attribute 'default nil :height 105)
(set-face-attribute 'default nil :family "Inconsolata")

(defun switch-theme (from-theme to-theme org-hide-face)
  (progn
    (disable-theme from-theme)
    (load-theme to-theme t)
    (set-face-foreground 'org-hide org-hide-face)))
(defun enable-dark-theme ()
  (interactive)
  (switch-theme 'adwaita 'wheatgrass "#000000"))
(defun enable-light-theme ()
  (interactive)
  (switch-theme 'wheatgrass 'adwaita "#EDEDED"))
(enable-light-theme)

;;; various stuff that I just always want to have open

(when (daemonp)
  (progn
    (defun spawn-shell (name command)
      (pop-to-buffer (get-buffer-create name))
      (shell (current-buffer))
      (process-send-string nil command))
    (spawn-shell "*sudo*" "echo; exec sudo -i\n")
    (find-file-noselect "/etc/nixos/configuration/config/init.el")
    (find-file-noselect "/etc/nixos/configuration/private/bad-hosts.nix")
    (cfw:open-org-calendar)))
