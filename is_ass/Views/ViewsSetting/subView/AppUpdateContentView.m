//
//  AppUpdateContentView.m
//  assistant
//
//  Created by Bepa  on 2017/10/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "AppUpdateContentView.h"
#import "UpdateAppWebView.h"

@interface AppUpdateContentView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UpdateAppWebView* updateWebView;
@property (nonatomic, strong) UIView* subView;

@end

@implementation AppUpdateContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createViews];
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAppUpdateContentView)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        self.updateWebView = [[UpdateAppWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.updateWebView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.updateWebView];
        self.updateWebView.hidden = YES;
        
    }
    return self;
}
- (void)createViews {
    __weak AppUpdateContentView* weakSelf = self;

    UIView* subview = [[UIView alloc] initWithFrame:CGRectMake(35, 80, ScreenWidth-35*2, ScreenHeight-260)];
    subview.backgroundColor = [UIColor whiteColor];
    self.subView = subview;
    [self addSubview:subview];
    [subview mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.mas_top).offset(80);
        make.left.equalTo(weakSelf.mas_left).offset(35);
        make.right.equalTo(weakSelf.mas_right).offset(-35);
        make.height.mas_equalTo(ScreenHeight-260);
    }];
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    [subview addSubview:label];
    label.text = @"最新版本：";
    label.textColor = RGB(170, 139, 99);
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(subview.mas_top).offset(60);
        make.centerX.equalTo(subview.mas_centerX).offset(-30);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(18);
    }];
    
    UILabel* editionLabel = [[UILabel alloc] init];
    editionLabel.backgroundColor = [UIColor clearColor];
    [subview addSubview:editionLabel];
    
    if ([AppDelegate appDelegate].version != nil && [AppDelegate appDelegate].version.length > 0) {
        editionLabel.text = [AppDelegate appDelegate].version;
    }
    
    editionLabel.textColor = RGB(170, 139, 99);
    editionLabel.font = [UIFont systemFontOfSize:16.0f];
    editionLabel.textAlignment = NSTextAlignmentLeft;
    [editionLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(subview.mas_top).offset(60);
        make.left.equalTo(label.mas_right);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(18);
    }];
    //
    UIButton* updateBtn = [[UIButton alloc] init];
    updateBtn.backgroundColor = RGB(201, 201, 201);
    [subview addSubview:updateBtn];
    [updateBtn setTitle:@"立刻升级" forState:UIControlStateNormal];
    [updateBtn setTitleColor:RGB(170, 139, 99) forState:UIControlStateNormal];
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    updateBtn.layer.shadowOffset =  CGSizeMake(1, 1);
    updateBtn.layer.shadowOpacity = 0.8;
    updateBtn.layer.shadowColor =  [UIColor lightGrayColor].CGColor;
    
    [updateBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(subview.mas_bottom).offset(-15);
        make.centerX.equalTo(subview.mas_centerX);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(43);
    }];
    [updateBtn addTarget:self action:@selector(upgradeImmediatelyPressed) forControlEvents:UIControlEventTouchUpInside];

    // update the content
    UILabel* content1 = [[UILabel alloc] init];
    [subview addSubview:content1];
    content1.text = @"1.首页对热门游戏与其他游戏做了区分";
    content1.textColor = RGB(151, 150, 151);
    content1.font = [UIFont systemFontOfSize:14.0f];
    content1.textAlignment = NSTextAlignmentLeft;
    
    [content1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(label.mas_bottom).offset(18);
        make.left.equalTo(subview.mas_left).offset(25);
        make.right.equalTo(subview.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    UILabel* content2 = [[UILabel alloc] init];
    [subview addSubview:content2];
    content2.text = @"2.敏感字的过滤、修改";
    content2.textColor = RGB(151, 150, 151);
    content2.font = [UIFont systemFontOfSize:14.0f];
    content2.textAlignment = NSTextAlignmentLeft;
    
    [content2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(content1.mas_bottom).offset(4);
        make.left.equalTo(subview.mas_left).offset(25);
        make.right.equalTo(subview.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];

    UILabel* content3 = [[UILabel alloc] init];
    [subview addSubview:content3];
    content3.text = @"3.个人中心新添金币以及申请提现功能";
    content3.textColor = RGB(151, 150, 151);
    content3.font = [UIFont systemFontOfSize:14.0f];
    content3.textAlignment = NSTextAlignmentLeft;
    
    [content3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(content2.mas_bottom).offset(4);
        make.left.equalTo(subview.mas_left).offset(25);
        make.right.equalTo(subview.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
}
- (void)upgradeImmediatelyPressed {
    NSLog(@"upgradeImmediatelyPressed--upgradeImmediatelyPressed");
    self.updateWebView.hidden = NO;
}
- (void)removeAppUpdateContentView {
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch* )touch {
    
    if ([touch.view isDescendantOfView:self.subView]) {
        return NO;
    }
    return YES;
}

@end
