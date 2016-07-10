(eval-after-load "compile"
  '(defun compilation-goto-locus (msg mk end-mk)
     "Jump to an error corresponding to MSG at MK.
All arguments are markers.  If END-MK is non-nil, mark is set there
and overlay is highlighted between MK and END-MK."
    ;; Show compilation buffer in other window, scrolled to this error.
    (let* ((from-compilation-buffer (eq (window-buffer)
                                        (marker-buffer msg)))
           ;; Use an existing window if it is in a visible frame.
           (pre-existing (get-buffer-window (marker-buffer msg) 0))
           (w (if (and from-compilation-buffer pre-existing)
                  ;; Calling display-buffer here may end up (partly) hiding
                  ;; the error location if the two buffers are in two
                  ;; different frames.  So don't do it if it's not necessary.
                  pre-existing
  	      (display-buffer (marker-buffer msg) '(nil (allow-no-window . t)))))
  	 (highlight-regexp (with-current-buffer (marker-buffer msg)
  			     ;; also do this while we change buffer
  			     (goto-char (marker-position msg))
  			     (and w (compilation-set-window w msg))
  			     compilation-highlight-regexp)))
      ;; Ideally, the window-size should be passed to `display-buffer'
      ;; so it's only used when creating a new window.
      (when (and (not pre-existing) w)
        (compilation-set-window-height w))

      (if from-compilation-buffer
          ;; If the compilation buffer window was selected,
          ;; keep the compilation buffer in this window;
          ;; display the source in another window.
;;          (let ((pop-up-windows t))
;;            (pop-to-buffer (marker-buffer mk) 'other-window))
        (switch-to-buffer (marker-buffer mk)))
      (unless (eq (goto-char mk) (point))
        ;; If narrowing gets in the way of going to the right place, widen.
        (widen)
        (if next-error-move-function
  	  (funcall next-error-move-function msg mk)
  	(goto-char mk)))
      (if end-mk
          (push-mark end-mk t)
        (if mark-active (setq mark-active)))
      ;; If hideshow got in the way of
      ;; seeing the right place, open permanently.
      (dolist (ov (overlays-at (point)))
        (when (eq 'hs (overlay-get ov 'invisible))
          (delete-overlay ov)
          (goto-char mk)))

      (when highlight-regexp
        (if (timerp next-error-highlight-timer)
  	  (cancel-timer next-error-highlight-timer))
        (unless compilation-highlight-overlay
  	(setq compilation-highlight-overlay
  	      (make-overlay (point-min) (point-min)))
  	(overlay-put compilation-highlight-overlay 'face 'next-error))
        (with-current-buffer (marker-buffer mk)
  	(save-excursion
  	  (if end-mk (goto-char end-mk) (end-of-line))
  	  (let ((end (point)))
  	    (if mk (goto-char mk) (beginning-of-line))
  	    (if (and (stringp highlight-regexp)
  		     (re-search-forward highlight-regexp end t))
  		(progn
  		  (goto-char (match-beginning 0))
  		  (move-overlay compilation-highlight-overlay
  				(match-beginning 0) (match-end 0)
  				(current-buffer)))
  	      (move-overlay compilation-highlight-overlay
  			    (point) end (current-buffer)))
  	    (if (or (eq next-error-highlight t)
  		    (numberp next-error-highlight))
  		;; We want highlighting: delete overlay on next input.
  		(add-hook 'pre-command-hook
  			  'compilation-goto-locus-delete-o)
  	      ;; We don't want highlighting: delete overlay now.
  	      (delete-overlay compilation-highlight-overlay))
  	    ;; We want highlighting for a limited time:
  	    ;; set up a timer to delete it.
  	    (when (numberp next-error-highlight)
  	      (setq next-error-highlight-timer
  		    (run-at-time next-error-highlight nil
  				 'compilation-goto-locus-delete-o)))))))
      (when (and (eq next-error-highlight 'fringe-arrow))
        ;; We want a fringe arrow (instead of highlighting).
        (setq next-error-overlay-arrow-position
  	    (copy-marker (line-beginning-position)))))))
