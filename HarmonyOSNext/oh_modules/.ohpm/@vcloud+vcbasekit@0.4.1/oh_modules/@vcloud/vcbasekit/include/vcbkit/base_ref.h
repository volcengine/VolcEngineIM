//
// Created on 2023/5/18.
//

#ifndef VCBASEKIT_BASE_REF_H
#define VCBASEKIT_BASE_REF_H

#include "attributes.h"
#include "vcbkit.h"

VCB_NAMESPACE_BEGIN

/**
 * A base class for (thread-safe) reference-counted classes.
 * <p>
 * The method of BaseRef which adds or releases the reference is private.
 * The initial value of the reference is 1, it's managed by smart pointers.
 * In most cases, you don't need to worry about it.
 * <p> For example:
 * @code
 *      class Mem : public BaseRef {};
 *      auto m = RefPtr<Mem>::makeNew();
 * @endcode
 * @see RefPtr RefDyn
 * @attention This class is thread-safe.
 */
class VCBASEKIT_PUBLIC BaseRef {
public:
    BaseRef() : mCount(1) {}

    virtual ~BaseRef() = default;

    /**
     * return The current count of reference
     */
    inline int refCount() const {
        return __atomic_load_n(&mCount, __ATOMIC_RELAXED);
    }

    friend class UnSafe;

    template<typename F>
    friend class RefPtr;

    template<typename F>
    friend class RefDyn;
private:

    /**
     * Adds a reference to this object.
     */
    void incRef() const;

    /**
     * Releases a reference to this object. This will destroy this object once the
     * last reference is released.
     */
    void decRef() const;

    /**
     * This is a compatible method to replace the old BaseRef in ttplayer.
     * Do not use this in any other situation
     * @return the ref count after decRef
     */
    int decRefAndFetch() const;
private:
    mutable volatile int mCount;
};

VCB_NAMESPACE_END

#endif // VCBASEKIT_BASE_REF_H
