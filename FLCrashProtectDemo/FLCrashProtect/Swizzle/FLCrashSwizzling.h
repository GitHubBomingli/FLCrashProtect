//
//  FLCrashSwizzling.h
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLCrashSwizzling : NSObject

+ (void)swizzlingMethod:(Class)clazz originalSEL:(SEL)originalSEL swizzleSEL:(SEL)swizzleSEL;

@end

NS_ASSUME_NONNULL_END
