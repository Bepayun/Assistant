//
//  RechargeViewController.m
//  is_ass
//
//  Created by Bepa  on 2018/3/29.
//  Copyright © 2018年 Bepa. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self cerateViews];
    [self createNav];
}
- (void)cerateViews {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/client/uc/account/pay_mobile.php",KASSURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

}
- (void)createNav {
    __weak typeof(&*self) weakSelf = self;
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(20, 25, 30, 25);
    leftButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftButton];
    [leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(popViewControllerPressed) forControlEvents:UIControlEventTouchUpInside];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(33);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(30, 25));
    }];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
