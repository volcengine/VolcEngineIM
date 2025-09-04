//
// Created on 2023/6/6.
//

#ifndef VCBASEKIT_FUNCTION_H
#define VCBASEKIT_FUNCTION_H

#include "base_ref.h"
#include "vcbkit.h"
#include "ref_ptr.h"
#include "unsafe.h"
#include <utility>
#include <type_traits>


VCB_NAMESPACE_BEGIN

/// @cond HIDDEN_SYMBOLS
class Callable : public BaseRef {
public:
    Callable() = default;
    virtual void invoke() const = 0;

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(Callable);
};

template<typename T>
class Functor : public Callable
{
public:
    template <typename U>
    explicit Functor(U &&obj): functor(std::forward<U>(obj)){}

    void invoke() const override {
        return functor();
    }
private:
    T functor;
};
/// @endcond

/// @cond HIDDEN_SYMBOLS
template <typename T>
class Function;
/// @endcond

template <>
class Function<void()> {
public:
    template <class U>
    Function(U &&obj) // NOLINT(*-explicit-constructor, *-forwarding-reference-overload)
    {
        callable.reset(RefPtr<Functor<std::remove_reference_t<U>>>::makeNew(std::forward<U>(obj)));
    }


    Function(std::nullptr_t) {} // NOLINT(*-explicit-constructor)
    Function() = default;

    Function(const Function& other) // NOLINT(*-use-equals-default)
    :callable(other.callable)
    {}
    Function(Function&& other) noexcept
    :callable(std::move(other.callable)){}

    Function& operator=(const Function &other) {
        callable.reset(other.callable);
        return *this;
    }
    Function &operator=(Function &&other)  noexcept {
        callable.reset(std::move(other.callable));
        return *this;
    }


    void operator()() const
    {
        return callable->invoke();
    }


    bool operator==(std::nullptr_t) const {
        return !static_cast<bool>(callable);
    }

    explicit operator bool() const {
        return static_cast<bool>(callable);
    }

private:
    RefPtr<Callable> callable {};
};


VCB_NAMESPACE_END

#endif // VCBASEKIT_FUNCTION_H
