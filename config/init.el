;;; bootstrap use-package

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
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

(use-package company
  :bind (:map company-active-map
              ("RET" . nil)
              ("M-1" . company-complete-selection))
  :init
  (setq company-global-modes '(not gud-mode))
  (setq company-dabbrev-downcase nil)
  :config
  (global-company-mode))

(use-package compile
  :init
  (setq compilation-always-kill t)
  (setq compilation-ask-about-save nil)
  :config
  ;; Do to my particular windowing setup (only window-manager-level
  ;; splits), I want a drastically simpler version of
  ;; compilation-goto-locus. It's not really possible to do this from
  ;; the outside, so just override the function.
  (defun compilation-goto-locus (msg mk end-mk)
    "Jump to an error corresponding to MSG at MK.
All arguments are markers.  If END-MK is non-nil, mark is set there
and overlay is highlighted between MK and END-MK."

    (display-buffer (marker-buffer msg) '(nil (allow-no-window . t)))
    (with-current-buffer (marker-buffer msg)
      (goto-char (marker-position msg))
      (and w (compilation-set-window w msg)))

    (display-buffer (marker-buffer mk))

    (with-current-buffer (marker-buffer mk)
      (unless (eq (goto-char mk) (point))
        ;; If narrowing gets in the way of going to the right place, widen.
        (widen)
        (if next-error-move-function
            (funcall next-error-move-function msg mk)
          (goto-char mk)))
      (if end-mk
          (push-mark end-mk t)
        (if mark-active (setq mark-active)))
      ;; If hideshow got in the way of
      ;; seeing the right place, open permanently.
      (dolist (ov (overlays-at (point)))
        (when (eq 'hs (overlay-get ov 'invisible))
          (delete-overlay ov)
          (goto-char mk))))))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flymake)

(use-package god-mode
  :bind (("<escape>" . god-local-mode)
         :map god-local-mode-map
         ("i" . god-local-mode)
         ("." . repeat)
         :map isearch-mode-map
         ("<escape>" . god-mode-isearch-activate)
         :map god-mode-isearch-map
         ("<escape>" . god-mode-isearch-disable))
  :init
  (setq god-mod-alist
   '((nil . "C-")
     ("t" . "M-")
     ("T" . "C-M-")))
  (defun anders/update-cursor ()
    (setq cursor-type (if god-local-mode 'box 'bar)))
  :hook
  ((god-mode-enabled god-mode-disabled) . anders/update-cursor)
  :config
  (require 'god-mode-isearch)

  ;; bugfix for https://github.com/chrisdone/god-mode/issues/110
  (defun god-mode-upper-p (char)
    "Is the given char upper case?"
    (and (>= char ?A)
         (<= char ?Z)
         (/= char ?T))))

(use-package ivy
  :config
  (ivy-mode 1))

