//
//  TabBarViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#define TabbarItemNums 4.0

#import "TabBarViewController.h"
#import "TaskhallViewController.h"
#import "TaskViewController.h"
#import "MainTaskhallViewController.h"
#import "MySetViewController.h"
#import "SessionRongViewController.h"


@interface TabBarViewController ()

@property NSUInteger previousIndex;

@end


@implementation TabBarViewController

+ (TabBarViewController *)shareInstance {
    static TabBarViewController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createViewControllers];
    [self sentTabBar];
}

- (void)createViewControllers {
    //`任务大厅
    MainTaskhallViewController *mainTAskhall = [[MainTaskhallViewController alloc] init];
    UINavigationController *taskhallNav = [[UINavigationController alloc] initWithRootViewController:mainTAskhall];
    
//    TaskhallViewController *taskhall = [[TaskhallViewController alloc] init];
//    UINavigationController *taskhallNav = [[UINavigationController alloc] initWithRootViewController:taskhall];
    //`我的任务
    TaskViewController *task = [[TaskViewController alloc] init];
    UINavigationController *taskNav = [[UINavigationController alloc] initWithRootViewController:task];
    //`我的消息
    SessionRongViewController *sessionRong  = [[SessionRongViewController alloc] init];
    UINavigationController *sessionRongNav = [[UINavigationController alloc] initWithRootViewController:sessionRong];
    //`个人中心
    MySetViewController *myset = [[MySetViewController alloc] init];
    UINavigationController *mysetNav = [[UINavigationController alloc] initWithRootViewController:myset];
    
    
    UIView *dotView = [[UIView alloc] init];
    [self.tabBarController.tabBar addSubview:dotView];
    dotView.backgroundColor = RGB(204, 0, 10);
    CGFloat height = 20;
    dotView.layer.masksToBounds = YES;
    dotView.layer.cornerRadius = height/2;
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    CGFloat x = ceilf(0.94 * tabFrame.size.width);
    CGFloat y = ceilf(0.2 * tabFrame.size.height);
    dotView.frame = CGRectMake(x, y, 6, 6);
    myset.tabBarItem.badgeValue = [NSString stringWithFormat:@""];
    
    self.selectedIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTabbarControllerIndex) name:@"SendTabbarControllerIndex" object:nil];
    self.viewControllers = @[taskhallNav,taskNav,sessionRongNav,mysetNav];
}
- (void)sendTabbarControllerIndex {
    self.selectedIndex = 0;
}

- (void)sentTabBar {
    //`未选中image
    NSArray *unselectedImageAry = @[@"icon_home_home_default",@"icon_home_task_default",@"icon_home_message_default",@"icon_home_preson_default"];
    //`选中image
    NSArray *selectedImageAry = @[@"icon_home_home_pressed",@"icon_home_task_pressed",@"icon_home_message_pressed",@"icon_home_preson_pressed"];
    //`标题
    NSArray *titleArray = @[@"任务大厅",@"我的任务",@"我的消息",@"个人中心"];
    
    for (int i = 0; i < self.tabBar.items.count; i ++) {
        //`未选中image
        UIImage *unselectedImage = [UIImage imageNamed:unselectedImageAry[i]];
        unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //`选中image
        UIImage *selectedImage = [UIImage imageNamed:selectedImageAry[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //`tabBarItem
        UITabBarItem *item = self.tabBar.items[i];
        item = [item initWithTitle:titleArray[i] image:unselectedImage selectedImage:selectedImage];
    
    }
    
    //`点击颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(18, 150, 219)} forState:UIControlStateSelected];

}
- (void)anUpdatedVersion {
    
    if ([AppDelegate appDelegate].commonmthod.getLocalVersion != nil && [AppDelegate appDelegate].commonmthod.getLocalVersion.length > 0 && [AppDelegate appDelegate].version.length > 0 && [AppDelegate appDelegate].version != nil) {
        if (![[AppDelegate appDelegate].commonmthod.getLocalVersion isEqualToString:[AppDelegate appDelegate].version]) {
            
            [self.tabBar showBadgeOnItemIndexOne:3];
        } else {
            [self.tabBar hideBadgeOnItemIndexOne:3];
        }
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SessionRongViewController class]]) {
            SessionRongViewController *chatListVC = (SessionRongViewController *)obj;
            [chatListVC updateBadgeValueForTabBarItem];
        }
    }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
