Roundtrip test: parse -> emit source -> parse -> emit source, then diff.
If the pretty-printer is idempotent, diff produces no output.

  $ for f in arrays.c basic_types.c comprehensive.c control_flow.c functions.c invalid_features.c nested_comments.c pointers.c structs.c; do
  >   ../../src/main.exe --emit-source < "$f" > pass1.c && \
  >   ../../src/main.exe --emit-source < pass1.c > pass2.c && \
  >   diff pass1.c pass2.c && echo "$f: OK" || echo "$f: FAIL"
  > done
  arrays.c: OK
  basic_types.c: OK
  comprehensive.c: OK
  control_flow.c: OK
  functions.c: OK
  invalid_features.c: OK
  nested_comments.c: OK
  pointers.c: OK
  structs.c: OK
