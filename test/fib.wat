;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fib                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Compiled by WAXC (Version May 30 2024);;

(module 
(import "wasi_snapshot_preview1" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))

;;=== User Code            BEGIN ===;;
  (func $fib (export "fib") (param $i i32) (result i32)
    (local $tmp___04 i32)
    (local $tmp___05 i32)
    (local $tmp___02 i32)
    (local $tmp___03 i32)
    (local $tmp___00 i32)
    (local $tmp___01 i32)
    
  
    (local.set $tmp___00 (i32.le_s (local.get $i) (i32.const 1)))
    (if (local.get $tmp___00) (then
            (local.get $i)
      return
    ))
    
    
    
    (local.set $tmp___03 (i32.sub (local.get $i) (i32.const 1)))
    (local.set $tmp___02 (call $fib (local.get $tmp___03)))
    
    
    (local.set $tmp___05 (i32.sub (local.get $i) (i32.const 2)))
    (local.set $tmp___04 (call $fib (local.get $tmp___05)))
    (local.set $tmp___01 (i32.add (local.get $tmp___02) (local.get $tmp___04)))
        (local.get $tmp___01)
    return
  )
  (func $main (export "_start") (result i32)
    (local $tmp___0c__s0f i32)
    (local $tmp___0b__s0f i32)
    (local $tmp___0a__s0f i32)
    (local $tmp___0d__s0f i32)
    (local $i__s0e i32)
    (local $tmp___09__s0f i32)
    (local $crlf i32)
    (local $tmp___08__s0f i32)
    (local $tmp___06 i32)
    (local $tmp___07 i32)
    (local $tab i32)
    (local $x i32)
    
  
    (local.set $x (i32.const 0))
    
    
    (local.set $tmp___06 (call $wax::str_new (i32.const 4)))
    (local.set $crlf (local.get $tmp___06))
    
    
    (local.set $tmp___07 (call $wax::str_new (i32.const 7)))
    (local.set $tab (local.get $tmp___07))
    (if (i32.const 1) (then
      
      (local.set $i__s0e (i32.const 2))
      block $tmp__block_0000000001F6EBE0
      loop $tmp__lp_10
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          (local.set $tmp___09__s0f (i32.lt_s (local.get $i__s0e) (i32.const 10)))
          (local.set $tmp___08__s0f (local.get $tmp___09__s0f))
          (if (local.get $tmp___08__s0f) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000001F6EBE0)
          ))
          
          (local.set $tmp___0a__s0f (call $wax::int2str (local.get $i__s0e)))
          (call $wax::print (local.get $tmp___0a__s0f))
          (call $wax::print (local.get $tab))
          
          (local.set $tmp___0b__s0f (call $fib (local.get $i__s0e)))
          (local.set $x (local.get $tmp___0b__s0f))
          
          (local.set $tmp___0c__s0f (call $wax::int2str (local.get $x)))
          (call $wax::print (local.get $tmp___0c__s0f))
          (call $wax::print (local.get $crlf))
          
          (local.set $tmp___0d__s0f (i32.add (local.get $i__s0e) (i32.const 1)))
          (local.set $i__s0e (local.get $tmp___0d__s0f))
          (call $wax::pop_stack)

          (br $tmp__lp_10)
        ))
      end
      end
    ))
        (i32.const 0)
    return
  )
(data (i32.const 4) "\n")
(data (i32.const 7) "\t")
(global $wax::min_addr (mut i32) (i32.const 12))
;;=== User Code            END   ===;;

;;=== WAX Standard Library BEGIN ===;;
;;========================================================;;
;;     BASELINE MALLOC WITH HANDWRITTEN WEBASSEMBLY       ;;
;;========================================================;;
;; 32-bit implicit-free-list first-fit baseline malloc    ;;
;;--------------------------------------------------------;;

;; IMPLICIT FREE LIST:
;; Worse utilization and throughput than explicit/segregated, but easier
;; to implement :P
;;
;; HEAP LO                                                         HEAP HI
;; +---------------------+---------------------+...+---------------------+
;; | HDR | PAYLOAD | FTR | HDR | PAYLOAD | FTR |...+ HDR | PAYLOAD | FTR |
;; +----------^----------+---------------------+...+---------------------+
;;            |_ i.e. user data
;;           
;; LAYOUT OF A BLOCK:
;; Since memory is aligned to multiple of 4 bytes, the last two bits of
;; payload_size is redundant. Therefore the last bit of header is used to
;; store the is_free flag.
;; 
;; |---- HEADER (4b)----
;; |    ,--payload size (x4)--.     ,-is free?
;; | 0b . . . . . . . . . . . . 0  0
;; |------ PAYLOAD -----
;; |
;; |  user data (N x 4b)
;; |
;; |---- FOOTER (4b)---- (duplicate of header)
;; |    ,--payload size (x4)--.     ,-is free?
;; | 0b . . . . . . . . . . . . 0  0
;; |--------------------
;;
;; FORMULAS:
;; (these formulas are used throughout the code, so they're listed here
;; instead of explained each time encountered)
;;
;; payload_size = block_size - (header_size + footer_size) = block_size - 8
;; 
;; payload_pointer = header_pointer + header_size = header_pointer + 4
;;
;; footer_pointer = header_pointer + header_size + payload_size
;;                = (header_pointer + payload_size) + 4
;;
;; next_header_pointer = footer_pointer + footer_size = footer_pointer + 4
;;
;; prev_footer_pointer = header_pointer - footer_size = header_pointer - 4

(memory (export "memory") 1)
;;// (global $wax::min_addr (mut i32) (i32.const 0))  ;; set by wax compiler depending on data section size
(global $wax::max_addr (mut i32) (i32.const 65536)) ;; initial heap size (64K)
(global $wax::heap_did_init (mut i32) (i32.const 0))     ;; init() called?

;; helpers to pack/unpack payload_size/is_free from header/footer
;; by masking out bits

;; read payload_size from header/footer given pointer to header/footer
(func $wax::hdr_get_size (param $ptr i32) (result i32)
  (i32.and (i32.load (local.get $ptr)) (i32.const 0xFFFFFFFC))
)
;; read is_free from header/footer
(func $wax::hdr_get_free (param $ptr i32) (result i32)
  (i32.and (i32.load (local.get $ptr)) (i32.const 0x00000001))
)
;; write payload_size to header/footer
(func $wax::hdr_set_size (param $ptr i32) (param $n i32) 
  (i32.store (local.get $ptr) (i32.or
    (i32.and (i32.load (local.get $ptr)) (i32.const 0x00000003))
    (local.get $n)
  ))
)
;; write is_free to header/footer
(func $wax::hdr_set_free (param $ptr i32) (param $n i32)
  (i32.store (local.get $ptr) (i32.or
    (i32.and (i32.load (local.get $ptr)) (i32.const 0xFFFFFFFE))
    (local.get $n)
  ))
)
;; align memory by 4 bytes
(func $wax::align4 (param $x i32) (result i32)
  (i32.and
    (i32.add (local.get $x) (i32.const 3))
    (i32.const -4)
  )
)

;; initialize heap
;; make the whole heap a big free block
;; - automatically invoked by first malloc() call
;; - can be manually called to nuke the whole heap
(func $wax::init_heap
  (i32.store (i32.const 0) (global.get $wax::min_addr) )
  ;; write payload_size to header and footer
  (call $wax::hdr_set_size (global.get $wax::min_addr) 
    (i32.sub (i32.sub (global.get $wax::max_addr) (global.get $wax::min_addr)) (i32.const 8))
  )
  (call $wax::hdr_set_size (i32.sub (global.get $wax::max_addr) (i32.const 4))
    (i32.sub (i32.sub (global.get $wax::max_addr) (global.get $wax::min_addr)) (i32.const 8))
  )
  ;; write is_free to header and footer
  (call $wax::hdr_set_free (global.get $wax::min_addr) (i32.const 1))
  (call $wax::hdr_set_free (i32.sub (global.get $wax::max_addr) (i32.const 4)) (i32.const 1))

  ;; set flag to tell malloc() that we've already called init()
  (global.set $wax::heap_did_init (i32.const 1)) 
)

