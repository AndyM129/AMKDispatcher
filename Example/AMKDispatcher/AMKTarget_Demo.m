//
//  AMKTarget_Demo.m
//  AMKDispatcher_Example
//
//  Created by 孟昕欣 on 2019/1/25.
//  Copyright © 2019年 AndyM129. All rights reserved.
//

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
