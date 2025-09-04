//
// Created on 2023/5/18.
//

#ifndef VCBASEKIT_REF_PTR_H
#define VCBASEKIT_REF_PTR_H

#include "base_ref.h"
#include "debug.h"
#include "vcbkit.h"

#include <cstdint>
#include <type_traits>
#include <utility>


namespace com {
namespace ss {
namespace ttm {
    class BaseRef;
}}}

VCB_NAMESPACE_BEGIN

template <typename T>
class RefDyn;

template <typename T>
class RefPtr;

template <typename T>
class Scoped;

template <>
class RefDyn<BaseRef> {
public:
    explicit operator bool() const {
        return mBase != 0;
    }

    bool operator==(const RefDyn<BaseRef> &other) const {
        return this->mBase == other.mBase;
    }

    bool operator!=(const RefDyn<BaseRef> &other) const {
        return this->mBase != other.mBase;
    }

    RefDyn<BaseRef>(const RefDyn<BaseRef> &) = delete;

    RefDyn<BaseRef>(RefDyn<BaseRef> &&other) = delete;

    RefDyn<BaseRef> &operator=(const RefDyn<BaseRef> &) = delete;

    RefDyn<BaseRef> &operator=(RefDyn<BaseRef> &&) = delete;

    virtual ~RefDyn<BaseRef>() = default;

    virtual void reset(RefDyn<BaseRef> &&any) = 0;

    template <typename F>
    friend class RefPtr;

    template <typename F>
    friend class RefDyn;

protected:
    RefDyn<BaseRef>() = default;

    uintptr_t mBase{0};
    debugexpr(std::size_t mSize{0});
};

template <typename T>
class RefPtr final {
public:

    template <class F = T, class... Args>
    static RefPtr<T> makeNew(Args &&...args) {
        static_assert(!std::is_base_of<com::ss::ttm::BaseRef, T>::value,  "Must not subclass of ttm::BaseRef");
        static_assert(!std::is_base_of<com::ss::ttm::BaseRef, F>::value,  "Must not subclass of ttm::BaseRef");
        return RefPtr<T>(new F(std::forward<Args>(args)...), InitTag::Init);
    }

private:
    enum InitTag {
        Init
    };

    explicit RefPtr(T *value, RefPtr<T>::InitTag) : mValue(value) {}

    explicit RefPtr(T *value) : mValue(value) {
        if (mValue) {
            mValue->incRef();
        }
    }

public:

    using Dyn = RefDyn<T>;
    
    template <typename F>
    friend class RefPtr;

    template <typename F>
    friend class WeakPtr;

    friend class UnSafe;

    // covariance
    template <typename F,
              typename = typename std::enable_if<
                      std::is_convertible<F *, T *>::value>::type>
    // NOLINTNEXTLINE(google-explicit-constructor)
    RefPtr(const RefPtr<F> &any) noexcept {
        static_assert(!std::is_same<F, T>::value, "Must not same type");
        mValue = static_cast<T*>(any.mValue);
        if (mValue) {
            mValue->incRef();
        }
    }

    RefPtr() = default;

    // NOLINTNEXTLINE(google-explicit-constructor)
    RefPtr(std::nullptr_t){}

    RefPtr(const RefPtr<T> &other) : mValue(other.mValue) {
        if (mValue) {
            mValue->incRef();
        }
    }

    RefPtr(RefPtr<T> &&other) noexcept {
        mValue = other.mValue;
        other.mValue = nullptr;
    }

    RefPtr& operator=(const RefPtr<T> &other) {
        if (this != &other) {
            reset(other);
        }
        return *this;
    }

    RefPtr& operator=(RefPtr<T> &&other) {
        if (this != &other) {
            reset(std::move(other));
        }
        return *this;
    }
    
    explicit operator bool() const {
        return mValue != nullptr;
    }

    bool operator == (const RefPtr<T> &other) const {
        return this->mValue == other.mValue;
    }

    bool operator != (const RefPtr<T> &other) const {
        return this->mValue != other.mValue;
    }

    T *operator->() {
        return mValue;
    }

    const T *operator->() const {
        return mValue;
    }

