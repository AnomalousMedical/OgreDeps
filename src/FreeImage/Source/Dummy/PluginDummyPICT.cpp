//// ==========================================================
//// Apple Macintosh QuickDraw/PICT Loader
////
//// Design and implementation by
//// - Amir Ebrahimi (amir@unity3d.com)
////
//// Based on PICT loading code from paintlib (http://www.paintlib.de/paintlib/).
////
//// Paintlib License:
//// The paintlib source code and all documentation are copyright (c) 1996-2002 
//// Ulrich von Zadow and other contributors.
////
//// The paintlib source code is supplied "AS IS". Ulrich von Zadow and other 
//// contributors disclaim all warranties, expressed or implied, including, without
//// limitation, the warranties of merchantability and of fitness for any purpose. 
//// The authors assume no liability for direct, indirect, incidental, special, 
//// exemplary, or consequential damages, which may result from the use of paintlib, 
//// even if advised of the possibility of such damage.
////
//// Permission is hereby granted to use, copy, modify, and distribute this source 
//// code, or portions hereof, for any purpose, without fee, subject to the following 
//// restrictions:
////
//// 1. The origin of this source code must not be misrepresented.
//// 2. Altered versions must be plainly marked as such and must not be misrepresented
////    as being the original source.
//// 3. This Copyright notice may not be removed or altered from any source or altered 
////    source distribution.
//// 4. Executables containing paintlib or parts of it must state that the software 
////    "contains paintlib code. paintlib is copyright (c) 1996-2002 Ulrich von Zadow
////    and other contributors.". This notice must be displayed in at least one place
////    where the copyright for the software itself is displayed. The documentation must 
////    also contain this notice.
////
//// Bug fixes were made to the original code to support version 2 PICT files
//// properly.
//// 
//// Additional resources:
//// http://developer.apple.com/documentation/mac/QuickDraw/QuickDraw-458.html
//// http://www.fileformat.info/format/macpict/egff.htm
//// 
//// Notes (http://lists.apple.com/archives/java-dev/2006/Apr/msg00588.html):
//// There are three main types of PICT files:
////  - Version 1
////  - Version 2
////  - Extended Version 2
////
//// Some things to look out for:
////  - The bounds and target DPI are stored in a different place in all three.
////  - Some of the values are fixed-point shorts ( short / 65536f )
////  - Values are big endian 
////  - All of this may be *preceded* by a 512 byte header--sometimes it is
////    there, and sometimes it isn't. You just have to check for the magic
////	  values in both places.
////
//// This file is part of FreeImage 3
////
//// COVERED CODE IS PROVIDED UNDER THIS LICENSE ON AN "AS IS" BASIS, WITHOUT WARRANTY
//// OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, WITHOUT LIMITATION, WARRANTIES
//// THAT THE COVERED CODE IS FREE OF DEFECTS, MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE
//// OR NON-INFRINGING. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE COVERED
//// CODE IS WITH YOU. SHOULD ANY COVERED CODE PROVE DEFECTIVE IN ANY RESPECT, YOU (NOT
//// THE INITIAL DEVELOPER OR ANY OTHER CONTRIBUTOR) ASSUME THE COST OF ANY NECESSARY
//// SERVICING, REPAIR OR CORRECTION. THIS DISCLAIMER OF WARRANTY CONSTITUTES AN ESSENTIAL
//// PART OF THIS LICENSE. NO USE OF ANY COVERED CODE IS AUTHORIZED HEREUNDER EXCEPT UNDER
//// THIS DISCLAIMER.
////
//// Use at your own risk!
//// ==========================================================

#include "FreeImage.h"
#include "Utilities.h"
#include "../Metadata/FreeImageTag.h"

// ==========================================================
// Plugin Interface
// ==========================================================

static int s_format_id;

// ==========================================================
// Plugin Implementation
// ==========================================================

static const char * DLL_CALLCONV
Format() {
	return "PICT";
}

static const char * DLL_CALLCONV
Description() {
	return "Macintosh PICT";
}

static const char * DLL_CALLCONV
Extension() {
	return "pct,pict,pic";
}

static const char * DLL_CALLCONV
RegExpr() {
	return NULL; // there is now reasonable regexp for raw G3
}

static const char * DLL_CALLCONV
MimeType() {
	return "image/x-pict";
}

static BOOL
HasMagicHeader(FreeImageIO *io, fi_handle handle) {
	return FALSE;
}

static BOOL DLL_CALLCONV
Validate(FreeImageIO *io, fi_handle handle) {
	return FALSE;
}

static BOOL DLL_CALLCONV
SupportsExportDepth(int depth) {
	return FALSE;
}

static BOOL DLL_CALLCONV
SupportsExportType(FREE_IMAGE_TYPE type) {
	return FALSE;
}

static BOOL DLL_CALLCONV
SupportsICCProfiles() {
	return TRUE;
}

static BOOL DLL_CALLCONV
SupportsNoPixels() {
	return TRUE;
}

// ----------------------------------------------------------

static FIBITMAP * DLL_CALLCONV
Load(FreeImageIO *io, fi_handle handle, int page, int flags, void *data) {
	return NULL;
}

// ==========================================================
//   Init
// ==========================================================

void DLL_CALLCONV
InitPICT(Plugin *plugin, int format_id) {
	s_format_id = format_id;

	plugin->format_proc = Format;
	plugin->description_proc = Description;
	plugin->extension_proc = Extension;
	plugin->regexpr_proc = RegExpr;
	plugin->open_proc = NULL;
	plugin->close_proc = NULL;
	plugin->pagecount_proc = NULL;
	plugin->pagecapability_proc = NULL;
	plugin->load_proc = Load;
	plugin->save_proc = NULL;
	plugin->validate_proc = Validate;
	plugin->mime_proc = MimeType;
	plugin->supports_export_bpp_proc = SupportsExportDepth;
	plugin->supports_export_type_proc = SupportsExportType;
	plugin->supports_icc_profiles_proc = SupportsICCProfiles;
	plugin->supports_no_pixels_proc = SupportsNoPixels;
}
