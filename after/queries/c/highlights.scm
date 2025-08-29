
; extends

(argument_list
  (string_literal) @PlaceholderPrintf . (_)
  (#match? @PlaceholderPrintf ".*%%.*")
)
