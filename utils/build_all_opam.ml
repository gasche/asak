let rec read_all_pkg desc =
  try
    let str = Unix.readdir desc in
    if str = ".." || str = "."
    then read_all_pkg desc
    else str::read_all_pkg desc
  with
  | End_of_file -> []

let test_problem should_fail x res =
  if not (res = 0)
  then
    let str = "PROBLEM WITH: " ^ x in
    if should_fail
    then failwith str
    else print_endline str; true
  else false

let install_pkg prefix x =
  let res = Sys.command ("opam install -y --switch="^ prefix ^" --show-actions " ^ x ^" | grep \"remove[ ]*ocaml-variants\"") in
  if res = 0
  then false
  else
    let res = Sys.command ("opam install -y --switch="^ prefix ^" " ^ x) in
    if test_problem false x res
    then false
    else
      let res = Sys.command ("PKG_NAME="^x^" opam reinstall -y --switch="^ prefix ^" " ^ x) in
      if test_problem true x res
      then false
      else
        let res = Sys.command ("opam remove -a -y --switch="^ prefix ^" " ^ x) in
        not (test_problem false x res)

let remove_head x xs =
  match x with
  | None -> xs
  | Some x ->
     let rec aux = function
       | [] -> []
       | y::ys ->
          if x >= y
          then ys
          else aux ys
     in aux xs

let main prefix dir from =
  let desc = Unix.opendir dir in
  let pkg_list =
    remove_head from @@
      List.sort compare @@
        read_all_pkg desc in
  Unix.closedir desc;
  let lst_ok = List.filter (install_pkg prefix) pkg_list in
  print_endline "INSTALLED PKGS";
  List.iter print_endline lst_ok

let () = main Sys.argv.(1) Sys.argv.(2) (try Some (Sys.argv.(3)) with | Invalid_argument _ -> None)