//
//  NSObject+FLKVOCrash.m
//  LayoutDemo
//
//  Created by 伯明利 on 2018/12/27.
//  Copyright © 2018 bomingli. All rights reserved.
//

#import "NSObject+FLKVOCrash.h"
#import <objc/runtime.h>
#import "FLCrashReport.h"
#import "FLCrashSwizzling.h"

@implementation FLObserverRemover {
    __unsafe_unretained NSObject *_observer;
    __strong NSHashTable <NSDictionary *>*_objects;
}

- (instancetype)initWithObserver:(NSObject *)observer {
    self = [super init];
    if (self) {
        _observer = observer;
        _objects = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)addObserverWithObject:(NSObject *)object keyPath:(NSString *)keyPath {
    if (_objects) {
        __unsafe_unretained NSObject *obj = object;
        [_objects addObject:@{@"keyPath": keyPath, @"object": obj}];
    }
}

- (void)dealloc {
    /**
     观察者销毁时移除观察者；如果观察者被销毁时没有移除观察者，在观察对象的keyPath改变时，可能会发生Crash。
     error: The process has been returned to the state before expression evaluation.
     */
    @try {
        for (NSDictionary *dic in _objects) {
            [dic[@"object"] fl_removeObserver:_observer forKeyPath:dic[@"keyPath"]];
        }
    } @catch (NSException *exception) {

    }
}

@end

@interface FLObserverContainer ()

/**
 {keyPath:[observer]}；使用NSHashTable的目的：持有元素的弱引用，而且在对象被销毁后能正确地将其移除
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSHashTable <NSObject *>*> *fl_observers;

@end

@implementation FLObserverContainer {
    // __unsafe_unretained: 不会对对象进行retain,当对象销毁时,会依然指向之前的内存空间(野指针) (__weak: 不会对对象进行retain,当对象销毁时,会自动指向nil)
    __unsafe_unretained NSObject *_obj;
}

/**
 根据观察对象创建实例，目的是在观察对象消耗时移除观察者

 @param obj 观察对象
 */
- (instancetype)initWithObject:(NSObject *)obj {
    self = [super init];
    if (self) {
        _obj = obj;
    }
    return self;
}

- (NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *)fl_observers {
    if (!_fl_observers) {
        _fl_observers = [NSMutableDictionary dictionary];
    }
    return _fl_observers;
}

- (void)dealloc {
    // 观察对象销毁时移除观察者
    for (NSString *keyPath in self.fl_observers.allKeys) {
        NSHashTable *table = self.fl_observers[keyPath];
        for (NSObject *observer in table) {
            @try {
                [_obj fl_removeObserver:observer forKeyPath:keyPath];
            } @catch (NSException *exception) {
                
            }
        }
    }
}

@end

@interface NSObject ()

/**
 存放观察者的容器
 */
@property (nonatomic, strong) FLObserverContainer *observerContainer;

@end

@implementation NSObject (FLKVOCrash)

// *** Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <类名 内存地址> for the key path "keyPath" from <类名 内存地址> because it is not registered as an observer.'

- (void)fl_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if ([NSStringFromClass(observer.class) hasPrefix:@"AF"]) { // 不兼容AFNetworking
        [self fl_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    NSHashTable *table = [self.observerContainer.fl_observers objectForKey:keyPath];
    if (!table) {
        // 可以持有元素的弱引用，而且在对象被销毁后能正确地将其移除
        table = [NSHashTable weakObjectsHashTable];
        [self.observerContainer.fl_observers setObject:table forKey:keyPath];
    }
    if ([table containsObject:observer]) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: adding the same observer <%@ %p> to key path '%@' too many times", self.class, NSStringFromSelector(@selector(addObserver:forKeyPath:options:context:)), observer.class, observer, keyPath];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [table addObject:observer];
    
    static const char FLObserverRemoverKey;
    FLObserverRemover *remover = objc_getAssociatedObject(observer, &FLObserverRemoverKey);
    if (remover == nil) {
        remover = [[FLObserverRemover alloc] initWithObserver:observer];
        objc_setAssociatedObject(observer, &FLObserverRemoverKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [remover addObserverWithObject:self keyPath:keyPath];
    
    [self fl_addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)fl_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if ([NSStringFromClass(observer.class) hasPrefix:@"AF"]) { // 不兼容AFNetworking
        [self fl_removeObserver:observer forKeyPath:keyPath];
        return;
    }
    NSHashTable *table = self.observerContainer.fl_observers[keyPath];
    if ([table containsObject:observer]) {
        [table removeObject:observer];
        [self fl_removeObserver:observer forKeyPath:keyPath];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Cannot remove an observer <%@ %p> for the key path '%@' from <%@ %p> because it is not registered as an observer.", self.class, NSStringFromSelector(@selector(removeObserver:forKeyPath:)), observer.class, observer, keyPath, self.class, self];
        [FLCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    
    if (table.count == 0) {
        [self.observerContainer.fl_observers removeObjectForKey:keyPath];
    }
}

static const char fl_observerContainerKey;
- (FLObserverContainer *)observerContainer {
    FLObserverContainer *observerContainer = objc_getAssociatedObject(self, &fl_observerContainerKey);
    if (observerContainer == nil) {
        observerContainer = [[FLObserverContainer alloc] initWithObject:self];
        objc_setAssociatedObject(self, &fl_observerContainerKey, observerContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observerContainer;
}

@end
