;;; package --- Summary
;;; Commentary:
;;; Code:
;;; useful links:
;;; https://zhuanlan.zhihu.com/p/343924066

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))

;; if "use-package" is not installed, install it and enable it
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)
    (eval-when-compile (require 'use-package)))

(package-initialize)

;; Uncomment this next line if you want line numbers on the left side
(global-linum-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dcoverage-moderate-covered-report-color "dark orange")
 '(dcoverage-pooly-covered-report-color "red")
 '(dcoverage-well-covered-report-color "green")
 '(package-selected-packages
   '(applescript-mode dumb-jump smartparens mips-mode flycheck company-fuzzy company-shell company-go company auto-complete popup-complete go-mode loc-changes gradle-mode load-relative clang-format markdown-mode rainbow-delimiters sml-mode elpy)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; enable the rainbow-delimiters-mode for most programming mode
(use-package rainbow-delimiters
    :config
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
;; enable smart parens
(use-package smartparens
    :config
    (add-hook 'prog-mode-hook 'smartparens-mode))

(use-package dumb-jump
  ;; Attempts to jump to the definition for the thing under point
  :bind (("C-M-g" . xref-find-definitions)
	 ;; jumps back to where you were when you jumped
         ("C-M-p" . xref-pop-marker-stack)
	 ;; just like find-definitions but only show tooltip, not jump
           ("C-M-q" . dumb-jump-quick-look)))

;; bind a keymap to the comment command (which can also used to uncomment)
(global-set-key (kbd "C-x /") 'comment-line)
(global-set-key (kbd "C-x a") 'align-regexp)
(global-set-key (kbd "C-x i") 'indent-region)
;; always show parentheses matching color
(show-paren-mode 1)

;; enable company-mode in all buffers (company = complete anything)
(add-hook 'after-init-hook 'global-company-mode)
;; enable flycheck
(add-hook 'after-init-hook 'global-flycheck-mode)
;; add filepath completion
(eval-after-load 'company
    '(push 'company-files company-backends))

(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.applescript\\'" . applescript-mode))
;; configuration for Java development (start)

(use-package elquery)
;; enable the coverage report for Java test in emacs
(add-to-list 'load-path "~/.emacs.d/dcoverage/")
(use-package dcoverage)

;; enable gradle-mode
(add-to-list 'auto-mode-alist '("\\.gradle\\'" . gradle-mode))
;; configuration for Java development (end)

(add-to-list 'auto-mode-alist '("\\.\\(s\\|assm\\)\\'" . mips-mode))

;; configuration for sml-mode (start)

(autoload 'sml-mode "sml-mode" "Major mode for editing SML." t)
(autoload 'run-sml "sml-proc" "Run an inferior SML process." t)
;; make sml-mode automatically for .sml/.sig file
(add-to-list 'auto-mode-alist '("\\.\\(sml\\|sig\\)\\'" . sml-mode))

(defun my-sml-mode-hook () "Local defaults for SML mode"
       (setq sml-indent-level 2)        ; conserve on horizontal space
       (setq words-include-escape t)    ; \ loses word break status
       (setq indent-tabs-mode nil))     ; never ever indent with tabs

(add-hook 'sml-mode-hook 'my-sml-mode-hook)
(add-hook 'sml-mode-hook 'turn-on-font-lock)

(defun my-sml-mode-before-save-hook ()
  (when (eq major-mode 'sml-mode)
    (delete-trailing-whitespace)))

(add-hook 'before-save-hook 'my-sml-mode-before-save-hook)

(global-font-lock-mode 1)

(add-to-list 'auto-mode-alist '("\\.lex\\'" . sml-lex-mode))
(add-to-list 'auto-mode-alist '("\\.yacc\\'" . sml-yacc-mode))
(add-to-list 'auto-mode-alist '("\\.cm\\'" . sml-cm-mode))

(define-derived-mode tiger-mode
  text-mode "Tiger"
  "Major mode for tiger (a simple language made for compiler learning)."
  (setq-local comment-start "/*")
  (setq-local comment-start-skip "/\\*+[ \t]*")
  (setq-local comment-end "*/")
  (setq-local comment-end-skip "[ \t]*\\*+/")
  )

(add-to-list 'auto-mode-alist '("\\.tig\\'" . tiger-mode))

;; configuration for sml-mode (end)

;; configuration for go-mode (start)

(add-hook 'go-mode-hook
          (lambda ()
	    ;; run gofmt before save
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)
	    ))

;; configuration for go-mode (end)

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  ;; enable mouse will disable mouse wheel scroll, this is a workaround
  (global-set-key [mouse-4] 'scroll-down-line)
  (global-set-key [mouse-5] 'scroll-up-line)
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

;; copy content in emacs to clipboard
(defun pbcopy ()
  (interactive)
  (call-process-region (point) (mark) "pbcopy")
  (setq deactivate-mark t))
(global-set-key (kbd "C-c c") 'pbcopy)