;; extend (grow) the heap (to accomodate more blocks)
;; parameter: number of pages (64K) to grow
;; - automatically invoked by malloc() when current heap has insufficient free space
;; - can be manually called to get more space in advance
(func $wax::extend (param $n_pages i32)
  (local $n_bytes i32)
  (local $ftr i32)
  (local $prev_ftr i32)
  (local $prev_hdr i32)
  (local $prev_size i32)

  (local.set $prev_ftr (i32.sub (global.get $wax::max_addr) (i32.const 4)) )

  ;; compute number of bytes from page count (1page = 64K = 65536bytes)
  (local.set $n_bytes (i32.mul (local.get $n_pages) (i32.const 65536)))

  ;; system call to grow memory (`drop` discards the (useless) return value of memory.grow)
  (drop (memory.grow (local.get $n_pages) ))

  ;; make the newly acquired memory a big free block
  (call $wax::hdr_set_size (global.get $wax::max_addr) (i32.sub (local.get $n_bytes) (i32.const 8)))
  (call $wax::hdr_set_free (global.get $wax::max_addr) (i32.const 1))

  (global.set $wax::max_addr (i32.add (global.get $wax::max_addr) (local.get $n_bytes) ))
  (local.set $ftr (i32.sub (global.get $wax::max_addr) (i32.const 4)))

  (call $wax::hdr_set_size (local.get $ftr)
    (i32.sub (local.get $n_bytes) (i32.const 8))
  )
  (call $wax::hdr_set_free (local.get $ftr) (i32.const 1))

  ;; see if we can join the new block with the last block of the old heap
  (if (i32.eqz (call $wax::hdr_get_free (local.get $prev_ftr)))(then)(else

    ;; the last block is free, join it.
    (local.set $prev_size (call $wax::hdr_get_size (local.get $prev_ftr)))
    (local.set $prev_hdr
      (i32.sub (i32.sub (local.get $prev_ftr) (local.get $prev_size)) (i32.const 4))
    )
    (call $wax::hdr_set_size (local.get $prev_hdr)
      (i32.add (local.get $prev_size) (local.get $n_bytes) )
    )
    (call $wax::hdr_set_size (local.get $ftr)
      (i32.add (local.get $prev_size) (local.get $n_bytes) )
    )
  ))

)

;; find a free block that fit the request number of bytes
;; modifies the heap once a candidate is found
;; first-fit: not the best policy, but the simplest
(func $wax::find (param $n_bytes i32) (result i32)
  (local $ptr i32)
  (local $size i32)
  (local $is_free i32)
  (local $pay_ptr i32)
  (local $rest i32)

  ;; loop through all blocks
  (local.set $ptr (global.get $wax::min_addr))
  loop $search
    ;; we reached the end of heap and haven't found anything, return NULL
    (if (i32.lt_u (local.get $ptr) (global.get $wax::max_addr))(then)(else
      (i32.const 0)
      return
    ))

    ;; read info about current block
    (local.set $size    (call $wax::hdr_get_size (local.get $ptr)))
    (local.set $is_free (call $wax::hdr_get_free (local.get $ptr)))
    (local.set $pay_ptr (i32.add (local.get $ptr) (i32.const 4) ))

    ;; check if the current block is free
    (if (i32.eq (local.get $is_free) (i32.const 1))(then

      ;; it's free, but too small, move on
      (if (i32.gt_u (local.get $n_bytes) (local.get $size))(then
        (local.set $ptr (i32.add (local.get $ptr) (i32.add (local.get $size) (i32.const 8))))
        (br $search)

      ;; it's free, and large enough to be split into two blocks
      )(else(if (i32.lt_u (local.get $n_bytes) (i32.sub (local.get $size) (i32.const 8)))(then
        ;; OLD HEAP
        ;; ...+-------------------------------------------+...
        ;; ...| HDR |              FREE             | FTR |...
        ;; ...+-------------------------------------------+...
        ;; NEW HEAP
        ;; ...+---------------------+---------------------+...
        ;; ...| HDR | ALLOC   | FTR | HDR |  FREE   | FTR |...
        ;; ...+---------------------+---------------------+...

        ;; size of the remaining half
        (local.set $rest (i32.sub (i32.sub (local.get $size) (local.get $n_bytes) ) (i32.const 8)))

        ;; update headers and footers to reflect the change (see FORMULAS)

        (call $wax::hdr_set_size (local.get $ptr) (local.get $n_bytes))
        (call $wax::hdr_set_free (local.get $ptr) (i32.const 0))

        (call $wax::hdr_set_size (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 4))
          (local.get $n_bytes)
        )
        (call $wax::hdr_set_free (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 4))
          (i32.const 0)
        )
        (call $wax::hdr_set_size (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 8))
          (local.get $rest)
        )
        (call $wax::hdr_set_free (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 8))
          (i32.const 1)
        )
        (call $wax::hdr_set_size (i32.add (i32.add (local.get $ptr) (local.get $size)) (i32.const 4))
          (local.get $rest)
        )

        (local.get $pay_ptr)
        return

      )(else
        ;; the block is free, but not large enough to be split into two blocks 
        ;; we return the whole block as one
        (call $wax::hdr_set_free (local.get $ptr) (i32.const 0))
        (call $wax::hdr_set_free (i32.add (i32.add (local.get $ptr) (local.get $size)) (i32.const 4))
          (i32.const 0)
        )
        (local.get $pay_ptr)
        return
      ))))
    )(else
      ;; the block is not free, we move on to the next block
      (local.set $ptr (i32.add (local.get $ptr) (i32.add (local.get $size) (i32.const 8))))
      (br $search)
    ))
  end

  ;; theoratically we will not reach here
  ;; return NULL
  (i32.const 0)
)


;; malloc - allocate the requested number of bytes on the heap
;; returns a pointer to the block of memory allocated
;; returns NULL (0) when OOM
;; if heap is not large enough, grows it via extend()
(func $wax::malloc (param $n_bytes i32) (result i32)
  (local $ptr i32)
  (local $n_pages i32)

  ;; call init() if we haven't done so yet
  (if (i32.eqz (global.get $wax::heap_did_init)) (then
    (call $wax::init_heap)
  ))

  ;; payload size is aligned to multiple of 4
  (local.set $n_bytes (call $wax::align4 (local.get $n_bytes)))

  ;; attempt allocation
  (local.set $ptr (call $wax::find (local.get $n_bytes)) )

  ;; NULL -> OOM -> extend heap
  (if (i32.eqz (local.get $ptr))(then
    ;; compute # of pages from # of bytes, rounding up
    (local.set $n_pages
      (i32.div_u 
        (i32.add (local.get $n_bytes) (i32.const 65527) )
        (i32.const 65528)
      )
    )
    (call $wax::extend (local.get $n_pages))

    ;; try again
    (local.set $ptr (call $wax::find (local.get $n_bytes)) )
  ))
  (local.get $ptr)
)

