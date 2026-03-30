let read_all_lines path =
  let channel = open_in path in
  Fun.protect
    ~finally:(fun () -> close_in channel)
    (fun () ->
      let rec loop acc =
        match input_line channel with
        | line -> loop (line :: acc)
        | exception End_of_file -> List.rev acc
      in
      loop [])

let read_process_lines command =
  let channel = Unix.open_process_in command in
  let lines =
    let rec loop acc =
      match input_line channel with
      | line -> loop (line :: acc)
      | exception End_of_file -> List.rev acc
    in
    loop []
  in
  match Unix.close_process_in channel with
  | Unix.WEXITED 0 -> lines
  | _ ->
      prerr_endline ("Test command failed: " ^ command);
      exit 1

let quote path = Filename.quote path

let compare_case lexer_exe fixture_path expected_path =
  let actual =
    read_process_lines (quote lexer_exe ^ " " ^ quote fixture_path)
  in
  let expected = read_all_lines expected_path in
  if actual = expected then
    None
  else
    Some (fixture_path, expected, actual)

let collect_cases fixtures_dir =
  Sys.readdir fixtures_dir
  |> Array.to_list
  |> List.sort String.compare
  |> List.filter_map (fun name ->
         if Filename.check_suffix name ".c" then
           let fixture_path = Filename.concat fixtures_dir name in
           let expected_path = fixture_path ^ ".out" in
           if Sys.file_exists expected_path then
             Some (fixture_path, expected_path)
           else
             None
         else
           None)

let print_diff expected actual =
  let expected_len = List.length expected in
  let actual_len = List.length actual in
  let max_len = max expected_len actual_len in
  for index = 0 to max_len - 1 do
    let expected_line = if index < expected_len then Some (List.nth expected index) else None in
    let actual_line = if index < actual_len then Some (List.nth actual index) else None in
    if expected_line <> actual_line then begin
      Printf.printf "  line %d\n" (index + 1);
      Printf.printf "    expected: %s\n"
        (match expected_line with Some line -> line | None -> "<none>");
      Printf.printf "    actual  : %s\n"
        (match actual_line with Some line -> line | None -> "<none>");
    end
  done

let () =
  let fixtures_dir, lexer_exe =
    match Array.to_list Sys.argv with
    | [_; fixtures_dir; lexer_exe] -> (fixtures_dir, lexer_exe)
    | _ ->
        prerr_endline "Usage: run_tests <fixtures-dir> <lexer-exe>";
        exit 2
  in
  let cases = collect_cases fixtures_dir in
  if cases = [] then begin
    prerr_endline "No lexer fixtures found.";
    exit 1
  end;
  let failures =
    List.filter_map (fun (fixture_path, expected_path) ->
        compare_case lexer_exe fixture_path expected_path)
      cases
  in
  if failures = [] then
    Printf.printf "Lexer tests passed: %d case(s)\n" (List.length cases)
  else begin
    List.iter
      (fun (fixture_path, expected, actual) ->
        Printf.printf "Mismatch: %s\n" fixture_path;
        print_diff expected actual)
      failures;
    exit 1
  end
