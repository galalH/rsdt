type_convert <- function(x) {
  purrr::quietly(readr::type_convert)(x)$result
}
