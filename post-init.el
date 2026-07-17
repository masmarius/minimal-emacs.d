;;; post-init.el --- post-init file -*- no-byte-compile: t; lexical-binding: t; -*-

;; lisp folder on the load-path
;(add-to-list 'load-path
;(require 'my-orgmode)
;(load "~/.emacs.d/lisp/org-capture-popup.el")

;; emacs base options
(use-package emacs
  :ensure nil
  :init
  (setq auto-revert-interval 3          ; Auto-revert
        auto-revert-remote-files nil
        auto-revert-use-notify t
        auto-revert-avoid-polling nil
        history-length 300              ; History
        savehist-autosave-interval 600
        save-place-limit 400            ; Save-place
        auto-save-default t             ; Auto-save
        auto-save-interval 300
        auto-save-timeout 30
        auto-save-visited-interval 5   ; Auto-save-visited (after 5 secs.)
        split-width-threshold 90
        split-height-threshold nil)
  (setopt line-spacing '(0.1 . 0.1))    ; Emacs => 31
  
  :config
  (global-auto-revert-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (repeat-mode 1)
  (auto-save-visited-mode 1)
  (electric-pair-mode 1)
  (show-paren-mode 1)
  (delete-selection-mode 1)
  (which-key-mode 1)
  (window-divider-mode 1)
  (pixel-scroll-precision-mode 1)
  (minibuffer-depth-indicate-mode 1)
  (fido-vertical-mode 1)              

  ;; usar ripgrep en vez de grep si esta disponible
  (if (executable-find "rg")
      (setq xref-search-program 'ripgrep grep-command "rg -nS --no-heading "
            grep-find-template "rg <C> --null -nH -e <R> <D>")
    (setq xref-search-program 'grep grep-command "grep -nH -r "
          grep-find-template
          "find -H <D> <X> -type f <F> -print0 | xargs -0 grep <C> -n --null -e <R>")))

;; theme first setup
(let ((inhibit-redisplay t))
  (mapc #'disable-theme custom-enabled-themes)   ;; Disable all active themes
  (load-theme 'modus-vivendi-tinted t))          ;; Load the built-in theme

;; Set the default font with specific size and weight
;; (set-face-attribute 'default nil
;;                    :height 130 :weight 'normal :family "DejaVu Sans Mono")

(use-package which-key
  :ensure nil
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.5)            ; Which-key tweaks
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 2)
  (which-key-max-description-length 60))

;; emacs keymaps and bindings
(use-package emacs
  :ensure nil
  :preface
  ;; Keymap definitions
  (defvar-keymap my-leader-map)         ; Leader keymap
  (defvar-keymap my-launch-map)         ; Assigned to Capslock using "keyd"
  (defvar-keymap my-buffer-map :doc "Buffers")
  (defvar-keymap my-register-map :doc "Registers")
  (defvar-keymap my-file-map :doc "Files")

  :init
  (keymap-global-unset "C-z")           ; Disable C-z
  (keymap-global-unset "<f1>")
  
  (keymap-set global-map "<menu>" my-leader-map)
  (keymap-set global-map "<Launch1>" my-launch-map) ; Capslock launches most used keybindings
  (keymap-set my-leader-map "b" my-buffer-map)
  (keymap-set my-leader-map "r" my-register-map)
  (keymap-set my-leader-map "f" my-file-map)
  
  :bind                                 ; General keys
  ("M-o"    . other-window)
  ("<f5>"   . bookmark-jump)
  ("C-<f5>" . bookmark-bmenu-list)
  ("C-<menu>"      . switch-to-buffer)
  ("<menu><SPC>"   . recentf-open)
  ("<menu><right>" . next-buffer)
  ("<menu><left>"  . previous-buffer)
  ("C-c d"         . duplicate-dwim)
  (:map global-map
        ("M-s s"  . isearch-forward))
    (:map my-leader-map
        ("<menu>" . mode-line-other-buffer)
        ("f"      . find-file)
        ("h"      . recentf-open))
    (:map my-launch-map
        ("b"      . switch-to-buffer)
        ("r"      . recentf-open))
  (:map my-buffer-map
        ("q" . bury-buffer)
        ("b" . list-buffers))
  (:map my-register-map
        ("b"     . bookmark-jump)
        ("l"     . bookmark-bmenu-list)
        ("j"     . jump-to-register)
        ("<SPC>" . point-to-register)
        ("m"     . bookmark-set))
  (:map my-file-map
        ("f" . find-file)))

;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

(use-package hippie-exp
  :ensure nil
  :init
  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-expand-dabbrev-visible
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-all-abbrevs
          try-expand-list
          try-expand-line
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol))
  :config
  (global-set-key [remap dabbrev-expand] 'hippie-expand)) ; Hippie-expand instead of Dabbrev

(use-package server
  :ensure nil
  :defer 1
  :config
  (unless (server-running-p)
    (server-start)))

(add-to-list 'load-path
             (expand-file-name "modules" user-emacs-directory))

(let ((local-file (expand-file-name "post-init-local.el"
                                    user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file nil t)))

