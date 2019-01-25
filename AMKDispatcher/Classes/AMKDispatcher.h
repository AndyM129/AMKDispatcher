//
//  AMKDispatcher.h
//  Pods
//
//  Created by 孟昕欣 on 2019/1/25.
//

#import <Foundation/Foundation.h>

/** Target-Ation 分发服务 */
@interface AMKDispatcher : NSObject

/** 单例 */
@property(nonatomic, strong, readonly, nonnull, class) AMKDispatcher *sharedInstance;

/** TargetName前缀，默认值为@"AMKTarget_"；请务必使用执行 -performTarget:action:params:shouldCacheTarget: 前赋值 */
@property(nonatomic, copy, nonnull) NSString *targetPrefix;

/** ActionName前缀，默认值为@"Action_"；请务必使用执行 -performTarget:action:params:shouldCacheTarget: 前赋值 */
@property(nonatomic, copy, nonnull) NSString *actionPrefix;

/** 未识别指定TargetName时转发的TargetName，默认值为@"Forwarding"；请务必使用执行 -performTarget:action:params:shouldCacheTarget: 前赋值 */
@property(nonatomic, copy, nonnull) NSString *forwardTargetName;

/** 未识别指定TargetName时转发的TargetName，默认值为@"forwardTargetActionWithParams:"；请务必使用执行 -performTarget:action:params:shouldCacheTarget: 前赋值 */
@property(nonatomic, copy, nonnull) NSString *forwardActionName;

/** 模块内组件调用入口 */
- (id _Nullable)performTarget:(NSString * _Nullable)targetName action:(NSString * _Nullable)actionName params:(NSDictionary * _Nullable)params shouldCacheTarget:(BOOL)shouldCacheTarget;

+ (id _Nullable)performTarget:(NSString * _Nullable)targetName action:(NSString * _Nullable)actionName params:(NSDictionary * _Nullable)params shouldCacheTarget:(BOOL)shouldCacheTarget;

/** 移除指定名称的CachedTarget */
- (void)removeCachedTargetWithTargetName:(NSString * _Nullable)targetName;

+ (void)removeCachedTargetWithTargetName:(NSString * _Nullable)targetName;

@end


FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherDefalutTargetPrefix;               ///< 默认TargetPrefix
FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherDefalutActionPrefix;               ///< 默认ActionPrefix
FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherDefalutForwardTargetName;          ///< 默认ForwardTargetName
FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherDefalutForwardActionName;          ///< 默认ForwardActionName

FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherTargetNameInfoKey;                 ///< Perform的Params参数Key：TargetName
FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherActionNameInfoKey;                 ///< Perform的Params参数Key：ActionName
FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherParamsInfoKey;                     ///< Perform的Params参数Key：Params
FOUNDATION_EXTERN NSString * _Nonnull const AMKDispatcherShouldCacheTargetInfoKey;          ///< Perform的Params参数Key：ShouldCacheTarget


