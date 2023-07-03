package com.bytedance.im.interfaces;

import com.bytedance.im.core.api.interfaces.BIMResultCallback;

import java.util.List;
import java.util.Map;

/**
 * 检查用户是否存在
 */
public interface BIMUserExistChecker {
    void check(List<Long> uidList, BIMResultCallback<Map<Long,Boolean>> callback);
}
