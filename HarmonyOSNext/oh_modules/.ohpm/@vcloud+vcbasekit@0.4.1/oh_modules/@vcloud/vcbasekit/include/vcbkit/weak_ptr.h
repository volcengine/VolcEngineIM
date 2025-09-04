//
// Created on 2023/6/29.
//

#ifndef VCBASEKIT_WEAK_REF_H
#define VCBASEKIT_WEAK_REF_H

#include "attributes.h"
#include "ref_ptr.h"
#include "vcbkit.h"
#include "unsafe.h"

VCB_NAMESPACE_BEGIN

class WeakBox;

template <typename T>
class WeakHolder;

template <typename T>
class WeakPtr;

template<>
class VCBASEKIT_PUBLIC WeakPtr<BaseRef> {
protected:
    WeakPtr();
    explicit WeakPtr(const RefPtr<WeakBox> &box);

    WeakPtr &operator=(const WeakPtr<BaseRef> &other);
    WeakPtr(const WeakPtr<BaseRef> &other);

    uintptr_t lock();

    ~WeakPtr();

protected:
    RefPtr<WeakBox> mBox;
};

template <typename T>
class VCBASEKIT_PUBLIC WeakPtr final : public WeakPtr<BaseRef> {

public:
    WeakPtr() = default;

    RefPtr<T> promote() {
        uintptr_t ptr = lock();
        T* v = reinterpret_cast<T*>(ptr);
        // Already incRef inner lock()
        return RefPtr<T>(v, RefPtr<T>::Init);
    }

protected:
    explicit WeakPtr(const RefPtr<WeakBox> &box):
            WeakPtr<BaseRef>(box) {}

    friend class WeakHolder<T>;
};

template <>
class VCBASEKIT_PUBLIC WeakHolder<BaseRef> {

protected:
    explicit WeakHolder(uintptr_t ptr, BaseRef *ref);
    ~WeakHolder();

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(WeakHolder);

protected:
    RefPtr<WeakBox> mBox;
};

template <typename T>
class WeakHolder final : public WeakHolder<BaseRef> {
public:
    explicit WeakHolder(T *ptr) : WeakHolder<BaseRef>(reinterpret_cast<uintptr_t>(ptr), static_cast<BaseRef*>(ptr)) {}

    ~WeakHolder() = default;

    WeakPtr<T> weak() {
        return WeakPtr<T>(mBox);
    }
};


VCB_NAMESPACE_END

#endif // VCBASEKIT_WEAK_REF_H
