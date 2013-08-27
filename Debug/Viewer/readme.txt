Shenmue Subtitles Preview
~~~~~~~~~~~~~~~~~~~~~~~~~

[ I. DESCRIPTION ]

This isn't a tool. It's a library called "Shenmue Subtitles Preview".
It allow you to give you an idea how the subtitle'll be shown in-game.

[ II. COMPILING ]

To test the library, go to the "src/debug" directory and open preview.dproj in 
Delphi 2007, then recompile the "preview.exe" project.

All the sources in "src" directory are required to implements the Viewer.
All the engine Viewer are localized in "viewer_intf.pas".

Enjoy.

[ III. USING ]

How to use the viewer in your application :

Add all files included in 'src' directory:
- font.rc (add the rsrc\font.bmp in executable resource)
- oldskool_font_mapper.pas: OldSkool Font Mapper
- oldskool_font_vcl.pas: Implementation for Font Mapper in Borland VCL
- viewer.dfm: The Viewer window
- viewer.pas: The Viewer window source code
- viewer_intf.pas: The Viewer core source code

Check the "viewer.dproj" debug project (localised in "src/debug" directory
to learn how to implements the Viewer in your app.

[ IV. ABOUT THE FONT ]

This module use a Bitmap Font (called OldSkool Bitmap Font).

The font is localized in the "src/rsrc/" directory. The file name is
"font.bmp".

To see if your font is correctly set, use the "fontmap" project inside the
"rsrc/tools" (where you can find "bin, "obj" directories).

Params for the font is 5 lines * 27 columns. All the font mapping is set
in the viewer_intf (check the CHARSMAP_STRING const). I think that's all.

[ V. CREDITS ]

This library was made by [big_fury]SiZiOUS on Shendream request.

http://shenmuesubs.sourceforge.net/