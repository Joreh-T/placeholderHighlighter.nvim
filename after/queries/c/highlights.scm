
; extends

(argument_list
  (string_literal) @injection.content . (_)
  (#match? @injection.content ".*%%.*")
  (#set! injection.language "c")
)
