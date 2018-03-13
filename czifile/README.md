# czireader subsection

This is the tiny terrible ecosystem that supports reading in CZI files, at least in theory.

## Necessary environmental configurations
In setup.py you need to set the external locations of some libraries installed system-wide.

### jxrlib
Still image format from MS. Needed by czifile.pyx. Installed via `brew install jxrlib`. Can fine library directory with `brew list jxrlib`

### jpeg-lib
Just the normal jpeg lib. Probably already present. Can be installed via `brew install jpeg`. Can find library directory with `brew list jxrlib`. 


## Where things came from?
- czifile.py
  * gives us the ability to load CZIs
  * came from (Christoph Gohlke's page)[https://www.lfd.uci.edu/~gohlke/code/czifile.py.html]
- Czifile.pyx
  * is strongly desired by czifile.py
  * gives us decoding of JXR and JPEG encoded images
  * came from (Christoph Gohlke's page)[https://www.lfd.uci.edu/~gohlke/code/czifile.pyx.html]
- windowsmediaphoto.h
  * is required by Czifile.pyx for compliation
  * supports windows media formats, I guess
  * came from [random github](https://raw.githubusercontent.com/curasystems/jxrlib/master/image/sys/windowsmediaphoto.h)
- tifffile.py
  * is required by czifile.py
  * gives us reading of tiffs
  * came from (Christoph Gohlke's page)[https://www.lfd.uci.edu/~gohlke/code/tifffile.py.html]
- tiffile.c
  * is required by tifffile.py
  * gives us decoding PackBits and LZW encoded TIFF data
  * came from (Christoph Gohlke's page)[https://www.lfd.uci.edu/~gohlke/code/tifffile.c.html]

