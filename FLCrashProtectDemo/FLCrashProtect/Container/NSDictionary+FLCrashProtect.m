//
//  NSDictionary+FLCrashProtect.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/26.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSDictionary+FLCrashProtect.h"
#import "FLCrashReport.h"

@implementation NSDictionary (FLCrashProtect)

/**
 使用“@{}”创建字典时，系统会执行-[__NSPlaceholderDictionary initWithObjects:forKeys:count:]
 */
- (instancetype)fl_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: attempt to insert nil object from objects[%d]", self.class, NSStringFromSelector(@selector(initWithObjects:forKeys:count:)), i];
            [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
            continue;
        }
        newObjects[index] = tmpItem;
        newkeys[index] = tmpKey;
        index++;
    }
    
    return [self fl_initWithObjects:newObjects forKeys:newkeys count:index];
}

@end
