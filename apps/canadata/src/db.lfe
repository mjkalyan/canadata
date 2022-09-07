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
CREDENTIALS is a map with the necessary credentials to establish the connection. See epgsql:connect."
  ((cons connection (cons credentials body))
   `(let* (((tuple 'ok ,connection) (epgsql:connect ,credentials))
           (retval (progn ,@body)))
     (epgsql:close ,connection)
     retval)))
