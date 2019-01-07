//
//  NSString+FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/26.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSString+FLCrashProtect.h"
#import "FLCrashReport.h"

@implementation NSString (FLCrashProtect)
// NSPlaceholderString的同名类方法也会执行该方法
- (instancetype)fl_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self fl_initWithString:@""];
    } else return [self fl_initWithString:aString];
}

- (NSString *)fl_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(stringByAppendingString:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    } else return [self fl_stringByAppendingString:aString];
}

- (unichar)fl_characterAtIndex:(NSUInteger)index {
    if (index < self.length) {
        return [self fl_characterAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(characterAtIndex:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return 0;
    }
}

- (NSString *)fl_substringFromIndex:(NSUInteger)from {
    if (from <= self.length) {
        return [self fl_substringFromIndex:from];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Index %lu out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringFromIndex:)), from, self.length];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return @"";
    }
}

- (NSString *)fl_substringToIndex:(NSUInteger)to {
    if (to <= self.length) {
        return [self fl_substringToIndex:to];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Index %lu out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringToIndex:)), to, self.length];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    }
}

- (NSString *)fl_substringWithRange:(NSRange)range {
    if (range.location < self.length && range.location + range.length <= self.length) {
        return [self fl_substringWithRange:range];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range {%lu, %lu} out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringWithRange:)), range.location, range.length, self.length];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
        return [self fl_substringWithRange:intersectionRange];
    }
}

@end
