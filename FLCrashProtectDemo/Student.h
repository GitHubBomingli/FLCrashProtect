//
//  Student.h
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/7.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) Teacher *teacher;

@end

NS_ASSUME_NONNULL_END
