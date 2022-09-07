;;;; Canadata: account-related facilities
;;;; Copyright © 2022 M. James Kalyan

(defmodule account
  (export
   (register 1)
   (registered? 1)
   (verify 2)))

;;; --------------------------------------------------------------------------
;;; API
;;; --------------------------------------------------------------------------

(defun register
  "Registers a user to the Canadata service. This will generate a login UUID (v4) for them, hash
their password, and store all given personal details in the database."
  (((tuple password surname given-names))
   (let* ((id               (make-user-id))
          (salt             (make-salt))
          ((tuple 'ok hash) (argon2:hash_with_secret password salt)))
     (db:with-connection c (db:CREDENTIALS)
       (epgsql:equery c
                      "INSERT INTO accounts (id, hash, salt, surname, given_names) VALUES ($1, $2, $3, $4, $5)"
                      (list id hash salt surname given-names))))))

;; TODO
(defun registered? (id)
  "Does this ID exist in the database?"
  'ok)

(defun verify (id password)
  "Check whether hashing the given PASSWORD with ID's salt matches the ID's stored hash."
  (let* (((tuple 'ok _ (list (tuple (tuple hash salt))))
          (db:with-connection c (db:CREDENTIALS)
            (epgsql:equery c
                           "select (hash, salt) from accounts where id = $1"
                           (list id))))
         ((tuple 'ok verified-p) (argon2:verify_with_secret password hash salt)))
    verified-p))

;;; --------------------------------------------------------------------------
;;; Helpers
;;; --------------------------------------------------------------------------

;; TODO use 4-word diceware from EFF https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt
(defun make-user-id ()
  "Return a unique but memorable user ID."
  (base64:encode (crypto:strong_rand_bytes 16)))

(defun make-salt ()
  "Make a salt for password hashing."
  ;; 2^128 bits of entropy
  (base64:encode (crypto:strong_rand_bytes 16)))
