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
rsr_processing_states <- function(asylum, year, month) {
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
rsr_internal_processing <- function(asylum, year, month) {
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
#' @export
rsr_full_processing <- function(asylum, year, month) {
  inds <- c(ind1 = "Processing time from submission to decision",
            ind2 = "Processing time from submission to departure",
            ind3 = "Processing time from case creation to submission")
  data <- rsdt("rsr", asylum, year, month)[[7]]
  data[1, 1:6] <- data[1, 5:10]
  data[1, 7:10] <- ""
  data <- data[, 1:10]
  ind1 <- select(data, 1:4, t1 = 5, t2 = 6)
  ind2 <- select(data, 1:4, t1 = 7, t2 = 8)
  ind3 <- select(data, 1:4, t1 = 9, t2 = 10)
  bind_rows(ind1 = ind1, ind2 = ind2, ind3 = ind3, .id = "ind") |>
    filter(t1 != "") |>
    mutate(ind = inds[ind], t1 = dmy(t1), t2 = dmy(t2)) |>
    select(origin = Origin, dest = Destination, priority = Priority, category = Category,
           ind, t1, t2)
}
