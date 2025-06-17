;; -----------------------------------------------
;; Contract: stx-raffle-pot
;; Description: Decentralized Raffle System on Stacks
;; Author: [Your Name]
;; -----------------------------------------------

(define-constant ERR_NOT_STARTED (err u100))
(define-constant ERR_ALREADY_ENTERED (err u101))
(define-constant ERR_TOO_EARLY (err u102))
(define-constant ERR_NO_PARTICIPANTS (err u103))
(define-constant MIN_ENTRY_AMOUNT u1000000) ;; 1 STX

(define-data-var participants (list 100 principal) (list))
(define-data-var deadline uint u0)
(define-data-var raffle-active bool false)
(define-data-var winner (optional principal) none)

;; === Admin starts the raffle with a deadline ===
(define-public (start-raffle (end uint))
  (begin
    (asserts! (not (var-get raffle-active)) (err u200)) ;; already active
    (var-set deadline end)
    (var-set participants (list))
    (var-set winner none)
    (var-set raffle-active true)
    (ok true)
  )
)

;; === Users enter by sending STX ===
(define-public (enter-raffle)
  (begin
    (asserts! (var-get raffle-active) ERR_NOT_STARTED)
    (asserts! (> (stx-get-balance tx-sender) MIN_ENTRY_AMOUNT) (err u104))

    ;; prevent duplicate entry
    (let ((current (var-get participants)))
      (asserts! (is-none (index-of current tx-sender)) ERR_ALREADY_ENTERED)
      (asserts! (< (len current) u99) (err u105))  ;; check if there's room for one more
      (var-set participants (unwrap! (as-max-len? (concat current (list tx-sender)) u100) (err u106)))
      (ok true)
    )
  )
)

;; === Pick winner after deadline ===
(define-public (pick-winner)
  (begin
    (asserts! (var-get raffle-active) ERR_NOT_STARTED)
    (asserts! (>= stacks-block-height (var-get deadline)) ERR_TOO_EARLY)

    (let ((users (var-get participants)))
      (asserts! (> (len users) u0) ERR_NO_PARTICIPANTS)

      ;; pseudo-random index using block-height as seed
      (let ((index (mod stacks-block-height (len users)))
            (selected-winner (unwrap! (element-at users index) ERR_NO_PARTICIPANTS)))
        (begin
          (unwrap! (stx-transfer? (stx-get-balance tx-sender) tx-sender selected-winner) (err u107))
          (var-set winner (some selected-winner))
          (var-set raffle-active false)
          (ok selected-winner)
        )
      )
    )
  )
)

;; === View current participants ===
(define-read-only (get-participants)
  (ok (var-get participants))
)

;; === View raffle state ===
(define-read-only (get-state)
  (ok {
    active: (var-get raffle-active),
    deadline: (var-get deadline),
    num-participants: (len (var-get participants)),
    winner: (var-get winner)
  })
)
