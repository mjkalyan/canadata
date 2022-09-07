(defmodule canadata-app
  (behaviour application)
  ;; app implementation
  (export
   (start 2)
   (stop 0)))

;;; --------------------------
;;; application implementation
;;; --------------------------

(defun start (_type _args)
  (logger:set_application_level 'canadata 'all)
  (logger:info "Starting canadata application ...")
  (canadata-sup:start_link))

(defun stop ()
  (canadata-sup:stop)
  'ok)
