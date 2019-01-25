//
//  AMKTarget_Forwarding.h
//  AMKDispatcher_Example
//
//  Created by 孟昕欣 on 2019/1/25.
//  Copyright © 2019年 AndyM129. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMKTarget_Forwarding : NSObject

- (void)Action_gotoViewControllerWithParams:(NSDictionary *)params;

- (void)Action_forwardTargetActionWithParams:(NSDictionary *)params;

@end
