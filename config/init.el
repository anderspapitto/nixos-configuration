;;; bootstrap use-package

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("orgmode" . "http://orgmode.org/elpa/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;; load secrets
(load "~/.emacs.d/lisp/secrets.el")

;;; Actual packages

(use-package avy
  :bind ("C-t" . avy-goto-char)
  :init
  (setq avy-keys
        (nconc (number-sequence ?a ?z)
               (number-sequence ?A ?Z)
               (number-sequence ?1 ?9)
               '(?0))))

(use-package cargo)

(use-package column-marker
  :init
  (add-hook 'prog-mode-hook (lambda () (column-marker-1 79))))

(use-package company
  :init
  (setq company-global-modes '(not gud-mode))
  (setq company-dabbrev-downcase nil)
  :config
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-active-map [tab] nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map [return] nil)
  (global-company-mode))

(use-package compile
  :init
  (setq compilation-always-kill t)
  (setq compilation-ask-about-save nil)
  :config
  (load "/etc/emacs/my-compile.el"))

(use-package counsel)

(use-package dirtrack
  :init
  (setq dirtrack-list '(".*?:\(.*?\)]" 1))
  :config
  (dirtrack-mode 1))

(use-package elm-mode
  :init
  (setq elm-sort-imports-on-save t)
  (setq elm-format-on-save t)
  (add-to-list 'company-backends 'company-elm)
  (add-hook 'elm-mode-hook 'elm-oracle-setup-completion))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flycheck
   :init
   (setq flycheck-disabled-checkers '(emacs-lisp emacs-lisp-checkdoc))
   (setq flycheck-emacs-lisp-load-path 'inherit)
   (setq flycheck-display-errors-function 'nil)
   (setq flycheck-standard-error-navigation 'nil))

(use-package haskell-mode)

(use-package hledger-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))
  (add-to-list 'company-backends 'hledger-company))

(use-package intero
  :init
  (defun anders-intero-mode-unless-global-project ()
    "Run intero-mode iff we're in a project with a stack.yaml"
    (interactive)
    (unless (string-match-p
             (regexp-quote "global")
             (shell-command-to-string "stack path --project-root --verbosity silent"))
      (intero-mode)))
  (add-hook 'haskell-mode-hook 'anders-intero-mode-unless-global-project))

(use-package ivy
  :config
  (ivy-mode 1))

(use-package load-relative)

(use-package magit
  :init
  (setq magit-commit-show-diff nil)
  (setq magit-delete-by-moving-to-trash nil)
  (setq magit-diff-expansion-threshold 2.0)
  (setq magit-diff-use-overlays nil)
  (setq magit-revert-buffers t)
  (setq magit-use-overlays nil))

(use-package man
  :init
  (setq Man-width 80)
  (setq Man-notify-method 'pushy))

(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package nix-mode)

(use-package org
  :ensure org-plus-contrib
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb))
  :init
  (add-hook 'org-capture-after-finalize-hook 'delete-frame)
  (setq org-agenda-block-separator
        "=============================================================")
  (setq org-agenda-compact-blocks nil)
  (setq org-agenda-custom-commands
        '(("a" "Agenda"
           ((agenda ""
                    ((org-super-agenda-groups
                      '((:discard (:tag "agenda_ignore"))
                        (:name "Important"
                               :priority "A")
                        (:name "Appointments"
                               :time-grid t)
                        (:name "Established Habits"
                               :and (:habit t :tag "established"))
                        (:name "Developing Habits"
                               :and (:habit t)
                               :order 2)
                        (:name "Tasks"
                               :scheduled t)
                        ))))
            (tags-todo "project"
                  ((org-agenda-overriding-header "Project Next Tasks")
                   (org-agenda-skip-function 'my-next-task-skip-function)))
            (tags-todo "-project-habit-capture-agenda_ignore"
                       ((org-agenda-overriding-header "Standalone Tasks")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'all)))
            ))
          ("c" "Captures"
           ((tags "capture"
                  ((org-agenda-overriding-header "Capture")))))
          ))

  (setq org-agenda-files '("~/org" "~/org/dev"))
  (setq org-agenda-include-diary t)
  (setq org-agenda-skip-function-global
        (lambda ()
          (let ((subtree-end (save-excursion (org-end-of-subtree t))))
            (if (re-search-forward ":agenda_ignore:" subtree-end t)
                subtree-end ; tag found, continue after end of subtree
              nil))))       ; tag not found, do not skip
  (setq org-agenda-span 'day)
  (setq org-agenda-time-grid
        '((daily today require-timed)
          ()
          "......"
          "----------------"))
  (setq org-agenda-window-setup 'current-window)
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file "~/org/capture.org")
           "* TODO %?\n  %i")
          ("a" "Appointment" entry
           (file "~/org/appts.org")
           "* %? :appointment:\n  %^T")
          ("j" "Journal" entry
           (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i")
          ("n" "Note" entry
           (file+datetree "~/org/notes.org")
           "* %U %?")))
  (setq org-archive-location "~/org/silent/archive.org::")
  (setq org-default-notes-file "~org/notes.org")
  (setq org-enforce-todo-dependencies t)
  (setq org-fast-tag-selection-single-key t)
  (setq org-from-is-user-regexp nil)
  (setq org-habit-graph-column 80)
  (setq org-habit-preceding-days 42)
  (setq org-hide-leading-stars t)
  (setq org-journal-dir "~/org/journal")
  (setq org-link-search-must-match-exact-headline nil)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-modules
        '(org-bbdb
          org-bibtex
          org-checkboxes
          org-docview
          org-gnus
          org-habit
          org-info
          org-irc
          org-mhe
          org-rmail
          org-w3m))
  (setq org-outline-path-complete-in-steps nil)
  (setq org-read-date-force-compatible-dates nil)
  (setq org-read-date-popup-calendar nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-target-verify-function
        (lambda ()
          (not (member (nth 2 (org-heading-components)) org-done-keywords))))
  (setq org-refile-targets '((org-agenda-files :maxlevel . 9)))
  (setq org-refile-use-outline-path 'file)
  (setq org-tags-exclude-from-inheritance  '("refile"))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)"
                    "|"
                    "CANCELLED(c)" "DONE(d)")))
  :config
  (load "/etc/emacs/my-org"))

(use-package org-super-agenda
  :config
  (org-super-agenda-mode))

(use-package prodigy)

(use-package projectile
  :init
  (setq projectile-keymap-prefix (kbd "M-t"))
  (setq projectile-mode-line
        ''(:eval (format "Projectile[%s]" default-directory)))
  (setq projectile-switch-project-action 'projectile-vc)
  (setq projectile-use-git-grep t)
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-global-mode)
  (ad-deactivate 'compilation-find-file))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package real-auto-save
  :init
  (add-hook 'org-mode-hook 'real-auto-save-mode)
  (setq real-auto-save-interval 30))

(use-package rust-mode)

(use-package shackle
  :init
  (setq shackle-rules '(("\\*input/output of.*\\*" :regexp t :ignore t))))

(use-package shell
  :config
  (define-key shell-mode-map (kbd "TAB") 'company-manual-begin))

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
  :bind ("C-x C-s" . save-with-delete-trailing-whitespace)
  :init
  (setq-default indent-tabs-mode nil)
  (setq whitespace-style '(face tabs))
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (defun save-with-delete-trailing-whitespace ()
    (interactive)
    (delete-trailing-whitespace)
    (save-buffer)))

(use-package yaml-mode)

;;; Miscellaneous

(global-set-key (kbd "C-z") nil)
(setq auto-save-file-name-transforms '((".*" "/tmp/" t)))
(setq backup-directory-alist '((".*" . "/tmp/")))
(setq dired-auto-revert-buffer t)
(setq gdb-display-io-nopopup t)
(setq recenter-positions '(bottom middle top))
(setq view-read-only t)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "<f12>") 'browse-url-at-point)
(global-set-key (kbd "<XF86Explorer>") 'browse-url-at-point)

;;; copy/paste

(setq kill-do-not-save-duplicates t)
(setq save-interprogram-paste-before-kill t)
(setq select-enable-clipboard nil)
(setq select-enable-primary t)

;;; Window management

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key "\M-o" 'switch-to-previous-buffer)
(setq frame-auto-hide-function 'delete-frame)
(setq display-buffer-alist
      '(("*shell*" (display-buffer-same-window) ())
        (".*" (display-buffer-reuse-window
               display-buffer-same-window
               display-buffer-pop-up-frame)
         (reusable-frames . t))))
(defun anders-same-window-instead
    (orig-fun buffer alist)
  (display-buffer-same-window buffer nil))
(advice-add 'display-buffer-pop-up-window :around 'anders-same-window-instead)
(defun anders-do-select-frame (orig-fun buffer &rest args)
  (let* ((old-frame (selected-frame))
         (window (apply orig-fun buffer args))
         (frame (window-frame window)))
    (unless (eq frame old-frame)
      (select-frame-set-input-focus frame))
    (select-window window)
    window))
(advice-add 'display-buffer :around 'anders-do-select-frame)
(advice-add 'set-window-dedicated-p :around
            (lambda (orig-fun &rest args) nil))

;;; Luddite mode

(set-scroll-bar-mode nil)
(setq tool-bar-mode nil)
(setq menu-bar-mode nil)
(setq initial-scratch-message nil)

;;; Looks

(set-face-attribute 'default nil :height 105)
(set-face-attribute 'default nil :family "Inconsolata")

(defun anders-switch-theme (from-theme to-theme org-hide-face)
  (progn
    (disable-theme from-theme)
    (load-theme to-theme t)))
(defun enable-dark-theme ()
  (interactive)
  (anders-switch-theme 'adwaita 'wheatgrass "#000000"))
(defun enable-light-theme ()
  (interactive)
  (anders-switch-theme 'wheatgrass 'adwaita "#EDEDED"))
(enable-light-theme)


(setq safe-local-variable-values
      '((projectile-project-compilation-cmd . "./build/Build.hs")))

;;; various stuff that I just always want to have open

(when (daemonp)
  (progn
    (defun spawn-shell (name command)
      (pop-to-buffer (get-buffer-create name))
      (shell (current-buffer))
      (process-send-string nil command))
    (spawn-shell "*sudo*" "echo; exec sudo -i\n")
    (find-file-noselect "/etc/nixos/configuration/config/init.el")
    (find-file-noselect "/etc/nixos/configuration/private/bad-hosts.nix")))
