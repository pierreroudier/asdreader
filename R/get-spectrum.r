#' @include get-metadata.r

# Normalise spectrum
# s
.normalise_spectrum <- function(spec, md) {

  wl <- .get_wavelengths(md)

  idx1 <- which(wl <= md$splice1_wavelength)
  idx2 <- which(wl > md$splice1_wavelength & wl <= md$splice2_wavelength)
  idx3 <- which(wl > md$splice2_wavelength)

  spec[idx1] <- spec[idx1] / md$it
  spec[idx2] <- spec[idx2] * md$swir1_gain / 2048
  spec[idx3] <- spec[idx3] * md$swir2_gain / 2048

  spec
}

# get spectra
#
.get_spec <- function(con, md) {

  # Got to the correct file position
  seek(con, where = 484)

  # Raw spectrum
  spec <- readBin(con, what = md$data_format, n = md$channels, endian = "little")

  # White reference flag
  # seek(con, 17692) = 484 + 8 * md$channels
  wr_flag <- readBin(con, what = logical(), size = 2)

  # White reference time
  # seek(con, 17694) = 484 + 8 * md$channels + 2
  wr_time <- readBin(con, integer(), size = 8, endian = "little")

  # Spectrum time
  # seek(con, 17702) = 484 + 8 * md$channels + 10
  spec_time <- readBin(con, integer(), size = 8, endian = "little")

  # Spectrum description length
  # seek(con, 17710) = 484 + 8 * md$channels + 18
  spec_description_length <- readBin(con, integer(), size = 2, endian = "little")

  # Spectrum description
  # seek(con, 17712) # = 484 + 8 * md$channels + 20
  spec_description <- readChar(con, nchars = spec_description_length)

  # White reference
  wr <- readBin(con, what = md$data_format, n = md$channels, endian = "little")

  # Put results in a list
  res <- list(spectrum = spec, wr = wr)
}

.process_spectra <- function(spec, md, type) {

  # If reflectance data requested
  if (type == 'reflectance') {
    if (md$data_type %in% c('radiance', 'reflectance') ) {
      res <- spec$spectrum / spec$wr
    } else if (md$data_type == 'raw') {
      res <- .normalise_spectrum(spec$spectrum, md) / .normalise_spectrum(spec$wr, md)
    } else {
      stop(paste0('File only contains data of type ', md$data_type, '.'))
    }

  # If radiance data requested
  } else if (type == 'radiance') {
    if (md$data_type %in% c('radiance', 'reflectance')) {
      res <- spec$spectrum
    } else if (md$data_type == 'raw') {
      res <- .normalise_spectrum(spec$spectrum, md)
    } else {
      stop(paste0('File only contains data of type ', md$data_type, '.'))
    }

  # If raw DN requested
  } else if (type == 'raw') {
    if (md$data_type == 'raw') {
      res <- spec$spectrum
    } else {
      stop(paste0('File only contains data of type ', md$data_type, '.'))
    }

  # If white reference requested
  } else if (type == 'white_reference') {
    if (md$data_type %in% c('radiance', 'reflectance')) {
      res <- spec$wr
    } else if (md$data_type == 'raw') {
    res <- .normalise_spectrum(spec$wr, md)

  # Otherwise just throw an error
  } else {
    stop('Invalid type of data requested.')
  }
 }
}
