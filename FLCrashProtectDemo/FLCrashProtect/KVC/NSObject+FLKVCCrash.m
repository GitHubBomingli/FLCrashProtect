//
//  NSObject+FLKVCCrash.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/7.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSObject+FLKVCCrash.h"
#import "FLCrashReport.h"

@implementation NSObject (FLKVCCrash)

/*
 setValue:forKeyPath:方法 和 setValuesForKeysWithDictionary:方法最后都会执行setValue:forKey:方法
 */
- (void)fl_setValue:(id)value forKey:(NSString *)key {
    if (key) {
        [self fl_setValue:value forKey:key];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setValue:forKey:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}
// 对未定义的属性赋值都会执行setValue:forUndefinedKey:
- (void)fl_setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: this class does not find this key (%@)", self.class, NSStringFromSelector(@selector(setValue:forUndefinedKey:)), key];
    [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
}
// 对未定义的属性取值都会执行valueForUndefinedKey:
- (id)fl_valueForUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: this class does not find this key (%@)", self.class, NSStringFromSelector(@selector(valueForUndefinedKey:)), key];
    [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    return nil;
}

@end
