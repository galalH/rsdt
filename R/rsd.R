#' @importFrom rlang set_names
#' @importFrom tidyr pivot_longer
#' @export
rsd_data <- function(asylum, year, month) {
  colnms <- c("origin", "authority", "stage", "process", "procedure",
              "identified", "interviewed", "closed", "appealed", "pending")
  data <- rsdt("rsd", asylum, year, month)[[1]]
  data[1, 1:10] <- data[1, 5:14]
  data[, 1:10] |>
    type_convert() |>
    set_names(colnms) |>
    pivot_longer(identified:pending, names_to = "group", values_to = "n")
}

#' @importFrom tidyr pivot_longer
#' @importFrom rlang set_names
#' @export
rsd_grounds <- function(asylum, year, month) {
  data <- rsdt("rsd", asylum, year, month)[[2]]
  data[1, 1:11] <- data[1, 5:15]
  data[, 1:11] |>
    type_convert() |>
    pivot_longer(6:11) |>
    set_names("origin", "authority", "stage", "process", "procedure",
              "grounds", "n")
}

#' @importFrom tidyr pivot_longer
#' @importFrom rlang set_names
#' @export
rsd_basis <- function(asylum, year, month) {
  data <- rsdt("rsd", asylum, year, month)[[3]]
  data[1, 1:11] <- data[1, 5:15]
  data[, 1:11] |>
    type_convert() |>
    pivot_longer(6:11) |>
    set_names("origin", "authority", "stage", "process", "procedure",
              "basis", "n")
}

#' @importFrom tidyr pivot_longer
#' @importFrom rlang set_names
#' @importFrom dplyr slice filter
#' @export
rsd_decisions <- function(asylum, year, month) {
  colnms <- c("origin", "authority", "stage", "process", "procedure", "decision",
              "F_0-17", "F_18-59", "F_60+", "F_UKN", "F_Total",
              "M_0-17", "M_18-59", "M_60+", "M_UKN", "M_Total",
              "UKN_UKN", "Total_Total")
  rsdt("rsd", asylum, year, month)[[4]] |>
    set_names(colnms) |>
    slice(-1) |>
    type_convert() |>
    pivot_longer(-c(origin:decision),
                 names_to = c("sex", "age"), names_sep = "_",
                 values_to = "n") |>
    filter(sex != "Total", age != "Total")
}

#' @importFrom tidyr pivot_longer
#' @importFrom rlang set_names
#' @importFrom dplyr slice filter
#' @export
rsd_registered <- function(asylum, year, month) {
  colnms <- c("origin",
              "F_0-17", "F_18-59", "F_60+", "F_UKN", "F_Total",
              "M_0-17", "M_18-59", "M_60+", "M_UKN", "M_Total",
              "UKN_UKN", "Total_Total")
  rsdt("rsd", asylum, year, month)[[5]] |>
    set_names(colnms) |>
    slice(-1) |>
    type_convert() |>
    pivot_longer(-origin,
                 names_to = c("sex", "age"), names_sep = "_",
                 values_to = "n") |>
    filter(sex != "Total", age != "Total")
}

#' @importFrom tidyr pivot_longer
#' @importFrom rlang set_names
#' @importFrom dplyr slice mutate
#' @export
rsd_identified <- function(asylum, year, month) {
  colnms <- c("origin", "authority", "stage", "process",
              "unaccompanied", "F", "M", "UNK")
  data <- rsdt("rsd", asylum, year, month)[[6]]
  data[1, 1:9] <- data[1, 5:13]
  data[, 1:8] |>
    type_convert() |>
    set_names(colnms) |>
    pivot_longer(F:UNK, names_to = "sex", values_to = "n") |>
    mutate(unaccompanied = unaccompanied == "YES")
}

#' @importFrom dplyr bind_rows mutate select
#' @importFrom rlang set_names
#' @importFrom lubridate dmy
#' @export
rsd_times <- function(asylum, year, month) {
  colnms <- c("origin", "authority", "stage", "process", "procedure",
              "t1", "t2",
              "x1", "x2", "x3", "x4")
  from <- c(ind1 = "registration", ind2 = "interview", ind3 = "appeal")
  to <- c(ind1 = "interview", ind2 = "decision", ind3 = "decision")
  data <-
    bind_rows(ind1 = rsdt("rsd", asylum, year, month)[[7]] |> set_names(colnms),
              ind2 = rsdt("rsd", asylum, year, month)[[8]] |> set_names(colnms),
              ind3 = rsdt("rsd", asylum, year, month)[[9]] |> set_names(colnms),
              .id = "ind")
  data[!is.na(data$x1), 2:8] <- data[!is.na(data$x1), 6:12]
  data[, 1:8] |>
    mutate(from = from[ind],
           to = to[ind],
           t1 = dmy(t1), t2 = dmy(t2),
           .after = procedure) |>
    select(-ind)
}
