;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super)
(w32-register-hot-key [M-tab])
(w32-register-hot-key [s-])
(setq w32-enable-caps-lock nil)

(global-set-key (kbd "<capslock>") ctl-x-map) ; make capslock key behave like C-x
(define-key key-translation-map (kbd "ESC") (kbd "C-g")) ; easier cancel with one ESC
(global-set-key [remap dabbrev-expand] 'hippie-expand) ; replace dabbrev-expand with hippie-expand

(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode))

(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode))

(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode))

(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode))

;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)
(setq auto-save-visited-interval 5)   ; Save after 5 seconds if inactivity
(auto-save-visited-mode 1)

(use-package vertico
  :ensure t
  :config
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless flex basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)
;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))
;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)
;; Dired buffers: Automatically hide file details (permissions, size,
;; modification date, etc.) and all the files in the `dired-omit-files' regular
;; expression for a cleaner display.
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
;; Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"))
(add-hook 'dired-mode-hook #'dired-omit-mode)
;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)
;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)

(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode))

(use-package emacs
  :ensure nil
  :bind
  (("M-o" . other-window)
   ("M-j" . duplicate-dwim)
   ("M-g r" . recentf)
   ("M-s g" . grep)
   ("s-k" . kill-current-buffer)
   ("s-b" . switch-to-buffer)
   ("C-x ;" . comment-line)
   ("M-s f" . find-name-dired)
   ("C-x C-b" . ibuffer)
   ("C-x p l". project-list-buffers)
   ("C-x 5 l"  . select-frame-by-name)
   ("C-x 5 s"  . set-frame-name)
   ("RET" . newline-and-indent)

   ("s-h c" . howm-create)
   ("s-h e" . howm-remember)

   ("C-z" . nil)
   ("C-x C-z" . nil)
   ("C-x C-k RET" . nil)))

(use-package server
  :ensure nil
  :commands server-start
  :hook
  (after-init . server-start))

(minimal-emacs-load-user-init "local.el")
