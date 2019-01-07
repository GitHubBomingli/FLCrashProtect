//
//  NSMutableDictionary+FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/8.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSMutableDictionary+FLCrashProtect.h"
#import "FLCrashReport.h"

@implementation NSMutableDictionary (FLCrashProtect)

/*
 NSMutableDictionary实际对应的是__NSDictionaryM类
 setValue:forKey:也会执行setObject:forKey:
 */
- (void)fl_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setObject:forKey:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    if (!anObject) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil (key: %@)", self.class, NSStringFromSelector(@selector(setObject:forKey:)), aKey];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [self fl_setObject:anObject forKey:aKey];
}

- (void)fl_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    // obj可以为nil
    if (!key) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setObject:forKeyedSubscript:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [self fl_setObject:obj forKeyedSubscript:key];
}

- (void)fl_removeObjectForKey:(id)aKey {
    if (aKey) {
        [self fl_removeObjectForKey:aKey];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(removeObjectForKey:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}

@end
