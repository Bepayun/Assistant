//
//  RecordsOfConsumptionViewController.m
//  is_ass
//
//  Created by Bepa  on 2017/10/17.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RecordsOfConsumptionViewController.h"
#import "RecordViewController.h"
#import "GoldCoinViewController.h"

@interface RecordsOfConsumptionViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleBtnAry;
@property (nonatomic, strong) UIButton *button;

@end

@implementation RecordsOfConsumptionViewController
#pragma mark - 设置第一个默认选中状态
- (void)viewWillAppear:(BOOL)animated {
    // 处理默认选中第一个按钮
    for (UIButton * btn in self.titleBtnAry) {
        if (btn == [self.titleBtnAry firstObject]) {
            btn.selected = YES;
            btn.backgroundColor = RGB(18, 150, 219);
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleBtnAry = [NSMutableArray arrayWithCapacity:0];
    [self createScrollViews];
    [self createNav];
}
- (void)createScrollViews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    RecordViewController *recordVC = [[RecordViewController alloc] init];
    GoldCoinViewController *goldCoinVC = [[GoldCoinViewController alloc] init];
    NSArray *array = @[recordVC,goldCoinVC];
    _scrollView.contentSize = CGSizeMake(array.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    int i = 0;
    for (UIViewController *vc in array) {
        vc.view.frame = CGRectMake(i * _scrollView.frame.size.width, 60, _scrollView.frame.size.width, _scrollView.frame.size.height);
        // 必须要将控制器设置为本控制器的childViewController
        [self addChildViewController:vc];
        [_scrollView addSubview:vc.view];
        i ++;
    }
    // 顶部切换按钮
    NSArray *titleArray = @[@"助手豆",@"金币",];
    for (int i = 0; i < titleArray.count ; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * ScreenWidth / 2, 10, ScreenWidth / 2, 40);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.backgroundColor = RGB(229, 233, 235);
        
        button.tag = 10+i;
        self.button = button;
        [button addTarget:self action:@selector(titleBtnAryPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBtnAry addObject:button];
        [self.view addSubview:button];
    }

}
- (void)titleBtnAryPressed:(UIButton *)sender {
    // 关联scrollView
    _scrollView.contentOffset = CGPointMake((sender.tag - 10) * _scrollView.frame.size.width, _scrollView.frame.origin.y);
    
    // 改变标题的选中状态，保证每次只有一个按钮被选中
    for (UIButton *btn in self.titleBtnAry) {
        if (btn.selected == YES) {
            btn.backgroundColor = RGB(18, 150, 219);
            btn.selected = NO;
        }
    }
    sender.selected = YES;
}
#pragma mark - 反向关联button
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int tag = (int)scrollView.contentOffset.x / scrollView.frame.size.width;

    for (UIButton *btn in self.titleBtnAry) {
        if (btn.selected == YES) {
            btn.backgroundColor = RGB(18, 150, 219);// 选中颜色
            btn.selected = NO;
        }
        btn.backgroundColor = RGB(229, 233, 235);// 默认颜色
    }
    UIButton *button = self.titleBtnAry[tag];
    button.selected = YES;
    if (button.selected == YES) {
        button.backgroundColor = RGB(18, 150, 219);

    } else {
        button.backgroundColor = RGB(229, 233, 235);
    }
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"消费记录";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