;; free - free an allocated block given a pointer to it
(func $wax::free (param $ptr i32)
  (local $hdr i32)
  (local $ftr i32)
  (local $size i32)
  (local $prev_hdr i32)
  (local $prev_ftr i32)
  (local $prev_size i32)
  (local $prev_free i32)
  (local $next_hdr i32)
  (local $next_ftr i32)
  (local $next_size i32)
  (local $next_free i32)
  
  ;; step I: mark the block as free

  (local.set $hdr (i32.sub (local.get $ptr) (i32.const 4)))
  (local.set $size (call $wax::hdr_get_size (local.get $hdr)))
  (local.set $ftr (i32.add (i32.add (local.get $hdr) (local.get $size)) (i32.const 4)))

  (call $wax::hdr_set_free (local.get $hdr) (i32.const 1))
  (call $wax::hdr_set_free (local.get $ftr) (i32.const 1))

  ;; step II: try coalasce

  ;; coalasce with previous block

  ;; check that we're not already the first block
  (if (i32.eq (local.get $hdr) (global.get $wax::min_addr)) (then)(else

    ;; read info about previous block
    (local.set $prev_ftr (i32.sub (local.get $hdr) (i32.const 4)))
    (local.set $prev_size (call $wax::hdr_get_size (local.get $prev_ftr)))
    (local.set $prev_hdr 
      (i32.sub (i32.sub (local.get $prev_ftr) (local.get $prev_size)) (i32.const 4))
    )

    ;; check if previous block is free -> merge them
    (if (i32.eqz (call $wax::hdr_get_free (local.get $prev_ftr))) (then) (else
      (local.set $size (i32.add (i32.add (local.get $size) (local.get $prev_size)) (i32.const 8)))
      (call $wax::hdr_set_size (local.get $prev_hdr) (local.get $size))
      (call $wax::hdr_set_size (local.get $ftr) (local.get $size))

      ;; set current header pointer to previous header
      (local.set $hdr (local.get $prev_hdr))
    ))
  ))

  ;; coalasce with next block

  (local.set $next_hdr (i32.add (local.get $ftr) (i32.const 4)))

  ;; check that we're not already the last block
  (if (i32.eq (local.get $next_hdr) (global.get $wax::max_addr)) (then)(else
    
    ;; read info about next block
    (local.set $next_size (call $wax::hdr_get_size (local.get $next_hdr)))
    (local.set $next_ftr 
      (i32.add (i32.add (local.get $next_hdr) (local.get $next_size)) (i32.const 4))
    )

    ;; check if next block is free -> merge them
    (if (i32.eqz (call $wax::hdr_get_free (local.get $next_hdr))) (then) (else
      (local.set $size (i32.add (i32.add (local.get $size) (local.get $next_size)) (i32.const 8)))
      (call $wax::hdr_set_size (local.get $hdr) (local.get $size))
      (call $wax::hdr_set_size (local.get $next_ftr) (local.get $size))
    ))

  ))

)
;; copy a block of memory over, from src pointer to dst pointer
;; WebAssembly seems to be planning to support memory.copy
;; until then, this function uses a loop and i32.store8/load8
(func $wax::memcpy (param $dst i32) (param $src i32) (param $n_bytes i32)
  (local $ptr i32)
  (local $offset i32)
  (local $data i32)

  (if (i32.eqz (local.get $n_bytes))(then
    return
  ))

  (local.set $offset (i32.const 0))

  loop $cpy
    (local.set $data (i32.load8_u (i32.add (local.get $src) (local.get $offset))))
    (i32.store8 (i32.add (local.get $dst) (local.get $offset)) (local.get $data))

    (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
    (br_if $cpy (i32.lt_u (local.get $offset) (local.get $n_bytes)))
  end
)

;; reallocate memory to new size
;; currently does not support contraction
;; nothing will happen if n_bytes is smaller than current payload size
(func $wax::realloc (param $ptr i32) (param $n_bytes i32) (result i32)
  (local $hdr i32)
  (local $next_hdr i32)
  (local $next_ftr i32)
  (local $next_size i32)
  (local $ftr i32)
  (local $size i32)
  (local $rest_hdr i32)
  (local $rest_size i32)
  (local $new_ptr i32)

  (local.set $hdr (i32.sub (local.get $ptr) (i32.const 4)))
  (local.set $size (call $wax::hdr_get_size (local.get $hdr)))

  (if (i32.gt_u (local.get $n_bytes) (local.get $size)) (then) (else
    (local.get $ptr)
    return
  ))

  ;; payload size is aligned to multiple of 4
  (local.set $n_bytes (call $wax::align4 (local.get $n_bytes)))

  (local.set $next_hdr (i32.add (i32.add (local.get $hdr) (local.get $size)) (i32.const 8)))

  ;; Method I: try to expand the current block

  ;; check that we're not already the last block
  (if (i32.lt_u (local.get $next_hdr) (global.get $wax::max_addr) )(then
    (if (call $wax::hdr_get_free (local.get $next_hdr)) (then

      (local.set $next_size (call $wax::hdr_get_size (local.get $next_hdr)))
      (local.set $rest_size (i32.sub 
        (local.get $next_size)
        (i32.sub (local.get $n_bytes) (local.get $size))
      ))
      (local.set $next_ftr (i32.add (i32.add (local.get $next_hdr) (local.get $next_size)) (i32.const 4)))

      ;; next block is big enough to be split into two
      (if (i32.gt_s (local.get $rest_size) (i32.const 0) ) (then
        
        (call $wax::hdr_set_size (local.get $hdr) (local.get $n_bytes))
        
        (local.set $ftr (i32.add (i32.add (local.get $hdr) (local.get $n_bytes) ) (i32.const 4)))
        (call $wax::hdr_set_size (local.get $ftr) (local.get $n_bytes))
        (call $wax::hdr_set_free (local.get $ftr) (i32.const 0))

        (local.set $rest_hdr (i32.add (local.get $ftr) (i32.const 4) ))
        (call $wax::hdr_set_size (local.get $rest_hdr) (local.get $rest_size))
        (call $wax::hdr_set_free (local.get $rest_hdr) (i32.const 1))

        (call $wax::hdr_set_size (local.get $next_ftr) (local.get $rest_size))
        (call $wax::hdr_set_free (local.get $next_ftr) (i32.const 1))

        (local.get $ptr)
        return

      ;; next block is not big enough to be split, but is
      ;; big enough to merge with the current one into one
      )(else (if (i32.gt_s (local.get $rest_size) (i32.const -9) ) (then
      
        (local.set $size (i32.add (i32.add (local.get $size) (i32.const 8) ) (local.get $next_size)))
        (call $wax::hdr_set_size (local.get $hdr) (local.get $size))
        (call $wax::hdr_set_size (local.get $next_ftr) (local.get $size))
        (call $wax::hdr_set_free (local.get $next_ftr) (i32.const 0))

        (local.get $ptr)
        return
      ))))

    ))
  ))

  ;; Method II: allocate a new block and copy over

  (local.set $new_ptr (call $wax::malloc (local.get $n_bytes)))
  (call $wax::memcpy (local.get $new_ptr) (local.get $ptr) (local.get $size))
  (call $wax::free (local.get $ptr))
  (local.get $new_ptr)

)

(func $wax::calloc (param $n_bytes i32) (result i32)
  (local $ptr i32)
  (local $offset i32)
  (local.set $ptr (call $wax::malloc (local.get $n_bytes)))
  (local.set $offset (i32.const 0))
  loop $zero
    (if (i32.lt_u (local.get $offset) (local.get $n_bytes)) (then
      (i32.store8 (i32.add (local.get $offset) (local.get $ptr) ) (i32.const 0))
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br $zero)
    ))
  end
  (local.get $ptr)
  return
)

(func $wax::memmove (param $dst i32) (param $src i32) (param $n_bytes i32)
  (local $ptr i32)
  (local $offset i32)
  (local $data i32)

  (if (i32.eqz (local.get $n_bytes))(then
    return
  ))
  
  (if (i32.gt_u (local.get $dst) (local.get $src)) (then
    (local.set $offset (i32.sub (local.get $n_bytes) (i32.const 1)))
    loop $cpy_rev
      (local.set $data (i32.load8_u (i32.add (local.get $src) (local.get $offset))))
      (i32.store8 (i32.add (local.get $dst) (local.get $offset)) (local.get $data))

      (local.set $offset (i32.sub (local.get $offset) (i32.const 1)))
      (br_if $cpy_rev (i32.gt_s (local.get $offset) (i32.const -1)))
    end
  
  )(else
    (local.set $offset (i32.const 0))
    loop $cpy
      (local.set $data (i32.load8_u (i32.add (local.get $src) (local.get $offset))))
      (i32.store8 (i32.add (local.get $dst) (local.get $offset)) (local.get $data))

      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br_if $cpy (i32.lt_u (local.get $offset) (local.get $n_bytes)))
    end
  ))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;               STACK              ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; poor man's stack
