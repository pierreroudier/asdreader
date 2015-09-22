# asdreader

Reading ASD Binary Files in R

## Scope

This package implements a simple reader for spectroscopy data collected using ASD (now PAN Analytics, Inc.) visible near-infrared spectrometers, and stored using the ASD format (which is documented [here](http://support.asdi.com/Document/Documents.aspx)).

## Installation

It's easiest to use the `devtools` package to install `asdreader`:

`devtools::install_github("pierreroudier/asdreader")`

I haven't come around to submit this on CRAN yet.

## Use

The main function is `get_spectra`. It takes one (or more) paths to `*.asd` files and returns a matrix of spectra. The other potentially useful function is `get_metadata`, which returns the contents of the header of a a given `*.asd` file.

A sample `*.asd` file is included for testing/examples purposes. The path to this sample file can be access using the shorthand function `asd_file()`. 

```
fn <- asd_file()
s <- get_spectra(fn)
plot(as.numeric(s), type = 'l')
```

or, for the pipe *afficionados*:

```
library(magrittr)
asd_file() %>% 
  get_spectra %>% 
  as.numeric %>% 
  plot(type = 'l')
```

This package has been developed working on `*.asd` files in version 8 (that's my setup), along with some of the documentation that can be found online.

Contributions welcome!
