(defmodule db
  (export-macro with-connection
                CREDENTIALS))

;; TODO Host the DB on Digital Ocean or something
;; TODO Use a function to securely retrieve the password
(defmacro CREDENTIALS ()
  "The credentials map necessary to connect to the database."
  `(map 'host "localhost" 'username "james" 'password "test" 'database "testdb"))

(defmacro with-connection
  "Execute BODY with a database CONNECTION, then close the connection.
CREDENTIALS is a map with the credentials needed to establish the connection. See epgsql:connect."
  ((cons connection (cons credentials body))
   `(let* (((tuple 'ok ,connection) (epgsql:connect ,credentials))
           (retval (progn ,@body)))
     (epgsql:close ,connection)
     retval)))

;;; --------------------------------------------------------------------------
;;; Tables TODO refine schema
;;; --------------------------------------------------------------------------

;; person
;; Tracks the name and account details for a Canadata user
;; ---------------------------------------------------------------------------
;; create table person (
;;   id serial primary key,
;;   surname varchar(40),
;;   given_names varchar(100),
;;   username varchar(40),
;;   hash varchar
;; );

;; address
;; Zero or more addresses associated with a denizen
;; ---------------------------------------------------------------------------
;; create table address (
;;   id serial primary key,
;;   street varchar(100),
;;   number int,
;;   postal_code varchar(6),
;;   owner_id int,
;;   constraint fk_denizen foreign key(owner_id) references denizen(id)
;; );

;; cra_data
;; Everything the CRA normally provides you: NOAs, contribution limits, filed tax forms, etc.
;; TODO