;; malloc a block of memory and pretend it's the stack, because of the apparent lack(?) of stack address in webassembly

(global $wax::stack_indices_ptr (mut i32) (i32.const 0))
(global $wax::stack_content_ptr (mut i32) (i32.const 0))
(global $wax::stack_count   (mut i32) (i32.const 32))
(global $wax::stack_size    (mut i32) (i32.const 128))
(global $wax::stack_index   (mut i32) (i32.const 0))
(global $wax::stack_now     (mut i32) (i32.const 0))
(global $wax::stack_did_init(mut i32) (i32.const 0))

(func $wax::init_stack
  (global.set $wax::stack_indices_ptr (call $wax::calloc (i32.mul (global.get $wax::stack_count) (i32.const 4))))
  (global.set $wax::stack_content_ptr (call $wax::malloc (global.get $wax::stack_size)))
  (global.set $wax::stack_index (i32.const 0))
  (global.set $wax::stack_did_init (i32.const 1))
)
(func $wax::stack_index_offset (result i32)
  (i32.add (global.get $wax::stack_indices_ptr) (i32.mul (global.get $wax::stack_index) (i32.const 4)))
)
(func $wax::push_stack

  (if (i32.eqz (global.get $wax::stack_did_init)) (then (call $wax::init_stack) ))

  (global.set $wax::stack_index (i32.add (global.get $wax::stack_index) (i32.const 1) ))

  (if (i32.ge_u (global.get $wax::stack_index) (global.get $wax::stack_count)) (then
    (global.set $wax::stack_count (i32.add (global.get $wax::stack_count) (i32.const 128)))
    (global.set $wax::stack_indices_ptr (call $wax::realloc 
      (global.get $wax::stack_indices_ptr) 
      (i32.mul (global.get $wax::stack_count) (i32.const 4))
    ))
  ))

  (i32.store (call $wax::stack_index_offset) (global.get $wax::stack_now) )

)
(func $wax::pop_stack

  (global.set $wax::stack_now (i32.load (call $wax::stack_index_offset) ))
  (global.set $wax::stack_index (i32.sub (global.get $wax::stack_index) (i32.const 1) ))
  
)
(func $wax::alloca (param $n_bytes i32) (result i32)
  (local $inc i32)
  (if (i32.ge_u (i32.add (global.get $wax::stack_now) (local.get $n_bytes) ) (global.get $wax::stack_size)) (then
    (local.set $inc (i32.const 512))
    (if (i32.gt_u (local.get $n_bytes) (local.get $inc)) (then
      (local.set $inc (call $wax::align4 (local.get $n_bytes)))
    ))
    (global.set $wax::stack_size (i32.add (global.get $wax::stack_size) (local.get $inc) ))
    (global.set $wax::stack_content_ptr
      (call $wax::realloc (global.get $wax::stack_content_ptr) (global.get $wax::stack_size))
    )
  ))

  ;; repurpose $inc for ret val
  (local.set $inc (i32.add (global.get $wax::stack_content_ptr ) (global.get $wax::stack_now)))

  (global.set $wax::stack_now (i32.add (global.get $wax::stack_now) (local.get $n_bytes)))

  (local.get $inc)
  return
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;              STRING              ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(func $wax::fmod (param $x f32) (param $y f32) (result f32)
  (f32.sub (local.get $x) (f32.mul (local.get $y) (f32.trunc (f32.div (local.get $x) (local.get $y)) )))
)

(func $wax::str_new (param $ptr i32) (result i32)
  (if (i32.eqz (local.get $ptr))(then
    (call $wax::calloc (i32.const 1))
    return
  ))
  (call $wax::str_slice (local.get $ptr) (i32.const 0) (call $wax::str_len (local.get $ptr)) )
  return
)

(func $wax::str_get (param $ptr i32) (param $i i32) (result i32)
  (i32.load8_s (i32.add (local.get $ptr) (local.get $i)))
  return
)

(func $wax::str_add (param $ptr i32) (param $c i32) (result i32)
  (local $l i32)
  (local.set $l (call $wax::str_len (local.get $ptr)))
  (local.set $ptr (call $wax::realloc (local.get $ptr) (i32.add (local.get $l) (i32.const 2) ) ) )
  (i32.store8 (i32.add (local.get $ptr) (local.get $l)) (local.get $c)  )
  (i32.store8 (i32.add (i32.add (local.get $ptr) (local.get $l)) (i32.const 1)) (i32.const 0)  )

  (local.get $ptr)
  (return)
)

(func $wax::str_cat (param $s0 i32) (param $s1 i32) (result i32)
  (local $l0 i32)
  (local $l1 i32)
  (local.set $l0 (call $wax::str_len (local.get $s0)))
  (local.set $l1 (call $wax::str_len (local.get $s1)))

  (local.set $s0 (call $wax::realloc (local.get $s0) (i32.add (i32.add (local.get $l0) (local.get $l1) ) (i32.const 1)) ))

  (call $wax::memcpy (i32.add (local.get $s0) (local.get $l0)) (local.get $s1) (local.get $l1) )
  (i32.store8 (i32.add (i32.add (local.get $s0) (local.get $l0)) (local.get $l1)) (i32.const 0)  )
  (local.get $s0)
  return
)

(func $wax::str_cmp (param $s0 i32) (param $s1 i32) (result i32)
  (local $offset i32)
  (local $x i32)
  (local $y i32)
  (local.set $offset (i32.const 0))
  loop $cmp
    (local.set $x (i32.load8_u (i32.add (local.get $s0) (local.get $offset))) )
    (local.set $y (i32.load8_u (i32.add (local.get $s1) (local.get $offset))) )

    (if (i32.eq (local.get $x) (local.get $y)) (then
      (if (i32.eqz (local.get $x)) (then
        (i32.const 1)
        return
      ))
    )(else
      (i32.const 0)
      return
    ))

    (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
    (br $cmp)
  end
  (i32.const 0) ;;impossible, just shut compiler up
  return
)

(func $wax::str_len (param $ptr i32) (result i32)
  (local $offset i32)
  (local.set $offset (i32.const 0))
  loop $zero
    (if (i32.load8_u (i32.add (local.get $ptr) (local.get $offset))) (then
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br $zero)
    ))
  end
  (local.get $offset)
  return
)

(func $wax::str_slice (param $ptr i32) (param $i i32) (param $n i32) (result i32)
  (local $nptr i32)
  (local.set $nptr (call $wax::malloc (i32.add (local.get $n) (i32.const 1))))
  (call $wax::memcpy 
    (local.get $nptr) 
    (i32.add (local.get $ptr) (local.get $i)) 
    (local.get $n)
  )
  (i32.store8 (i32.add (local.get $nptr) (local.get $n) ) (i32.const 0))
  (local.get $nptr)
  return
)

(func $wax::print (param $ptr i32)
  (local $len i32)
  (local.set $len (call $wax::str_len (local.get $ptr)))

  (i32.store (i32.const 0) (local.get $ptr))
  (i32.store (i32.const 4) (local.get $len))

  (call $fd_write
    (i32.const 1)
    (i32.const 0)
    (i32.const 1)
    (i32.const 100)
    )
    drop
)

(func $wax::int2str (param $x i32) (result i32)
  (local $ptr i32)
  (local $rem i32)
  (local $isneg i32)
  (local $str i32)

  (local.set $str (call $wax::alloca (i32.const 16)))
  (local.set $ptr (i32.add (local.get $str) (i32.const 15)))
  (i32.store8 (local.get $ptr) (i32.const 0))
  
  (local.set $isneg (i32.const 0))
  (if (i32.lt_s (local.get $x) (i32.const 0)) (then
    (local.set $isneg (i32.const 1))
    (local.set $x (i32.sub (i32.const 0) (local.get $x) ))
  ))

  loop $digits
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))

    (local.set $rem (i32.rem_u (local.get $x) (i32.const 10)))
    (i32.store8 (local.get $ptr) (i32.add (local.get $rem) (i32.const 48)))

    (local.set $x (i32.div_u (local.get $x) (i32.const 10)))

    (if (i32.eqz (i32.eqz (local.get $x))) (then
      (br $digits)
    ))
  end

  (if (local.get $isneg) (then
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))
    (i32.store8 (local.get $ptr) (i32.const 45)) ;; '-'
  ))

  (local.get $ptr)
  return
)

