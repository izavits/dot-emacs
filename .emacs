(add-to-list 'load-path "~/.emacs.d/lisp")

;; ========== Marmalade, SC and MELPA package repositories ==========
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment   "utf-8")

;; Make command key bindings work while in Greek layout as well
(define-key function-key-map [?χ]       [?x])
(define-key function-key-map [?κ]       [?k])
(define-key function-key-map [?σ]       [?s])
(define-key function-key-map [?φ]       [?f])
(define-key function-key-map [?\C-χ]    [?\C-x])
(define-key function-key-map [?\C-φ]    [?\C-f])
(define-key function-key-map [?\C-γ]    [?\C-g])
(define-key function-key-map [?\C-σ]    [?\C-s])
(define-key function-key-map [?\M-χ]    [?\M-x])
(define-key function-key-map [?\M-\C-χ] [?\M-\C-x])

;; Don't use messages that you don't read
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
;; Don't let Emacs hurt your ears
;(setq visible-bell t)
;(scroll-bar-mode 0)
(tool-bar-mode 0)
;;(menu-bar-mode 0)

;; Wrap at window edge by default
(setq-default truncate-lines nil)
;; ...and in ORG mode
(setq org-startup-truncated nil)

;; ===== Nice printing in Mac OS X
(when (require 'mac-print-mode nil t)
  (mac-print-mode 1)
  (global-set-key (kbd "M-p") 'mac-print-buffer))

;; ===== Tramp setup =====
(setq tramp-default-method "ssh")

;; ===== Use emacs ls in dired =====
;; Reduce the amount of information in dired 
;; using Emacs' ls emulation instead of ls directly
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)

;; Global Key bindings
(global-set-key [f5] 'revert-buffer)
(global-set-key [f9] 'org-html-export-to-html)
(global-set-key [f12] 'toggle-truncate-lines)

;; ===== Make all “yes or no” prompts show “y or n” instead =====
(fset 'yes-or-no-p 'y-or-n-p)

;; ===== CSS and Rainbow modes =====
(defun all-css-modes() (css-mode) (rainbow-mode)) 
;; Load both major and minor modes in one call based on file type 
(add-to-list 'auto-mode-alist '("\\.css$" . all-css-modes)) 

;; ===== org mode setup =====
;; Make windmove work in org-mode:
(add-hook 'org-metaup-final-hook 'windmove-up)
(add-hook 'org-metaleft-final-hook 'windmove-left)
(add-hook 'org-metadown-final-hook 'windmove-down)
(add-hook 'org-metaright-final-hook 'windmove-right)
;; fontify code in code blocks
(setq org-src-fontify-natively t)

;; ===== Inhibit splash screen =====
(setq inhibit-splash-screen t)

;; ===== Disable scrollbars =====
(scroll-bar-mode -1)

;; ===== Split screen horizontally in ediff-mode =====
(setq ediff-split-window-function 'split-window-horizontally)

;; ===== Show paths when visiting files with same name =====
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;; ===== Bind the euro symbol to ALT+e =====                       
(defun insert-euro ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x20ac))
(global-set-key [(meta e)] 'insert-euro)

;; ===== Do not highlight mark region =====
(setq transient-mark-mode nil)

;; disable auto save
(setq auto-save-default nil)

;; Initiate windmove mode and use shift for moving
(windmove-default-keybindings 'shift)

;; ===== Set the highlight current line minor mode =====                       
;; In every buffer, the line which contains the cursor will be fully            
;; highlighted                                                                  
;; (global-hl-line-mode 1)

;; ===== Set standard indent to 4 =====
(setq standard-indent 4)

;; Emacs normally uses both tabs and spaces to indent lines. If you             
;; prefer, all indentation can be made from spaces only. To request this,       
;; set `indent-tabs-mode' to `nil'. This is a per-buffer variable;              
;; altering the variable affects only the current buffer, but it can be         
;; disabled for all buffers.                                                    

;;                                                                              
;; Use (setq ...) to set value locally to a buffer                              
;; Use (setq-default ...) to set value globally                                 
;;                                                                              
(setq-default indent-tabs-mode nil)

;; ========== Prevent Emacs from making backup files ==========
(setq make-backup-files nil)

;; ====== mooz's js2-mode fork ======
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;; Toggle region comment via C-/
(defun toggle-region-comment ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-/") 'toggle-region-comment)

;; Highlight matching parentheses
(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;; ===== Full screen via F11 =====
(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))
(global-set-key [f11] 'toggle-fullscreen)

;; ===== Rename file and buffer =====
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; Disabel backup and autosave
(setq backup-inhibited t)
(setq auto-save-default nil)

;; ========== Set default theme ==========
;; (load-theme 'sanityinc-tomorrow-night t)
(load-theme 'solarized-light t)

; Set cursor color
(set-cursor-color "#bb5555")

;; Disable cursor blinking
(blink-cursor-mode 0)

;; ===== Enable new version of Emacs powerline
(require 'powerline)
(powerline-default-theme)

;;(setq mac-allow-anti-aliasing nil) ;;DOESN'T WORK IN EMACS 24?
;; Mac OS X needs the following to
;; display Greek with a specific font
(set-fontset-font "fontset-default"
                  'greek-iso8859-7
                  '("Ubuntu Mono" . "iso10646-1"))

(set-face-italic-p 'italic nil)
(add-to-list 'default-frame-alist
                       '(font . "Ubuntu Mono-14"))

(setq visible-bell t)                           ; No beep when reporting errors
(setq european-calendar-style 't)               ; European style calendar
(setq calendar-week-start-day 1)                ; Week starts monday
(setq ps-paper-type 'a4)                        ; Specify printing format
(setq make-backup-files nil)                    ; No backup files ~
(setq read-file-name-completion-ignore-case 't) ; Ignore case when completing file names
(setq-default indent-tabs-mode nil)             ; Use spaces instead of tabs
(setq tab-width 4)                              ; Length of tab is 4 SPC
(setq sentence-end-double-space nil)            ; Sentences end with one space
(setq truncate-partial-width-windows nil)       ; Don't truncate long lines
(setq-default indicate-empty-lines t)           ; Show empty lines
(setq next-line-add-newlines t)                 ; Add newline when at buffer end
(setq require-final-newline 't)                 ; Always newline at end of file
;;(global-linum-mode 1)                           ; Show line numbers on buffers
(show-paren-mode 1)                             ; Highlight parenthesis pairs
(setq show-paren-style 'parenthesis)            ; ditto
(setq blink-matching-paren-distance nil)        ; Blinking parenthesis
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
