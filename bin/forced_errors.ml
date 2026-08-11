
(* ================================================================== *)
(* Locality Errors *)

(* ------------------------------------------------------------------ *)
(* There is no restriction on the use of a function parameter with the
   "global" mode within the body of the function.
*)

let _ =
  let foo (x @ global) =
    let () = incr x in
    let bar (y @ local) = incr y in
    bar x
  in foo (ref 0)

(* ------------------------------------------------------------------ *)
(* Likewise, there is no restriction on the use of a function that
   expects a value in the "local" mode, i.e., it can be passed
   something in the local or global mode.  The mode expresses that the
   function has restricted itself in how it uses its argument.
*)

let _ =
  let foo (x @ local) = () in
  let x @ local = ref 0 in
  let y @ global = ref 1 in
  let () = foo x in
  let () = foo y in
  ()

(* ------------------------------------------------------------------ *)
(* A function paramter with the "local" mode cannot be used anywhere
   that expects something with the "global" mode.  In this example,
   the function parameter ~x~ with the "local" mode is passed to a
   function which expects a value with the "global" mode
*)

(* let _ = *)
(*   let foo (x @ global) = () in *)
(*   let _bar (x @ local) = foo x *)
(*   in () *)

(* ------------------------------------------------------------------ *)
(* A similar example to above, but more concrete.  The function
   parameter ~x~ with the "local" mode escapes it's scope by being put
   into a reference outside the scope of the function.

   I think this shows "the point" of the local mode on function
   parameters: you can't put local parameters into global stores.
*)

(* let _ = *)
(*   let y = ref (ref 0) in *)
(*   let _ = *)
(*     let _foo (x @ local) = y := x in *)
(*     () *)
(*   in () *)

(* ------------------------------------------------------------------ *)
(* Named values with the "local" mode behave similarly.  They can't
   be used anywhere which expects something with the "global" mode.
*)

(* let _ = *)
(*   let foo (x @ global) = () in *)
(*   let _ = *)
(*     let x @ local = ref 0 *)
(*     in foo x *)
(*   in () *)

(* let _ = *)
(*   let y = ref (ref 0) in *)
(*   let _ = *)
(*     let x @ local = ref 1 in *)
(*     y := x *)
(*   in () *)

(* ================================================================== *)
(* Contention Errors *)

(* ------------------------------------------------------------------ *)
(* There is no restriction in how a function parameter with the
   "uncontended" mode is used within the body of the function.
*)

let _ =
  let y = ref (ref 0) in
  let _foo (x @ uncontended) =
    let () = incr x in
    let () = y := x in
    ()
  in
  ()

(* ------------------------------------------------------------------ *)
(* There is no restriction in the use of a function that expects a
   parameters with the "contended" mode.  The mode expresses that the
   function /will be fine even if the passed argument is contended/.
*)

(* It's a bit too annoying to come up with an example right now *)

(* ------------------------------------------------------------------ *)
(* A function parameter with the "contended" mode can't be used
   anywhere that expects something "uncontended" *)

(* let _ = *)
(*   let foo (x @ uncontended) = () in *)
(*   let _bar (x @ contended) = foo x in *)
(*   () *)

(* ------------------------------------------------------------------ *)
(* The mutable part of a function parameter with the "contended" mode
   can't be read within body of the function.
*)

(* type baz = { *)
(*   a : int; *)
(*   mutable b : int; *)
(* } *)

(* let _ = *)
(*   let _foo (x @ contended) = *)
(*     let _ = x.a in *)
(*     let _ = x.b in *)
(*     () *)
(*   in () *)

(* ------------------------------------------------------------------ *)
(* The mutable part of a function parameter with the "contended" mode
   can't be written to within body of the function.
*)

(* let _ = *)
(*   let _foo (x @ contended) = x := 2 *)
(*   in () *)

(* ================================================================== *)
(* Portability Errors *)

(* ------------------------------------------------------------------ *)
(* A function parameter with the "nonportable" model can't be used
   anywhere that expected something "portable".
*)

(* let _ = *)
(*   let foo (x @ portable) = () in *)
(*   let _bar (x @ nonportable) = foo x in *)
(*   () *)

(* ------------------------------------------------------------------ *)
(* A portable function must capture all values as contended, so you
   cannot access mutable parts of captured values.
*)

(* type baz = { *)
(*   a : int ref; *)
(*   mutable b : int ref; *)
(* } *)

(* let _ = *)
(*   let _foo (x : baz) : (unit -> int ref) @ portable = *)
(*     fun () -> x.b *)
(*   in () *)


(* ------------------------------------------------------------------ *)
(* Values change contention within portable closures.
*)

(* let _ = *)
(*   let _foo x @ portable = *)
(*     let _ = (x : int ref @ uncontended) in *)
(*     fun () -> *)
(*       let _ = (x : int ref @ uncontended) in *)
(*       () *)
(*   in () *)

let _ =
  let foo (x @ aliased) = () in
  let _bar (x @ unique) = foo x in
  ()

(* let _ = *)
(*   let foo (x @ unique) = () in *)
(*   let _bar (x @ aliased) = foo x in *)
(*   () *)

(* let _ = *)
(*   let y = ref 0 in *)
(*   let foo (x @ unique) = incr x in *)
(*   foo y, foo y *)

(* let _ = *)
(*   let _foo (x @ aliased) @ unique = x in *)
(*   () *)

(* type 'a aliased = { a : 'a @@ aliased } [@@unboxed] *)

(* let _ = *)
(*   let _borrow (x : 'a @ unique) (f : 'a @ local -> 'b) : ('a * 'b aliased) @ unique = *)
(*     let result = f (borrow_ x) in *)
(*     x, { a = result } *)
(*   in () *)

type foo =
  { mutable a : int }

let _ =
  let x = ref { a = 0 } in
  let y = ref { a = 1 } in
  let bar (z : foo @ unique) =
    x := z;
    y := z
  in
  let q @ unique = { a = 2 } in
  let _ = bar q in
  let _ = (!y).a <- 3 in
  print_int (!x).a

let _ =
  let a @ unique = { a = 100 } in
  let bar (x : foo @ local) (y : foo @ local) =
    if x.a > 10
    then y.a <- 1;
    if x.a > 5
    then y.a <- 2 * y.a
  in
  let _ = bar (borrow_ a) (borrow_ a) in
  print_int a.a