(func $wax::fint2str (param $x f32) (result i32)
  (local $ptr i32)
  (local $rem i32)
  (local $isneg i32)
  (local $str i32)
  (local.set $x (f32.trunc (local.get $x)))

  (local.set $str (call $wax::alloca (i32.const 48)))
  (local.set $ptr (i32.add (local.get $str) (i32.const 47)))
  (i32.store8 (local.get $ptr) (i32.const 0))
  
  (if (f32.lt (local.get $x) (f32.const 0)) (then
    (local.set $isneg (i32.const 1))
    (local.set $x (f32.sub (f32.const 0) (local.get $x) ))
  ))

  loop $digits
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))

    (local.set $rem (i32.trunc_f32_s (call $wax::fmod (local.get $x) (f32.const 10.0))))
    (i32.store8 (local.get $ptr) (i32.add (local.get $rem) (i32.const 48)))

    (local.set $x (f32.div (local.get $x) (f32.const 10.0)))

    (if (f32.gt (local.get $x) (f32.const 0.99999994) ) (then ;;nextafterf(1.00000001,0.0);
      (br $digits)
    ))
  end

  (if (local.get $isneg) (then
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))
    (i32.store8 (local.get $ptr) (i32.const 45)) ;; '-'
  ))

  (local.get $ptr)
  return
)




(func $wax::flt2str (param $x f32) (result i32)
  (local $ptr0 i32)
  (local $ptr i32)
  (local $rem i32)
  (local $isneg i32)
  (local $str i32)

  (local.set $ptr0 (call $wax::fint2str (local.get $x)))

  (if (f32.lt (local.get $x) (f32.const 0)) (then
    (local.set $x (f32.sub (f32.const 0.0) (local.get $x)))
  ))
  (local.set $x (f32.sub (local.get $x) (f32.trunc (local.get $x))))
  
  (local.set $str (call $wax::alloca (i32.const 16)))
  (i32.store8 (i32.sub (local.get $str) (i32.const 1)) (i32.const 46)  )
  (local.set $ptr (local.get $str))
  
  loop $digits
    
    (local.set $rem (i32.trunc_f32_s (f32.mul (local.get $x) (f32.const 10.0)) ))
    (i32.store8 (local.get $ptr) (i32.add (local.get $rem) (i32.const 48)))

    (local.set $x (f32.sub (f32.mul (local.get $x) (f32.const 10.0)) (f32.convert_i32_s (local.get $rem))) )

    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))

    (if (i32.and
      (f32.gt (local.get $x) (f32.const 1.1920928955078126e-7) ) ;; floating-point epsilon
      (i32.lt_s (i32.sub (local.get $ptr) (local.get $str)) (i32.const 15))
    )(then
      (br $digits)
    ))
  end
  (i32.store8 (local.get $ptr) (i32.const 0))

  (local.get $ptr0)
  return

)

(func $wax::str2int (param $s i32) (result i32)
  (local $x i32)
  (local $ptr i32)
  (local $d i32)
  (local $sign i32)
  (local.set $x (i32.const 0))

  (local.set $ptr (local.get $s))

  (local.set $sign (i32.const 1))
  (if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 45) ) (then ;;'-'
    (local.set $sign (i32.const -1))
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
  )(else(if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 43) ) (then ;;'+'
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1))) ;;redundant
  ))))

  loop $digits
    (local.set $d (i32.load8_s (local.get $ptr) ))
    (if (i32.or
      (i32.lt_s (local.get $d) (i32.const 48))
      (i32.gt_s (local.get $d) (i32.const 57))
    )(then
      (i32.mul (local.get $sign) (local.get $x))
      return
    ))
    
    (local.set $x (i32.mul (local.get $x) (i32.const 10)))
    (local.set $x (i32.add (local.get $x) (i32.sub (local.get $d) (i32.const 48))))
    
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
    (br $digits)
  end

  (i32.mul (local.get $sign) (local.get $x))
  return
)

(func $wax::str2flt (param $s i32) (result f32)
  (local $x f32)
  (local $ptr i32)
  (local $d i32)
  (local $sign f32)
  (local $mlt f32)

  (local.set $x (f32.const 0.0))

  (local.set $ptr (local.get $s))


  (local.set $sign (f32.const 1.0))
  (if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 45) ) (then ;;'-'
    (local.set $sign (f32.const -1))
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
  )(else(if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 43) ) (then ;;'+'
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1))) ;;redundant
  ))))

  block $out
  loop $digits
    (local.set $d (i32.load8_s (local.get $ptr) ))
    (if (i32.eq (local.get $d) (i32.const 46)) (then ;; '.'
      (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
      (br $out)
    ))
    (if (i32.or
      (i32.lt_s (local.get $d) (i32.const 48))
      (i32.gt_s (local.get $d) (i32.const 57))
    )(then
      (f32.mul (local.get $sign) (local.get $x))
      return
    ))
    
    (local.set $x (f32.mul (local.get $x) (f32.const 10.0)))
    (local.set $x (f32.add (local.get $x) (f32.convert_i32_s (i32.sub (local.get $d) (i32.const 48)))))
    
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
    (br $digits)
  end
  end

  (local.set $mlt (f32.const 0.1))
  loop $fracs
    (local.set $d (i32.load8_s (local.get $ptr) ))

    (if (i32.or
      (i32.lt_s (local.get $d) (i32.const 48))
      (i32.gt_s (local.get $d) (i32.const 57))
    )(then
      (f32.mul (local.get $sign) (local.get $x))
      return
    ))
    (local.set $x (f32.add
      (local.get $x)
      (f32.mul (f32.convert_i32_s (i32.sub (local.get $d) (i32.const 48))) (local.get $mlt))
    ))
    (local.set $mlt (f32.mul (local.get $mlt) (f32.const 0.1)))
    
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))

    (br $fracs)
  end

  (f32.mul (local.get $sign) (local.get $x))
  return
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;               ARRAY              ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; addapted from https://github.com/LingDong-/wasm-fun

