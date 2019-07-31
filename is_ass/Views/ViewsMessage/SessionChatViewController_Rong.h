//
//  SessionChatViewController_Rong.h
//  assistant
//
//  Created by Bepa  on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SessionChatViewController_Rong : RCConversationViewController

/**
 * 会话数据模型
 */
@property (nonatomic, strong) RCConversationModel* conversation;
@property (nonatomic, strong) NSString * cookiersString;

@end
