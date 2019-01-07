//
//  PushedViewController.m
//  FLCrashProtectDemo
//
//  Created by 伯明利 on 2019/1/2.
//  Copyright © 2019 bomingli. All rights reserved.
//

#import "PushedViewController.h"
#import "FLCrashProtect/FLCrashProtect.h"
#import "FLCrashProtect/FLCrashReport.h"
#import "Student.h"

@interface PushedViewController ()

@property (nonatomic, strong) NSNumber *number;

@end

@implementation PushedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"内存地址 %p", self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action_notification) name:@"NotificationName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action_notification) name:@"NotificationName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationName" object:nil];

    [self.vc addObserver:self forKeyPath:@"vcNumber" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    self.number = @1;
    [self removeObserver:self forKeyPath:@"number"];
    [self removeObserver:self forKeyPath:@"number"];
    [self removeObserver:self forKeyPath:@"number" context:nil];
    self.number = @2;
    
    NSString *insertString = nil;
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:insertString];
    mStr = [NSMutableString stringWithString:insertString];
    [mStr appendString:insertString];
    [mStr stringByAppendingString:insertString];
    [mStr insertString:insertString atIndex:0];
    [mStr insertString:@"s" atIndex:1];
    [mStr appendString:@"0123"];
    [mStr deleteCharactersInRange:NSMakeRange(4, 0)];
    [mStr deleteCharactersInRange:NSMakeRange(4, 1)];
    [mStr deleteCharactersInRange:NSMakeRange(3, 2)];

    NSString *nilStr = nil;
    NSString *str = [[NSString alloc] initWithString:nilStr];
    str = [NSString stringWithString:nilStr];
    str = @"0123";
    [str stringByAppendingString:nilStr];
    NSLog(@"%c", [str characterAtIndex:4]);
    NSLog(@"%@", [str substringFromIndex:5]);
    NSLog(@"%@", [str substringToIndex:5]);
    NSLog(@"%@", [str substringWithRange:NSMakeRange(2, 4)]);

    NSObject *obj = nil;
    NSArray *ar = @[@0,@1,obj,@3];
    NSLog(@"%@",ar);

    NSString *key = @"key2";
    NSString *value = nil;
    NSDictionary *dict = @{@"key1": @"v2", key: value, @"key3": @"v3"};
    NSLog(@"%@", dict);

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:nil forKey:@"a"];
    [dic setValue:@"a" forKey:nil];
    [dic setValue:@"b" forKeyPath:@"b.b"];
    [dic setValuesForKeysWithDictionary:@{@"ccccccc": @"C", @"d": @"d"}];
    [dic setObject:nil forKeyedSubscript:@"a"];
    [dic setObject:nil forKeyedSubscript:nil];
    [dic removeObjectForKey:nil];
    [dic removeObjectForKey:@"不存在的key"];

    NSMutableArray *mArr = [NSMutableArray array];
    [mArr addObject:nil];
    [mArr insertObject:@"1" atIndex:1];
    [mArr insertObject:@"1" atIndex:0];
    [mArr insertObject:@"2" atIndex:2];

    [mArr removeObject:nil];
    [mArr removeObject:@"1"];
    [mArr removeObjectAtIndex:0];
    [mArr addObject:@"1"];
    [mArr removeObjectAtIndex:2];

    [mArr replaceObjectAtIndex:2 withObject:nil];
    [mArr addObject:@"1"];
    [mArr replaceObjectAtIndex:2 withObject:@"2"];
    [mArr replaceObjectAtIndex:-1 withObject:@"2"];

    [mArr exchangeObjectAtIndex:2 withObjectAtIndex:3];
    [mArr addObject:@"1"];
    [mArr exchangeObjectAtIndex:2 withObjectAtIndex:3];
    [mArr exchangeObjectAtIndex:0 withObjectAtIndex:3];

    NSArray *array = @[];
    id obj0 = array[1];

    NSArray *array1 = @[@"1"];
    id obj1 = array1[2];

    NSArray *array2 = @[@"1", @"2"];
    id obj2 = array2[3];

    NSArray *array3 = @[@(1), @(2)];
    id obj3 = array3[4];


    id num = [NSNumber numberWithInteger:1];
    [num stringByAppendingString:@"aa"];


    Teacher *teacher = [Teacher new];
    teacher.name = @"teacher name";
    Student *student = [Student new];
    student.name = @"student name";
    student.age = 20;
    student.teacher = teacher;

    [student setValue:@"student name" forKey:@"name"];
    [student setValue:@"teacher name" forKeyPath:@"teacher.name"];
    [student setValuesForKeysWithDictionary:@{@"name": @"student name keyvalue"}];

    [student setValue:@"teacher name" forKey:@"te"];
    [student setValue:@"teacher name" forKeyPath:@"teacher."];
    [student setValue:@"teacher name" forKeyPath:@".name"];
    [student setValue:@"teacher name" forKeyPath:@"df.name"];
    [student setValue:@"teacher name" forKeyPath:@"name11"];
    [student valueForKey:@"ad"];
    [student valueForKeyPath:@"s.v"];
    [student setValue:@"sf" forKeyPath:nil];

//    NSLog(@"%@", [FLCrashReport crashMessagesHistory]);
    [FLCrashReport clean];

}

- (void)action_notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%s %@ %@", __FUNCTION__, keyPath, change);
}

@end
