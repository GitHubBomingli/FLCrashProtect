//
//  FLCrashReport.h
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLCrashReport : NSObject

+ (instancetype)shareCrashReport;
// 崩溃日志上报
- (void)reportCrashMessage:(NSString *)crashMessage;
// 收到崩溃日志时的回调
- (void)receivedReport:(void(^)(NSString *crashMessage))handle;

@property (nonatomic, strong, readonly) NSMutableDictionary *userInfo;

@end

@interface FLCrashReport (FLFileManager)
// 获取本地的崩溃日志
+ (NSArray <NSString *>*)crashMessagesHistory;
// 清除本地的崩溃日志
+ (void)clean;

@end

@interface NSObject (FLCrashStack)

// 获取当前的堆栈信息
+ (NSArray <NSString *>*)fl_callStackSymbols;

@end

NS_ASSUME_NONNULL_END
