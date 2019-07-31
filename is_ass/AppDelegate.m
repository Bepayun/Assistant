//
//  AppDelegate.m
//  assistant
//
//  Created by Bepa  on 2017/8/28.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import <Bugly/Bugly.h>
#define kForcedUpdateVersionValue  60 // 这里改变将强制更新该app,主要是不兼容旧版的该app，才导致要更新


@interface AppDelegate ()<CLLocationManagerDelegate,BuglyDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)CLLocationManager* locationManager;
@property (nonatomic, strong)TabBarViewController* mainTabBarController;
@property (nonatomic, strong) NSString* ipString;
@property (nonatomic, strong) NSString* setup_url;

@end

@implementation AppDelegate;
@synthesize commonmthod;
@synthesize userInfostruct;
@synthesize loginViewController;

- (BOOL)application:(UIApplication* )application didFinishLaunchingWithOptions:(NSDictionary* )launchOptions {
    // Override point for customization after application launch.
    
    [self Otherinit];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    TabBarViewController* tabBarC = [TabBarViewController shareInstance];
    _mainTabBarController = tabBarC;
    self.window.rootViewController = tabBarC;
    [self.window makeKeyAndVisible];
    //
    LoginViewController* appLogonViewController = [self loginViewController];
    CGRect appLogonViewRect = appLogonViewController.view.frame;
    appLogonViewRect = [[UIScreen mainScreen] bounds];
    appLogonViewController.view.frame = appLogonViewRect;
    [self.window addSubview:loginViewController.view];
    
    NSString* appidstring = kAppidstring;
    NSUInteger buglyTag = 28367;
    BuglyConfig* bugConfig = [[BuglyConfig alloc] init];
    bugConfig.channel = kAppchannelstring;
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* nowbundleVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString* appversionstring = nowbundleVersion;
    
    [AppDelegate appDelegate].userInfostruct.nowVersion = nowbundleVersion;
    
    bugConfig.version = appversionstring;
    // 设置自定义日志上报的级别，默认不上报自定义日志
    bugConfig.reportLogLevel = BuglyLogLevelVerbose;
    // bugConfig.debugMode = YES;
    bugConfig.unexpectedTerminatingDetectionEnable = YES;
    bugConfig.delegate = self;
    [Bugly startWithAppId:appidstring config:bugConfig];
    [Bugly setTag:buglyTag];
    
    // 统一导航条样式
    UIFont* font = [UIFont systemFontOfSize:18.f];
    NSDictionary* textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:RGB(18, 150, 219)];
    
    // 开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    // 设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    // 开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    // 开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    // 设置Log级别，开发阶段打印详细log
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    [self getLocation];
    [self RegistNotification];
    [self mandatoryUpdatingMechanism];
    return YES;
}

- (LoginViewController* )loginViewController {
    if (!loginViewController) {
        loginViewController = [[LoginViewController alloc] init];
    }
    return loginViewController;
}
- (void)Otherinit {
    commonmthod = [[CommonMethod alloc]init];
    userInfostruct = [[UserInfoStructre alloc]init];
    self.verifyDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.cookieArray = [NSMutableArray arrayWithCapacity:0];
    self.cookieString = @"";
}
+ (AppDelegate* )appDelegate {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return delegate;
}
- (void)RegistNotification {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendVerifyInfoToSeller) name:KNotificationVerifySuccess object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
}
- (void)changeTabItemAndCellUnReadmessageCount:(int)count andMessage:(RCMessage* )message {

    int unReadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[[NSNumber numberWithInt:ConversationType_PRIVATE]]];
    UITabBarItem* item = [self.mainTabBarController.tabBar.items objectAtIndex:2];
    NSString* badge = [NSString stringWithFormat:@"%d", unReadCount];
    if (unReadCount == 0) {
        badge = nil;
    }
    item.badgeValue = badge;

    if (message == nil) {
        return;
    }

