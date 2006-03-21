;;; arorem-rhtml

;; Part of arorem - Another Ruby on Rails Emacs Mode
;; Sets up an rhtml mode
;; (C) 2006 Phil Hagelberg

(add-to-list 'auto-mode-alist '("\\.rhtml$" . arorem-rhtml))

(defconst rhtml-font-lock-keywords
  (append
   '(("<%[=]?" . font-lock-preprocessor-face)
     ("%>" . font-lock-preprocessor-face)
     ("<\\(/?[[:alnum:]][-_.:[:alnum:]]*\\)" 1 font-lock-function-name-face)
     ("[&%][[:alpha:]][-_.:[:alnum:]]*;?" . font-lock-variable-name-face))
   ruby-font-lock-keywords))

(define-derived-mode arorem-rhtml
  html-mode "RHTML"
  "Another Ruby on Rails Emacs Mode (RHTML)"
  (abbrev-mode)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((rhtml-font-lock-keywords))))

(define-key arorem-rhtml-map
  "\C-x\C-v" 'arorem-switch-view)

(provide 'arorem-rhtml)

