
;;; My .emacs project

;; by Phil Hagelberg
;; Much thanks to RMS and emacswiki.org

;; Note: this relies on files found in my .emacs.d:
;; http://github.com/technomancy/dotfiles

;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; "What you want is probably already in Emacs. If you don't use Emacs,
;; start. If do use Emacs, use it more. If you *still* can't do what you
;; want to do, you probably shouldn't do it."
;; -Shawn Betts, Ratpoison FAQ

;; I think of emacs as Shkembe Chorba. As one Bulgarian saying goes:
;; 'Shkembe chorba is best when it's hot, peppery and someone praises it'.
;; -http://programming.reddit.com/info/uw44/comments/cuze4

;; Lisp dialects [...] are wonderful provided you don't mind spending
;; 20% of your time rejoicing in the beauty that is a dynamic language
;; with uniform syntax and a real macro system.
;; - http://ratpoison.nongnu.org/inspiration.html

;;; On with the show:

(toggle-debug-on-error)

;;; Fix for a bug in CVS Emacs 2 April 08; remove when fixed upstream:
(require 'cl)
(defun handle-shift-selection (&rest args))

;;;
;;; server singleton
;;;

(unless (string-equal "root" (getenv "USER"))
  (when (and (> emacs-major-version 22)
             (or (not (boundp 'server-process))
                 (not (eq (process-status server-process)
                          'listen))))
    (server-start)))

;;;
;;; load-path, autoloads, and requires
;;;

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/jabber")
(add-to-list 'load-path "~/.emacs.d/nxml")
(add-to-list 'load-path "~/.emacs.d/nxml/nxml-mode-20041004")

;; Regenerate the autoload file if it doesn't exist or it's too
;; old. (2 weeks or so)

(let ((autoload-file "~/.emacs.d/loaddefs.el"))
  (if (or (not (file-exists-p autoload-file))
          (< (+ (car (nth 5 (file-attributes autoload-file))) 20)
             (car (current-time))))
      (let ((generated-autoload-file autoload-file))
        (message "Updating autoloads...")
        (update-directory-autoloads "~/.emacs.d/")))
  (load autoload-file))

(autoload 'nxhtml-mode "nxml/autostart" "" t)
(autoload 'nxml-mode "nxml/autostart" "" t)

(autoload 'w3m "w3m-load" "" t)
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(autoload 'whitespace-mode "whitespace" "Toggle whitespace visualization." t)
(autoload 'tail-file "tail" "Tail a file." t)
(autoload 'lisppaste-paste-region "lisppaste" "" t)
(autoload 'top "top-mode" "" t)
(autoload 'jabber-connect "jabber" "" t)
(autoload 'cheat "cheat" "" t)
(autoload 'gitsum "gitsum" "" t)
(autoload 'vivid-chalk "vivid-chalk" "" t)

(require 'cl)
(require 'saveplace)
(require 'toggle)
(require 'compile)
(require 'which-func)
(require 'cc-defs)
(require 'project-local-variables)
(require 'find-file-in-project)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
(require 'css-mode)
(require 'idle-highlight)

(eval-after-load 'vc-annotate
  '(progn
     (require 'log-view)
     (define-key log-view-mode-map (kbd "RET") 'log-view-find-revision)
     (define-key vc-annotate-mode-map (kbd "RET")
       'vc-annotate-find-revision-at-line)))

(ignore-errors
  (load "elpa/package.el")
  (package-initialize))

;;
;; My support files and configurations
;;

(require 'my-eshell)
(require 'my-bindings)
(require 'my-defuns)
(require 'my-registers)
(require 'my-misc)
(require 'my-hook-setup)
(require 'my-lisp)

(eval-after-load 'ruby-mode '(require 'my-ruby))
(eval-after-load 'javascript-mode '(require 'my-js))
(eval-after-load 'jabber '(load "my-jabber"))
(eval-after-load 'rcirc '(load "my-rcirc"))

;; Well, these autoloads have to get invoked somehow.
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . nxhtml-mode))
(add-to-list 'auto-mode-alist '("\\.rhtml$" . nxhtml-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(setq system-specific-config (concat "~/.emacs.d/" system-name ".el"))

(if (file-exists-p system-specific-config)
    (load system-specific-config))

;;;
;;;  Cheat Sheet
;;;

;;; General
;; M-z zap to char
;; C-u C-SPC jump to previous edit
;; M-! insert output of shell command
;; M-| replace region with shell output
;; M-x thumbs
;; M-x follow-mode
;; C-u C-SPC jump to mark ring

;;; Custom bindings
;; C-c \ align-regexp
;; C-c r revert buffer
;; C-x M-k kill buffer and window
;; C-c d toggle-dedicated-window
;; C-c p message point

;;; Rectangles
;; C-x r k Rectangle kill
;; C-x r y Rectangle yank
;; C-x r c Rectangle clear (replace with space)
;; C-x r o Insert space rectangle
;; C-x r t Replace rectangle with string

;;; Ruby
;; M-C-p, M-C-n back and forward blocks
;; C-c C-s irb when in ruby-mode
;; C-c C-r Send region to inf-ruby
;; C-c M-r Send region to inf-ruby and switch to buffer
;; C-c C-l Load file in ruby
;; C-c C-x Send definition

;;; Display
;; C-u N C-x $ only display lines with less than N spaces of indentation
;; C-x $ disable above
;; C-x n n narrow visibility of buffer to region
;; C-x n w widen to full buffer

;;; Dired
;; mark with 'm', press 'Q' for multi-file find/replace
;; C-j launch dired when ido-mode is enabled

;;; Gnus Namazu
;; G G gnus keyword search
;; G T show context in keyword search

;; list-colors-display

;;; VC
;; C-x v g - blame (V to toggle committer data)
;; C-x v d - dired (v t to show all files)
;; C-x v = - diff (C-u to specify revision)
;; C-x v ~ - visit specific revision
;; C-x v l - log
;; C-x v d - vc-status

;;; Eshell
;; piping: ifconfig > #<buffer interfaces>

;; Well, we already have `C-x r w R' (window-configuration-to-register)
;; and `C-x r f R' (frame-configuration-to-register) for saving window
;; configurations, and `C-x r j R' for restoring them.

;; Profiling: time emacs -e save-buffers-kill-terminal

;;;
;;; TODO:
;;;

;; nxhtml-mode
;; - set up launchpad
;; - load into ELPA
;; - bugfix: apply ruby-mode to chunks on first load

;; finish documenting ruby-mode.el
;; follow Stefan's advice wrt filesets in log-view
;; submit patched rcirc completion
;; submit test runner using compile to inf-ruby.el

;; unify statuses in twitter and jabber

;; start using ditz
;; - move issue db to ~/.bugs; allow it to be autoconfigured

;; Make my face customizations stick around with other color themes.

;; Look into adding zeroconf-chat to jabber.el

;;; Minor

;; defadvice find-file-at-point to look for line numbers (zss setup-aliases does this)
;; fix ruby-get-old-input to not care about what the prompt looks like

;;; Long-term:

;; figure out how to get nnml under version control w/o merge conflicts

;; do something about getting a better ruby highlighter:
;; http://rubyforge.org/projects/ruby-tp-dw-gram/
;; http://cedet.cvs.sourceforge.net/cedet/cedet/contrib/

;; make an emacs peepcode