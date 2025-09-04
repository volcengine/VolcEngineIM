#ifndef VCBASEKIT_DEFER_H
#define VCBASEKIT_DEFER_H

#include <tuple>
#include <utility>

#include "function.h"
#include "weak_ptr.h"

VCB_NAMESPACE_BEGIN


/**
 * @class Defer
 * @brief The Defer class provides a mechanism for deferring the execution of a task until the object is destroyed.
 */
template <typename F, typename... Args>
class Defer final {
public:
    /**
     * @brief Constructs a Defer object with the specified task.
     * @param task The task to be deferred.
     */
    explicit Defer(F &&fn, Args &&...args) :
            func(std::forward<F>(fn)),
            args(std::forward_as_tuple(std::forward<Args>(args)...)){}

    /**
     * @brief Destroys the Defer object and executes the deferred task.
     */
    ~Defer() {
        std::apply(std::move(func), std::move(args));
    }

private:
    F func;
    std::tuple<Args...> args;

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(Defer);
};

template <typename F, typename... Args>
Defer(F &&, Args &&...) -> Defer<F, Args...>;


using closure = Function<void()>;

/**
 * @class MtDefer, a Defer used in multiple threads.
 * Like Defer, MtDefer execution of a task until the object is destroyed.
 * But MtDefer has thread safe refCount, can be shared between different threads.
 */
class MtDefer final : public BaseRef {

public:
    /**
    * @brief Constructs a MtDefer object with the specified task.
    * @param task The task to be deferred.
    */
    explicit MtDefer(closure task):defer(std::move(task)), mWeak(this){}

    /**
    * @brief Destroys the MtDefer object and executes the deferred task.
    */
    ~MtDefer() override {
        discard();
    }

    /**
     * Executes the deferred task manually
     */
    void discard() {
        if (defer) {
            defer();
        }
        defer = nullptr;
    }


    /**
     * Returns a weak pointer to the underlying `MtDefer` object.
     *
     * @return A `WeakPtr` to the `MtDefer` object.
     */
    WeakPtr<MtDefer> weak() {
        return mWeak.weak();
    }

private:
    closure  defer;
    WeakHolder<MtDefer> mWeak;
};


VCB_NAMESPACE_END

#endif // VCBASEKIT_DEFER_H
