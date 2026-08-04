type ('a, 'b) pair = { fst : 'a; snd : 'b }
let update_snd : ('a, 'b) pair @ unique -> 'c -> ('a, 'c) pair =
  fun pair c -> { pair with snd = c }

let process_parts (pair @ unique) =
  let x @ unique = pair.fst in
  let y @ unique = pair.snd in
  x + y

let process_parts_wrong (pair @ unique) =
  let x @ unique = pair.fst in
  let y @ unique = pair.fst in
  x + y

let () =
  let local_ greeting = "Hello, OxCaml!" in
  print_endline greeting

