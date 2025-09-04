//
// Created on 2023/5/19.
//

#ifndef VCBASEKIT_VCBKIT_H
#define VCBASEKIT_VCBKIT_H

/// @cond HIDDEN_SYMBOLS

#define VCB_DISALLOW_COPY(TypeName) TypeName(const TypeName &) = delete

#define VCB_DISALLOW_ASSIGN(TypeName) \
    TypeName &operator=(const TypeName &) = delete

#define VCB_DISALLOW_MOVE(TypeName) \
    TypeName(TypeName &&) = delete; \
    TypeName &operator=(TypeName &&) = delete

#define VCB_DISALLOW_COPY_AND_ASSIGN(TypeName) \
    VCB_DISALLOW_COPY(TypeName);               \
    VCB_DISALLOW_ASSIGN(TypeName)

#define VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(TypeName) \
    VCB_DISALLOW_COPY_AND_ASSIGN(TypeName);         \
    VCB_DISALLOW_MOVE(TypeName)

#define VCB_DISALLOW_IMPLICIT_CONSTRUCTORS(TypeName) \
    TypeName() = delete;                             \
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(TypeName)

#define VCB_NAMESPACE_BEGIN \
    namespace com {         \
    namespace ss {          \
    namespace vcbkit {

#define VCB_NAMESPACE_END \
    }                     \
    }                     \
    }

#define USING_VCB_NAMESPACE using namespace com::ss::vcbkit;


#if defined(__has_cpp_attribute)
#if __has_cpp_attribute(nodiscard)
#define VCB_NODISCARD [[nodiscard]]
#endif
#endif
#if !defined(VCB_NODISCARD)
#if defined(_MSC_VER) && (_MSC_VER >= 1700)
#define VCB_NODISCARD _Check_return_
#elif defined(__GNUC__)
#define VCB_NODISCARD __attribute__((__warn_unused_result__))
#else
#define VCB_NODISCARD
#endif
#endif

/// @endcond

#endif // VCBASEKIT_VCBKIT_H
