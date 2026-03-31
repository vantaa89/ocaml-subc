let emit_log = ref false

let print_log s = if !emit_log then print_endline s
