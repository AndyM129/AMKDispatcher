//
//  AMKTarget_Forwarding.m
//  AMKDispatcher_Example
//
//  Created by 孟昕欣 on 2019/1/25.
//  Copyright © 2019年 AndyM129. All rights reserved.
//

#import "AMKTarget_Forwarding.h"

@implementation AMKTarget_Forwarding

- (void)Action_gotoViewControllerWithParams:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未识别Target" message:params.description preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)Action_forwardTargetActionWithParams:(NSDictionary *)params {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未识别Target和Action" message:params.description preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];;
}

@end
