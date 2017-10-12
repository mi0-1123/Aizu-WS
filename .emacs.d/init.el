;;
;; -*-emacs-lisp-*-
;;
;;  $HOME/emacs.d/init.el file
;;  Last Updated: 2017-08-29
;;

;; load path
;; Lisp ライブラリの load path に "~/lib/emacs/lisp" を追加します。
;;(setq load-path (cons (expand-file-name "~/lib/emacs/lisp")
;;                     load-path))

;; 言語環境設定(標準UTF-8)
(set-language-environment 'Japanese)
(cond ((string-match "apple-darwin"        system-configuration) (prefer-coding-system 'utf-8)))
(cond ((string-match "i386-pc-solaris2.11" system-configuration) (prefer-coding-system 'utf-8-unix)))
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setup-japanese-environment-internal)
(set-file-name-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; version    solaris    macos
;; emacs22       o         x
;; emacs23       x         o
;; emacs24       o         o

(cond ((string-match "^22" emacs-version)
  (cond ((string-match "i386-pc-solaris2.11"       system-configuration) (load "~/.emacs.d/emacs-older")))
  (cond ((string-match "x86_64-apple-darwin13.2.0" system-configuration) (load "~/.emacs.d/emacs22-mac")))
))

(cond ((string-match "^23" emacs-version)
  (cond ((string-match "apple-darwin"              system-configuration) (load "~/.emacs.d/emacs-older")))
))

(cond ((string-match "^24" emacs-version)
  (cond ((string-match "solaris2.11"               system-configuration) (load "~/.emacs.d/emacs24-sol")))
  (cond ((string-match "x86_64-apple-darwin"       system-configuration) (load "~/.emacs.d/emacs24-mac")))
))

;; 共通環境設定

;; 会津標準環境設定(ポリシー)

;; Auto save機能の抑制
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;; c-mode
(add-hook 'c-mode-hook
	  '(lambda () (set-buffer-file-coding-system 'utf-8 t)))

;; カーソルの位置が何行目か表示
(line-number-mode 1)

;; ガーベージコレクションをおこりにくくする
(setq gc-cons-threshold 200000)

;; BS (C-h)キーと DEL キーを入れかえます
(cond ((not window-system)
       (load-library "term/bobcat")))

;; モードラインに時計表示
(display-time)

;; 会津大学標準環境(後方互換性)

;; mule-19 同様に Esc-# で ispell-word が走る
(define-key esc-map "#" 'ispell-word)   ;originally "$"

;; Emacs20,22 以前との互換 - 選択範囲の色をかえない
(setq transient-mark-mode nil)

;; Emacs20,22 準互換 - markset 及びクリップボード設定
(cond
    (window-system
     (setq select-active-regions nil)
     (setq mouse-drag-copy-region t)
     (setq x-select-enable-primary t)
     (setq x-select-enable-clipboard nil)
     (global-set-key [mouse-2] 'mouse-yank-at-click)
     ;; xterm-mouse-mode
     (unless (fboundp 'track-mouse)
       (defun track-mouse (e)))
     (xterm-mouse-mode t)
     (require 'mouse)
     (require 'mwheel)
     (mouse-wheel-mode t)
    ))

;; Emacs20,22 以前との互換 - set C-l as recenter rahter than recneter-top-bottom
(global-set-key (kbd "C-l") 'recenter)

;; Emacs22 との互換設定 - 折り返し表示でのカーソル移動
(setq line-move-visual nil)

;; Emacs22 との互換設定 - ツールバーを非表示にする
(tool-bar-mode 0)

;; mail-mode にしたときに、ファイル文字コードを JIS にセットするようにします。
(add-hook 'mail-mode-hook
          (set-buffer-file-coding-system 'junet))

;; Text モードにするとき、常に auto-fill-mode にします。
;;(add-hook 'text-mode-hook
;;      '(lambda () (auto-fill-mode 1)))

;; Gnus setup
(autoload 'gnus "gnus" "Read network news." t)
(autoload 'gnus-post-news "gnuspost" "Post a new news." t)
(setq gnus-local-domain "u-aizu.ac.jp"
    gnus-local-organization "University of Aizu, Fukushima, Japan"
    gnus-nntp-server "nh1"
    gnus-use-generic-from t
    gnus-use-generic-path t
    gnus-local-timezone "+0900"
    gnus-newsgroup-ephemeral-charset 'iso-2022-jp-2
    mail-host-address "u-aizu.ac.jp"
    message-insert-canlock nil)
(setq gnus-summary-line-format "%U%R%z%I%(%N: %[%4L: %-20,20n%]%) %s\n")
;; Gnus での文字コードを JIS にセットします。
(setq gnus-newsgroup-ephemeral-charset 'iso-2022-jp-2)
(setq gnus-summary-line-format "%U%R%z%I%(%N: %[%4L: %-20,20n%]%) %s\n")

;; スクロールバーを右側に持ってくる。
(set-scroll-bar-mode 'right)
;; スクロールバーの表示を消す
(scroll-bar-mode 0)
;; メニューバーを消す
(menu-bar-mode 0)

;; スクロールマウスの設定
(global-set-key   [mouse-4] '(lambda () (interactive) (scroll-down 5)))
(global-set-key   [mouse-5] '(lambda () (interactive) (scroll-up   5)))
;;                 Shift
(global-set-key [S-mouse-4] '(lambda () (interactive) (scroll-down 1)))
(global-set-key [S-mouse-5] '(lambda () (interactive) (scroll-up   1)))
;;                 Control
(global-set-key [C-mouse-5] '(lambda () (interactive) (scroll-up   (/ (window-height) 2))))
(global-set-key [C-mouse-4] '(lambda () (interactive) (scroll-down (/ (window-height) 2))))

;; completion in minibuffer with SPC
(if (boundp 'minibuffer-local-filename-completion-map)
    (define-key minibuffer-local-filename-completion-map
      " " 'minibuffer-complete-word))
(if (boundp 'minibuffer-local-must-match-filename-map)
    (define-key minibuffer-local-must-match-filename-map
      " " 'minibuffer-complete-word))

;; テキストに色を付ける
(cond
    (window-system
        (global-font-lock-mode t)
        (setq font-lock-support-mode 'jit-lock-mode)
        (require 'font-lock)
    ))

;;
;; テキストに色を付けない
;;
;; 「テキストに色を付ける」の下から(require 'font-lock)))
;; までをコメントアウトして以下の2行のコメントを
;; はずしてください。
;;(setq font-lock-mode nil)
;;(global-font-lock-mode nil)

;; 表示色を変更する設定
;;(if window-system (progn
;;  ;; 文字の色を設定します。
;;  (add-to-list 'default-frame-alist '(foreground-color . "Black"))
;;  ;; 背景色を設定します。
;;  (add-to-list 'default-frame-alist '(background-color . "LightGray"))
;;  ;; カーソルの色を設定します。
;;  (add-to-list 'default-frame-alist '(cursor-color . "Black"))
;;  ;; マウスポインタの色を設定します。
;;  (add-to-list 'default-frame-alist '(mouse-color . "Black"))
;;  ;; モードラインの文字の色を設定します。
;;  (set-face-foreground 'modeline "White")
;;  ;; モードラインの背景色を設定します。
;;  (set-face-background 'modeline "Black")
;;))

;; color-theme sample
;;(if window-system (progn
;;    (color-theme-standard)))

;; custom file
(if (file-exists-p (expand-file-name "~/.emacs.d/options.el"))
    (load (expand-file-name "~/.emacs.d/options.el") nil t nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; スタートアップメッセージを表示させない
(setq inhibit-startup-message 1)

;; ターミナルで起動したときにメニューを表示しない
(if (eq window-system 'x)
    (menu-bar-mode 1) (menu-bar-mode 0))
(menu-bar-mode nil)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")


;; line numberの表示
(require 'linum)
(global-linum-mode 1)


;; バックアップファイルを作成させない
(setq make-backup-files nil)
(put 'upcase-region 'disabled nil)