;;   Continous, resizable storage for a sequence of values,
;;   similar to C++ vector<T>
;;
;;   +--------------------+
;;   |data|length|capacity|
;;   +-|------------------+
;;     |        +---------------------------
;;     `------> |elem 0|elem 1|elem 2|......
;;              +---------------------------

;; struct arr {
;;   i32/f32/(void*) data
;;   int length
;;   int capacity
;; }

(global $wax::DEFAULT_CAPACITY (mut i32) (i32.const 8))

;; (internal) getter/setters for arr struct fields

(func $wax::_arr_set_data (param $ptr i32) (param $data i32)
  (i32.store (local.get $ptr) (local.get $data))
)
(func $wax::_arr_set_length (param $ptr i32) (param $length i32)
  (i32.store (i32.add (local.get $ptr) (i32.const 4)) (local.get $length))
)
(func $wax::_arr_set_capacity (param $ptr i32) (param $capacity i32)
  (i32.store (i32.add (local.get $ptr) (i32.const 8)) (local.get $capacity))
)
(func $wax::_arr_get_data (param $ptr i32) (result i32)
  (i32.load (local.get $ptr))
)
(func $wax::_arr_get_capacity (param $ptr i32) (result i32)
  (i32.load (i32.add (local.get $ptr) (i32.const 8)))
)

;; returns length of an array given an arr pointer
(func $wax::arr_length (param $ptr i32) (result i32)
  (i32.load (i32.add (local.get $ptr) (i32.const 4)) )
)

;; initialize a new arr, returns a pointer to it
;; elem_size: size of each element, in bytes
(func $wax::arr_new (param $len i32) (result i32)
  (local $ptr i32)
  (local $cap i32)
  (local $data i32)
  (if (i32.lt_u (local.get $len) (global.get $wax::DEFAULT_CAPACITY)) (then
    (local.set $cap (global.get $wax::DEFAULT_CAPACITY))
  )(else
    (local.set $cap (local.get $len))
  ))
  (local.set $ptr (call $wax::malloc (i32.const 12)))
  (local.set $data (call $wax::calloc (i32.mul (local.get $cap) (i32.const 4))))
  (call $wax::_arr_set_data (local.get $ptr) (local.get $data))
  (call $wax::_arr_set_length (local.get $ptr) (local.get $len))
  (call $wax::_arr_set_capacity (local.get $ptr) (local.get $cap))
  (local.get $ptr)
)

;; free allocated memory given an arr pointer
(func $wax::arr_free (param $a i32)
  (call $wax::free (call $wax::_arr_get_data (local.get $a)))
  (call $wax::free (local.get $a))
)



;; get ith element of an array
(func $wax::arr_get (param $a i32) (param $i i32) (result i32)
  (local $data i32)
  (local $elem_size i32)
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))
  (i32.load (i32.add (i32.mul (local.get $i) (local.get $elem_size)) (local.get $data)))
)

;; set ith element of an array
(func $wax::arr_set (param $a i32) (param $i i32) (param $v i32)
  (local $data i32)
  (local $elem_size i32)
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))
  (i32.store (i32.add (i32.mul (local.get $i) (local.get $elem_size)) (local.get $data)) (local.get $v))
)

;; remove n elements from an array starting at index i
(func $wax::arr_remove (param $a i32) (param $i i32) (param $n i32)
  (local $data i32)
  (local $elem_size i32)
  (local $length i32)
  (local $offset i32)

  (local.set $length (call $wax::arr_length (local.get $a)))
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))

  (local.set $offset 
    (i32.add (local.get $data) (i32.mul (local.get $i) (local.get $elem_size) ))
  )

  (call $wax::memmove 
    (local.get $offset)
    (i32.add (local.get $offset) (i32.mul (local.get $n) (local.get $elem_size)))
    (i32.mul (i32.sub (local.get $length) (i32.add (local.get $i) (local.get $n)) ) (local.get $elem_size))
  )
  (call $wax::_arr_set_length  (local.get $a) (i32.sub (local.get $length) (local.get $n) ))
)


;; add an element to the end of the array
;; does not write the element, instead, returns a pointer
;; to the new last element for the user to write at
(func $wax::arr_push (param $a i32) (result i32)
  (local $length i32)
  (local $capacity i32)
  (local $data i32)
  (local $elem_size i32)

  (local.set $length (call $wax::arr_length (local.get $a)))
  (local.set $capacity (call $wax::_arr_get_capacity (local.get $a)))
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))

  (if (i32.lt_u (local.get $length) (local.get $capacity) ) (then) (else
    (local.set $capacity (i32.add
      (i32.add (local.get $capacity) (i32.const 1))
      (local.get $capacity)
    ))
    (call $wax::_arr_set_capacity (local.get $a) (local.get $capacity))

    (local.set $data 
      (call $wax::realloc (local.get $data) (i32.mul (local.get $elem_size) (local.get $capacity) ))
    )
    (call $wax::_arr_set_data (local.get $a) (local.get $data))
  ))
  (call $wax::_arr_set_length (local.get $a) (i32.add (local.get $length) (i32.const 1)))
  
  ;; (i32.store (i32.add (local.get $data) (i32.mul (local.get $length) (local.get $elem_size))) (i32.const 0))

  (i32.add (local.get $data) (i32.mul (local.get $length) (local.get $elem_size)))
)

;; insert into an array at given index
(func $wax::arr_insert (param $a i32) (param $i i32) (param $v i32)
  (local $data i32)
  (local $elem_size i32)
  (local $length i32)
  (local $offset i32)

  (local.set $length (call $wax::arr_length (local.get $a)))

  (drop (call $wax::arr_push (local.get $a)))

  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))

  (local.set $offset 
    (i32.add (local.get $data) (i32.mul (local.get $i) (local.get $elem_size) ))
  )

  (call $wax::memmove
    (i32.add (local.get $offset) (local.get $elem_size))
    (local.get $offset)
    (i32.mul 
      (i32.sub (local.get $length) (local.get $i) ) 
      (local.get $elem_size)
    )
  )

  (i32.store (local.get $offset) (local.get $v))

)

;; slice an array, producing a copy of a range of elements 
;; i = starting index (inclusive), j = stopping index (exclusive)
;; returns pointer to new array
(func $wax::arr_slice (param $a i32) (param $i i32) (param $n i32) (result i32)
  (local $a_length i32)
  (local $length i32)
  (local $elem_size i32)
  (local $ptr i32)
  (local $data i32)
  (local $j i32)

  (local.set $j (i32.add (local.get $i) (local.get $n)))

  (local.set $a_length (call $wax::arr_length (local.get $a)))

  (if (i32.lt_s (local.get $i) (i32.const 0) )(then
    (local.set $i (i32.add (local.get $a_length) (local.get $i)))
  ))
  (if (i32.lt_s (local.get $j) (i32.const 0) )(then
    (local.set $j (i32.add (local.get $a_length) (local.get $j)))
  ))

  (local.set $length (i32.sub (local.get $j) (local.get $i)))
  (local.set $elem_size (i32.const 4))

  (local.set $ptr (call $wax::malloc (i32.const 12)))
  (local.set $data (call $wax::malloc (i32.mul (local.get $length) (local.get $elem_size))))
  (call $wax::_arr_set_data (local.get $ptr) (local.get $data))
  (call $wax::_arr_set_length (local.get $ptr) (local.get $length))
  (call $wax::_arr_set_capacity (local.get $ptr) (local.get $length))

  (call $wax::memcpy (local.get $data) 
    (i32.add
      (call $wax::_arr_get_data (local.get $a))
      (i32.mul (local.get $i) (local.get $elem_size))
    )
    (i32.mul (local.get $length) (local.get $elem_size))
  )

  (local.get $ptr)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;                MAP               ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; adapted from https://github.com/LingDong-/wasm-fun

;;   Hash table (separate chaining with linked lists)
;;   similar to C++ map<T,T>.
;;
;;   Entire key is stored in map node; val is 32 bit int/float/pointer
;;
;;   Functions involving keys have two versions, *_i and *_h.
;;   _i takes an i32 as key directly (for simple small keys), 
;;   while _h versions read the key from the heap given a 
;;   pointer and a byte count (for larger keys)
;;
;;   +-----------+
;;   |num_buckets|          ,----------------------.
;;   |-----------|        +-|-------------------+  |  +---------------------+
;;   | bucket 0  |------->|next|key_size|key|val|  `->|next|key_size|key|val|
;;   |-----------|        +---------------------+     +---------------------+
;;   | bucket 1  |
;;   |-----------|        +---------------------+
;;   | bucket 2  |------->|next|key_size|key|val|
;;   |-----------|        +---------------------+
;;   | ......... |


;; struct map{
;;   int num_buckets;
;;   int length;
;;   mapnode* bucket0;
;;   mapnode* bucket1;
;;   mapnode* bucket2;
;;   ...
;; }
;; struct mapnode{
;;   mapnode* next;
;;   int key_size;
;;   key_t key;
;;   int val;
;; }

;; (internal) getters and setters for map struct

