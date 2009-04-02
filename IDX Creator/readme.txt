IDX Creator
~~~~~~~~~~~

[ I. DESCRIPTION ]

IDX Creator is a tool to rebuild indexes files (.IDX) for the corresponding AFS.
In fact, each AFS file which contains audios files (.STR or .AHX) and .SRF files 
is "indexed" by external ".IDX" files.

Two versions are availables:
- IDX Creator (Win32 GUI)
- IDX Maker (Console)

[ II. COMPILING ]

To compile IDX Creator (Win32 GUI), open "idxcreator.dproj" and REBUILD.

To compile IDX Maker (Console), open "idxmaker.dproj" and REBUILD.

[ III. WARNING ]

BEWARE: 

When switching from IDX Maker (Console) to IDX Creator (Win32 GUI), 
please REBUILD (not compile).

You MUST recompile shared Units (located in "engine" directory).

*IF YOU DON'T DO THIS, YOU'LL HAVE I/O ERRORS WHEN ATTEMPTING TO CREATE IDX 
FROM IDX CREATOR, LIKE I/O ERROR 105.*

[ IV. CREDITS ]

Original IDX Creator and all creation algorithms: Manic
Updating / Fusionning IDX Creator for Shenmue I & II / IDX Maker (console version): [big_fury]SiZiOUS

http://shenmuesubs.sourceforge.net/