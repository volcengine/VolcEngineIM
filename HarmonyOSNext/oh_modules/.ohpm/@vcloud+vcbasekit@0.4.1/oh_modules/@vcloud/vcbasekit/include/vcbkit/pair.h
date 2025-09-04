//
// Created by ByteDance on 2024/4/25.
//

#ifndef VCBASEKIT_PAIR_H
#define VCBASEKIT_PAIR_H

#include "vcbkit.h"

VCB_NAMESPACE_BEGIN

template <class T1, class T2>
struct Pair {
    T1 first;
    T2 second;
};

VCB_NAMESPACE_END
#endif // VCBASEKIT_PAIR_H
