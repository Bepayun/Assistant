//
//  SessionRongViewController.h
//  assistant
//
//  Created by Bepa  on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import <UIKit/UIKit.h>

@interface SessionRongViewController : RCConversationListViewController

- (id)initWithSessionTypeIsLiveRoomSession:(BOOL)isLiveRoomSession;
- (void)updateBadgeValueForTabBarItem;

@end
