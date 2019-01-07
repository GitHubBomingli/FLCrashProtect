//
//  NSObject+FLKVOCrash.h
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/27.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLObserverRemover : NSObject

@end

@interface FLObserverContainer : NSObject

@end

@interface NSObject (FLKVOCrash)

- (void)fl_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
