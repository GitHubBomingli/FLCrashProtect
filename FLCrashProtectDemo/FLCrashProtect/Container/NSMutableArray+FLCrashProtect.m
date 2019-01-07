//
//  NSMutableArray+FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/8.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSMutableArray+FLCrashProtect.h"
#import "FLCrashReport.h"

@implementation NSMutableArray (FLCrashProtect)

/*
 NSMutableArray的实际执行者是__NSArrayM类
 addObject:也会执行insertObject:atIndex:方法；
 */
- (void)fl_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject) {
        if (NSLocationInRange(index, NSMakeRange(0, self.count + 1))) {
            [self fl_insertObject:anObject atIndex:index];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds", self.class, NSStringFromSelector(@selector(insertObject:atIndex:)), index];
            if (self.count == 0) {
                crashMessages = [crashMessages stringByAppendingString:@" for empty array"];
            } else {
                crashMessages = [crashMessages stringByAppendingFormat:@" [0 .. %lu]", self.count];
            }
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil", self.class, NSStringFromSelector(@selector(insertObject:atIndex:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}
/*
 iOS10后removeObjectAtIndex:也会执行removeObjectsInRange:
 */
- (void)fl_removeObjectsInRange:(NSRange)range {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: rannge {%lu, %lu} extends beyond bounds for empty array", self.class, NSStringFromSelector(@selector(removeObjectsInRange:)), range.location, range.length];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        NSRange bounds = NSMakeRange(0, self.count);
        if (NSLocationInRange(range.location, bounds) && NSLocationInRange(range.location + range.length - 1, bounds)) {
            [self fl_removeObjectsInRange:range];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: rannge {%lu, %lu} extends beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(removeObjectsInRange:)), range.location, range.length, self.count - 1];
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    }
}

- (void)fl_removeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu extends beyond bounds for empty array", self.class, NSStringFromSelector(@selector(removeObjectAtIndex:)), index];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        if (index < self.count) {
            [self fl_removeObjectAtIndex:index];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu extends beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(removeObjectAtIndex:)), index, self.count - 1];
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    }
}

- (void)fl_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject) {
        if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
            [self fl_replaceObjectAtIndex:index withObject:anObject];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds", self.class, NSStringFromSelector(@selector(replaceObjectAtIndex:withObject:)), index];
            if (self.count == 0) {
                crashMessages = [crashMessages stringByAppendingString:@" for empty array"];
            } else {
                crashMessages = [crashMessages stringByAppendingFormat:@" [0 .. %lu]", self.count];
            }
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil", self.class, NSStringFromSelector(@selector(replaceObjectAtIndex:withObject:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}

- (void)fl_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds for empty array", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        if (!NSLocationInRange(idx1, NSMakeRange(0, self.count))) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx1, self.count - 1];
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        } else if (!NSLocationInRange(idx2, NSMakeRange(0, self.count))) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx2, self.count - 1];
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        } else {
            [self fl_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        }
    }
}

- (id)fl_objectAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self fl_objectAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}

- (id)fl_objectAtIndexedSubscript:(NSUInteger)idx {
    if (NSLocationInRange(idx, NSMakeRange(0, self.count))) {
        return [self fl_objectAtIndexedSubscript:idx];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), idx, self.count - 1];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}

@end
