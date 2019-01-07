//
//  NSObject+UnrecognizedSelector.h
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLForwardingTarget : NSObject

@end

@interface NSObject (FLUnrecognizedSelector)

@end

NS_ASSUME_NONNULL_END
