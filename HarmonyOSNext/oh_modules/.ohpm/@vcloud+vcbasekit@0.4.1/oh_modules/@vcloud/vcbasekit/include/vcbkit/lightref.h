/*
 * Copyright (C) 2017 The Android Open Source Project
 * Copyright (C) 2022 Bytedance
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file lightref.h
 * @owner baishuai@bytedance.com
 *
 * @brief object reference for custom smart pointer and object life management.
 * 
 * The class LightRef and VirtualRef are designed to be inherited.
 * So must keep the c++ abi stability.
 * 
 * LightRef has no virtual method, while VirtualRef has a virtual destructor.
 * LightRef is template while VirtualRef is no template.
 * 
 * If your class has on virtual method, your class should inherit LightRef.
 * Or you can inherit VirtualRef.
 *
 * Light means this is lighter than the ref that have both strong and weak ref
 */


#ifndef VCBASEKIT_LIGHTREF_H
#define VCBASEKIT_LIGHTREF_H

#include "vcbkit.h"
#include <atomic>

VCB_NAMESPACE_BEGIN

/// @cond HIDDEN_SYMBOLS

/**
 * @deprecated Use BaseRef instead
 */
template<class T>
class LightRef {
public:
    inline LightRef() : mCount(0) {}

    /**
     * @brief increase strong ref atomically
     * 
     * @param id debug only
     */
    inline void incStrong(__attribute__((unused)) const void *id) const {
        mCount.fetch_add(1, std::memory_order_relaxed);
    }

    /**
     * @brief decrease strong ref atomically
     *
     * @param id debug only
     */
    inline void decStrong(__attribute__((unused)) const void *id) const {
        if (mCount.fetch_sub(1, std::memory_order_release) == 1) {
            std::atomic_thread_fence(std::memory_order_acquire);
            delete static_cast<const T *>(this);
        }
    }

    /**
     * @brief Get current strong ref count atomically.
     * @notice 
     *      !!!DEBUGGING ONLY!!!
     * @return int32_t, current strong ref count
     */
    inline int32_t getStrongCount() const {
        return mCount.load(std::memory_order_relaxed);
    }

protected:
    inline ~LightRef() {}

private:
    mutable std::atomic<int32_t> mCount;
};


// This is a wrapper around LightRef that simply enforces a virtual
// destructor to eliminate the template requirement of LightRef
class VirtualRef : public LightRef<VirtualRef> {
public:
    virtual ~VirtualRef() = default;
};

/// @endcond

VCB_NAMESPACE_END

#endif //VCBASEKIT_LIGHTREF_H