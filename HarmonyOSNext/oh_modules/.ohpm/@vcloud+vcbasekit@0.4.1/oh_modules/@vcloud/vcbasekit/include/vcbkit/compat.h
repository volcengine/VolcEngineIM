//
// Created on 2023/7/4.
//

#ifndef VCBASEKIT_COMPAT_H
#define VCBASEKIT_COMPAT_H

#include "vcbkit.h"

VCB_NAMESPACE_BEGIN

/**
 * AnyCall is designed to keep same abi while add new method for abstract api class.
 * <p>
 * Do not use this class out of VCBaseKit
 */
class AnyCall {
public:
    AnyCall() = default;

    virtual ~AnyCall() = default;

protected:
    /**
     * A generically method without type constrict, can pass any argument and return any type
     * @param what use what to identify the method id.
     * @param anyIn wrap anything input to void*
     * @param anyOut wrap anything output to void*
     * @return can return anything with type void*
     */
    virtual void *anyCall(int what, void *anyIn, void *anyOut) {
        return nullptr;
    }
};

VCB_NAMESPACE_END

#endif // VCBASEKIT_COMPAT_H
