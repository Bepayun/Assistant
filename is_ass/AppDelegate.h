//
//  AppDelegate.h
//  assistant
//
//  Created by Bepa  on 2017/8/28.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethod.h"
#import "UserInfoStructre.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMReceiveMessageDelegate> {
     LoginViewController *loginViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) CommonMethod *commonmthod;
@property (strong, nonatomic) UserInfoStructre *userInfostruct;
@property (nonatomic, strong) NSMutableDictionary *verifyDic;
@property (nonatomic, strong) NSMutableArray *cookieArray;
@property (nonatomic, strong) NSString *cookieString;
@property (nonatomic, strong) NSString *version;

+ (AppDelegate *)appDelegate;

- (void)anUpdatedVersionOne;

@end

