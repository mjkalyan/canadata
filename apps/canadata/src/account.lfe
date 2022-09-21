;;;; Canadata: account-related facilities
;;;; Copyright © 2022 M. James Kalyan

(defmodule account
  (export
   (register 3)
   (registered? 1)
   (verify 2)))

;;; --------------------------------------------------------------------------
;;; API
;;; --------------------------------------------------------------------------

(defun register (password surname given-names)
  "Registers a user to the Canadata service. This will generate a login UUID (v4) for them, hash
their password, and store all given personal details in the database."
  (let* ((username         (make-username))
         ((tuple 'ok hash) (argon2:hash password)))
    (db:with-connection c (db:CREDENTIALS)
      (epgsql:equery c
                     "INSERT INTO person (surname, given_names, username, hash) VALUES ($1, $2, $3, $4)"
                     (list surname given-names username hash)))))

;; TODO
(defun registered? (username)
  "Does this USERNAME exist in the database?"
  'ok)

(defun verify (username password)
  "Check whether hashing the given PASSWORD matches the USERNAME's stored hash."
  (let* (((tuple 'ok _ (list (tuple hash)))
          (db:with-connection c (db:CREDENTIALS)
            (epgsql:equery c
                           "select hash from person where username = $1"
                           (list username))))
         ((tuple 'ok verified-p) (argon2:verify password hash)))
    verified-p))

;;; --------------------------------------------------------------------------
;;; Helpers
;;; --------------------------------------------------------------------------

;; TODO use 4-word diceware from EFF https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt
(defun make-username ()
  "Generate a unique but memorable username."
  (let* ((num-words 4)
         (word-keys )))
  (base64:encode (crypto:strong_rand_bytes 4)))

(defun roll-n (d n)
  "Roll a D-sided die N times, returning the results as a list."
  (roll-n d n []))

(defun roll-n
  "TCO roll-n."
  ((_ 0 acc)
   acc)

  ((d n acc) (when (> n 0))
   (roll-n d (- n 1) (cons (rand:uniform d) acc))))
