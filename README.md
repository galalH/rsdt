
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
