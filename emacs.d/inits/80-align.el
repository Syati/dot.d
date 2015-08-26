(add-to-list 'align-rules-list
             '(camma-assignment
               (regexp . ",\\( *\\)")
               (repeat . t)              ; 複数回適用を有効に
               (modes  . '(rst-mode))))

