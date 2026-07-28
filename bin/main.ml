type ('a, 'b) pair = { fst : 'a; snd : 'b }
let update_snd : ('a, 'b) pair @ unique -> 'c -> ('a, 'c) pair =
  fun pair c -> { pair with snd = c }

let () =
  let local_ greeting = "Hello, OxCaml!" in
  print_endline greeting
