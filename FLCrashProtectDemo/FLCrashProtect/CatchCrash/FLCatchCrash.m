//
//  FLCatchException.m
//  FLCrashProtectDemo
//
//  Created by 伯明利 on 2019/1/2.
//  Copyright © 2019 bomingli. All rights reserved.
//

#import "FLCatchCrash.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "FLCrashReport.h"

static NSUncaughtExceptionHandler *fl_previousUncaughtExceptionHandler;

typedef void (*SignalHandler)(int signo, siginfo_t *info, void *context);
static SignalHandler fl_previousSignalHandler = NULL;

@implementation FLCatchCrash

+ (void)registerHandler {
    FLInstallSignalHandler();
    FLInstallUncaughtExceptionHandler();
}

static void FLInstallSignalHandler(void) {
    struct sigaction old_action;
    sigaction(SIGABRT, NULL, &old_action);
    if (old_action.sa_flags & SA_SIGINFO) {
        fl_previousSignalHandler = old_action.sa_sigaction;
    }
    
    FLSignalRegister(SIGABRT);
//    FLSignalRegister(SIGHUP);
//    FLSignalRegister(SIGINT);
//    FLSignalRegister(SIGQUIT);
//    FLSignalRegister(SIGILL);
//    FLSignalRegister(SIGSEGV);
//    FLSignalRegister(SIGFPE);
//    FLSignalRegister(SIGBUS);
//    FLSignalRegister(SIGPIPE);
    // .......
    /*
     SIGABRT--程序中止命令中止信号
     SIGALRM--程序超时信号
     SIGFPE--程序浮点异常信号
     SIGILL--程序非法指令信号
     SIGHUP--程序终端中止信号
     SIGINT--程序键盘中断信号
     SIGKILL--程序结束接收中止信号
     SIGTERM--程序kill中止信号
     SIGSTOP--程序键盘中止信号
     SIGSEGV--程序无效内存中止信号
     SIGBUS--程序内存字节未对齐中止信号
     SIGPIPE--程序Socket发送失败中止信号
     */
}

static void FLSignalRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = FLSignalHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}
static void FLSignalHandler(int signal, siginfo_t* info, void* context) {
    NSString *crashMessage = [NSString stringWithFormat:@"*** crash *** signal: %d, info: %@", signal, info];
    [FLCrashReport.shareCrashReport reportCrashMessage:crashMessage];
    //    FLClearSignalRigister();
    // 处理前者注册的 handler
    if (fl_previousSignalHandler) {
        fl_previousSignalHandler(signal, info, context);
    }
}

static void FLHandleException(NSException *exception) {
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    [FLCrashReport.shareCrashReport reportCrashMessage:[NSString stringWithFormat:@"*** crash *** %@ \n*** First throw call stack:\n%@", reason, [exception callStackSymbols]]];
    
    //  处理前者注册的 handler
    if (fl_previousUncaughtExceptionHandler) {
        fl_previousUncaughtExceptionHandler(exception);
    }
}

static void FLInstallUncaughtExceptionHandler(void) {
    fl_previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&FLHandleException);
}

@end
