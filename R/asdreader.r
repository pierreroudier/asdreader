#' @include get-spectrum.r

#' @title Reads ASD Binary Files in R.
#'
#' \code{asdreader} is a simple driver to read spectroscopy data collected
#' using ASD FieldSpec spectrometer and stored in \code{*.asd} files.
#'
#' @docType package
#' @name asdreader
NULL

#' @name get_metadata
#' @export
#' @title Reads metadata header from ASD file
#' @author Pierre Roudier
#' @param f character, path to ASD file
#' @return a list storing the metadata information in the ASD header,
#' as documented here: \url{http://support.asdi.com/Document/Documents.aspx}
#' @examples
#' asd_fn <- asd_file()
#' md <- get_metadata(asd_fn)
#' names(md)
get_metadata <- function(f) {
  # Open connection to file
  con <- file(f, "rb")

  # Get metadata from file
  md <- .get_metadata(con)

  # Close connection
  close(con)

  # Return list
  md
}

#' @name get_spectra
#' @title Reads reflectance from ASD file
#' @export
#' @author Pierre Roudier
#' @param f a vector of paths to ASD file(s)
#' @param type a character vector, which type of spectra to return. \code{"reflectance"}, \code{"raw"}, \code{"white_reference"} are currently supported
#' @return a matrix of the spectrum contained in the ASD file(s)
#' @examples
#' asd_fn <- asd_file()
#' m <- get_spectra(asd_fn)
#' plot(m[1,], type = 'l')
get_spectra <- function(f, type = "reflectance") {

  if (length(type) > 1) {
    stop('Please select only one type.')
  }

  res <- lapply(f, function(fn) {
    # Open connection to file
    con <- file(f, "rb")

    # Get metadata from file
    md <- .get_metadata(con)

    # Read spectrum
    spec <- .get_spec(con, md)

    # Close connection
    close(con)

    # Process spectra depending on data type required
    res <- .process_spectra(spec, md, type)

    # Return spectrum with proper column names
    res <- matrix(res, ncol = length(res))
    colnames(res) <- .get_wavelengths(md)

    res
  })

  do.call(rbind, res)
}
