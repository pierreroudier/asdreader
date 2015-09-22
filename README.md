# asdreader
Reading ASD Binary Files in R

This package implements a simple reader for spectroscopy data collected using ASD (now PAN Analytics, Inc.) visible near-infrared spectrometers, and stored using the ASD format (which is documented [here](http://support.asdi.com/Document/Documents.aspx)).

The main function is `get_spectra`. It takes one (or more) paths to `*.asd` files and returns a matrix of spectra. The other potentially useful function is `get_metadata`, which returns the contents of the header of a a given `*.asd` file.

A sample `*.asd` file is included for testing/examples purposes. The path to this sample file can be access using the shorthand function `asd_file()`.

This package has been developed working on `*.asd` files in version 8 (that's my setup), along with some of the documentation that can be found online.

Contributions welcome!
