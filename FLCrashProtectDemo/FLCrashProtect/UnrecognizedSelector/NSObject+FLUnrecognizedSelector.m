//
//  NSObject+UnrecognizedSelector.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSObject+FLUnrecognizedSelector.h"
#import "FLCrashReport.h"
#import <objc/runtime.h>

@implementation FLForwardingTarget

/**
 default Implement
 
 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunctionForFLForwardingTarget(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethodForFLForwardingTarget(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunctionForFLForwardingTarget, funcTypeEncoding);
}

+ (instancetype)defaultForwardingTarget {
    static FLForwardingTarget *target = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        target = [[FLForwardingTarget alloc] init];
    });
    return target;
}

- (BOOL)addInstanceMethod:(SEL)instanceSEL {
    return __addMethodForFLForwardingTarget([FLForwardingTarget class], instanceSEL);
}

+ (BOOL)addClassMethod:(SEL)classSEL {
    Class metaClass = objc_getMetaClass(class_getName([FLForwardingTarget class]));
    return __addMethodForFLForwardingTarget(metaClass, classSEL);
}

@end

@implementation NSObject (FLUnrecognizedSelector)

- (id)fl_forwardingTargetForSelector:(SEL)aSelector {
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signatrue) {
        return self;
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: unrecognized selector sent to instance (%@)",self.class, NSStringFromSelector(aSelector), self];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        [FLForwardingTarget.defaultForwardingTarget addInstanceMethod:aSelector];
        return FLForwardingTarget.defaultForwardingTarget;
    }
}

@end
