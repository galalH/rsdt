#' @importFrom rvest session html_elements html_text html_element
#' @importFrom rvest html_attr session_jump_to html_table
#' @importFrom httr set_cookies
#' @importFrom dplyr filter
#' @importFrom purrr keep
#' @importFrom lubridate year today
#' @importFrom stringr str_replace
#' @export
rsdt <- function(platform, asylum, year, month) {
  base_year <- c(rsd = 2019, rsr = 2016)
  base_url <- c(rsd = "https://rsd.unhcr.org/location/{id}/{year-base_year['rsd']}",
                rsr = "https://rsr.unhcr.org/location/report/{id}/{year-base_year['rsr']}")
  if (!platform %in% c("rsd", "rsr"))
    stop("invalid platform")
  if (!asylum %in% filter(rsdt_countries, .data[[platform]])$code)
    stop("invalid country")
  if (!year %in% base_year[platform]:year(today()))
    stop("invalid year")
  if (!month %in% 1:12)
    stop("invalid month")
  id <- filter(rsdt_countries, code == asylum)$id
  r <- session(glue::glue(base_url[platform]), set_cookies(PHPSESSID = get_sessionid(platform)))
  href <-
    html_elements(r, "tr")[-1] |>
    keep(\(x) html_text(html_element(x, "td"), trim = TRUE) == glue::glue("{month.name[month]} {year}")) |>
    html_element("a[href*='downloadReport']") |>
    html_attr("href") |>
    str_replace("download", "preview")
  r <- session_jump_to(r, href)
  html_table(r, convert = FALSE)[-1]
}
