//
// Created on 2024/1/10
//

#ifndef VCBASEKIT_DAEMON_H
#define VCBASEKIT_DAEMON_H

#include "vcbkit.h"
#include "msg_loop.h"

VCB_NAMESPACE_BEGIN


/**
 * @brief The Daemon class represents a singleton object that manages tasks in a separate thread.
 */
class VCBASEKIT_PUBLIC Daemon final {

public:
    /**
     * @brief Returns the instance of the Daemon class.
     * @return The instance of the Daemon class.
     */
    static Daemon& instance();

    /**
     * @brief Posts a task to be executed by the Daemon.
     * @param task The task to be executed.
     * @param delay The delay before executing the task.
     */
    void postTask(const closure& task, TimeDelta delay) {
        mLoop->postTask(task, delay);
    }

private:
    /**
     * @brief Private constructor to prevent direct instantiation of the Daemon class.
     */
    Daemon();

    RefPtr<MsgLoop> mLoop;

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(Daemon);
};


VCB_NAMESPACE_END


#endif // VCBASEKIT_DAEMON_H

