library(tidyverse)
library(httr)

unhcr_countries <-
  jsonlite::fromJSON("http://api.unhcr.org/population/v1/countries/")$items |>
  filter(!code %in% c("STA", "UKN")) |>
  select(id, code, iso, name)

rsd_countries <-
  GET(glue::glue("https://rsd.unhcr.org/complianceMapData/{year(today())-2019}/{month(today())}"),
      set_cookies(PHPSESSID = rsdt:::get_sessionid("rsd"))) |>
  content(as = "text") |>
  jsonlite::fromJSON() |>
  select(-status) |>
  mutate(rsd = TRUE)

rsr_countries <-
  GET(glue::glue("https://rsr.unhcr.org/complianceMapData/{year(today())-2016}/{month(today())}"),
      set_cookies(PHPSESSID = rsdt:::get_sessionid("rsr"))) |>
  content(as = "text") |>
  jsonlite::fromJSON() |>
  select(-status) |>
  mutate(rsr = TRUE)

rsdt_countries <-
  list(unhcr_countries, rsd_countries, rsr_countries) |>
  reduce(full_join) |>
  replace_na(list(rsd = FALSE, rsr = FALSE)) |>
  left_join(refugees::countries |> select(code = unhcr_code, region = unhcr_region)) |>
  relocate(region, .before = name) |>
  as_tibble()

usethis::use_data(rsdt_countries, overwrite = TRUE)
