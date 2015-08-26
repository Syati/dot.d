(require 'auth-source) ;; or nothing if already in the load-path

(let (credentials)
  ;; only required if your auth file is not already in the list of auth-sources
  (add-to-list 'auth-sources "~/.netrc")
  (setq credentials (auth-source-user-and-password "myblog"))
  (setq org2blog/wp-blog-alist
        `(("my-blog"
           :url "http://syati.info/xmlrpc.php"
           :username ,(car credentials)))))
           :password ,(cadr credentials)))))

