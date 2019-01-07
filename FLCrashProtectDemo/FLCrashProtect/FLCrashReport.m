//
//  FLCrashReport.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/6.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "FLCrashReport.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <mach-o/ldsyms.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define FLCrashProtectLog(format, ...) NSLog((@"*** FLCrashProtection: " format), ##__VA_ARGS__);
#else
#define FLCrashProtectLog(...)
#endif

@implementation NSObject (FLCrashStack)

+ (NSArray <NSString *>*)fl_callStackSymbols {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i ++) {
        NSString *stackString = [NSString stringWithUTF8String:strs[i]];
        [backtrace addObject:stackString];
    }
    free(strs);
    return backtrace;
}

static NSString *executableUUID(void) {
    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
        if (((const struct load_command *)command)->cmd == LC_UUID) {
            command += sizeof(struct load_command);
            return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                    command[0], command[1], command[2], command[3],
                    command[4], command[5],
                    command[6], command[7],
                    command[8], command[9],
                    command[10], command[11], command[12], command[13], command[14], command[15]];
        } else {
            command += ((const struct load_command *)command)->cmdsize;
        }
    }
    return nil;
}

@end

@implementation FLCrashReport (FLFileManager)

+ (NSString *)directoryPath {
    NSArray <NSString *>*directoryPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [directoryPaths.firstObject stringByAppendingString:@"/FLCrashMessages"];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];
    if (!isExist) {
        NSError *error;
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isSuccess) {
            FLCrashProtectLog(@"creat Directory Failed. errorInfo:%@",error);
        }
    }
    return directoryPath;
}

// 获取文件夹下文件列表
+ (NSArray <NSString *>*)getFileListInFolderWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        FLCrashProtectLog(@"getFileListInFolderWithPathFailed, errorInfo:%@",error);
    }
    return fileList;
}

+ (NSArray <NSString *>*)crashMessagesHistory {
    NSArray <NSString *>*fileNames = [FLCrashReport getFileListInFolderWithPath:[FLCrashReport directoryPath]];
    
    NSMutableArray <NSString *>*crashMessages = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        NSString *crashMessage = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [FLCrashReport directoryPath], fileName] encoding:NSUTF8StringEncoding error:nil];
        [crashMessages addObject:[NSString stringWithFormat:@"%@ %@", fileName, crashMessage]];
    }
    return crashMessages;
}

+ (void)clean {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *directoryPath = [FLCrashReport directoryPath];
    if ([fileManage fileExistsAtPath:directoryPath]) [fileManage removeItemAtPath:directoryPath error:nil];
}

- (void)writeCrashMessage:(NSString *)crashMessage toDirectoryPath:(NSString *)directoryPath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSZ";
    NSString *filePath = [directoryPath stringByAppendingFormat:@"/%@", [dateFormatter stringFromDate:[NSDate date]]];
    [crashMessage writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end

@interface FLCrashReport ()

@property (nonatomic, copy) void (^handle) (NSString *);

@end

@implementation FLCrashReport {
    __strong NSMutableDictionary *_userInfo;
}

+ (instancetype)shareCrashReport {
    static FLCrashReport *crashReport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashReport = [[FLCrashReport alloc] init];
    });
    return crashReport;
}

- (void)reportCrashMessage:(NSString *)crashMessage {
    if (![crashMessage containsString:@"First throw call stack"]) {
        crashMessage = [crashMessage stringByAppendingFormat:@"\n*** First throw call stack:\n%@",[NSObject fl_callStackSymbols]];
    }
    crashMessage = [crashMessage stringByAppendingFormat:@"\n*** UserInfo:\n%@", self.userInfo];
    
    FLCrashProtectLog(@"%@", crashMessage);
    
    if (_handle) _handle(crashMessage);
    // 收集Crash信息
    [self writeCrashMessage:crashMessage toDirectoryPath:[FLCrashReport directoryPath]];
}

- (void)receivedReport:(void (^)(NSString * _Nonnull))handle {
    _handle = handle;
}

- (NSMutableDictionary *)userInfo {
    if (!_userInfo) {
        _userInfo = [NSMutableDictionary dictionary];
        UIDevice *device = [UIDevice currentDevice];
        _userInfo[@"device_name"] = device.name;
        _userInfo[@"device_model"] = device.model;
        _userInfo[@"device_localizedModel"] = device.localizedModel;
        _userInfo[@"device_system"] = [device.systemName stringByAppendingFormat:@" %@", device.systemVersion];
        _userInfo[@"device_UUID"] = device.identifierForVendor;
    }
    return _userInfo;
}

@end
