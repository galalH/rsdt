#' @importFrom purrr discard
#' @importFrom stringr str_detect
#' @export
unhcr_login <- function() {
  cookiejar <- fs::path(fs::dir_create(rappdirs::app_dir("unhcr")$cache()), "cookies.rds")
  b <- chromote::ChromoteSession$new()
  b$Page$navigate("https://intranet.unhcr.org")
  b$view()
  readline("Hit [RETURN] to continue when you've logged in.")
  cookies <- b$Network$getAllCookies()
  b$close()
  cookies$cookies |> discard(\(x) str_detect(x$domain, "^(.+)\\.unhcr\\.org$")) |> saveRDS(cookiejar)
}

#' @importFrom purrr keep pluck
#' @noRd
get_sessionid <- function(platform) {
  cookiejar <- fs::path(rappdirs::app_dir("unhcr")$cache(), "cookies.rds")
  b <- chromote::ChromoteSession$new()
  b$Network$setCookies(cookies = readRDS(cookiejar))
  b$Page$navigate(glue::glue("https://{platform}.unhcr.org/connect/azure"))
  cookies <- b$Network$getAllCookies()
  b$close()
  cookies$cookies |> keep(\(x) x$name == "PHPSESSID" & x$domain == paste0(platform, ".unhcr.org")) |> pluck(1, "value")
}
