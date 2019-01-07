//
//  NSMutableString+FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/26.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSMutableString+FLCrashProtect.h"
#import "FLCrashReport.h"

@implementation NSMutableString (FLCrashProtect)

// NSPlaceholderMutableString的同名类方法也会执行该方法
- (instancetype)fl_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self fl_initWithString:@""];
    } else return [self fl_initWithString:aString];
}

- (void)fl_appendString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(appendString:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else [self fl_appendString:aString];
}

- (NSString *)fl_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(stringByAppendingString:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    } else return [self fl_stringByAppendingString:aString];
}

- (void)fl_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(insertString:atIndex:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else if (loc > self.length) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(insertString:atIndex:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else
    [self fl_insertString:aString atIndex:loc];
}

- (void)fl_deleteCharactersInRange:(NSRange)range {
    if (range.location < self.length && range.location + range.length <= self.length) {
        [self fl_deleteCharactersInRange:range];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(deleteCharactersInRange:))];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
        [self fl_deleteCharactersInRange:intersectionRange];
    }
}

@end
