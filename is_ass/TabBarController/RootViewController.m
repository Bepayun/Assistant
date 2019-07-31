//
//  RootViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRootNav];
}
- (void)createRootNav {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGBA(18, 150, 219, 1.0f);
    //`左按钮
    self.leftButton = [[UIButton alloc] init];
    self.leftButton.frame = CGRectMake(0, 0, 30, 25);
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    //`标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0, 0, 100, 40);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleLabel;
    //`右按钮
    self.rightButton = [[UIButton alloc] init];
    self.rightButton.frame = CGRectMake(0, 0, 30, 25);
    self.rightButton.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

//设置导航栏背景颜色
-(void)setnavigationBarcolor:(UIColor *)color andalph:(BOOL)alph{
    //`导航透明度
    self.navigationController.navigationBar.translucent = alph;
    //`导航颜色
    self.navigationController.navigationBar.barTintColor = color;
}
- (void)addLeftTarget:(SEL)selector {
    [self.leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}
- (void)addRightTarget:(SEL)selector {
    [self.rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
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
