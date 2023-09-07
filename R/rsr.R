#' @importFrom dplyr mutate filter slice
#' @importFrom readr parse_number
#' @export
rsr_summary <- function(asylum, year, month) {
  rsdt("rsr", asylum, year, month)[[1]] |>
    mutate(indicator = X1, value = parse_number(X2),
           .keep = "none") |>
    filter(!is.na(value)) |>
    slice(-11)
}

#' @importFrom rlang set_names
#' @importFrom dplyr slice
#' @importFrom tidyr pivot_longer
#' @export
rsr_submissions <- function(asylum, year, month) {
  colnms <- c("origin", "dest", "priority", "category",
              "Submitted_C", "Submitted_P",
              "Accepted_C", "Accepted_P",
              "Rejected_C", "Rejected_P")
  rsdt("rsr", asylum, year, month)[[2]] |>
    set_names(colnms) |>
    slice(-1) |>
    type_convert() |>
    pivot_longer(-c(origin:category),
                 names_to = c("status", "unit"), names_sep = "_",
                 values_to = "n")
}

#' @importFrom rlang set_names
#' @export
rsr_departures <- function(asylum, year, month) {
  colnms <- c("origin", "dest", "n")
  data <- rsdt("rsr", asylum, year, month)[[3]]
  data[1, 1:3] <- data[1, 4:6]
  data[, 1:3] |> set_names(colnms) |> type_convert()
}

#' @importFrom rlang set_names
#' @importFrom dplyr slice filter
#' @importFrom tidyr pivot_longer
#' @export
rsr_demographics <- function(asylum, year, month) {
  colnms <- c("origin", "dest",
              "F_0-17", "F_18-59", "F_60+", "F_UKN", "F_Total",
              "M_0-17", "M_18-59", "M_60+", "M_UKN", "M_Total",
              "UKN_Total", "Total_Total")
  rsdt("rsr", asylum, year, month)[[4]] |>
    set_names(colnms) |>
    slice(-1) |>
    type_convert() |>
    pivot_longer(-c(origin, dest),
                 names_to = c("sex", "age"), names_sep = "_",
                 values_to = "n") |>
    filter(sex != "Total", age != "Total")
}

#' @importFrom rlang set_names
#' @importFrom dplyr slice
#' @importFrom tidyr pivot_longer
#' @export
rsr_states <- function(asylum, year, month) {
  colnms <- c("origin", "dest", "priority", "category",
              "Pending decision_P", "Pending departure_P",
              "Withdrawn_C", "Withdrawn_P",
              "On hold_C", "On hold_P")
  rsdt("rsr", asylum, year, month)[[5]] |>
    set_names(colnms) |>
    slice(-1) |>
    type_convert() |>
    pivot_longer(-c(origin:category),
                 names_to = c("status", "unit"), names_sep = "_",
                 values_to = "n")
}

#' @importFrom rlang set_names
#' @importFrom dplyr slice
#' @importFrom tidyr pivot_longer
#' @export
rsr_internal <- function(asylum, year, month) {
  colnms <- c("origin",
              "Sent back_P",
              "Pending interview_C", "Pending interview_P",
              "Pending submission_C", "Pending submission_P",
              "Interviewed pending submission_C", "Interviewed pending submission_P",
              "Withdrawn pre-submission_C", "Withdrawn pre-submission_P",
              "On hold pre-submission_C", "On hold pre-submission_P")
  rsdt("rsr", asylum, year, month)[[6]] |>
    set_names(colnms) |>
    slice(-1) |>
    type_convert() |>
    pivot_longer(-origin,
                 names_to = c("status", "unit"), names_sep = "_",
                 values_to = "n")
}

#' @importFrom dplyr select bind_rows filter mutate
#' @importFrom lubridate dmy
#' @importFrom rlang set_names
#' @export
rsr_times <- function(asylum, year, month) {
  from <- c(ind1 = "submission", ind2 = "submission", ind3 = "creation")
  to <- c(ind1 = "decision", ind2 = "departure", ind3 = "submission")
  colnms <- c("origin", "dest", "priority", "category",
              "t1", "t2")
  data <- rsdt("rsr", asylum, year, month)[[7]]
  data[1, 1:6] <- data[1, 5:10]
  data[1, 7:10] <- ""
  bind_rows(ind1 = data[, c(1:4, 5:6)] |> set_names(colnms),
            ind2 = data[, c(1:4, 7:8)] |> set_names(colnms),
            ind3 = data[, c(1:4, 9:10)] |> set_names(colnms),
            .id = "ind") |>
    mutate(from = from[ind],
           to = to[ind],
           t1 = dmy(t1), t2 = dmy(t2),
           .after = category) |>
    filter(!is.na(t1)) |>
    select(-ind)
}
