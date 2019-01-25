//
//  AMKTarget_Demo.h
//  AMKDispatcher_Example
//
//  Created by 孟昕欣 on 2019/1/25.
//  Copyright © 2019年 AndyM129. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMKTarget_Demo : NSObject

- (void)Action_gotoViewControllerWithParams:(NSDictionary *)params;

- (void)Action_forwardTargetActionWithParams:(NSDictionary *)params;

- (id)Action_alertDispatcherResult:(NSDictionary *)params;

- (NSInteger)Action_alertDispatcherResult2:(NSDictionary *)params;

@end
