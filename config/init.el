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

;;; Acutal packages

(use-package calfw
  :config
  (require 'calfw-org)
  (use-package org-gcal)
  (setq org-gcal-down-days 30)
  (setq org-gcal-up-days 7)
  )

(use-package company
  :config
  (setq company-global-modes '(not shell-mode gud-mode)))

(use-package compile
  :config
  (setq compilation-always-kill t)
  (setq compilation-ask-about-save nil))

(use-package helm
  :bind (:map helm-map
              ("<tab>" . helm-next-line)
              ("<backtab>" . helm-previous-line)))

(use-package helm-descbinds)

(use-package magit
  :config
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
  :bind (("\C-cl" . org-store-link)
         ("\C-cc" . org-capture)
         ("\C-ca" . org-agenda)
         ("\C-cb" . org-iswitchb))
  :init
  (setq org-default-notes-file "~org/notes.org")
  :config
  (setq org-agenda-files '("~/org/todo.org" "~/org/schedule.org"))
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-window-setup 'current-window)
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?
  %i")
          ("h" "Habit" entry
           (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?
  %i
  SCHEDULED:
  :PROPERTIES:
    :STYLE: habit
  :END:")
          ("j" "Journal" entry
           (file+datetree "~/org/journal.org")
           "* %?
Entered on %U
  %i")
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
  :config
  (projectile-global-mode)
  (setq projectile-mode-line ''(:eval (format "Projectile[%s]" default-directory)))
  (setq projectile-switch-project-action 'projectile-vc)
  (setq projectile-use-git-grep t)
  (setq projectile-completion-system 'helm))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package real-auto-save)

(use-package shackle
  :config
  (setq shackle-rules '(("\\*input/output of.*\\*" :regexp t :ignore t))))

(use-package subword
  :config
  (global-subword-mode))

(use-package tramp
  :config
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin")
  (setq tramp-default-method "ssh")
  (setq tramp-use-ssh-controlmaster-options nil))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "/tmp/undo-tree"))))

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

(setq scroll-bar-mode nil)
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
