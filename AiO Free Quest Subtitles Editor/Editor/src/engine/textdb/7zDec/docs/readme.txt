7z ANSI-C Decoder by Igor Pavlov
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adapted by SiZiOUS of the SHENTRAD Team.

Included files...:
- 7zC.txt
- 7ZFormat.txt
- history.txt
- lzma.txt
- Methods.txt

... are from the original LZMA SDK v9.10 beta [2009-12-12].

To compile it, you must have MinGW installed. Tested with 5.1.4 version.

The decoder was patched (file 7zMain) to allowing you to pass the output_directory
parameter.

3 casts was made too: UInt16 -> WCHAR.

