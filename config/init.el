(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Man-notify-method (quote pushy))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#839496"])
 '(auto-save-file-name-transforms (quote ((".*" "/tmp/" t))))
 '(backup-directory-alist (quote ((".*" . "/tmp/"))))
 '(c-basic-offset 4)
 '(c-default-style "linux")
 '(company-global-modes (quote (not shell-mode gud-mode)))
 '(compilation-always-kill t)
 '(compilation-ask-about-save nil)
 '(compilation-message-face (quote default))
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(fci-rule-color "#eee8d5")
 '(frame-auto-hide-function (quote delete-frame))
 '(global-subword-mode t)
 '(haskell-interactive-mode-scroll-to-bottom t)
 '(haskell-process-args-cabal-repl
   (quote
    ("--ghc-option=-ferror-spans" "--with-ghci=ghci-ng")))
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote cabal-repl))
 '(haskell-process-wrapper-function
   (lambda
     (argv)
     (append
      (quote
       ("fancy-cabal-repl"))
      (cdr
       (cdr
        (list
         (mapconcat
          (quote identity)
          argv " "))))
      (quote
       ("--ghc-option=-ferror-spans")))))
 '(help-window-select t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100))))
 '(hl-bg-colors
   (quote
    ("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(indent-tabs-mode nil)
 '(initial-scratch-message nil)
 '(js-indent-level 2)
 '(kill-do-not-save-duplicates t)
 '(magit-commit-show-diff nil)
 '(magit-delete-by-moving-to-trash nil)
 '(magit-diff-expansion-threshold 2.0)
 '(magit-diff-use-overlays nil)
 '(magit-revert-buffers t t)
 '(magit-use-overlays nil)
 '(menu-bar-mode nil)
 '(org-agenda-files (quote ("~/org/todo.org" "~/org/schedule.org")))
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-agenda-window-setup (quote current-window))
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
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
      "* %U %?"))))
 '(org-default-notes-file "~org/notes.org")
 '(org-enforce-todo-dependencies t)
 '(org-fast-tag-selection-single-key t)
 '(org-from-is-user-regexp nil)
 '(org-hide-leading-stars t)
 '(org-journal-dir "~/org/journal")
 '(org-log-done (quote time))
 '(org-log-into-drawer t)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-read-date-popup-calendar nil)
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t!)" "|" "DEFERRED(f!)" "CANCELLED(c!)" "DONE(d!)")
     (sequence "INVESTIGATE(i!)" "APPLY(a!)" "SENT(s!)" "IN-PROGRESS(p!)" "|" "REJECTED(r!)" "OFFER(o!)"))))
 '(package-archives
   (quote
    (("melpa" . "http://melpa.milkbox.net/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(pop-up-windows nil)
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(projectile-completion-system (quote helm))
 '(projectile-keymap-prefix (kbd "M-t"))
 '(projectile-mode-line
   (quote
    (quote
     (:eval
      (format " Projectile[%s]" default-directory)))))
 '(projectile-switch-project-action (quote projectile-vc))
 '(projectile-use-git-grep t)
 '(recenter-positions (quote (bottom middle top)))
 '(same-window-buffer-names (quote ("Calendar")))
 '(scroll-bar-mode nil)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(special-display-regexps (quote ("(.*)")))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(tramp-use-ssh-controlmaster-options nil)
 '(undo-tree-auto-save-history t)
 '(undo-tree-history-directory-alist (quote (("." . "/tmp/undo-tree"))))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c85d17")
     (60 . "#be730b")
     (80 . "#b58900")
     (100 . "#a58e00")
     (120 . "#9d9100")
     (140 . "#959300")
     (160 . "#8d9600")
     (180 . "#859900")
     (200 . "#669b32")
     (220 . "#579d4c")
     (240 . "#489e65")
     (260 . "#399f7e")
     (280 . "#2aa198")
     (300 . "#2898af")
     (320 . "#2793ba")
     (340 . "#268fc6")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(web-mode-enable-auto-quoting nil)
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 105 :family "Inconsolata"))))
 '(org-hide ((t (:foreground "black")))))

; why???
(global-set-key "\C-z" nil)

(require 'package)
(package-initialize)

(global-subword-mode)

(require 'tramp)
(add-to-list 'tramp-remote-path "/run/current-system/sw/bin")

(setq org-default-notes-file "~org/notes.org")
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; (autoload 'ghc-init "ghc" nil t)
;; (autoload 'ghc-debug "ghc" nil t)
;; (add-hook 'haskell-mode-hook 'ghc-init)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(eval-after-load "haskell-mode"
  '(progn
     (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
     (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)
     (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)))

;; these more or less work, but aren't too useful
;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;; (add-hook 'haskell-mode-hook 'haskell-process-load-file)
;; (eval-after-load "haskell-mode"
;;   '(progn
;;     (define-key haskell-mode-map (kbd "C-x C-d") nil)
;;     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
;;     (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
;;     (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
;;     (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
;;     (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
;;     (define-key haskell-mode-map (kbd "C-c M-.") nil)
;;     (define-key haskell-mode-map (kbd "C-c C-d") nil)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'undo-tree)
(global-undo-tree-mode)

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(setq dark-theme 'wheatgrass)
(setq light-theme 'adwaita)
(load-theme light-theme t)

(defun enable-dark-theme ()
  (interactive)
  (progn
    (disable-theme light-theme)
    (load-theme dark-theme t)
    (set-face-foreground 'org-hide "#000000")))
(defun enable-light-theme ()
  (interactive)
  (progn
    (disable-theme dark-theme)
    (load-theme light-theme t)
    (set-face-foreground 'org-hide "#EDEDED")))

(setq magit-last-seen-setup-instructions "1.4.0")

(require 'git)

(projectile-global-mode)

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.2)
(setq company-minimum-prefix-length 1)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'whitespace)
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)

(add-to-list 'auto-mode-alist '("\\.js$" . web-mode))
(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")))

(helm-mode)
(define-key helm-map (kbd "<tab>") 'helm-next-line)
(define-key helm-map (kbd "<backtab>") 'helm-previous-line)

(require 'helm-descbinds)
(helm-descbinds-mode)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") 'rust-format-buffer)))
(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)

(setq view-read-only t)

(require 'calfw)
(require 'calfw-org)
(require 'org-gcal)
(setq org-gcal-down-days 30)
(setq org-gcal-up-days 7)

(require 'nix-mode)
;; (require 'nixos-options)
;; (require 'helm-nixos-options)
;; (global-set-key (kbd "C-c C-S-n") 'helm-nixos-options)
;; (add-to-list 'company-backends 'company-nixos-options)

;; various stuff that I just always want to have open
(find-file-noselect "/etc/nixos/configuration/config/init.el")
(find-file-noselect "/etc/nixos/configuration/private/bad-hosts.nix")
(cfw:open-org-calendar)

(defun spawn-shell (name command)
  (pop-to-buffer (get-buffer-create name))
  (shell (current-buffer))
  (process-send-string nil command))
(spawn-shell "*sudo*" "exec sudo -i\n")

(setenv "MANWIDTH" "72")
;; (man "configuration.nix")

(require 'real-auto-save)

(require 'racer)
(setq racer-cmd "racer")
(setq racer-rust-src-path "/not-used")
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)

(shackle-mode)
(setq shackle-rules '(("\\*input/output of.*\\*" :regexp t :ignore t)))

(setq select-enable-clipboard nil)

(setq gdb-display-io-nopopup t)

(defun skip-set-window-dedicated-p (orig-fun &rest args) nil)
(advice-add 'set-window-dedicated-p :around #'skip-set-window-dedicated-p)
