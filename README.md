
# rsdt

Retrieve and tidy data from the [UNHCR RSD Statistical
Report](https://rsd.unhcr.org/) and the [UNHCR Resettlement Statistics
Report](https://rsr.unhcr.org/) applications.

### Installation

``` r
pak::pkg_install("galalH/rsdt")
```

### Usage

``` r
library(rsdt)
```

The first time you load the package, you need to call `unhcr_login()` to
initialize your access credentials. `rsdt` uses the
[`chromote`](https://github.com/rstudio/chromote) package to launch a
new tab in any chromium-based browser on your system where you should
login to your UNHCR account as usual before returning to your R session
and hitting return to continue. This process needs to be done only once
after installation, then again any time you update your UNHCR access
credentials. See the excellent documentation from sister-package
[popdata](https://github.com/PopulationStatistics/popdata/#using-the-popdata-package)
for more details on how this works.

All functions in the package follow the same naming/calling convention:

> platform_table(country, year, month)

Where `platform` is one of `rsd` or `rsr`, `table` is the name of the
desired dataset (see below), `country` is the UNHCR country code, and
`year` and `month` are provided in `yyyy` and `mm` format.

The available `RSD` datasets are:

- `rsd_data`: RSD Data \[Tab 1\].
- `rsd_grounds`: Frequency of use of Convention ground in 1951
  Recognitions during reporting period \[Tab 2\].
- `rsd_basis`: Legal Basis of Recognition \[Tab 3\].
- `rsd_decisions`: Substantive RSD decisions taken during reporting
  period \[Tab 4\].
- `rsd_registered`: Number of new asylum-seekers registered during
  reporting period \[Tab 5\].
- `rsd_identified`: Number of asylum-seekers identified in reporting
  period in need of RSD \[Tab 6\].
- `rsd_times`: Processing times \[Tabs 7-9\].

The available `RSR` datasets are:

- `rsr_summary`: Summary Resettlement Statistics Report \[Tab 1\].
- `rsr_submissions`: Resettlement submissions and decisions \[Tab 2\].
- `rsr_departures`: Resettlement departures \[Tab 3\].
- `rsr_demographics`: Demographics \[Tab 4\].
- `rsr_states`: Resettlement processing with States \[Tab 5\].
- `rsr_internal`: Internal resettlement processing \[Tab 6\].
- `rsr_times`: Full Resettlement processing data \[Tab 7\].

### Example

``` r
rsd_decisions("ARE", 2023, 6)
```

    ## # A tibble: 495 × 9
    ##    origin authority stage process procedure decision sex   age       n
    ##    <chr>  <chr>     <chr> <chr>   <chr>     <chr>    <chr> <chr> <dbl>
    ##  1 CAR    U         AR    RSD     REGLR     NEG      F     0-17      0
    ##  2 CAR    U         AR    RSD     REGLR     NEG      F     18-59     0
    ##  3 CAR    U         AR    RSD     REGLR     NEG      F     60+       0
    ##  4 CAR    U         AR    RSD     REGLR     NEG      F     UKN       0
    ##  5 CAR    U         AR    RSD     REGLR     NEG      M     0-17      0
    ##  6 CAR    U         AR    RSD     REGLR     NEG      M     18-59     3
    ##  7 CAR    U         AR    RSD     REGLR     NEG      M     60+       0
    ##  8 CAR    U         AR    RSD     REGLR     NEG      M     UKN       0
    ##  9 CAR    U         AR    RSD     REGLR     NEG      UKN   UKN       0
    ## 10 CAR    U         FI    RSD     REGLR     POS      F     0-17      0
    ## # ℹ 485 more rows
