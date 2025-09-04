//
// Created by Yuguo Li on 2023/9/25.
//

#ifndef VCBASEKIT_UNEXPECTED_H
#define VCBASEKIT_UNEXPECTED_H

#include "attributes.h"

#ifdef __cplusplus
#include "daemon.h"
#include "ref_ptr.h"
#include "string.h"
#include "pair.h"
#include "thread.h"
#include "vcbkit.h"
#include "wait_event.h"
#include <cinttypes>
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    BackTraceCurrent = 1,
    // BackTraceAll = 2,
    // BackTraceThread = 3,
} BackTraceType;


/**
 * Ensure your code not reach here.
 * This report a custom exception to slardar APM, that helps you find the unexpected code execute
 * <p>
 * C style API
 */
VCBASEKIT_PUBLIC void vcbkit_unexpected_reach(const char *message, BackTraceType type);

#ifdef __cplusplus
}
#endif


#ifdef __cplusplus

VCB_NAMESPACE_BEGIN


class VCBASEKIT_PUBLIC UnExpected final {
public:
    /**
     * Ensure your code not reach here.
     * This report a custom exception to slardar APM, that helps you find the unexpected code execute
     */
    static void notReachHere(const char *message, BackTraceType type = BackTraceType::BackTraceCurrent)
    {
        vcbkit_unexpected_reach(message, type);
    }


    static void reportIfTimeout(RefPtr<Thread>& thread, TimeDelta delay);

    static void reportIfTimeout(RefPtr<SerialWaitEvent> event, int serial, TimeDelta delay);

    static void reportCustomData(const char *message,
                                 const char *frames,
                                 const Pair<StringView, StringView> data[],
                                 int dataLength);

private:

    static void reportStack(const char *message, const RefPtr<Thread> &thread);
};

VCB_NAMESPACE_END

#endif //__cplusplus

#endif // VCBASEKIT_UNEXPECTED_H
