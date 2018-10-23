#lang racket
(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-cardano (ffi-lib "libcardano_c"))


;;;;;;;;;;;;
;;; Keys ;;;
;;;;;;;;;;;;

; #define XPRV_SIZE 96

; typedef struct cardano_xprv cardano_xprv;
; typedef struct cardano_xpub cardano_xpub;

(define-cpointer-type _xprv_pointer)
(define-cpointer-type _xpub_pointer)

; cardano_xpub *cardano_xprv_delete(cardano_xprv *privkey);
(define-cardano cardano_xprv_delete (_fun _xprv_pointer -> _xpub_pointer))
; cardano_xpub *cardano_xprv_to_xpub(cardano_xprv *privkey);
(define-cardano cardano_xprv_to_xpub (_fun _xprv_pointer -> _xpub_pointer))

; uint8_t *cardano_xprv_to_bytes(cardano_xprv *privkey);
; Size of the list?!
(define-cardano cardano_xprv_to_bytes (_fun _xprv_pointer -> (_list o _uint8 96)))

; cardano_xprv *cardano_xprv_from_bytes(uint8_t bytes[XPRV_SIZE]);
(define-cardano cardano_xprv_from_bytes (_fun [b : (_list i _uint8 )] -> _xprv_pointer))

; cardano_xpub *cardano_xpub_delete(cardano_xpub *pubkey);
(define-cardano cardano_xpub_delete (_fun _xpub_pointer -> _xpub_pointer))

;;;;;;;;;;;;;;;;;
;;; Addresses ;;;
;;;;;;;;;;;;;;;;;

; typedef struct cardano_address cardano_address;
(define-cpointer-type _address_pointer)

; /* check if an address is a valid protocol address.
;  * return 0 on success, !0 on failure. */
; int cardano_address_is_valid(const char * address_base58);
; TODO : *char input : check for a *char of a base58
; (define-cardano cardano_address_is_valid (_fun _pointer -> _int))
; 
; cardano_address *cardano_address_new_from_pubkey(cardano_xpub *publickey);
(define-cardano cardano_address_new_from_pubkey (_fun _xpub_pointer -> _address_pointer))
; void cardano_address_delete(cardano_address *address);
(define-cardano cardano_address_delete (_fun _address_pointer -> _address_pointer))
; 
; char *cardano_address_export_base58(cardano_address *address);
; cardano_address *cardano_address_import_base58(const char * address_bytes);

;;;;;;;;;;;;;;
;;; Wallet ;;;
;;;;;;;;;;;;;;
; Type
(define-cpointer-type _wallet_pointer)
(define-cpointer-type _account_pointer)

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
(define-cardano cardano_account_create (_fun _wallet_pointer _string _uint -> _account_pointer))

; void cardano_account_delete(cardano_account *account);
(define-cardano cardano_account_delete (_fun _account_pointer -> _void))

; unsigned long cardano_account_generate_addresses(cardano_account *account, int internal, unsigned int from_index, unsigned long num_indices, char *addresses_ptr[]);
(define-cardano cardano_account_generate_addresses(_fun _account_pointer _int _uint _ulong _pointer -> _ulong))

;;;;;;;;;;;;;;;;;;;
;;; Transaction ;;;
;;;;;;;;;;;;;;;;;;;

;typedef struct cardano_transaction_builder cardano_transaction_builder;
;typedef struct cardano_transaction_finalized cardano_transaction_finalized;
;typedef struct cardano_txoptr cardano_txoptr;
; TODO Remove duplicate?
;typedef struct cardano_txoutput cardano_txoutput;
;typedef struct cardano_txoutput cardano_txoutput;
;typedef struct cardano_transaction cardano_transaction;
;typedef struct cardano_signed_transaction cardano_signed_transaction;
(define-cpointer-type _transaction_builder_pointer)
(define-cpointer-type _transaction_finalized_pointer)
(define-cpointer-type _txoptr_pointer)
(define-cpointer-type _txoutput_pointer)
(define-cpointer-type _transaction_pointer)
(define-cpointer-type _signed_transaction_pointer)

;cardano_txoptr * cardano_transaction_output_ptr_new(uint8_t txid[32], uint32_t index);
(define-cardano cardano_transaction_output_ptr_new (_fun (_list i _uint8) _uint32 -> _txoptr_pointer))
;void cardano_transaction_output_ptr_delete(cardano_txoptr *txo);
(define-cardano cardano_transaction_output_ptr_delete (_fun _txoptr_pointer -> _void))

;cardano_txoutput * cardano_transaction_output_new(cardano_address *c_addr, uint64_t value);
(define-cardano cardano_transaction_output_new (_fun _address_pointer _uint64 -> _txoutput_pointer))
;void cardano_transaction_output_delete(cardano_txoutput *output);
(define-cardano cardano_transaction_output_delete (_fun _txoutput_pointer -> _void))

;cardano_transaction_builder * cardano_transaction_builder_new(void);
(define-cardano cardano_transaction_builder_new (_fun -> _transaction_builder_pointer))
;void cardano_transaction_builder_delete(cardano_transaction_builder *tb);
(define-cardano cardano_transaction_builder_delete (_fun _transaction_builder_pointer -> _void))
;void cardano_transaction_builder_add_output(cardano_transaction_builder *tb, cardano_txoptr *txo);
(define-cardano cardano_transaction_builder_add_output (_fun _transaction_builder_pointer _txoptr_pointer -> _void))
;cardano_result cardano_transaction_builder_add_input(cardano_transaction_builder *tb, cardano_txoptr *c_txo, uint64_t value);
(define-cardano cardano_transaction_builder_add_input (_fun _transaction_builder_pointer _txoptr_pointer _uint64 -> _int))
;cardano_result cardano_transaction_builder_add_change_addr(cardano_transaction_builder *tb, cardano_address *change_addr);
(define-cardano cardano_transaction_builder_add_change_addr (_fun _transaction_builder_pointer _address_pointer -> _int))
;uint64_t cardano_transaction_builder_fee(cardano_transaction_builder *tb);
(define-cardano cardano_transaction_builder_fee (_fun _transaction_builder_pointer -> _uint64))
;cardano_transaction *cardano_transaction_builder_finalize(cardano_transaction_builder *tb);
(define-cardano cardano_transaction_builder_finalize (_fun _transaction_builder_pointer -> _transaction_pointer))

;cardano_transaction_finalized * cardano_transaction_finalized_new(cardano_transaction *c_tx);
(define-cardano cardano_transaction_finalized_new (_fun _transaction_pointer -> _transaction_finalized_pointer))
;cardano_result cardano_transaction_finalized_add_witness(cardano_transaction_finalized *tf, uint8_t c_xprv[96], uint32_t protocol_magic, uint8_t c_txid[32]);
(define-cardano cardano_transaction_finalized_add_witness (_fun _transaction_finalized_pointer (_list i _uint8) _uint32 (_list i _uint8) -> _int))
;cardano_signed_transaction *cardano_transaction_finalized_output(cardano_transaction_finalized *tf);
(define-cardano cardano_transaction_finalized_output (_fun _transaction_finalized_pointer -> _signed_transaction_pointer))


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

(define transaction (cardano_transaction_builder_new))
(println transaction)
(cardano_transaction_builder_delete transaction)
