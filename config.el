;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Hans Villarroel"
      user-mail-address "hans.villarroel@usach.cl")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-rouge)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; (after! doom-themes
;;   (load-theme 'doom-nano-light t))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Better defaults for Emacs
(setq-default
 delete-by-moving-to-trash t                      ; delete files to trash
 window-combination-resize t                      ; take new windowspace from all other windows (not just current)
 x-stretch-cursor t)                              ; stretch cursor to the glyph width

(setq undo-limit 80000000                         ; raise undo-limit to 80mb
      evil-want-fine-undo t                       ; by default while in insert all changes are one big blob. be more granular
      auto-save-default t                         ; nobody likes to loose work, i certainly don't
      truncate-string-ellipsis "…"                ; unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; i can trust my computers ... can't i?
      ;; scroll-preserve-screen-position 'always     ; don't have `point' jump around
      scroll-margin 2)                            ; it's nice to maintain a little margin
(display-time-mode 1)                             ; enable time in the mode-line


;; Show battery percenTage
(unless (string-match-p "^power n/a" (battery))   ; on laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have
                                        ; iterate through camelcase words
(global-subword-mode 1)

;; Default window split
(setq evil-vsplit-window-right t
      evil-split-window-below t)

;; Select buffer to split
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

;; Change bindings for moving windows
(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

(defun meain/evil-delete-advice (orig-fn beg end &optional type _ &rest args)
  "make d, c, x to not write to clipboard."
  (apply orig-fn beg end type ?_ args))
(advice-add 'evil-delete :around 'meain/evil-delete-advice)
(advice-add 'evil-change :around 'meain/evil-delete-advice)

;; Better jump with gsf
(map! :after evil-easymotion
      :map evilem-map
      :desc "jump to char" "f" #'evil-avy-goto-char)


;; Scrolling with mouse
(setf mouse-wheel-scroll-amount '(3 ((shift) . 3))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t
      scroll-step 1
      scroll-conservatively 100
      disabled-command-function nil)



;; Set font depending on OS
(cond
 ((string-equal system-type "gnu/linux")
  (setq doom-font (font-spec :family "JetBrains Mono" :size 16)
        doom-big-font (font-spec :family "JetBrains Mono" :size 24)
        doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 12)
        doom-unicode-font (font-spec :family "Julia Mono")
        doom-serif-font (font-spec :family "Alegreya" :weight 'light)))
 ((string-equal system-type "darwin")
  (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16)
        doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 24)
        doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 12)
        doom-unicode-font (font-spec :family "Ubuntu Mono Font")
        doom-serif-font (font-spec :family "Iosevka Nerd Font" :weight 'light))
  )
 )

;; indent-guides
(setq highlight-indent-guides-method 'column)


;; Which-key configuraiton
(setq which-key-idle-delay 0.5) ;; i need the help, i really do
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

;; Evil configuration
(after! evil
  (setq evil-ex-substitute-global t     ; i like my s/../.. to by global by default
        evil-move-cursor-back nil       ; don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil)) ; don't put overwritten text in the kill ring


;; Org-modern configuration, makes orgmode look pretty
(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(with-eval-after-load 'org (global-org-modern-mode))
;; Minimal UI
(package-initialize)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (modus-themes-load-operandi)

;; Choose some fonts in case you don't like using the same for coding
;; (set-face-attribute 'default nil :family "Iosevka")
;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")

;; Add frame borders and window dividers
(modify-all-frames-parameters
 '((right-divider-width . 2)
   (internal-border-width . 2)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "⭠ now ─────────────────────────────────────────────────")

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star ["◉" "○" "✸" "✿" "✤" "✜" "◆" "▶"]
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((43 . "➤")
                          (45 . "–")
                          (42 . "•"))
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("STRT" :inverse-video t :inherit +org-todo-active)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel)
          ("NO"   :inverse-video t :inherit +org-todo-cancel))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-progress nil
        org-modern-priority nil
        org-modern-keyword
        '((t . t)
          ("title" . "𝙏")
          ("subtitle" . "𝙩")
          ("author" . "𝘼")
          ("email" . #("" 0 1 (display (raise -0.14))))
          ("date" . "𝘿")
          ("property" . "☸")
          ("options" . "⌥")
          ("startup" . "⏻")
          ("macro" . "𝓜")
          ("bind" . #("" 0 1 (display (raise -0.1))))
          ("bibliography" . "")
          ("print_bibliography" . #("" 0 1 (display (raise -0.1))))
          ("cite_export" . "⮭")
          ("import" . "⇤")
          ("setupfile" . "⇚")
          ("html_head" . "🅷")
          ("html" . "🅗")
          ("latex_class" . "🄻")
          ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
          ("latex_header" . "🅻")
          ("latex_header_extra" . "🅻⁺")
          ("latex" . "🅛")
          ("beamer_theme" . "🄱")
          ("beamer_color_theme" . #("🄱" 1 2 (display (raise -0.12))))
          ("beamer_font_theme" . "🄱𝐀")
          ("beamer_header" . "🅱")
          ("beamer" . "🅑")
          ("attr_latex" . "🄛")
          ("attr_html" . "🄗")
          ("attr_org" . "⒪")
          ("name" . "⁍")
          ("header" . "›")
          ("caption" . "☰")
          ("RESULTS" . "🠶")))
  (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo)))
(global-org-modern-mode)

;; Set org-roam directory
(setq org-roam-directory "~/org/")
(defadvice! doom-modeline--buffer-file-name-roam-aware-a (orig-fun)
  :around #'doom-modeline-buffer-file-name ; takes no args
  (if (s-contains-p org-roam-directory (or buffer-file-name ""))
      (replace-regexp-in-string
       "\\(?:^\\|.*/\\)\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\)[0-9]*-"
       "🢔(\\1-\\2-\\3) "
       (subst-char-in-string ?_ ?  buffer-file-name))
    (funcall orig-fun)))
;; Org-roam-ui setup
;; Websocket for local server
(use-package! websocket
  :after org-roam)
;; roam-ui configuration
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
;; Replacement for Deft
(defun org-roam-rg ()
  "Ripgrep into org-roam-directory"
  (interactive)
  (let ((default-directory org-roam-directory))
    (consult-ripgrep)))

;; Deft directory
;; Will be disabled if org-roam-rg proves to work
(setq deft-directory "~/org")

;; Disable "look" process on mac because it keeps freezing emacs
;;
(cond
 ((string-equal system-type "darwin")
 (add-hook 'org-mode-hook(lambda () ( company-mode -1)))
 (setq company-ispell-available nil)
 )
)


;; Use chatgpt shell
(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-openai-key
    (lambda ()
      (auth-source-pass-get 'secret "openai-key")))))


;; Get API Key from Mac Keychain or from .authinfo
;; If you're using .authinfo it should be like this
;; machine api.openai.com password YOURAPIKEYHERE
;; And here's how to setup gpg https://github.com/daviwil/emacs-from-scratch/blob/master/show-notes/Emacs-Tips-Pass.org
(setq chatgpt-shell-openai-key
      (auth-source-pick-first-password :host "api.openai.com"))


;; Copilot.el configuration
;; accept completion from copilot and fallback to company
;; use copilot-login if it's your first time using it
;;
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(require 'ob-chatgpt-shell)
