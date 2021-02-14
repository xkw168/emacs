;;; package --- Summary
;;; Commentary:
;;; Code:

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(require 'package)
(require 'use-package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

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
   '(auto-complete popup-complete go-mode loc-changes gradle-mode load-relative clang-format markdown-mode rainbow-delimiters sml-mode elpy)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; enable the rainbow-delimiters-mode for most programming mode
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; bind a keymap to the comment command (which can also used to uncomment)
(global-set-key (kbd "C-x /") 'comment-line)
(global-set-key (kbd "C-x a") 'align-regexp)

;; configuration for Java development (start)

(use-package elquery)
;; enable the coverage report for Java test in emacs
(add-to-list 'load-path "~/.emacs.d/dcoverage/")
(use-package dcoverage)

;; enable gradle-mode
(add-to-list 'auto-mode-alist '("\\.gradle\\'" . gradle-mode))
;; configuration for Java development (end)

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
(global-font-lock-mode 1)

(add-to-list 'auto-mode-alist '("\\.lex\\'" . sml-lex-mode))
(add-to-list 'auto-mode-alist '("\\.yacc\\'" . sml-yacc-mode))
(add-to-list 'auto-mode-alist '("\\.cm\\'" . sml-cm-mode))
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

