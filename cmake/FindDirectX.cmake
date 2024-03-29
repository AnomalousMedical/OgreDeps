#-------------------------------------------------------------------
# This file is part of the CMake build system for OGRE
#     (Object-oriented Graphics Rendering Engine)
# For the latest info, see http://www.ogre3d.org/
#
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Find DirectX SDK
# Define:
# DirectX_FOUND
# DirectX_INCLUDE_DIR
# DirectX_LIBRARY
# DirectX_ROOT_DIR

if(WIN32) # The only platform it makes sense to check for DirectX SDK
  include(FindPkgMacros)
  findpkg_begin(DirectX)
  
  # Get path, convert backslashes as ${ENV_DXSDK_DIR}
  getenv_path(DXSDK_DIR)
  getenv_path(DIRECTX_HOME)
  getenv_path(DIRECTX_ROOT)
  getenv_path(DIRECTX_BASE)
  
  # construct search paths
  set(DirectX_PREFIX_PATH 
    "${DXSDK_DIR}" "${ENV_DXSDK_DIR}"
    "${DIRECTX_HOME}" "${ENV_DIRECTX_HOME}"
    "${DIRECTX_ROOT}" "${ENV_DIRECTX_ROOT}"
    "${DIRECTX_BASE}" "${ENV_DIRECTX_BASE}"
    "C:/apps_x86/Microsoft DirectX SDK*"
    "C:/Program Files (x86)/Microsoft DirectX SDK*"
    "C:/apps/Microsoft DirectX SDK*"
    "C:/Program Files/Microsoft DirectX SDK*"
	"$ENV{ProgramFiles}/Microsoft DirectX SDK*"
  )
  
  # Windows 8 SDK has custom layout
  set(DirectX_INC_SEARCH_PATH 
    "C:/Program Files (x86)/Windows Kits/10/Include/10.0.18362.0/shared"
    "C:/Program Files (x86)/Windows Kits/10/Include/10.0.18362.0/um"
    "C:/Program Files (x86)/Windows Kits/10/Include/10.0.18362.0/shared"
    "C:/Program Files (x86)/Windows Kits/10/Include/10.0.18362.0/um"
    "C:/Program Files (x86)/Windows Kits/8.1/Include/shared"
    "C:/Program Files (x86)/Windows Kits/8.1/Include/um"
    "C:/Program Files (x86)/Windows Kits/8.0/Include/shared"
    "C:/Program Files (x86)/Windows Kits/8.0/Include/um"
  )
  set(DirectX_LIB_SEARCH_PATH 
	"C:/Program Files (x86)/Windows Kits/10/Lib/10.0.18362.0/um"
    "C:/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um"
    "C:/Program Files (x86)/Windows Kits/8.0/Lib/win8/um"
  )
  
  create_search_paths(DirectX)
  # redo search if prefix path changed
  clear_if_changed(DirectX_PREFIX_PATH
    DirectX_LIBRARY
	DirectX_INCLUDE_DIR
  )
  
  find_path(DirectX_INCLUDE_DIR NAMES d3d9.h HINTS ${DirectX_INC_SEARCH_PATH})

  # dlls are in DirectX_ROOT_DIR/Developer Runtime/x64|x86
  # lib files are in DirectX_ROOT_DIR/Lib/x64|x86
  # determine if we are compiling for a 32bit or 64bit system
  include(CheckTypeSize)
  CHECK_TYPE_SIZE("void*" _PTR_SIZE BUILTIN_TYPES_ONLY)
  if (_PTR_SIZE EQUAL 8)
    set(DirectX_LIBPATH_SUFFIX "x64")
  else ()
    set(DirectX_LIBPATH_SUFFIX "x86")
  endif ()
  find_library(DirectX_LIBRARY NAMES d3d9 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
  find_library(DirectX_D3DX9_LIBRARY NAMES d3dx9 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
  find_library(DirectX_DXERR_LIBRARY NAMES DxErr HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
  find_library(DirectX_DXGUID_LIBRARY NAMES dxguid HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
  find_library(DirectX_DINPUT8_LIBRARY NAMES dinput8 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
  

  # look for dxgi (needed by both 10 and 11)
  find_library(DirectX_DXGI_LIBRARY NAMES dxgi HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
  
  # look for d3dcompiler (needed by 11)
  find_library(DirectX_D3DCOMPILER_LIBRARY NAMES d3dcompiler HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})

  findpkg_finish(DirectX)
  set(DirectX_LIBRARIES ${DirectX_LIBRARIES} 
    ${DirectX_D3DX9_LIBRARY}
    ${DirectX_DXERR_LIBRARY}
    ${DirectX_DXGUID_LIBRARY}
  )
  
  mark_as_advanced(DirectX_D3DX9_LIBRARY DirectX_DXERR_LIBRARY DirectX_DXGUID_LIBRARY
    DirectX_DXGI_LIBRARY DirectX_D3DCOMPILER_LIBRARY)
  

  # look for D3D10 and D3D10.1 components
  if (DirectX_FOUND)
    find_path(DirectX_D3D10_INCLUDE_DIR NAMES D3D10_1shader.h HINTS ${DirectX_INC_SEARCH_PATH})
	get_filename_component(DirectX_LIBRARY_DIR "${DirectX_LIBRARY}" PATH)
	message(STATUS "DX lib dir: ${DirectX_LIBRARY_DIR}")
    find_library(DirectX_D3D10_LIBRARY NAMES d3d10 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
    find_library(DirectX_D3DX10_LIBRARY NAMES d3dx10 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
	if (DirectX_D3D10_INCLUDE_DIR AND DirectX_D3D10_LIBRARY)
	  set(DirectX_D3D10_FOUND TRUE)
	  set(DirectX_D3D10_INCLUDE_DIRS ${DirectX_D3D10_INCLUDE_DIR})
	  set(DirectX_D3D10_LIBRARIES  ${DirectX_D3D10_LIBRARIES}
	    ${DirectX_D3D10_LIBRARY}
	    ${DirectX_D3DX10_LIBRARY}
	    ${DirectX_DXGI_LIBRARY}
        ${DirectX_DXERR_LIBRARY}
        ${DirectX_DXGUID_LIBRARY}	  
      )
	endif ()
	mark_as_advanced(DirectX_D3D10_LIBRARY DirectX_D3DX10_LIBRARY DirectX_D3D10_INCLUDE_DIR)
  endif ()

  # look for D3D11 components
  if (DirectX_FOUND)
    find_path(DirectX_D3D11_INCLUDE_DIR NAMES D3D11Shader.h HINTS ${DirectX_INC_SEARCH_PATH})
	get_filename_component(DirectX_LIBRARY_DIR "${DirectX_LIBRARY}" PATH)
	message(STATUS "DX lib dir: ${DirectX_LIBRARY_DIR}")
    find_library(DirectX_D3D11_LIBRARY NAMES d3d11 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})
    find_library(DirectX_D3DX11_LIBRARY NAMES d3dx11 HINTS ${DirectX_LIB_SEARCH_PATH} PATH_SUFFIXES ${DirectX_LIBPATH_SUFFIX})	
	if (DirectX_D3D11_INCLUDE_DIR AND DirectX_D3D11_LIBRARY)
	  set(DirectX_D3D11_FOUND TRUE)
	  set(DirectX_D3D11_INCLUDE_DIR ${DirectX_D3D11_INCLUDE_DIR})
	  set(DirectX_D3D11_LIBRARIES ${DirectX_D3D11_LIBRARIES}
	    ${DirectX_D3D11_LIBRARY}
	    ${DirectX_D3DX11_LIBRARY}
	    ${DirectX_DXGI_LIBRARY}
        ${DirectX_DXERR_LIBRARY}
        ${DirectX_DXGUID_LIBRARY}
        ${DirectX_D3DCOMPILER_LIBRARY}        	  
      )	
    endif ()
	mark_as_advanced(DirectX_D3D11_INCLUDE_DIR DirectX_D3D11_LIBRARY DirectX_D3DX11_LIBRARY)
  endif ()
  
endif(WIN32)