;; Magit is awesome.
(use-package magit
  :init
  (setq magit-commit-show-diff nil)
  (setq magit-delete-by-moving-to-trash nil)
  (setq magit-diff-expansion-threshold 2.0)
  (setq magit-diff-use-overlays nil)
  (setq magit-no-confirm
        '(abort-rebase
          delete-unmerged-branch
          drop-stashes
          stage-all-changes
          unstage-all-changes))
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
  :hook
  ((org-mode) . real-auto-save-mode)
  ((org-mode) . auto-revert-mode)
  ((org-capture-after-finalize) . delete-frame)
  :init
  ;; Utility function so that I don't have to fix the set of org files
  ;; statically.
  (defun anders/dynamic-org-files (directory)
    (f-entries directory
               (lambda (filename) (s-ends-with-p ".org" filename))
               t))
  (defun anders/dynamic-all-org-files ()
    (anders/dynamic-org-files "~/projects"))

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
  (defun anders/ignore-project (project)
    (string-match-p "/nix/store" project))
  (setq projectile-keymap-prefix (kbd "M-t"))
  (setq projectile-mode-line
        ''(:eval (format "Projectile[%s]" default-directory)))
  (setq projectile-switch-project-action 'anders/vc-or-dired)
  (setq projectile-completion-system 'ivy)
  (setq projectile-ignored-project-function 'anders/ignore-project)
  :config
  (projectile-global-mode)
  (ad-deactivate 'compilation-find-file))

(use-package projectile-ripgrep
  :bind ((:map projectile-command-map
               (("s g" . projectile-ripgrep)))))

(use-package real-auto-save
  :init
  (setq real-auto-save-interval 30))

(use-package subword
  :config
  (global-subword-mode))

(use-package term
  :bind (("M-RET" . anders/get-term)
         :map term-mode-map
         (("M-i" . anders/term-toggle-mode))
         :map term-raw-map
         (("M-i" . anders/term-toggle-mode)
          ("C-y" . term-paste)))
  :init
  (defun anders/new-term ()
    (interactive)
    (term "bash")
    (rename-buffer "shell" t))
  (defun anders/get-term ()
    (interactive)
    (if (get-buffer "shell")
        (switch-to-buffer "shell")
      (anders/new-term)))
  (defun anders/expose-global-binding-in-term (binding)
    (define-key term-raw-map binding
      (lookup-key (current-global-map) binding)))
  (defun anders/term-toggle-mode ()
    "Toggles term between line mode and char mode"
    (interactive)
    (if (term-in-line-mode)
        (term-char-mode)
      (term-line-mode)))
  :config
  (anders/expose-global-binding-in-term (kbd "M-x"))
  (anders/expose-global-binding-in-term (kbd "C-x"))
  (anders/expose-global-binding-in-term (kbd "C-c a")))


(use-package tramp
  :init
  (setq tramp-default-method "ssh")
  (setq tramp-use-ssh-controlmaster-options nil)
  :config
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))

(use-package undo-tree
  :init
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "/tmp/undo-tree")))
  :config
  (global-undo-tree-mode))

(use-package whitespace
  :bind ("C-x C-s" . anders/save-with-delete-trailing-whitespace)
  :hook ((prog-mode . whitespace-mode))
  :init
  (setq-default indent-tabs-mode nil)
  (setq whitespace-style '(face tabs))
  (defun anders/save-with-delete-trailing-whitespace ()
    (interactive)
    (delete-trailing-whitespace)
    (save-buffer)))

;;; Programming-language specific packages

(use-package cargo)

(use-package elm-mode
  :init
  (setq elm-sort-imports-on-save t)
  (setq elm-format-on-save t))

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
  :hook ((haskell-mode . anders/intero-mode-unless-global-project)))

(use-package lua-mode)

(use-package markdown-mode
  :mode
  (("\\.markdown\\'" . markdown-mode)
   ("\\.md\\'"       . markdown-mode)))

(use-package nix-mode)

(use-package rust-mode
  :init
  (eval-after-load 'compile
    (remove-hook 'next-error-hook 'rustc-scroll-down-after-next-error)))

(use-package yaml-mode)

;;; Copy/paste

(setq kill-do-not-save-duplicates t)
(setq save-interprogram-paste-before-kill t)
(setq select-enable-clipboard nil)
(setq select-enable-primary t)

;;; Window management

;; gud mode is a bad actor
(setq gdb-display-io-nopopup t)

(setq frame-auto-hide-function 'delete-frame)
(setq display-buffer-alist
      '(("shell.*" (display-buffer-same-window) ())
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

;; Dedicated windows are evil
(advice-add 'set-window-dedicated-p :around
            (lambda (orig-fun &rest args) nil))

;;; Luddite mode

(set-scroll-bar-mode nil)
(setq tool-bar-mode nil)
(setq menu-bar-mode nil)
(setq initial-scratch-message nil)

;;; Looks

(setq-default truncate-lines t)
(set-face-attribute 'default nil :height 105)
(set-face-attribute 'default nil :family "Inconsolata")
(load-theme 'deeper-blue)
(show-paren-mode 1)

;;; Miscellaneous

(defun anders/switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key "\M-o" 'anders/switch-to-previous-buffer)

(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(setq auto-save-file-name-transforms '((".*" "/tmp/" t)))
(setq backup-directory-alist '((".*" . "/tmp/")))
(setq dired-auto-revert-buffer t)
(setq recenter-positions '(bottom middle top))
(setq uniquify-buffer-name-style 'post-forward)

;;; various stuff that I just always want to have open

(when (daemonp)
  (progn
    (find-file-noselect "/etc/nixos/configuration/config/init.el")
    (find-file-noselect "/etc/nixos/configuration/private/bad-hosts.nix")
    (man "configuration.nix")))