(func $wax::_map_get_num_buckets (param $m i32) (result i32)
  (i32.load (local.get $m))
)
(func $wax::_map_set_num_buckets (param $m i32) (param $num_buckets i32)
  (i32.store (local.get $m) (local.get $num_buckets))
)
(func $wax::map_length (param $m i32) (result i32)
  (i32.load (i32.add (local.get $m) (i32.const 4)))
)
(func $wax::_map_inc_length (param $m i32) (param $dx i32)
  (local $l i32)
  (local $o i32)
  (local.set $o (i32.add (local.get $m) (i32.const 4)))
  (local.set $l (i32.load (local.get $o)))
  (i32.store (local.get $o) (i32.add (local.get $l) (local.get $dx)))
)
(func $wax::_map_get_bucket (param $m i32) (param $i i32) (result i32)
  (i32.load (i32.add 
    (i32.add (local.get $m) (i32.const 8)) 
    (i32.mul (local.get $i) (i32.const 4))
  ))
)
(func $wax::_map_set_bucket (param $m i32) (param $i i32) (param $ptr i32)
  (i32.store (i32.add 
    (i32.add (local.get $m) (i32.const 8)) 
    (i32.mul (local.get $i) (i32.const 4))
  ) (local.get $ptr) )
)

;; (internal) getters and setters for map node struct

(func $wax::_mapnode_get_next (param $m i32) (result i32)
  (i32.load (local.get $m))
)
(func $wax::_mapnode_get_key_size (param $m i32) (result i32)
  (i32.load (i32.add (local.get $m) (i32.const 4)))
)
(func $wax::_mapnode_get_key_ptr (param $m i32) (result i32)
  (i32.add (local.get $m) (i32.const 8))
)
(func $wax::_mapnode_get_val_ptr (param $m i32) (result i32)
  (local $key_size i32)
  (local.set $key_size (call $wax::_mapnode_get_key_size (local.get $m)))
  (i32.add (i32.add (local.get $m) (i32.const 8)) (local.get $key_size))
)

(func $wax::_mapnode_set_next (param $m i32) (param $v i32)
  (i32.store (local.get $m) (local.get $v))
)
(func $wax::_mapnode_set_key_size (param $m i32) (param $v i32)
  (i32.store (i32.add (local.get $m) (i32.const 4)) (local.get $v))
)

(func $wax::_mapnode_set_key_h (param $m i32) (param $key_ptr i32) (param $key_size i32)
  (local $ptr i32)
  (local $i i32)
  (local.set $ptr (call $wax::_mapnode_get_key_ptr (local.get $m)))
  loop $loop_mapnode_set_key_h
    (i32.store8 
      (i32.add (local.get $ptr) (local.get $i))
      (i32.load8_u (i32.add (local.get $key_ptr) (local.get $i)))
    )
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_mapnode_set_key_h (i32.lt_u (local.get $i) (local.get $key_size) ))
  end
)
(func $wax::_mapnode_set_key_i (param $m i32) (param $key i32)
  (i32.store
    (call $wax::_mapnode_get_key_ptr (local.get $m))
    (local.get $key) 
  )
)

;; Hash functions

;; hash an integer with SHR3
(func $wax::_map_hash_i (param $num_buckets i32) (param $key i32) (result i32)
  (local.set $key (i32.xor (local.get $key) (i32.shl   (local.get $key) (i32.const 17))))
  (local.set $key (i32.xor (local.get $key) (i32.shr_u (local.get $key) (i32.const 13))))
  (local.set $key (i32.xor (local.get $key) (i32.shl   (local.get $key) (i32.const 5 ))))
  (i32.rem_u (local.get $key) (local.get $num_buckets))
)

;; hash a sequence of bytes by xor'ing them into an integer and calling _map_hash_i
(func $wax::_map_hash_h (param $num_buckets i32) (param $key_ptr i32) (param $key_size i32) (result i32)
  (local $key i32)
  (local $i i32)
  (local $byte i32)

  (local.set $i (i32.const 0))
  loop $loop_map_hash_h
    (local.set $byte (i32.load8_u (i32.add (local.get $key_ptr) (local.get $i))))
    
    (local.set $key
      (i32.xor (local.get $key) 
        (i32.shl (local.get $byte) (i32.mul (i32.const 8) (i32.rem_u (local.get $i) (i32.const 4))))
      )
    )
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_map_hash_h (i32.lt_u (local.get $i) (local.get $key_size) ))
  end

  (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key))
)

;; initialize a new map, given number of buckets
;; returns a pointer to the map
(func $wax::map_new (param $num_buckets i32) (result i32)
  (local $m i32)
  (local $i i32)
  (local.set $m (call $wax::malloc (i32.add (i32.mul (local.get $num_buckets) (i32.const 4)) (i32.const 8)) ))
  (call $wax::_map_set_num_buckets (local.get $m) (local.get $num_buckets))

  (local.set $i (i32.const 0))
  loop $loop_map_new_clear
    (call $wax::_map_set_bucket (local.get $m) (local.get $i) (i32.const 0))
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_map_new_clear (i32.lt_u (local.get $i) (local.get $num_buckets) ))
  end
  (local.get $m)
)

;; compare the key stored in a node agianst a key on the heap
(func $wax::_map_cmp_key_h (param $node i32) (param $key_ptr i32) (param $key_size i32) (result i32)
  (local $key_ptr0 i32)
  (local $key_size0 i32)
  (local $i i32)
  (local.set $key_ptr0 (call $wax::_mapnode_get_key_ptr (local.get $node)))
  (local.set $key_size0 (call $wax::_mapnode_get_key_size (local.get $node)))
  (if (i32.eq (local.get $key_size0) (local.get $key_size))(then
    (local.set $i (i32.const 0))
    loop $loop_map_cmp_key_h

      (if (i32.eq 
        (i32.load8_u (i32.add (local.get $key_ptr0) (local.get $i)))
        (i32.load8_u (i32.add (local.get $key_ptr ) (local.get $i)))
      )(then)(else
        (i32.const 0)
        return
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_map_cmp_key_h (i32.lt_u (local.get $i) (local.get $key_size) ))
    end
    (i32.const 1)
    return
  ))
  (i32.const 0)
  return
)

;; compare the key stored in a node agianst a key passed directly as i32 argument
(func $wax::_map_cmp_key_i (param $node i32) (param $key i32) (result i32)
  (local $key_ptr0 i32)
  (local $key_size0 i32)
  (local.set $key_ptr0 (call $wax::_mapnode_get_key_ptr (local.get $node)))
  (local.set $key_size0 (call $wax::_mapnode_get_key_size (local.get $node)))

  (if (i32.eq (local.get $key_size0) (i32.const 4))(then
    (i32.eq (i32.load (local.get $key_ptr0))  (local.get $key) )
    return
  ))
  (i32.const 0)
  return
)

;; insert a new entry to the map, taking a key stored on the heap
;; m : the map
;; key_ptr: pointer to the key on the heap
;; key_size: size of the key in bytes
;; returns pointer to the value inserted in the map for the user to write at

(func $wax::map_set_h (param $m i32) (param $key_ptr i32) (param $val i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $node_size i32)
  (local $prev i32)
  (local $key_size i32)
  (local.set $key_size (i32.add (call $wax::str_len (local.get $key_ptr)) (i32.const 1)))

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_h (local.get $num_buckets) (local.get $key_ptr) (local.get $key_size)))
  
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  (local.set $node_size (i32.add (local.get $key_size) (i32.const 12) ))


  (if (i32.eqz (local.get $it))(then
    (local.set $it (call $wax::malloc (local.get $node_size)))

    (call $wax::_mapnode_set_key_size (local.get $it) (local.get $key_size))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size))

    (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))

    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  )(else
    (local.set $prev (i32.const 0))
    loop $loop_map_set_h
      (if (i32.eqz (local.get $it))(then)(else
        (if (call $wax::_map_cmp_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size) )(then
          (local.set $it (call $wax::realloc (local.get $it) (local.get $node_size)))

          (if (i32.eqz (local.get $prev)) (then
            (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))
          )(else
            (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
          ))
          (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
          return
        ))
        (local.set $prev (local.get $it))
        (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
        (br $loop_map_set_h)
      ))
    end
    (local.set $it (call $wax::malloc (local.get $node_size)))
    (call $wax::_mapnode_set_key_size (local.get $it) (local.get $key_size))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size))

    (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  ))

)

;; insert a new entry to the map, taking a key passed directly as i32 argument
;; m : the map
;; key: the key
;; returns pointer to the value inserted in the map for the user to write at

