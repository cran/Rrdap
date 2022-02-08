Rrdap 1.0.2
===========

R package that queries RDAP servers.

NOTE: As of time of writing, RDAP in my experience appears to have less information in the databases and messier formats than traditional WHOIS for some odd reason despite having the same backend data and more years of experience with messy data by IANA/IETF and company... perhaps, and hopefully, this will change since it seems to be a better technical protocol overall.

For more information on RDAP:

https://www.arin.net/resources/registry/whois/rdap/

# Installation #

## Production/CRAN install ##

This package is available in [CRAN](https://bcable.net/x/Rrdap/CRAN).

```
install.packages("Rrdap")
```

## Development/GIT Install ##

To install the development or GIT repository version, this requires the "devtools" package available in [CRAN](https://cran.r-project.org/package=devtools).

### Install devtools ###

Assuming you don't already have devtools installed, run the following:

```
install.packages("devtools")
```

### Install Rrdap ###

With devtools installed, it's fairly simple to install the development branch:

```
library(devtools)
install_git("https://gitlab.com/BCable/Rrdap.git")
```

# Examples #

```r
library(Rrdap)

# Grab RDAP data for a domain
rdap_query("bcable.net")

# Grab RDAP data for an IP
rdap_query("1.1.1.1")

# Grab RDAP data for a domain from a specific RDAP provider
rdap_query("bcable.net", rdap_uri="https://rdap.verisign.com/net/v1/")

# Grab multiple mixed vectorized results
hosts_ips <- c("1.0.0.1", "bcable.net")
)
rdap_data <- rdap_query(hosts_ips)
rdap_data

# Extract Country Info About Domains
countries <- rdap_keyextract(rdap_data, "country")

# Get list of available attribute names for each entry
rdap_keynames(rdap_data)

# Get more traditional WHOIS style registration data
entity_data <- rdap_extract_df(rdap_data, "entities")

# Grab default role reported
rdap_keyval_extract(entity_data, "roles")
```
