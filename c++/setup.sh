sudo apt install emacs
sudo apt install clang-format

cat > ~/.clang-format <<EOF
Language:        Cpp
# BasedOnStyle:  Google
AccessModifierOffset: -1
AlignAfterOpenBracket: Align
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignEscapedNewlines: Left
AlignOperands:   true
AlignTrailingComments: true
AllowAllParametersOfDeclarationOnNextLine: false
AllowShortBlocksOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: InlineOnly
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: true
BinPackArguments: false
BinPackParameters: false
BraceWrapping:   
  AfterClass:      false
  AfterControlStatement: false
  AfterEnum:       false
  AfterFunction:   false
  AfterNamespace:  false
  AfterObjCDeclaration: false
  AfterStruct:     false
  AfterUnion:      false
  AfterExternBlock: false
  BeforeCatch:     true
  BeforeElse:      true
  IndentBraces:    false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
BreakBeforeBinaryOperators: None
BreakBeforeBraces: Custom
BreakBeforeInheritanceComma: false
BreakBeforeTernaryOperators: true
BreakConstructorInitializersBeforeComma: false
BreakConstructorInitializers: AfterColon
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: true
ColumnLimit:     90
CommentPragmas:  '^ IWYU pragma:'
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: true
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
DerivePointerAlignment: false
DisableFormat:   false
ExperimentalAutoDetectBinPacking: false
FixNamespaceComments: true
ForEachMacros:   
  - foreach
  - Q_FOREACH
  - BOOST_FOREACH
IncludeBlocks:   Regroup
IncludeCategories: 
  - Regex:           '^<ext/.*\.hp?p?>'
    Priority:        2
  - Regex:           '^<.*\.hp?p?>'
    Priority:        1
  - Regex:           '^<.*'
    Priority:        2
  - Regex:           '.*'
    Priority:        3
IncludeIsMainRegex: '([-_](test|unittest))?$'
IndentCaseLabels: true
IndentPPDirectives: None
IndentWidth:     2
IndentWrappedFunctionNames: false
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
KeepEmptyLinesAtTheStartOfBlocks: false
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 1
NamespaceIndentation: All
ObjCBlockIndentWidth: 2
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: false
PenaltyBreakAssignment: 2
PenaltyBreakBeforeFirstCallParameter: 1
PenaltyBreakComment: 300
PenaltyBreakFirstLessLess: 120
PenaltyBreakString: 1000
PenaltyExcessCharacter: 1000000
PenaltyReturnTypeOnItsOwnLine: 200
PointerAlignment: Middle
ReflowComments:  false
SortIncludes:    true
SortUsingDeclarations: true
SpaceAfterCStyleCast: false
SpaceAfterTemplateKeyword: false
SpaceBeforeAssignmentOperators: true
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 2
SpacesInAngles:  false
SpacesInContainerLiterals: false
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard:        Cpp03
TabWidth:        8
UseTab:          Never
EOF

# create .emacs and add initial
cat > ~/.emacs <<EOF
;;; package --- Summary
;;; Commentary:
;;; Code:
(package-initialize)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

(package-initialize)
(package-refresh-contents)

EOF

# all package you need
cat > package-list <<EOF
(package-install 'clang-format)
(package-install 'company-c-headers)
(package-install 'company-rtags)
(package-install 'company)
(package-install 'flycheck-clang-analyzer)
(package-install 'flycheck-clang-tidy)
(package-install 'flycheck-popup-tip)
(package-install 'ggtags)
(package-install 'popup-kill-ring)
EOF

# install package
echo "y" | emacs --batch -u `whoami` --script package-list

rm package-list

# modify .emacs
cat > ~/.emacs <<EOF
;;; package --- Summary
;;; Commentary:
;;; Code:
(package-initialize)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

;; Uncomment this next line if you want line numbers on the left side
(global-linum-mode 1)


;; Sets our compilation key binding to C-c C-v
(global-set-key "\C-c\C-v" 'compile)


(setq line-number-mode t)
(setq column-number-mode t)
(display-time)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;Want electric pair mode? Uncomment the next line
;(electric-pair-mode)

;;Want to turn off show paren mode? Comment out the below line.
(show-paren-mode)


(global-set-key "\C-x\C-g" 'goto-line)

;; Automatically set compilation mode to
;; move to an error when you move the point over it
;; Dont want this behavior? commend out the next 4 lines.
(add-hook 'compilation-mode-hook
 (lambda ()
   (progn
     (next-error-follow-minor-mode))))

;;Automatically go to the first error
;;Dont want this behavior? comment out next line
(setq compilation-auto-jump-to-first-error t)


;;This prevents gdb from getting a dedicated window,
;;which is generally super annoying
(defun set-window-undedicated-p (window flag)
  "Never set window dedicated."
  flag)
(advice-add 'set-window-dedicated-p :override #'set-window-undedicated-p)


;;Autocompletion from company
(require 'company)
(require 'company-rtags)
;; This turns on autocomplete globally. Want to turn it off (why???) comment out next line.
(global-company-mode)
(add-to-list 'company-backends 'company-c-headers)

;;clang-format to format file reasonably.  Do NOT turn off!
(require 'clang-format)
(global-set-key [C-M-tab] 'clang-format-region)
(add-hook 'c-mode-common-hook
          (function (lambda ()
                    (add-hook 'write-contents-functions
                              (lambda() (progn (clang-format-buffer) nil))))))

(add-hook 'cpp-mode-common-hook
          (function (lambda ()
                      (add-hook 'write-contents-functions
                                (lambda() (progn (clang-format-buffer) nil))))))

;; Flycheck: show you whats wrong while you write
;; Dont want?  comment out next 3 lines.
;; Dont want popups with whats wrong?  comment out third line only
(require 'flycheck)
(global-flycheck-mode)
(flycheck-popup-tip-mode)


;; This does the popup menu for M-y.
;; if you dont want it, you can comment out the next 12 lines.
(require 'popup-kill-ring)
(defun drew-popup-kill-ring(&optional arg)
  (interactive "*p")
  (if  (eq last-command 'yank)
      (let ((inhibit-read-only t)
            (before (< (point) (mark t))))
        (if before
            (funcall (or yank-undo-function 'delete-region) (point) (mark t))
          (funcall (or yank-undo-function 'delete-region) (mark t) (point)))))
  (popup-kill-ring))
(global-set-key "\M-y" 'drew-popup-kill-ring)
(setq popup-kill-ring-interactive-insert t)



;;This just shows your grade.txt files in color and read only.
(defun colorize-grade-txt ()
  "Make a grade.txt file show colors, then set read only."
  (interactive)
  (if (or (string= (buffer-name) "grade.txt")
          (string-prefix-p (buffer-name) "grade.txt<"))
      (progn (let ((inhibit-read-only t))
               (ansi-color-apply-on-region (point-min) (point-max)))
             (set-buffer-modified-p nil)
             (read-only-mode t))))

(add-hook 'find-file-hook 'colorize-grade-txt)
;;company mode doesnt play well with gdb mode.  Leave this here
(add-hook 'gud-mode-hook (lambda() (company-mode 0)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ac-html py-yapf elpy s pyvenv highlight-indentation find-file-in-project verilog-mode popup-kill-ring ggtags flycheck-popup-tip flycheck-clang-tidy flycheck-clang-analyzer company-rtags company-c-headers clang-format))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide '.emacs)
;;; .emacs ends here
EOF
