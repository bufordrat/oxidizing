(* break uniqueness *)
(* let dude (x : int ref @ unique) (y : int ref @ unique) = *)
(*   () *)

(* let _ = *)
(*   let r1 = ref 12 in *)
(*   dude r1 r1 *)

(* break affinity *)
(* let bro (x @ once) = x, x *)

(* break contention *)
(* let hey (x : int ref @ contended) = *)
  (* !x *)


(* break portability *)

(* let shya (f @ portable) = f *)

(* let increment = *)
(*   let r = ref 12 in *)
(*   fun () -> incr r *)

(* let _ = shya increment *)

(* break locality *)

(* let man x = *)
  (* let (y @ local) = ref 12 in *)
  (* y *)

(* let riz = *)
  (* let each_ref (x : int ref @ local) = incr x ; !x *)
  (* in List.map each_ref [ref 1; ref 2; ref 3] *)

(* let _ = *)
(*   let r = ref 18 in *)
(*   man r *)
