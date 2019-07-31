
//
//  MainTaskhallViewController.m
//  assistant
//
//  Created by Bepa  on 2017/10/31.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "MainTaskhallViewController.h"
#import "TaskhallViewController.h"
#import "TaskhallViewController_Registration.h"
#import "CustomAlertView.h"

@interface MainTaskhallViewController ()<UIScrollViewDelegate,CustomAlertViewDelegate>

@property (nonatomic, strong) TaskhallViewController* taskhallVC;
@property (nonatomic, strong) TaskhallViewController_Registration* taskhallVC_Registration;
@property (nonatomic, strong) CustomAlertView* AlertView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray* titleBtnAry;
@property (nonatomic, strong) UIButton* button;

@end

@implementation MainTaskhallViewController
#pragma mark - 设置第一个默认选中状态
- (void)viewWillAppear:(BOOL)animated {
//    // 处理默认选中第一个按钮
//    for (UIButton* btn in self.titleBtnAry) {
//        if (btn == [self.titleBtnAry firstObject]) {
//            btn.selected = YES;
//            btn.backgroundColor = RGB(18, 150, 219);
//        }
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.titleBtnAry = [NSMutableArray arrayWithCapacity:0];
    [self createScrollViews];
    [self createNav];
    for (UIButton* btn in self.titleBtnAry) {
        if (btn == [self.titleBtnAry firstObject]) {
            btn.selected = YES;
            btn.backgroundColor = RGB(18, 150, 219);
        }
    }
}
- (void)createScrollViews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.taskhallVC = [[TaskhallViewController alloc] init];
    self.taskhallVC_Registration = [[TaskhallViewController_Registration alloc] init];
    NSArray* array = @[self.taskhallVC_Registration, self.taskhallVC];
    self.scrollView.contentSize = CGSizeMake(array.count*  self.scrollView.frame.size.width, 0);
    int i = 0;
    for (UIViewController* vc in array) {
        vc.view.frame = CGRectMake(i*  self.scrollView.frame.size.width, 56, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        i ++;
    }
    
    //`顶部切换按钮
    NSArray* titleArray = @[@"高佣厅",@"京淘厅"];
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*  (ScreenWidth-40)/2+20, 8, (ScreenWidth-40) / 2, 40);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.backgroundColor = RGB(229, 233, 235);
        
        button.tag = 100+i;
        self.button = button;
        [button addTarget:self action:@selector(titleBtnAryPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBtnAry addObject:button];
        [self.view addSubview:button];
    }
    
}
- (void)titleBtnAryPressed:(UIButton* )sender {
    //`关联ScrollView
    self.scrollView.contentOffset = CGPointMake((sender.tag - 100)*  _scrollView.frame.size.width, _scrollView.frame.origin.y);
    
    //`改变标题的选中状态，保证每次只有一个按钮被选中
    for (UIButton* btn in self.titleBtnAry) {
        if (btn.selected == YES) {
            btn.backgroundColor = RGB(18, 150, 219);//选中颜色
            btn.selected = NO;
        }
    }
    sender.selected = YES;
}
#pragma mark - 反关联button
- (void)scrollViewDidScroll:(UIScrollView* )scrollView {
    int tag = (int)scrollView.contentOffset.x / scrollView.frame.size.width;
    for (UIButton* btn in self.titleBtnAry) {
        if (btn.selected == YES) {
            btn.backgroundColor = RGB(18, 150, 219);
            btn.selected = NO;
        }
        btn.backgroundColor = RGB(229, 233, 235);//默认颜色
    }
    UIButton* button = self.titleBtnAry[tag];
    button.selected = YES;
    if (button.selected == YES) {
        button.backgroundColor = RGB(18, 150, 219);
    
    } else {
        button.backgroundColor = RGB(229, 233, 235);
    }
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"任务大厅";
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton setImage:[UIImage imageNamed:@"setup_Img"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(ChangePlatformType:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)ChangePlatformType:(UIButton* )btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomAlertView" object:nil];
    [self.view  addSubview:self.AlertView];
    self.AlertView.hidden = NO;
    
}
- (CustomAlertView* )AlertView {
    if (!_AlertView) {
        _AlertView = [[CustomAlertView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
        _AlertView.delegate = self;
    }
    return _AlertView;
}
// 选择列表条件
- (void)buy_type:(NSString* )buytypestr andlevel:(NSString* )levelstr withPlatform:(NSString* )platform {
    
    self.taskhallVC.isCondition = YES;
    if (![platform isEqualToString:@"其他游戏"]) {
        self.taskhallVC.conditionPlatform = [self mainViewControllerWithPlatfrom:platform];
        self.taskhallVC.level = [self mainViewControllerWithLevelstr:levelstr];
        self.taskhallVC.buy_type = [self mainViewControllerWithBuytypeString:buytypestr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETTaskHallData" object:nil];
        
    } else {
        self.taskhallVC_Registration.conditionPlatform = [self mainViewControllerWithPlatfrom:platform];;
        self.taskhallVC_Registration.level = [self mainViewControllerWithLevelstr:levelstr];
        self.taskhallVC_Registration.buy_type = [self mainViewControllerWithBuytypeString:buytypestr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETTaskHallData_Registration" object:nil];
        
    }
    self.AlertView.hidden = YES;
}
- (NSString* )mainViewControllerWithLevelstr:(NSString* )levelstr {
    if ([levelstr isEqualToString:@"1级"]) {
        return levelstr = @"白号";
        
    } else if ([levelstr isEqualToString:@"10级"]) {
        return levelstr = @"1心";
        
    } else if ([levelstr isEqualToString:@"20级"]) {
        return levelstr = @"2心";
      
    } else if ([levelstr isEqualToString:@"30级"]) {
        return levelstr = @"3心";
   
    } else if ([levelstr isEqualToString:@"40级"]) {
        return levelstr = @"4心";
   
    } else if ([levelstr isEqualToString:@"50级"]) {
        return levelstr = @"5心";
   
    } else if ([levelstr isEqualToString:@"60级"]) {
        return levelstr = @"1钻";
   
    } else if ([levelstr isEqualToString:@"70级"]) {
        return levelstr = @"2钻";
    
    } else if ([levelstr isEqualToString:@"80级"]) {
        return levelstr = @"3钻";
    
    } else if ([levelstr isEqualToString:@"90级"]) {
        return levelstr = @"4钻";
   
    } else if ([levelstr isEqualToString:@"100级"]) {
        return levelstr = @"5钻";
        
    } else if ([levelstr isEqualToString:@"新手"]) {
        return levelstr = @"白号";
    
    } else if ([levelstr isEqualToString:@"青铜"]) {
        return levelstr = @"铜牌";
    
    } else if ([levelstr isEqualToString:@"白银"]) {
        return levelstr = @"银牌";
    
    } else if ([levelstr isEqualToString:@"黄金"]) {
        return levelstr = @"金牌";
   
    } else if ([levelstr isEqualToString:@"王者"]) {
        return levelstr = @"钻石";
    
    } else {
        return levelstr;
    }
    
    return @"";
}
- (NSString* )mainViewControllerWithBuytypeString:(NSString* )buytype {
    if ([buytype isEqualToString:@"'精品'"]) {
        return buytype = @"'精刷单'";
        
    } else if ([buytype isEqualToString:@"'高级'"]) {
        return buytype = @"'秒拍单'";;
        
    } else if ([buytype isEqualToString:@"'普通'"]) {
        return buytype = @"'浏览单'";
        
    } else {
        return buytype;
    }
    
    return @"";
}
- (NSString* )mainViewControllerWithPlatfrom:(NSString* )platfrom {
    
    if ([platfrom isEqualToString:@"热门游戏"]) {
        return platfrom = @"淘宝";
        
    } else if ([platfrom isEqualToString:@"网络游戏"]) {
        return platfrom = @"京东";;
        
    } else if ([platfrom isEqualToString:@"网页游戏"]) {
        return platfrom = @"拼多多";
        
    } else if ([platfrom isEqualToString:@"其他游戏"]) {
        return platfrom = @"其他";
    
    } else {
        return platfrom;
    }
    
    return @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
