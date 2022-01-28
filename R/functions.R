entity_detect <- function(entity){
	is_ip <- grepl("^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$", entity)
	if(is_ip){
		"ip"
	} else {
		"domain"
	}
}

rdap_query_one <- function(entity, rdap_uri, query_entity=FALSE, debug=FALSE){
	if(query_entity == FALSE){
		query_entity <- entity_detect(entity)
	}

	rdap_query_uri <- paste0(c(rdap_uri, query_entity, "/", entity), collapse="")
	if(debug == TRUE || debug >= 1){
		print(paste0(c("DEBUG: RDAP Query URL: ", rdap_query_uri), collapse=""))
	}

	curl_con <- curl::curl(rdap_query_uri)
	lines <- FALSE
	tryCatch(
		lines <- readLines(curl_con, warn=FALSE),
		error=function(e){
			print(paste0(
				c("Error (RDAP Query URI: ", rdap_query_uri, ")"),
				collapse=""
			))
			print(e)
		}
	)

	tryCatch(close(curl_con))
	if(length(lines) == 1 && lines == FALSE){
		NA

	} else {
		if(debug >= 2){
			print("DEBUG:")
			print(paste0(lines, collapse="\n"))
			print("END DEBUG//")
		}

		clean_lines <- enc2utf8(trimws(paste0(lines, collapse=""), "both"))
		json_obj <- rjson::fromJSON(clean_lines)
		json_obj
	}
}

rdap_query <- function(entities,
	rdap_uri="https://rdap-bootstrap.arin.net/bootstrap/",
	query_entity=FALSE, debug=FALSE
){
	if(length(entities)>1){
		lapply(entities, FUN=function(entity){
			rdap_query_one(entity, rdap_uri, query_entity, debug)
		})
	} else {
		rdap_query_one(entities, rdap_uri, query_entity, debug)
	}
}

rdap_keyextract <- function(query_ret, key){
	if(length(query_ret)>1){
		unlist(lapply(query_ret, FUN=function(df){
			if(!is.data.frame(df) || is.null(df[[key]])){
				NA
			} else if(length(df[[key]]) > 1) {
				df[[key]][[1]]
			} else {
				df[[key]]
			}
		}))
	} else if (!is.data.frame(query_ret) || is.null(query_ret[[key]])){
		NA
	} else {
		query_ret[[key]]
	}
}

rdap_keynames <- function(query_ret){
	if(length(query_ret)>1){
		lapply(query_ret, FUN=names)
	} else {
		names(query_ret)
	}
}

rdap_extract_df <- function(query_ret, sub_name){
	if(length(query_ret)>1){
		lapply(query_ret, FUN=function(df){
			data_ret <- unlist(df[[sub_name]])
			data.frame(
				key=names(data_ret),
				val=as.vector(data_ret)
			)
		})
	} else {
		data_ret <- unlist(query_ret[[sub_name]])
		data.frame(
			key=names(data_ret),
			val=as.vector(data_ret)
		)
	}
}

# shared code with Rwhois and Rrdap
.keyval_extract <- function(query_ret, keys, unlist.recursive=TRUE){
	data_ret <- lapply(query_ret, FUN=function(df){
		df$val[tolower(df$key) %in% tolower(keys)]
	})
	data_ret[sapply(data_ret, FUN=length) == 0] <- NA

	if(sum(sapply(data_ret, FUN=length) > 1) != 0){
		data_ret[sapply(data_ret, FUN=length) > 1] <-
			sapply(data_ret[
				sapply(data_ret, FUN=length) > 1],
				FUN=function(df){ df[[1]] }
			)
	}

	unlist(data_ret, recursive=unlist.recursive)
}

#rdap_keyval_extract <- function(query_ret, keys, unlist.recursive=FALSE){ .keyval_extract(...) }
rdap_keyval_extract <- .keyval_extract
