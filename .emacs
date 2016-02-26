(package-initialize)

(add-to-list 'display-buffer-alist '("*shell*" display-buffer-same-window))

;; M-x toggle-debug-on-error
;; (setq debug-on-message "Not a nREPL dict object")

;; (profiler-start)
;; (profiler-stop)
;; (profiler-report)

"--------THEME STUFF--------"
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;(load-theme 'ample)
;;(load-theme 'ample-zen t)
(load-theme 'darktooth t)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
  (package-initialize))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

"-------ORG-MODE STUFF-------"

(unless package-archive-contents    ;; Refresh the packages descriptions
  (package-refresh-contents))
(setq package-load-list '(all))     ;; List of packages to load
(unless (package-installed-p 'org)  ;; Make sure the Org package is
  (package-install 'org))           ;; installed, install it if not

(setq org-todo-keywords
       '((sequence "TODO" "DO ASAP" "|" "DONE" "SCHEDULED")))

(setenv "PATH" (concat (getenv "PATH") ":/Users/pairuser/bin"))
(setq exec-path (append exec-path '("/Users/pairuser/bin")))

(menu-bar-mode -1)
(electric-pair-mode t)
(scroll-bar-mode -1)
(show-paren-mode 1)
(setq make-backup-files nil)
(setq backup-by-copying t)
(setq delete-auto-save-files t)
(setq delete-old-versions t)

(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)

(setq visible-bell nil)
(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(blink-cursor-mode 1)
(menu-bar-mode -1)
(set-fill-column '80)
(setq minibuffer-max-depth nil)
(setq display-time-day-and-date t)
(setq display-time-mail-string "")
(setq display-time-default-load-average nil)
(display-time)

(setq calendar-standard-time-zone-name "MST")
(setq calendar-location-name "Phoenix, AZ")
(setq calendar-latitude 34.65)
(setq calendar-longitude -112.43)
(setq calendar-week-start-day 1)
(smart-mode-line-enable)

(require 'ido)
(ido-mode t)

(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setq browse-url-browser-function 'browse-url-default-browser)

(setq search-highlight t)
(setq query-replace-highlight t)

(setq next-line-add-newline t)
(setq require-final-newline nil)
(setq transient-mark-mode t)
(setq select-enable-clipboard t)
(setq max-specpdl-size 15000)
(setq max-lisp-eval-depth 12000)
(setq-default case-fold-search t)
(set-frame-parameter (selected-frame) 'alpha 100)
(mouse-avoidance-mode 'cat-and-mouse)
(abbrev-mode t)
(icomplete-mode t)
(setq org-directory "/Users/pairuser/.org/")

(defun perfect-track-directory (text)
  (if (string-match "\\w*Working directory is ||\\([^|]+\\)||" text)
      (cd (substring text (match-beginning 1) (match-end 1)))))

;; (setq shell-mode-hook 'brant-shell-setup) 

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on nil)

(setq process-coding-system-alist
      (cons '("bash" . undecided-unix) process-coding-system-alist))

(setq exec-path (cons "/bin" exec-path))

(setenv "PATH" (concat "/bin:" "/usr/bin:" "/usr/sbin:" "/usr/local/bin:"
		       (getenv "PATH")))

(setq shell-filename "bash")
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)

(defun brant-clear()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (eshell-send-input))

(defun brant-clear-region ()
  (interactive)
  (delete-region (point-min) (point-max))
  (comint-send-input))

"-------KEY BINDINGS-------"

(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)
(global-set-key (kbd "<f11>") 'linum-mode)
(global-set-key (kbd "<f12>") 'revert-buffer)
(global-set-key (kbd "<f13>") 'eval-buffer)
(global-set-key (kbd "<kp-decimal>") 'comint-previous-input)
(global-set-key (kbd "<kp-enter>") 'comint-next-input)
(global-set-key (kbd "<kp-delete>") 'brant-clear-region)
(global-set-key (kbd "C-c <deletechar>") 'pairuser-cider-reple-clear-output-and-buffer)

(global-set-key (kbd "C-c p") 'paredit-mode)
(global-set-key (kbd "C-c s") 'shell)
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c v") 'brant-clear-region)

"------SHELL CONFIG STUFF----------"

(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

"------CLEAR COMMAND-------"
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "12Jan2002 - sailor, shell mode customizations."
  (setq comint-input-sender 'n-shell-simple-send)
  )

(defun n-shell-simple-send (proc command)
  "17Jan02 - sailor. Various commands pre-processing before sending to shell."
  (cond
   ;; Checking for clear command and execute it.
   ((string-match "^[ \t]*clear[ \t]*$" command)
    (comint-send-string proc "\n")
    (erase-buffer)
    )
   ;; Checking for man command and execute it.
   ((string-match "^[ \t]*man[ \t]*" command)
    (comint-send-string proc "\n")
    (setq command (replace-regexp-in-string "^[ \t]*man[ \t]*" "" command))
    (setq command (replace-regexp-in-string "[ \t]+$" "" command))
    ;;(message (format "command %s command" command))
    (funcall 'man command)
    )
   ;; Send other commands to the default handler.
   (t (comint-simple-send proc command))
   )
  )

"--------GROOVY MODE------"
;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

"-------CLOJURE CIDER LEIN STUFF-------"
(rainbow-delimiters-mode 1)
(require 'cider)

(add-hook 'cider-mode-hook #'eldoc-mode)

(add-hook 'cider-repl-mode-hook #'paredit-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook #'auto-complete-mode)
;; (add-hook 'clj-mode-hook #'cider-mode)

(add-hook 'clj-mode-hook #'paredit-mode)
(add-hook 'clj-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clj-mode-hook #'auto-complete-mode)
(add-hook 'clj-mode-hook #'cider-mode)
(add-hook 'clj-mode-hook #'clojure-mode)

(add-hook 'emacs-lisp-mode-hook #'paredit-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'auto-complete-mode)

(require 'paredit-everywhere)
(paredit-everywhere-mode 1)
(setq cider-show-error-buffer nil)

(defun pairuser-cider-reple-clear-output-and-buffer ()
  (interactive)
  (cider-repl-clear-output)
  (cider-repl-clear-buffer))

(global-set-key (kbd "C-c j") 'cider-jack-in)
(global-set-key (kbd "C-c r") 'cider-restart)
(global-set-key (kbd "C-c C-l") 'cider-load-file)

(require 'ac-cider)

(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
;; (add-hook 'cider-repl-mode-hook 'ac-flyspell-workaround)

(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)

(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

(define-key paredit-mode-map (kbd "[") 'paredit-open-round)
(define-key paredit-mode-map (kbd "]") 'paredit-close-round)
(define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-round)
(define-key paredit-mode-map (kbd "(") 'paredit-open-square)
(define-key paredit-mode-map (kbd ")") 'paredit-close-square)



(desktop-save-mode 1)
(setq desktop-path '("/Users/pairuser/.emacs.d/"))
(setq desktop-save 'ask-if-new)



(tool-bar-mode -1)



(load-file "/Users/pairuser/.emacs_macros")
(global-set-key (kbd "C-c ;") 'semi-colonizer)
(global-set-key (kbd "C-c ,") 'comaizer)


;; (require 'clj-refactor)
;; (defun my-clojure-mode-hook ()
;;     (clj-refactor-mode 1)
;;     (yas-minor-mode 1) ; for adding require/use/import statements
;;     ;; This choice of keybinding leaves cider-macroexpand-1 unbound
;;     (cljr-add-keybindings-with-prefix "C-c C-m"))

;; (add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("52f03628824e6f87d32487593aaa707021e9af2ad00cd8009416dca5865b825a" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'erase-buffer 'disabled nil)
