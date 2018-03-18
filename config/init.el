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

;;; Elisp utilities

(use-package f)
(use-package s)

;;; Actual packages, except language-specific

(use-package avy
  :bind ("C-t" . avy-goto-char))

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

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package ivy
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

(use-package man
  :init
  (setq Man-width 80)
  (setq Man-notify-method 'pushy))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package org
  :bind (("C-c a" . anders/org-agenda))
  :init
  ;; Utility function so that I don't have to fix the set of org files
  ;; statically.
  (defun anders/dynamic-org-files (directory)
    (f-entries directory
               (lambda (filename) (s-ends-with-p ".org" filename))
               t))

  ;; Autosave files, and gracefully handle the special case of
  ;; automatic cross-machine syncing for the files subject to it.
  (add-hook 'org-mode-hook 'real-auto-save-mode)
  (add-hook 'org-mode-hook 'auto-revert-mode)

  ;; This is part of my window-management strategy (only use os-level
  ;; window control)
  (add-hook 'org-capture-after-finalize-hook 'delete-frame)
  (setq org-agenda-window-setup 'current-window)

  ;; Set up the agenda for the particular things I want out of it.
  (defun anders/org-agenda ()
    (interactive)
    (org-agenda nil "custom"))
  (setq org-agenda-compact-blocks t)
  (setq org-agenda-custom-commands
        '(("custom" "Custom Agenda"
           ((todo ""
                  ((org-agenda-files
                    (anders/dynamic-org-files "~/projects/primary"))))
            (todo ""
                  ((org-agenda-files
                    (anders/dynamic-org-files "~/projects/special"))))
            (tags "project"
                  ((org-agenda-files
                    (anders/dynamic-org-files "~/projects/background"))
                   (org-use-tag-inheritance nil)))))))
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file "~/projects/special/capture/capture.org")
           "* TODO %?\n  %i")))

  ;; I only refile from my capture files to the top (file) level of
  ;; other org files.
  ;;
  ;; Forcing level == 100 is a hack to perfomantly filter out all
  ;; headings and leave only file names.
  ;;
  ;; The argument to org-refile-targets must be a named function.
  (defun anders/dynamic-all-org-files ()
    (anders/dynamic-org-files "~/projects"))
  (setq org-refile-use-outline-path 'file)
  (setq org-refile-targets '((anders/dynamic-all-org-files :level . 100)))

  ;; Miscellaneous
  (setq org-fast-tag-selection-single-key t)
  (setq org-from-is-user-regexp nil)
  (setq org-hide-leading-stars t)
  (setq org-read-date-force-compatible-dates nil)
  (setq org-read-date-popup-calendar nil))

(use-package projectile
  :init
  (defun anders/vc-or-dired ()
    (interactive)
    (projectile-dired)
    (ignore-errors (projectile-vc)))
  (setq projectile-keymap-prefix (kbd "M-t"))
  (setq projectile-mode-line
        ''(:eval (format "Projectile[%s]" default-directory)))
  (setq projectile-switch-project-action 'anders/vc-or-dired)
  (setq projectile-completion-system 'ivy)
  (define-key projectile-command-map (kbd "s g") 'projectile-ripgrep)
  :config
  (projectile-global-mode)
  (ad-deactivate 'compilation-find-file))

(use-package projectile-ripgrep)

(use-package real-auto-save
  :init
  (setq real-auto-save-interval 30))

(use-package shackle
  :init
  (setq shackle-rules '(("\\*input/output of.*\\*" :regexp t :ignore t))))

(use-package subword
  :config
  (global-subword-mode))

(use-package term
  :init
  (defun anders/get-term ()
    (interactive)
    (term "bash"))
  :config
  (defun anders/expose-global-binding-in-term (binding)
    (define-key term-raw-map binding
      (lookup-key (current-global-map) binding)))
  (anders/expose-global-binding-in-term (kbd "M-x"))
  (anders/expose-global-binding-in-term (kbd "C-x"))
  (anders/expose-global-binding-in-term (kbd "C-c a"))

  (defun anders/term-toggle-mode ()
    "Toggles term between line mode and char mode"
    (interactive)
    (if (term-in-line-mode)
        (term-char-mode)
      (term-line-mode)))
  (define-key term-mode-map (kbd "M-i") 'anders/term-toggle-mode)
  (define-key term-raw-map  (kbd "M-i") 'anders/term-toggle-mode)
  (define-key term-raw-map (kbd "C-y") 'term-paste))

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

(use-package whitespace
  :bind ("C-x C-s" . anders/save-with-delete-trailing-whitespace)
  :init
  (setq-default indent-tabs-mode nil)
  (setq whitespace-style '(face tabs))
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (defun anders/save-with-delete-trailing-whitespace ()
    (interactive)
    (delete-trailing-whitespace)
    (save-buffer)))

;;; Programming-language specific packages

(use-package cargo)

(use-package elm-mode
  :init
  (setq elm-sort-imports-on-save t)
  (setq elm-format-on-save t)
  (add-to-list 'company-backends 'company-elm)
  (add-hook 'elm-mode-hook 'elm-oracle-setup-completion))

(use-package haskell-mode)

(use-package intero
  :init
  (defun anders/intero-mode-unless-global-project ()
    "Run intero-mode iff we're in a project with a stack.yaml"
    (interactive)
    (unless (string-match-p
             (regexp-quote "global")
             (shell-command-to-string
              "stack path --project-root --verbosity silent"))
      (intero-mode)))
  (add-hook 'haskell-mode-hook 'anders/intero-mode-unless-global-project))

(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

(use-package nix-mode)

(use-package rust-mode)

(use-package yaml-mode)

;;; Copy/paste

(setq kill-do-not-save-duplicates t)
(setq save-interprogram-paste-before-kill t)
(setq select-enable-clipboard nil)
(setq select-enable-primary t)

;;; Window management

(defun anders/switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key "\M-o" 'anders/switch-to-previous-buffer)
(setq frame-auto-hide-function 'delete-frame)
(setq display-buffer-alist
      '(("*shell*" (display-buffer-same-window) ())
        ("*term*" (display-buffer-same-window) ())
        (".*" (display-buffer-reuse-window
               display-buffer-same-window
               display-buffer-pop-up-frame)
         (reusable-frames . t))))
(defun anders/same-window-instead
    (orig-fun buffer alist)
  (display-buffer-same-window buffer nil))
(advice-add 'display-buffer-pop-up-window :around 'anders/same-window-instead)
(defun anders/do-select-frame (orig-fun buffer &rest args)
  (let* ((old-frame (selected-frame))
         (window (apply orig-fun buffer args))
         (frame (window-frame window)))
    (unless (eq frame old-frame)
      (select-frame-set-input-focus frame))
    (select-window window)
    window))
(advice-add 'display-buffer :around 'anders/do-select-frame)
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
(load-theme 'deeper-blue)
(show-paren-mode 1)

;;; Miscellaneous

(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(setq auto-save-file-name-transforms '((".*" "/tmp/" t)))
(setq backup-directory-alist '((".*" . "/tmp/")))
(setq dired-auto-revert-buffer t)
(setq gdb-display-io-nopopup t)
(setq recenter-positions '(bottom middle top))
(setq view-read-only t)

;;; various stuff that I just always want to have open

(when (daemonp)
  (progn
    (find-file-noselect "/etc/nixos/configuration/config/init.el")
    (find-file-noselect "/etc/nixos/configuration/private/bad-hosts.nix")))