    template<class F = T>
    Scoped<F> scoped() const {
        static_assert(std::is_same<T,F>::value || std::is_base_of<T, F>::value, "cast self or subclass");
        return Scoped<F>(static_cast<F*>(mValue));
    }

    void drop() {
        if (mValue) {
            T *v = mValue;
            mValue = nullptr;
            v->decRef();
        }
    }

    void reset(RefDyn<BaseRef> &&other) {
        T *value = reinterpret_cast<T *>(other.mBase);
        assertm(other.mSize == sizeof(T), "Type not match");
        other.mBase = 0;
        drop();
        mValue = value;
    }

    void reset(RefPtr<T> &&other) {
        if (this != &other) {
            drop();
            mValue = other.mValue;
            other.mValue = nullptr;
        }
    }

    void reset(const RefPtr<T> &other) {
        if (this != &other) {
            drop();
            mValue = other.mValue;
            if (mValue)
                mValue->incRef();
        }
    }

    template <typename F, typename = typename std::enable_if<std::is_convertible<F *, T *>::value>::type>
    void reset(const RefPtr<F> &any) noexcept {
        static_assert(!std::is_same<F, T>::value, "Must not same type");
        drop();
        mValue = static_cast<T*>(any.mValue);
        if (mValue) {
            mValue->incRef();
        }
    }

    ~RefPtr() {
        drop();
    }

    RefDyn<T> toDyn() const {
        return RefDyn<T>(mValue);
    }

private:
    T *mValue{nullptr};
};

template <typename T>
class VCBASEKIT_PUBLIC RefDyn final : public RefDyn<BaseRef> {
public:
    RefDyn() {
        debugexpr(mSize = sizeof(T));
    }

    ~RefDyn() override {
        drop();
    }

    RefDyn(RefDyn &&other) noexcept {
        mBase = other.mBase;
        other.mBase = 0;
        debugexpr(mSize = other.mSize);
    }

    template<class F = T>
    Scoped<F> scoped() {
        static_assert(std::is_same<T,F>::value || std::is_base_of<T, F>::value, "cast self or subclass");
        return Scoped<F>(static_cast<F*>(reinterpret_cast<T*>(mBase)));
    }

    void drop() {
        T *tmp = reinterpret_cast<T *>(mBase);
        mBase = 0;
        if (tmp) {
            tmp->decRef();
        }
    }

    void reset(RefDyn<BaseRef> &&any) override {
        if (this != &any) {
            assertm(any.mSize == sizeof(T), "Type not match");
            T *tmp = reinterpret_cast<T *>(mBase);
            if (tmp) {
                tmp->decRef();
            }
            mBase = any.mBase;
            any.mBase = 0;
            debugexpr(mSize = sizeof(T));
        }
    }

    friend class RefPtr<T>;

private:
    explicit RefDyn(T *value) {
        if (value) {
            value->incRef();
        }
        mBase = reinterpret_cast<uintptr_t>(value);
        debugexpr(mSize = sizeof(T));
    }
};

/**
 * A scoped pointer, only used in stack.
 * Must not be used in heap.
 *
 * Scoped is generate from a RefPtr, and must be live shorter than RefPtr
 */
template <typename T>
class Scoped final {

public:
    
    Scoped(const Scoped& other) {
        mValue = other.mValue;
    }

    Scoped(Scoped &&)  noexcept = default;

    template <typename F>
    friend class Scoped;
    
    // covariance
    template <typename F,
            typename = typename std::enable_if<
                    std::is_convertible<F *, T *>::value>::type>
    // NOLINTNEXTLINE(google-explicit-constructor)
    Scoped(const Scoped<F> &any) noexcept {
        static_assert(!std::is_same<F, T>::value, "Must not same type");
        mValue = static_cast<T*>(any.mValue);
    }

    inline T* operator->() {
        return mValue;
    }

    inline explicit operator bool() const {
        return mValue != nullptr;
    }

    template <typename F>
    friend class RefPtr;

    template <typename F>
    friend class RefDyn;

    friend class UnSafe;

private:
    explicit Scoped(T *value):mValue(value){}
private:
    T * mValue;
};
VCB_NAMESPACE_END

#endif // VCBASEKIT_REF_PTR_H
