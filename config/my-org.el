(defun my-has-subtask ()
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (save-excursion
      (outline-back-to-heading t)
      (forward-line 1)
      (and (< (point) subtree-end)
           (re-search-forward "^*+ TODO" subtree-end t)))))

(defun my-is-preempted-by-sibling ()
  (let ((boh (save-excursion (outline-back-to-heading t) (point))))
    (save-excursion
      (condition-case nil
          (progn
            (outline-up-heading 1 t)
            (forward-line 1)
            (re-search-forward "^\*+ TODO" boh t))
        (error nil)))))

(defun my-next-task-skip-function ()
  "Skip everything but the first leaf TODO in a tree"
  (let ((subtree-end
         (save-excursion (org-end-of-subtree t)))
        (next-headline
         (save-excursion (or (outline-next-heading) (point-max)))))
    (cond
     ((my-is-preempted-by-sibling)
      subtree-end)

     ((my-has-subtask)
      next-headline)

     ((not (string= "TODO" (org-get-todo-state)))
      subtree-end)

     ((org-is-habit-p)
      next-headline)
     )))
