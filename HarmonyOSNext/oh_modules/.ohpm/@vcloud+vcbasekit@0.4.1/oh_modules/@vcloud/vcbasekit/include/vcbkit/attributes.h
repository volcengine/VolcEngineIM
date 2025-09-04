
#ifndef VCBASEKIT_ATTRIBUTES
#define VCBASEKIT_ATTRIBUTES

/**
 * @brief VCBaseKit Attributes is header only which include preprocess macro for
 *  **visibility** and (**inline** [todo])
 */

// clang-format off

/// @cond HIDDEN_SYMBOLS

/** Define your own visibility macro base on VCB_HELPER_*
 *  For example in libvcn:
 *  
 *  copy next 11 lines to your headers, and then rename the LIBVCN  prefix
    #if LIBVCN_DLL  // build libvcn as a dynamic library
      #ifdef LIBVCN_DLL_EXPORTS // defined if we are building the libvcn dynamic lib (instead of using it)
        #define LIBVCN_PUBLIC VCB_HELPER_EXPORT
      #else
        #define LIBVCN_PUBLIC VCB_HELPER_IMPORT
      #endif // LIBVCN_DLL_EXPORTS
      #define LIBVCN_HIDDEN VCB_HELPER_HIDDEN
    #else // LIBVCN_DLL is not defined: this means libvcn is a static lib.
      #define LIBVCN_PUBLIC
      #define LIBVCN_HIDDEN
    #endif
 * 
 * then you shuold define <LIBVCN>_DLL and <LIBVCN>_DLL_EXPORTS while build dynamic lib, 
 * and also define <LIBVCN>_DLL when you use a <LIBVCN> dynamic lib.
 */
#if defined _WIN32 || defined __CYGWIN__
  #define VCB_HELPER_IMPORT __declspec(dllimport)
  #define VCB_HELPER_EXPORT __declspec(dllexport)
  #define VCB_HELPER_HIDDEN
#else
  #if __GNUC__ >= 4
    #define VCB_HELPER_IMPORT __attribute__ ((visibility ("default")))
    #define VCB_HELPER_EXPORT __attribute__ ((visibility ("default")))
    #define VCB_HELPER_HIDDEN __attribute__ ((visibility ("hidden")))
  #else
    #define VCB_HELPER_IMPORT
    #define VCB_HELPER_EXPORT
    #define VCB_HELPER_HIDDEN
  #endif
#endif

#if VCBASEKIT_DLL  // build vcbasekit as a dynamic library
  #ifdef VCBASEKIT_DLL_EXPORTS // defined if we are building the vcbasekit dynamic lib (instead of using it)
    #define VCBASEKIT_PUBLIC VCB_HELPER_EXPORT
  #else
    #define VCBASEKIT_PUBLIC VCB_HELPER_IMPORT
  #endif // VCBASEKIT_DLL_EXPORTS
  #define VCBASEKIT_HIDDEN VCB_HELPER_HIDDEN
#else // VCBASEKIT_DLL is not defined: this means vcbasekit is a static lib.
  #define VCBASEKIT_PUBLIC
  #define VCBASEKIT_HIDDEN
#endif

/// @endcond

// clang-format on
#endif // VCBASEKIT_ATTRIBUTES