//    NSString*  targetId = message.targetId;

}
- (void)didReceiveMessageNotification:(NSNotification* )notification {
    // item消息count
    id obj = notification.object;
    RCMessage* mess = (RCMessage*)obj;
    
    int unReadMessageCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    
    NSThread* currentThread = [NSThread currentThread];
    if ([currentThread isMainThread]) {
        [self changeTabItemAndCellUnReadmessageCount:unReadMessageCount andMessage:mess];
        
    } else {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self changeTabItemAndCellUnReadmessageCount:unReadMessageCount andMessage:mess];
        }];
    }
    
    RCMessage* message = notification.object;
    if ([message.content isKindOfClass:[RCCommandMessage class]]) {
        RCCommandMessage* content = (RCCommandMessage* )message.content;
        if ([content.name isEqualToString:@"SellerRejectTask"]) { // 雇主拒绝接任务请求
            
            [[AppDelegate appDelegate].commonmthod showHUD:@"雇主拒绝了你的请求"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCloseWaitView object:nil];
    } else if ([content.name isEqualToString:@"SellerAcceptTask"]) { // 雇主接受接任务请求
            
            [[AppDelegate appDelegate].commonmthod ToChatViewWithCellerwith:message];
            [[AppDelegate appDelegate].commonmthod showHUD:@"雇主接受了你的请求"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCloseWaitView object:nil];
            
        } else if([content.name isEqualToString:@"RequestRemotePay"]) { // 雇主发起同步
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCloseWaitView object:nil];

            if (![content.data isKindOfClass:[NSNull class]]) {
                id data = [[AppDelegate appDelegate].commonmthod dictionaryWithJsonString:content.data];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if ([self.verifyDic allKeys].count > 0) {
                        [self.verifyDic removeAllObjects];
                    }
                    [self.verifyDic addEntriesFromDictionary:data];
                }
            }
                      
            [[AppDelegate appDelegate].commonmthod showMessageFromSeller:[self.verifyDic objectForKey:@"content"]];
            
        } else if ([content.name isEqualToString:@"SellerCancelRequest"]) { // 雇主取消同步
            
            [[AppDelegate appDelegate].commonmthod showHUD:@"雇主取消了同步请求"];
        }
    }
}
- (void)sendVerifyInfoToSeller {
    [self.commonmthod SendVerifyMessagewithcookiers];
}
- (void)anUpdatedVersionOne {
    NSMutableString* userAgent = [NSMutableString stringWithString:[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];

    NSString* url = [NSString stringWithFormat:@"%@%@",kUpdateAppURLString,[AppDelegate appDelegate].commonmthod.getLocalVersion];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    request.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse*  _Nullable response, NSData*  _Nullable data, NSError*  _Nullable connectionError) {
        if (data && connectionError == nil) {
            
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary* dic = (NSDictionary* )result;
            NSLog(@"%@",dic);
            NSDictionary* version_status = [NSDictionary dictionary];
            if ([dic objectForKey:@"version_status"] && ![[dic objectForKey:@"version_status"] isKindOfClass:[NSNull class]]) {
                version_status = (NSDictionary* )[dic objectForKey:@"version_status"];
                
                int force = 0;
                if ([version_status objectForKey:@"force"] && ![[version_status objectForKey:@"force"] isKindOfClass:[NSNull class]]) {
                    force = [[version_status objectForKey:@"force"] intValue];
                    NSLog(@"force    %d",force);
                }
                NSDictionary* latestDic = [NSDictionary dictionary];
                if ([version_status objectForKey:@"latest"] && ![[version_status objectForKey:@"latest"] isKindOfClass:[NSNull class]]) {
                    latestDic = (NSDictionary* )[version_status objectForKey:@"latest"];
                }
                NSString* description = @"";
                if ([latestDic objectForKey:@"description"] && ![[latestDic objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
                    description = [latestDic objectForKey:@"description"];
                }
                NSString* version = @"";
                if ([latestDic objectForKey:@"version"] && ![[latestDic objectForKey:@"version"] isKindOfClass:[NSNull class]]) {
                    version = [latestDic objectForKey:@"version"];
                    self.version = version;
                }
                NSString* setup_url = @"";
                if ([latestDic objectForKey:@"setup_url"] && ![[latestDic objectForKey:@"setup_url"] isKindOfClass:[NSNull class]]) {
                    setup_url = [latestDic objectForKey:@"setup_url"];
                    self.setup_url = setup_url;
                }
                NSString* part_upgrade_url = @"";
                if ([latestDic objectForKey:@"part_upgrade_url"] && ![[latestDic objectForKey:@"part_upgrade_url"] isKindOfClass:[NSNull class]]) {
                    part_upgrade_url = [latestDic objectForKey:@"part_upgrade_url"];
                }
                if (![[AppDelegate appDelegate].commonmthod.getLocalVersion isEqualToString:version]) {
                    if (force == 0) {
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:description delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertView.tag = 888;
                        [alertView show];
                        
                    } else {
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"更新" message:description delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        alertView.tag = 889;
                    }
                }
                [_mainTabBarController anUpdatedVersion];
            }
        }
    }];
}
- (void)alertView:(UIAlertView* )alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 888) {
        
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.setup_url]];
        
        } else if (buttonIndex == 0) {
            return;
        }
        
    } else if (alertView.tag == 889) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.setup_url]];
    }
}
#pragma mark 获取定位
- (void)getLocation {
    
    NSString* url = kInternationalIPURLString;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    request.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse*  _Nullable response, NSData*  _Nullable data, NSError*  _Nullable connectionError) {
        if (data && connectionError == nil) {
//            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange strRange = [str rangeOfString:@"var returnCitySN = {"];
            
            if (strRange.location != NSNotFound) {
                
                str = [str substringFromIndex:strRange.location + strRange.length];
                str = [str stringByReplacingOccurrencesOfString:@"};" withString:@""];
                NSArray* array = [str componentsSeparatedByString:@","];

                for (int i = 0; i < array.count ; i ++) {
                    NSString* cityName = [array objectAtIndex:i];
                    NSArray* array1 = [cityName componentsSeparatedByString:@": "];
                    if (array1.count >= 2) {
                        
                        NSString* ipStr = [array1 objectAtIndex:0];
                        NSString* ipstring = [array1 objectAtIndex:1];
                        if ([ipStr hasSuffix:@"\"cip\""]) {
                            [AppDelegate appDelegate].userInfostruct.loginip = [ipstring stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            NSLog(@"AppDelegate appDelegate].userInfostruct.loginip  ====%@",[AppDelegate appDelegate].userInfostruct.loginip);
                        }
                    }
                }
            }
        }
    }];
}
- (void)applicationWillResignActive:(UIApplication* )application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[
                                               @(ConversationType_PRIVATE),
                                               @(ConversationType_DISCUSSION),
                                               @(ConversationType_APPSERVICE),
                                               @(ConversationType_PUBLICSERVICE),
                                               @(ConversationType_GROUP)
                                               ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
}


- (void)applicationDidEnterBackground:(UIApplication* )application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication* )application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication* )application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication* )application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 强制更新机制
- (void)mandatoryUpdatingMechanism {
    
}

@end
