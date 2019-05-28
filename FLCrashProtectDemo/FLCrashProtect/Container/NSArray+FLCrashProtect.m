//
//  NSArray+FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/7.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSArray+FLCrashProtect.h"
#import "FLCrashReport.h"

@implementation NSArray (FLCrashProtect)

/*
 NSArray真正对应的类：__NSArray0、__NSSingleObjectArrayI、__NSArrayI
 对于超过一个字面量初始化的时候取值走的不是objectAtIndex: 而是objectAtIndexedSubscript:
 */

// 空数组：__NSArray0；objectAtIndex:
- (id)fl_objectWithArray0AtIndex:(NSUInteger)index {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds for empty NSArray", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index];
    [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    return nil;
}
// 单元素数组：__NSSingleObjectArrayI；objectAtIndex:
- (id)fl_objectWithSingleObjectArrayIAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self fl_objectWithSingleObjectArrayIAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 多元素数组：__NSArrayI；objectAtIndex:
- (id)fl_objectWithArrayIAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self fl_objectWithArrayIAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 单元素数组：__NSSingleObjectArrayI；objectAtIndexedSubscript:
- (id)fl_objectWithSingleObjectArrayIAtIndexedSubscript:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self fl_objectWithSingleObjectArrayIAtIndexedSubscript:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), index, self.count - 1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 多元素数组：__NSArrayI；objectAtIndexedSubscript:
- (id)fl_objectWithArrayIAtIndexedSubscript:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self fl_objectWithArrayIAtIndexedSubscript:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), index, self.count - 1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 使用“@[]”创建数组时，系统会执行-[__NSPlaceholderArray initWithObjects:count:]
- (instancetype)fl_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    for (NSUInteger i = 0; i < cnt; i ++) {
        id tmpObject = objects[i];
        if (tmpObject == nil) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: attempt to insert nil object from objects[%lu]", self.class, NSStringFromSelector(@selector(initWithObjects:count:)), (unsigned long)i];
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
            continue;
        }
        newObjects[index] = tmpObject;
        index ++;
    }
    return [self fl_initWithObjects:newObjects count:index];
}

@end
