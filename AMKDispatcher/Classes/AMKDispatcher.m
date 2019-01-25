//
//  AMKDispatcher.m
//  Pods
//
//  Created by 孟昕欣 on 2019/1/25.
//

#import "AMKDispatcher.h"

@interface AMKDispatcher ()
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
@property (nonatomic, assign) BOOL initialized; //!< 已完成初始化，避免再修改必要参数值
@end


@implementation AMKDispatcher

#pragma mark - Init Methods

- (void)dealloc {
    [self.cachedTarget removeAllObjects];
}

+ (instancetype _Nonnull)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self.class alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.targetPrefix = AMKDispatcherDefalutTargetPrefix;
        self.actionPrefix = AMKDispatcherDefalutActionPrefix;
        self.forwardTargetName = AMKDispatcherDefalutForwardTargetName;
        self.forwardActionName = AMKDispatcherDefalutForwardActionName;
    }
    return self;
}

#pragma mark - Properties

- (void)setTargetPrefix:(NSString *)targetPrefix {
    if (![_targetPrefix isEqualToString:targetPrefix]) {
        NSAssert(!self.initialized, @"请勿重复赋值");
        targetPrefix = [targetPrefix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _targetPrefix = targetPrefix.copy;
    }
}

- (void)setActionPrefix:(NSString *)actionPrefix {
    if (![_actionPrefix isEqualToString:actionPrefix]) {
        NSAssert(!self.initialized, @"请勿重复赋值");
        actionPrefix = [actionPrefix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _actionPrefix = actionPrefix.copy;
    }
}

- (void)setForwardTargetName:(NSString *)forwardTargetName {
    if (![_forwardTargetName isEqualToString:forwardTargetName]) {
        NSAssert(!self.initialized, @"请勿重复赋值");
        forwardTargetName = [forwardTargetName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _forwardTargetName = forwardTargetName.copy;
    }
}

- (void)setForwardActionName:(NSString *)forwardActionName {
    if (![_forwardActionName isEqualToString:forwardActionName]) {
        NSAssert(!self.initialized, @"请勿重复赋值");
        forwardActionName = [forwardActionName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _forwardActionName = forwardActionName.copy;
    }
}

- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

#pragma mark - Public Methods

/** 模块内组件调用入口（注：若参数params与URLString中存在相同key的参数值，会优先使用参数params对应key的值，即“参数params的优先级高于URLString中的参数键值对”） */
- (id _Nullable)performTarget:(NSString * _Nullable)targetName action:(NSString * _Nullable)actionName params:(NSDictionary * _Nullable)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.initialized = YES;
    });
    
    NSMutableDictionary *dispatcherPrams = [params?:@{} mutableCopy];
    dispatcherPrams[AMKDispatcherTargetNameInfoKey] = targetName?:@"";
    dispatcherPrams[AMKDispatcherActionNameInfoKey] = actionName?:@"";
    dispatcherPrams[AMKDispatcherParamsInfoKey] = params?:@"";
    dispatcherPrams[AMKDispatcherShouldCacheTargetInfoKey] = [NSNumber numberWithBool:shouldCacheTarget];
    
    NSObject *target = [self targetWithName:targetName shouldCache:shouldCacheTarget];
    SEL action = [self actionWithTarget:target name:actionName];
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:dispatcherPrams];
    }
    return nil;
}

+(id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget{
    return [[self sharedInstance]performTarget:targetName action:actionName params:params shouldCacheTarget:shouldCacheTarget];
}

/** 移除指定名称的CachedTarget */
- (void)removeCachedTargetWithTargetName:(NSString * _Nullable)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"%@%@", self.targetPrefix?:@"", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

+(void)removeCachedTargetWithTargetName:(NSString *)targetName{
    [[self sharedInstance]removeCachedTargetWithTargetName:targetName];
}

#pragma mark - Private Methods

/** 根据Name返回Target对象 */
- (id)targetWithName:(NSString *)targetName shouldCache:(BOOL)shouldCache {
    NSArray *targetNames = @[targetName?:@"", self.forwardTargetName];
    for (NSString *targetName in targetNames) {
        if (!targetName.length) continue;
        
        NSString *targetClassString = [NSString stringWithFormat:@"%@%@", self.targetPrefix?:@"", targetName];
        NSObject *target = self.cachedTarget[targetClassString];
        if (target) return target;
        
        Class targetClass = NSClassFromString(targetClassString);
        if (!targetClass) continue;
        
        target = [[targetClass alloc] init];
        if (shouldCache) {
            self.cachedTarget[targetClassString] = target;
        }
        return target;
    }
    return nil;
}

/** 根据Name返回Target对象 */
- (SEL)actionWithTarget:(id)target name:(NSString *)actionName {
    NSArray *actionNames = @[actionName?:@"", self.forwardActionName];
    for (NSString *actionName in actionNames) {
        if (!actionName.length) continue;
        NSString *actionString = actionName;
        if (![actionString hasPrefix:self.actionPrefix]) {
            actionString = [NSString stringWithFormat:@"%@%@", self.actionPrefix?:@"", actionName];
        }
        SEL action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]){
            return action;
        }
    }
    return nil;
}

/** 安全的执行方法 */
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if ([NSStringFromSelector(action) hasSuffix:@":"]) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if ([NSStringFromSelector(action) hasSuffix:@":"]) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if ([NSStringFromSelector(action) hasSuffix:@":"]) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if ([NSStringFromSelector(action) hasSuffix:@":"]) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if ([NSStringFromSelector(action) hasSuffix:@":"]) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:([NSStringFromSelector(action) hasSuffix:@":"] ? params : nil)];
#pragma clang diagnostic pop
}

@end


NSString * _Nonnull const AMKDispatcherDefalutTargetPrefix = @"AMKTarget_";
NSString * _Nonnull const AMKDispatcherDefalutActionPrefix = @"Action_";
NSString * _Nonnull const AMKDispatcherDefalutForwardTargetName = @"Forwarding";
NSString * _Nonnull const AMKDispatcherDefalutForwardActionName = @"forwardTargetActionWithParams:";

NSString * _Nonnull const AMKDispatcherTargetNameInfoKey = @"__TargetName";
NSString * _Nonnull const AMKDispatcherActionNameInfoKey = @"__ActionName";
NSString * _Nonnull const AMKDispatcherParamsInfoKey = @"__Params";
NSString * _Nonnull const AMKDispatcherShouldCacheTargetInfoKey = @"__ShouldCacheTarget";
