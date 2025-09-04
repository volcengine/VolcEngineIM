//
// Created on 2023/5/24.
//

#ifndef VCBASEKIT_UNSAFE_H
#define VCBASEKIT_UNSAFE_H

#include "vcbkit.h"
#include "base_ref.h"
#include "attributes.h"
#include "ref_ptr.h"

VCB_NAMESPACE_BEGIN

class ScopedJniEnv;

template <typename T>
class RefPtr;

class VCBASEKIT_PUBLIC UnSafe final {
public:

    template <class T>
    static Scoped<T> asScoped(T *v)
    {
        return Scoped<T>(v);
    }

    /**
     * @brief incRef with nullptr check
     * 
     * @param ref pointer to BaseRef, can be null
     */
    static void incRef(BaseRef *ref);

    /**
     * @brief decRef with nullptr check
     * 
     * @param ref pointer to BaseRef, can be null
     */
    static void decRef(BaseRef *ref);

    /**
     * This is a compatible method to replace the old BaseRef in player.
     * Do not use this in any other situation
     * @return the ref count after decRef
     */
    static int decRefAndFetch(BaseRef *ref);

    // Init RefPtr from manual, do not incRef
    template <class T>
    static RefPtr<T> initRefPtr(T *value) {
        static_assert(!std::is_base_of<com::ss::ttm::BaseRef, T>::value, "Must not subclass of ttm::BaseRef");
        return RefPtr<T>(value, RefPtr<T>::Init);
    }

    // Create RefPtr from raw ptr value, and incRef
    template <class T>
    static RefPtr<T> toRefPtr(T *value) {
        static_assert(!std::is_base_of<com::ss::ttm::BaseRef, T>::value, "Must not subclass of ttm::BaseRef");
        return RefPtr<T>(value);
    }

    template <class T>
    static T* refPtrToRaw(RefPtr<T> &rp) {
        static_assert(!std::is_base_of<com::ss::ttm::BaseRef, T>::value, "Must not subclass of ttm::BaseRef");
        return rp.mValue;
    }

    template <class T>
    static const T* refPtrToRaw(const RefPtr<T> &rp) {
        static_assert(!std::is_base_of<com::ss::ttm::BaseRef, T>::value, "Must not subclass of ttm::BaseRef");
        return rp.mValue;
    }

    // Only available on Android
    static ScopedJniEnv* toHeapJniEnvIfAttached(ScopedJniEnv &&env);

};


VCB_NAMESPACE_END


#endif // VCBASEKIT_UNSAFE_H
