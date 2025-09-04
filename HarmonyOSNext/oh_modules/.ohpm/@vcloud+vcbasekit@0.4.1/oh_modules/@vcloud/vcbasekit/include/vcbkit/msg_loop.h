//
// Created on 2023/6/2.
//

#ifndef VCBASEKIT_MESSAGE_LOOP_H
#define VCBASEKIT_MESSAGE_LOOP_H

#include "vcbkit.h"
#include "ref_ptr.h"
#include "time_util.h"
#include "thread.h"
#include "function.h"

VCB_NAMESPACE_BEGIN

using closure = Function<void()>;

/**
 * An event loop associated with a thread.
 *
 * This class is the generic abstract api to the MessageLoop, differences in
 * implementation based on the running platform.
 * @attention This class is thread-safe.
 */
class VCBASEKIT_PUBLIC MsgLoop : public BaseRef, public AnyCall {

public:
    enum MessageTaskType {
        TaskTypeDefault = 1,
        TaskTypeLoop = 2,
        TaskTypeSmartService = 3,
        TaskTypeSmartTask = 4,
    };

    enum  MessageLoopType {
        TypeOsDefault = 0,
        TypeLinuxEpoll = 1,    // avaiable on ohos, linux
        TypeAndroidLooper = 2, // avaiable on android
        TypeAppleRunLoop = 3,  // avaiable on apple
        TypeOhosLibUV = 4,     // avaiable on ohos
    };

protected:
    MsgLoop() = default;

public:

    /**
     * Create a new MsgLoop with thread name
     * @param name the thread name, can be nullptr
     * @return A msgLoop wrapped in a Smart Pointer
     */
    static RefPtr<MsgLoop> spawn(const char *name = nullptr);
    static RefPtr<MsgLoop> spawn(MessageLoopType type, const char *name);

    void postTask(const closure& task, TimeDelta delay);
    void postTask(const closure& task, MessageTaskType type, TimeDelta delay);
    virtual void postTask(const closure& task, TimeDelta target_time, MessageTaskType type) = 0;

    virtual void doTerminal() = 0;
    virtual void disposeTasks(size_t limitNum) = 0;
    virtual void disposeTaskByType(MessageTaskType type) = 0;

    virtual bool runOnCurrentThread() = 0;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(MsgLoop);

};


VCB_NAMESPACE_END

#endif // VCBASEKIT_MESSAGE_LOOP_H
