#lang racket
(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-cardano (ffi-lib "libcardano_c"))

; Type
(define-cpointer-type _wallet_pointer)

;void cardano_wallet_delete(cardano_wallet *);
(define-cardano cardano_wallet_delete (_fun _wallet_pointer -> _void))


;cardano_wallet *cardano_wallet_new(const uint8_t * const entropy_ptr, unsigned long entropy_size,
;                                   const char * const password_ptr, unsigned long password_size);
(define-cardano cardano_wallet_new (_fun 
                                         [ent : (_list i _uint8)]
                                         [_ulong = (length ent)]
                                         [pwd : _string]
                                         [_ulong = (string-length pwd)]
                                         ->
                                         _wallet_pointer
                                         ))


; cardano_account *cardano_account_create(cardano_wallet *wallet, const char *alias, unsigned int index);
(define-cpointer-type _account_pointer)
(define-cardano cardano_account_create (_fun _wallet_pointer _string _uint -> _account_pointer))

; void cardano_account_delete(cardano_account *account);
(define-cardano cardano_account_delete (_fun _account_pointer -> _void))

; unsigned long cardano_account_generate_addresses(cardano_account *account, int internal, unsigned int from_index, unsigned long num_indices, char *addresses_ptr[]);

(define-cardano cardano_account_generate_addresses(_fun _account_pointer _int _uint _ulong _pointer -> _ulong))

(define wallet (cardano_wallet_new (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32)
                              "test"))
wallet
(define account (cardano_account_create wallet "account1" 2))
account

(define s (make-bytes 256))
(define res (cardano_account_generate_addresses account 0 1 2 s))
res
(for ([i (range 0 15)])
  (println (bytes-ref s i)))

(cardano_account_delete account)
(cardano_wallet_delete wallet)
