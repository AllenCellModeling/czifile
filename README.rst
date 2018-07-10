Read image and metadata from Carl Zeiss(r) ZISRAW (CZI) files.

CZI is the native image file format of the ZEN(r) software by Carl Zeiss
Microscopy GmbH. It stores multidimensional images and metadata from
microscopy experiments.

This repository is a mirror of the original_ release of the code, intended to make ``pip`` installation possible. 

.. _original: https://www.lfd.uci.edu/~gohlke/code/czifile.py.html

:Author:
  `Christoph Gohlke <http://www.lfd.uci.edu/~gohlke/>`_

:Organization:
  Laboratory for Fluorescence Dynamics, University of California, Irvine

:Version: 2017.09.12

Requirements
------------
* `CPython 3.6 64-bit <http://www.python.org>`_
* `Numpy 1.13 <http://www.numpy.org>`_
* `Scipy 0.19 <http://www.scipy.org>`_
* `Tifffile.py 2017.09.12 <http://www.lfd.uci.edu/~gohlke/>`_
* `Czifle.pyx 2017.07.20 <http://www.lfd.uci.edu/~gohlke/>`_
  (for decoding JpegXrFile and JpgFile images)

Revisions
---------
2017.09.12
    Require tifffile.py 2017.09.12
2017.07.21
    Use multi-threading in CziFile.asarray to decode and copy segment data.
    Always convert BGR to RGB. Remove bgr2rgb options.
    Decode JpegXR directly from byte arrays.
2017.07.13
    Add function to convert CZI file to memory-mappable TIFF file.
2017.07.11
    Add 'out' parameter to CziFile.asarray.
    Remove memmap option from CziFile.asarray (backwards incompatible).
    Change spline interpolation order to 0 (backwards incompatible).
    Make axes return a string.
    Require tifffile 2017.07.11.
2015.08.17
    Require tifffile 2015.08.17.
2014.10.10
    Read data into a memory mapped array (optional).
2013.12.04
    Decode JpegXrFile and JpgFile via _czifle extension module.
    Attempt to reconstruct tiled mosaic images.
2013.11.20
    Initial release.

Notes
-----
The API is not stable yet and might change between revisions.

The file format design specification [1] is confidential and the licence
agreement does not permit to write data into CZI files.

Only a subset of the 2012 specification is implemented in the initial release.
Specifically, multifile images are not yet supported.

Tested on Windows with a few example files only.

References
----------
(1) ZISRAW (CZI) File Format Design specification Release Version 1.2.2.
    CZI 07-2016/CZI-DOC ZEN 2.3/DS_ZISRAW-FileFormat.pdf (confidential).
    Documentation can be requested at
    <http://microscopy.zeiss.com/microscopy/en_us/downloads/zen.html>
(2) CZI The File Format for the Microscope | ZEISS International
    <http://microscopy.zeiss.com/microscopy/en_us/products/microscope-software/
    zen-2012/czi.html>

Examples
--------
>>> with CziFile('test.czi') as czi:
...     image = czi.asarray()
>>> image.shape
(3, 3, 3, 250, 200, 3)
>>> image[0, 0, 0, 0, 0]
array([10, 10, 10], dtype=uint8)


