//
//  FLCrashSwizzling.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "FLCrashSwizzling.h"
#import <objc/runtime.h>

@implementation FLCrashSwizzling

+ (void)swizzlingMethod:(Class)clazz originalSEL:(SEL)originalSEL swizzleSEL:(SEL)swizzleSEL {
    // 如果originalSel没有实现过，class_getInstanceMethod无法找到该方法，所以originalMethod为nil
    Method originalMethod = class_getInstanceMethod(clazz, originalSEL);
    Method swizzleMethod = class_getInstanceMethod(clazz, swizzleSEL);
    
    if (!originalMethod)  {
        class_addMethod(clazz, originalSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        method_setImplementation(swizzleMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    
    BOOL didAddMethod = class_addMethod(clazz, originalSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        //  当originalMethod为nil时，这里的class_replaceMethod将不做替换，所以swizzleSel方法里的实现还是自己原来的实现
        class_replaceMethod(clazz, swizzleSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@end
