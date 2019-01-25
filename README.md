# AMKDispatcher - 模块化接口，跨模块操作分发

[![CI Status](https://img.shields.io/travis/AndyM129/AMKDispatcher.svg?style=flat)](https://travis-ci.org/AndyM129/AMKDispatcher)
[![Version](https://img.shields.io/cocoapods/v/AMKDispatcher.svg?style=flat)](https://cocoapods.org/pods/AMKDispatcher)
[![License](https://img.shields.io/cocoapods/l/AMKDispatcher.svg?style=flat)](https://cocoapods.org/pods/AMKDispatcher)
[![Platform](https://img.shields.io/cocoapods/p/AMKDispatcher.svg?style=flat)](https://cocoapods.org/pods/AMKDispatcher)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AMKDispatcher is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AMKDispatcher'
```

## Usage

### 1. 按照示例工程中的用法，创建相关类

- AMKTarget_Demo.h

```objective-c
#import <Foundation/Foundation.h>

@interface AMKTarget_Demo : NSObject

/// 测试：前往某页面
- (void)Action_gotoViewControllerWithParams:(NSDictionary *)params;

/// 测试：未实现分发的转发
- (void)Action_forwardTargetActionWithParams:(NSDictionary *)params;

/// 测试：分发并返回对象类型的值
- (id)Action_alertDispatcherResult:(NSDictionary *)params;

/// 测试：分发并返回基础数据类型的值
- (NSInteger)Action_alertDispatcherResult2:(NSDictionary *)params;

@end
```



- AMKTarget_Demo.m

```objective-c
#import "AMKTarget_Demo.h"
#import "AMKViewController.h"

@implementation AMKTarget_Demo

- (void)Action_gotoViewControllerWithParams:(NSDictionary *)params {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [navigationController pushViewController:AMKViewController.new animated:YES];
    }
}

- (void)Action_forwardTargetActionWithParams:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未识别Action" message:params.description preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];;
}

- (void)Action_alertWithoutParams {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AlertWithoutParams" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];;
}

- (id)Action_alertDispatcherResult:(NSDictionary *)params {
    return [params objectForKey:@"text"];
}

- (NSInteger)Action_alertDispatcherResult2:(NSDictionary *)params {
    return 20180105;
}

@end
```



### 2. 注册（如下是AMKDispatcher的相关属性&接口）

```objective-c
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
```



### 3. 分发

```objective-c
id object = [[AMKDispatcher sharedInstance] performTarget:@"Demo" action:@"gotoViewControllerWithParams:" params:@{} shouldCacheTarget:YES];
```




## Author

AndyM129, andy_m129@163.com

## License

AMKDispatcher is available under the MIT license. See the LICENSE file for more info.
