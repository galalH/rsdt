#' @importFrom readr type_convert
#' @importFrom purrr quietly
type_convert <- function(x) {
  quietly(type_convert)(x)$result
}
