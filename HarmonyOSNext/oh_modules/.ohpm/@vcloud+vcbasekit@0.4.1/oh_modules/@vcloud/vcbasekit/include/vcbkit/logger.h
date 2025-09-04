//
// Created on 2023/5/26.
//

#ifndef VCBASEKIT_LOGGER_H
#define VCBASEKIT_LOGGER_H

#include "attributes.h"
#include "vcbkit.h"

#include <stdarg.h>


#define VCBLOG_LEVEL_VERBOSE 0
#define VCBLOG_LEVEL_DEBUG   1
#define VCBLOG_LEVEL_INFO    2
#define VCBLOG_LEVEL_WARN    3
#define VCBLOG_LEVEL_ERROR   4
#define VCBLOG_LEVEL_FATAL   5
#define VCBLOG_LEVEL_SILENT  6

/**
 * #define ALOG_LEVEL_VERBOSE 0
 * #define ALOG_LEVEL_DEBUG   1
 * #define ALOG_LEVEL_INFO    2
 * #define ALOG_LEVEL_WARN    3
 * #define ALOG_LEVEL_ERROR   4
 * #define ALOG_LEVEL_FATAL   5
 * #define ALOG_LEVEL_SILENT  6
 */


#ifdef __cplusplus
extern "C" {
#endif


/**
 * Print log with 'fmt' string and va_list
 * The parts exceeding 4096 bytes will be discarded
 */
VCBASEKIT_PUBLIC void vcbkit_logs(unsigned int level, const char *tag, const char *filename, const char *func_name, int line, const char *fmt, va_list args);

/**
 * Print log with 'fmt' and variable parameter
 * The parts exceeding 4096 bytes will be discarded
 */
VCBASEKIT_PUBLIC void vcbkit_logf(unsigned int level, const char *tag, const char *filename, const char *func_name, int line, const char *fmt, ...);

/**
 * Direct print a string message
 * The parts exceeding 4096 bytes will be discarded
 */
VCBASEKIT_PUBLIC void vcbkit_logm(unsigned int level, const char *tag, const char *filename, const char *func_name, int line, const char *msg);

/**
 * Print message longer than 4096 bytes
 * Automatically split message into multiple lines, but not discarded
 */
VCBASEKIT_PUBLIC void vcbkit_logl(unsigned int level, const char *tag, const char *filename, const char *func_name, int line, const char *fmt, va_list args);


VCBASEKIT_PUBLIC int vcbkit_init_logger_wrapper();

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

VCB_NAMESPACE_BEGIN

template<typename... Args>
constexpr bool is_empty(Args... args) {
    return sizeof...(args) == 0;
}

VCB_NAMESPACE_END

#define VLOG(level, tag, fmt, ...)                                                          \
    if (is_empty(__VA_ARGS__)) {                                                            \
        vcbkit_logm(level, tag, __FILE_NAME__, __FUNCTION__, __LINE__, fmt);                \
    } else {                                                                                \
        vcbkit_logf(level, tag, __FILE_NAME__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__); \
    }


#else // not cpluscplus

#define VLOG(level, tag, fmt, ...)   \
    vcbkit_logf(level, tag, __FILE_NAME__, __FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);

#endif // __cplusplus



#if defined(__DEBUG__)
#define VLOGD(tag, fmt, ...)  VLOG(VCBLOG_LEVEL_DEBUG, tag, fmt, ##__VA_ARGS__)
#else
#define VLOGD(tag, fmt, ...)
#endif

#define VLOGI(tag, fmt, ...)  VLOG(VCBLOG_LEVEL_INFO,  tag, fmt, ##__VA_ARGS__)
#define VLOGW(tag, fmt, ...)  VLOG(VCBLOG_LEVEL_WARN,  tag, fmt, ##__VA_ARGS__)
#define VLOGE(tag, fmt, ...)  VLOG(VCBLOG_LEVEL_ERROR, tag, fmt, ##__VA_ARGS__)


#endif //VCBASEKIT_LOGGER_H
