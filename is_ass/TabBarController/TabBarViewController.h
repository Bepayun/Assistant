//
//  TabBarViewController.h
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController

@property (nonatomic, assign) NSUInteger selectedTabBarIndex;

+ (TabBarViewController* )shareInstance;

- (void)anUpdatedVersion;

@end
