//
//  ViewController.m
//  FLCrashProtectDemo
//
//  Created by 伯明利 on 2019/1/2.
//  Copyright © 2019 bomingli. All rights reserved.
//

#import "ViewController.h"
#import "PushedViewController.h"
#import "FLCrashProtect/FLCrashProtect.h"

@interface ViewController ()

@property (nonatomic, strong) NSNumber *vcNumber;

@end

@implementation ViewController {
    __unsafe_unretained UIViewController *_vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [FLCrashProtect.shareCrashProtect registerCrashProtect:FLCrashProtectOptionAll];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName" object:nil];
    self.vcNumber = @3;
    [_vc removeObserver:self forKeyPath:@"number"];
}

- (IBAction)action_pushButton:(UIButton *)sender {
    PushedViewController *vc = [[PushedViewController alloc] init];
    vc.vc = self;
    [vc addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    [self.navigationController pushViewController:vc animated:YES];
    _vc = vc;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%s %@ %@", __FUNCTION__, keyPath, change);
}

@end
