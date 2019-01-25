//
//  AMKDispatcher+Demo.m
//  AMKDispatcher
//
//  Created by 孟昕欣 on 2019/1/25.
//  Copyright © 2019年 AndyM129. All rights reserved.
//

#import "AMKDispatcher+Demo.h"
#import "AMKTarget_Demo.h"

NSString * const AMKDemoTargetName = @"Demo";

@implementation AMKDispatcher (Demo)

- (void)gotoViewControllerWithParams:(NSDictionary *)params {
    [self performTarget:AMKDemoTargetName action:@"gotoViewControllerWithParams:" params:params shouldCacheTarget:YES];
}

- (void)alertWithoutParams:(NSDictionary *)params {
    [self performTarget:AMKDemoTargetName action:@"alertWithoutParams" params:params shouldCacheTarget:YES];
}

@end
