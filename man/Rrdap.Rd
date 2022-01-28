\name{Rrdap}
\alias{Rrdap}
\alias{Rrdap::rdap_query}
\alias{Rrdap::rdap_extract_df}
\alias{Rrdap::rdap_keyextract}
\alias{Rrdap::rdap_keynames}
\alias{Rrdap::rdap_keyval_extract}
\alias{rdap_query}
\alias{rdap_extract_df}
\alias{rdap_keyextract}
\alias{rdap_keynames}
\alias{rdap_keyval_extract}
\title{RDAP server querying}
\description{Queries RDAP servers}
\usage{
rdap_query(entities, rdap_uri="https://rdap-bootstrap.arin.net/bootstrap/",
  query_entity=FALSE, debug=FALSE)

rdap_keyextract(query_ret, key)

rdap_keynames(query_ret)

rdap_extract_df(query_ret, sub_name)

rdap_keyval_extract(query_ret, keys, unlist.recursive=TRUE)
}
\arguments{
\item{entities}{Entity (or entities as vector) to query RDAP for.  Can IP addresses, domains, or a mix of the two.}
\item{rdap_uri}{RDAP URI to use as the search base.  This should not need to be anything other than the default bootstrap URI unless you really want to do something specific.}
\item{query_entity}{Manually override what type of entity is being queried.  Not recommended.}
\item{query_ret}{Data structure that was returned from rdap_query()}
\item{sub_name}{Name of sub-table to return as a flat list}
\item{key}{Single string, case-sensitive, of what key to look to return back values from the RDAP return}
\item{keys}{Single string or vector of strings, case-insensitive, of what keys to look for in-order to return back values of from the RDAP return}
\item{debug}{Boolean if you want debug prints (good for large quantities of manual data)}
\item{unlist.recursive}{Boolean if you want the unlist at the end to pass recursively}
}
\value{
rdap_query() returns a large JSON data.frame()
rdap_extract_df() returns a data.frame
rdap_keyextract() returns a vector
rdap_keynames() returns a vector
rdap_keyval_extract() returns a vector
}
\author{Brad Cable}
\examples{
# Grab RDAP data for a domain
rdap_query("bcable.net")

# Grab RDAP data for an IP
rdap_query("1.1.1.1")

# Grab RDAP data for a domain from a specific RDAP provider
rdap_query("bcable.net", rdap_uri="https://rdap.verisign.com/net/v1/")

# Grab multiple mixed vectorized results
hosts_ips <- c("1.0.0.1", "bcable.net")
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
}
\keyword{Rrdap}
\keyword{rdap}
\keyword{rdap_query}
\keyword{rdap_extract_df}
\keyword{rdap_keyextract}
\keyword{rdap_keynames}
\keyword{rdap_keyval_extract}
