#' @noRd
.onLoad <- function(libname, pkgname) {
  get_sessionid <<- memoise::memoise(get_sessionid, cache = cachem::cache_mem(max_age = 30*60))
  rsdt <<- memoise::memoise(rsdt)
}
