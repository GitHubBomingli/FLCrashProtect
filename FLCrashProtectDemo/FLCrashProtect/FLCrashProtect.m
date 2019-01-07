//
//  FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "FLCrashProtect.h"
#import <objc/runtime.h>
#import "FLCrashSwizzling.h"
#import "FLCatchCrash.h"

@implementation FLCrashProtect

+ (instancetype)shareCrashProtect {
    static FLCrashProtect *crashProtect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashProtect = [[FLCrashProtect alloc] init];
    });
    return crashProtect;
}

- (void)registerCrashProtect:(FLCrashProtectOption)option {
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionUnrecognizedSelector) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(forwardingTargetForSelector:)
                                   swizzleSEL:NSSelectorFromString(@"fl_forwardingTargetForSelector:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionKVC) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(setValue:forKey:)
                                   swizzleSEL:NSSelectorFromString(@"fl_setValue:forKey:")];
            [FLCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(setValue:forUndefinedKey:)
                                   swizzleSEL:NSSelectorFromString(@"fl_setValue:forUndefinedKey:")];
            [FLCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(valueForUndefinedKey:)
                                   swizzleSEL:NSSelectorFromString(@"fl_valueForUndefinedKey:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionKVO) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(addObserver:forKeyPath:options:context:)
                                   swizzleSEL:NSSelectorFromString(@"fl_addObserver:forKeyPath:options:context:")];
            [FLCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(removeObserver:forKeyPath:)
                                   swizzleSEL:NSSelectorFromString(@"fl_removeObserver:forKeyPath:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionNotification) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSNotificationCenter.class
                                  originalSEL:@selector(addObserver:selector:name:object:)
                                   swizzleSEL:NSSelectorFromString(@"fl_addObserver:selector:name:object:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionContainer || option & FLCrashProtectOptionArray) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSPlaceholderArray")
                                  originalSEL:@selector(initWithObjects:count:)
                                   swizzleSEL:NSSelectorFromString(@"fl_initWithObjects:count:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_objectWithSingleObjectArrayIAtIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayI")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_objectWithArrayIAtIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArray0")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_objectWithArray0AtIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                                  originalSEL:@selector(objectAtIndexedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"fl_objectWithSingleObjectArrayIAtIndexedSubscript:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayI")
                                  originalSEL:@selector(objectAtIndexedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"fl_objectWithArrayIAtIndexedSubscript:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(insertObject:atIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_insertObject:atIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(removeObjectsInRange:)
                                   swizzleSEL:NSSelectorFromString(@"fl_removeObjectsInRange:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(removeObjectAtIndex:)                                   swizzleSEL:NSSelectorFromString(@"fl_removeObjectAtIndex:")];

            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(replaceObjectAtIndex:withObject:)
                                   swizzleSEL:NSSelectorFromString(@"fl_replaceObjectAtIndex:withObject:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(exchangeObjectAtIndex:withObjectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_exchangeObjectAtIndex:withObjectAtIndex:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionContainer || option & FLCrashProtectOptionDictionary) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(setObject:forKey:)
                                   swizzleSEL:NSSelectorFromString(@"fl_setObject:forKey:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(setObject:forKeyedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"fl_setObject:forKeyedSubscript:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(removeObjectForKey:)
                                   swizzleSEL:NSSelectorFromString(@"fl_removeObjectForKey:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSPlaceholderDictionary")
                                  originalSEL:@selector(initWithObjects:forKeys:count:)
                                   swizzleSEL:NSSelectorFromString(@"fl_initWithObjects:forKeys:count:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionContainer || option & FLCrashProtectOptionString) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"NSPlaceholderString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"fl_initWithString:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(stringByAppendingString:)
                                   swizzleSEL:NSSelectorFromString(@"fl_stringByAppendingString:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(characterAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_characterAtIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringToIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_substringToIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringFromIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_substringFromIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringWithRange:)
                                   swizzleSEL:NSSelectorFromString(@"fl_substringWithRange:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"NSPlaceholderMutableString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"fl_initWithString:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(appendString:)
                                   swizzleSEL:NSSelectorFromString(@"fl_appendString:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(stringByAppendingString:)
                                   swizzleSEL:NSSelectorFromString(@"fl_stringByAppendingString:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(insertString:atIndex:)
                                   swizzleSEL:NSSelectorFromString(@"fl_insertString:atIndex:")];
            [FLCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(deleteCharactersInRange:)
                                   swizzleSEL:NSSelectorFromString(@"fl_deleteCharactersInRange:")];
        });
    }
    if (option & FLCrashProtectOptionAll || option & FLCrashProtectOptionCatchCrash) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FLCatchCrash registerHandler];
        });
    }
    
}

@end
