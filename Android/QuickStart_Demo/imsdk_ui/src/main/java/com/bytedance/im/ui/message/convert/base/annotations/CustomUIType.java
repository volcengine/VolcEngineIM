package com.bytedance.im.ui.message.convert.base.annotations;


import com.bytedance.im.core.model.inner.msg.BIMBaseElement;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface CustomUIType {
    Class<? extends BIMBaseElement> contentCls();
}