(func $wax::map_set_i (param $m i32) (param $key i32)  (param $val i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $node_size i32)
  (local $prev i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key)))
  
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  (local.set $node_size (i32.const 16) )


  (if (i32.eqz (local.get $it))(then
    (local.set $it (call $wax::malloc (local.get $node_size)))

    (call $wax::_mapnode_set_key_size (local.get $it) (i32.const 4))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_i (local.get $it) (local.get $key))

    (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))

    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  )(else
    (local.set $prev (i32.const 0))
    loop $loop_map_set_i
      (if (i32.eqz (local.get $it))(then)(else
        (if (call $wax::_map_cmp_key_i (local.get $it) (local.get $key) )(then
          (local.set $it (call $wax::realloc (local.get $it) (local.get $node_size)))

          (if (i32.eqz (local.get $prev)) (then
            (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))
          )(else
            (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
          ))
          (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
          return
        ))
        (local.set $prev (local.get $it))
        (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
        (br $loop_map_set_i)
      ))
    end
    (local.set $it (call $wax::malloc (local.get $node_size)))
    (call $wax::_mapnode_set_key_size (local.get $it) (i32.const 4))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_i (local.get $it) (local.get $key))

    (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  ))

)

;; lookup a key for its value in the map, taking a key stored on the heap
;; m : the map
;; key_ptr: pointer to the key on the heap
;; key_size: size of the key in bytes
;; returns pointer to the value in the map, NULL (0) if not found.

(func $wax::map_get_h (param $m i32) (param $key_ptr i32) (result i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $key_size i32)
  (local.set $key_size (i32.add (call $wax::str_len (local.get $key_ptr)) (i32.const 1)))

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_h (local.get $num_buckets) (local.get $key_ptr) (local.get $key_size)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))

  loop $loop_map_get_h
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size) )(then
        (i32.load (call $wax::_mapnode_get_val_ptr (local.get $it)))
        return
      ))
      (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
      (br $loop_map_get_h)
    ))
  end

  (i32.const 0)
)

;; lookup a key for its value in the map, taking a key passed directly as i32 argument
;; m : the map
;; key : the key
;; returns pointer to the value in the map, NULL (0) if not found.

(func $wax::map_get_i (param $m i32) (param $key i32) (result i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))

  loop $loop_map_get_i
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_i (local.get $it) (local.get $key) )(then
        (i32.load (call $wax::_mapnode_get_val_ptr (local.get $it)))
        return
      ))
      (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
      (br $loop_map_get_i)
    ))
  end

  (i32.const 0)
)

;; remove a key-value pair from the map, given a key stored on the heap
;; m : the map
;; key_ptr: pointer to the key on the heap
;; key_size: size of the key in bytes

(func $wax::map_remove_h (param $m i32) (param $key_ptr i32) (param $key_size i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $prev i32)
  (local $next i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_h (local.get $num_buckets) (local.get $key_ptr) (local.get $key_size)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  
  (local.set $prev (i32.const 0))

  loop $loop_map_remove_h
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size) )(then
        (local.set $next (call $wax::_mapnode_get_next (local.get $it)))

        (if (i32.eqz (local.get $prev)) (then
          (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $next))
        )(else
          (call $wax::_mapnode_set_next (local.get $prev) (local.get $next))
        ))
        (call $wax::free (local.get $it))
        (call $wax::_map_inc_length (local.get $m) (i32.const -1))
        return
      ))
      (local.set $prev (local.get $it))
      (local.set $it (local.get $next))
      (br $loop_map_remove_h)
    ))
  end
)

;; remove a key-value pair from the map, given a key passed directly as i32 argument
;; m : the map
;; key : the key
(func $wax::map_remove_i (param $m i32) (param $key i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $prev i32)
  (local $next i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  
  (local.set $prev (i32.const 0))

  loop $loop_map_remove_i
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_i (local.get $it) (local.get $key) )(then
        (local.set $next (call $wax::_mapnode_get_next (local.get $it)))

        (if (i32.eqz (local.get $prev)) (then
          (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $next))
        )(else
          (call $wax::_mapnode_set_next (local.get $prev) (local.get $next))
        ))
        (call $wax::free (local.get $it))
        (call $wax::_map_inc_length (local.get $m) (i32.const 1))
        return
      ))
      (local.set $prev (local.get $it))
      (local.set $it (local.get $next))
      (br $loop_map_remove_i)
    ))
  end
)


;; generate a new iterator for traversing map pairs
;; in effect, this returns a pointer to the first node
(func $wax::map_iter_new  (param $m i32) (result i32)
  (local $num_buckets i32)
  (local $i i32)
  (local $node i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))

  (local.set $i (i32.const 0))
  loop $loop_map_iter_new
    (local.set $node (call $wax::_map_get_bucket (local.get $m) (local.get $i)))
    (if (i32.eqz (local.get $node))(then)(else
      (local.get $node)
      return
    ))
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_map_iter_new (i32.lt_u (local.get $i) (local.get $num_buckets) ))
  end
  (i32.const 0)
  return
)

;; increment an interator for traversing map pairs
;; in effect, this finds the next node of a given node, by first looking
;; at the linked list, then re-hashing the key to look through the rest of the hash table
(func $wax::map_iter_next (param $m i32) (param $iter i32) (result i32)
  (local $next i32)
  (local $num_buckets i32)
  (local $node i32)
  (local $i i32)
  
  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))

  (local.set $next (call $wax::_mapnode_get_next (local.get $iter)))

  (if (i32.eqz (local.get $next))(then

    (local.set $i (i32.add (call $wax::_map_hash_h
      (local.get $num_buckets)
      (call $wax::_mapnode_get_key_ptr  (local.get $iter))
      (call $wax::_mapnode_get_key_size (local.get $iter))
    ) (i32.const 1)))

    
    (if (i32.eq (local.get $i) (local.get $num_buckets)) (then
      (i32.const 0)
      return
    ))
    
    loop $loop_map_iter_next
      (local.set $node (call $wax::_map_get_bucket (local.get $m) (local.get $i)))
      (if (i32.eqz (local.get $node))(then)(else
        (local.get $node)
        return
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_map_iter_next (i32.lt_u (local.get $i) (local.get $num_buckets) ))
    end

    (i32.const 0)
    return

  )(else
    (local.get $next)
    return
  ))
  (i32.const 0)
  return
)

;; given a map iterator, get a pointer to the key stored
(func $wax::map_iter_key_h (param $iter i32) (result i32)
  (call $wax::_mapnode_get_key_ptr (local.get $iter))
)
;; given a map iterator, read the key stored as an int
;; only works if your key is an i32
(func $wax::map_iter_key_i (param $iter i32) (result i32)
  (i32.load (call $wax::_mapnode_get_key_ptr (local.get $iter)))
)
;; given a map iterator, get a pointer to the value stored
(func $wax::map_iter_val (param $iter i32) (result i32)
  (i32.load (call $wax::_mapnode_get_val_ptr (local.get $iter)))
)

;; remove all key-values in the map
(func $wax::map_clear (param $m i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)

  (local $next i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))

  (local.set $hash (i32.const 0))

  loop $loop_map_clear_buckets

    (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))

    loop $loop_map_clear_nodes
      (if (i32.eqz (local.get $it))(then)(else
        (local.set $next (call $wax::_mapnode_get_next (local.get $it)))

        (call $wax::free (local.get $it))

        (local.set $it (local.get $next))
        (br $loop_map_clear_nodes)
      ))
    end

    (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (i32.const 0))

    (local.set $hash (i32.add (local.get $hash) (i32.const 1)))
    (br_if $loop_map_clear_buckets (i32.lt_u (local.get $hash) (local.get $num_buckets)))

  end  
)

;; free all allocated memory for a map
(func $wax::map_free (param $m i32)
  (call $wax::map_clear (local.get $m))
  (call $wax::free (local.get $m))
)
;;=== WAX Standard Library END   ===;;

)
