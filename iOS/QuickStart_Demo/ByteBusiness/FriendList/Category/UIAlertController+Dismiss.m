//
//  UIAlertController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/8/4.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "UIAlertController+Dismiss.h"

#import <objc/runtime.h>

@implementation UIAlertController (Dismiss)

- (void)setWontDismiss:(BOOL)wontDismiss
{
    objc_setAssociatedObject(self, @selector(wontDismiss), @(wontDismiss), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)wontDismiss
{
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSel = NSSelectorFromString(@"_dismissAnimated:triggeringAction:triggeredByPopoverDimmingView:dismissCompletion:");
        SEL swizzledSel = @selector(veim_dismissAnimated:
                                    triggeringAction:
                                    triggeredByPopoverDimmingView:
                                    dismissCompletion:);
        
        Method originalMtd = class_getInstanceMethod(class, originalSel);
        Method swizzledMtd = class_getInstanceMethod(class, swizzledSel);
        
        BOOL addMethodSuccess = class_addMethod(class,
                                                originalSel,
                                                method_getImplementation(swizzledMtd),
                                                method_getTypeEncoding(swizzledMtd));
        
        if (addMethodSuccess) {
            class_replaceMethod(class,
                                swizzledSel,
                                method_getImplementation(originalMtd),
                                method_getTypeEncoding(originalMtd));
        } else {
            method_exchangeImplementations(originalMtd, swizzledMtd);
        }
    });
}

- (void)veim_dismissAnimated:(BOOL)animation
            triggeringAction:(UIAlertAction *)action
triggeredByPopoverDimmingView:(id)view
           dismissCompletion:(id)handler
{
    if (action.style == UIAlertActionStyleCancel || self.wontDismiss == NO) {
        [self veim_dismissAnimated:animation triggeringAction:action triggeredByPopoverDimmingView:view dismissCompletion:handler];
    } else {
        SEL invokeHandler = NSSelectorFromString(@"_invokeHandlersForAction:");
        IMP imp = [self methodForSelector:invokeHandler];
        void (*func)(id, SEL, UIAlertAction *) = (void *)imp;
        func(self, invokeHandler, action);
    }
}

@end
