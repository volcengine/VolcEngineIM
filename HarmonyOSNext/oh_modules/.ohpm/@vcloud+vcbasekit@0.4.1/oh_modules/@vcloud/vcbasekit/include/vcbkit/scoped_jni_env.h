#pragma once

#include "attributes.h"
#include "vcbkit.h"
#include <jni.h>

VCB_NAMESPACE_BEGIN

class UnSafe;
/**
 * ScopedJniEnv should only be used in stack, not heap.
 * Attach and detach jnienv automatically
 *
 * Example:
 * ScopedJniEnv jenv;
 * jenv->xxx;
 */
class VCBASEKIT_PUBLIC ScopedJniEnv {
public:
    ScopedJniEnv();

    ScopedJniEnv(JNIEnv *env);

    ~ScopedJniEnv();

    ScopedJniEnv(const ScopedJniEnv &) = delete;

    ScopedJniEnv &operator=(const ScopedJniEnv &) = delete;

    explicit operator bool() const {
        return mEnv != nullptr;
    }

    JNIEnv *operator->() {
        return mEnv;
    }

    JNIEnv *env() {
        return mEnv;
    }

private:
    ScopedJniEnv *toHeap();

    friend class UnSafe;
    friend class ScopedJniEnvUt;
protected:
    bool mAttach{false};
    JNIEnv *mEnv{nullptr};
};

VCB_NAMESPACE_END
