//
//  PersonalHeaderView.m
//  assistant
//
//  Created by Bepa  on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "PersonalHeaderView.h"

@interface PersonalHeaderView ()

@property (nonatomic, strong) UIImageView* iconImageView;
@property (nonatomic, strong) UILabel* idLabel;
@property (nonatomic, strong) UILabel* roomNumLabel;
@property (nonatomic, strong) UILabel* addessLabel;
@property (nonatomic, strong) UILabel* points;// 助手豆
@property (nonatomic, strong) UILabel* marginLabel; // 保证金
@property (nonatomic, strong) UILabel* lineOne;
@property (nonatomic, strong) UILabel* lineTwo;

@end

@implementation PersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {

        [self createViews];
    }
    return self;
}
- (void)createViews {
    //`头像
    UIImage* icoverImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kDefaultAvatarIcon ofType:kPngName]];
    self.iconImageView = [[UIImageView alloc] init];
    [self.iconImageView setImage:icoverImage];
    [self addSubview:self.iconImageView];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    //`id
    self.idLabel = [[UILabel alloc] init];
    [self addSubview:self.idLabel];
    self.idLabel.text = @"ID：";
    self.idLabel.textColor = [UIColor blackColor];
    self.idLabel.font = [UIFont systemFontOfSize:15.0f];
    self.idLabel.backgroundColor = [UIColor clearColor];
    //房间号
    self.roomNumLabel = [[UILabel alloc] init];
    [self addSubview:self.roomNumLabel];
    self.roomNumLabel.text = @"房间：";
    self.roomNumLabel.textColor = [UIColor blackColor];
    self.roomNumLabel.font = [UIFont systemFontOfSize:15.0f];
     self.roomNumLabel.backgroundColor = [UIColor clearColor];
    // 保证金
    self.marginLabel = [[UILabel alloc] init];
    [self addSubview:self.marginLabel];
    self.marginLabel.text = @"保证金：";
    self.marginLabel.textColor = [UIColor blackColor];
    self.marginLabel.font = [UIFont systemFontOfSize:15.0f];
     self.marginLabel.backgroundColor = [UIColor clearColor];
    //`地址
    self.addessLabel = [[UILabel alloc] init];
    [self addSubview:self.addessLabel];
    self.addessLabel.text = @"地址：";
    
    self.addessLabel.textColor = [UIColor blackColor];
    self.addessLabel.font = [UIFont systemFontOfSize:14.0f];
    self.addessLabel.textAlignment = NSTextAlignmentCenter;
    //`助手豆
    self.points = [[UILabel alloc] init];
    [self addSubview:self.points];
    self.points.text = @"助手豆：";
    
    self.points.textColor = [UIColor blackColor];
    self.points.font = [UIFont systemFontOfSize:14.0f];
    self.points.textAlignment = NSTextAlignmentCenter;
    //`
    self.lineOne = [[UILabel alloc] init];
    _lineOne.backgroundColor = RGB(234, 238, 241);
    [self addSubview:self.lineOne];
    self.lineTwo = [[UILabel alloc] init];
    _lineTwo.backgroundColor = RGB(234, 238, 241);
    [self addSubview:self.lineTwo];
    
    __weak PersonalHeaderView* weakself = self;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakself).offset(20);
        make.left.equalTo(weakself).offset(20);
        make.width.height.equalTo(@(70));
    }];
    //`
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.height.equalTo(@(25));
        make.width.equalTo(@(200));
    }];
    //
    [self.roomNumLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.bottom.equalTo(self.iconImageView);
        make.left.width.height.equalTo(self.idLabel);
        make.top.equalTo(self.idLabel.mas_bottom);
    }];
    //
    [self.marginLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.roomNumLabel.mas_bottom);
        make.left.with.height.equalTo(self.idLabel);
    }];
    //
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(1.3*20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.mas_left).offset(ScreenWidth/3+30);
        make.top.equalTo(_lineOne.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    //
    [self.addessLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.mas_equalTo(0);
        make.top.equalTo(self.lineOne.mas_bottom);
        make.right.equalTo(self.lineTwo.mas_left);
    }];
    //
    [self.points mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.bottom.mas_equalTo(0);
        make.left.equalTo(self.lineTwo.mas_left);
        make.top.equalTo(self.addessLabel);
    }];
}
- (void)PersonalHeaderViewData {
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* roomidStr = [userDefault objectForKey:kUserDefaultKeyRoomID];
    
    if ([AppDelegate appDelegate].userInfostruct.UserID != nil && [AppDelegate appDelegate].userInfostruct.UserID.length > 0) {
        self.idLabel.text = [NSString stringWithFormat:@"ID：%@",[AppDelegate appDelegate].userInfostruct.UserID];
    }
    if (roomidStr != nil && roomidStr.length > 0) {
        self.roomNumLabel.text = [NSString stringWithFormat:@"房间：%@",roomidStr];
    } else {
        if ([AppDelegate appDelegate].userInfostruct.roomID != nil && [AppDelegate appDelegate].userInfostruct.roomID.length > 0) {
            self.roomNumLabel.text = [NSString stringWithFormat:@"房间：%@",[AppDelegate appDelegate].userInfostruct.roomID];
        }
    }

    if ([AppDelegate appDelegate].userInfostruct.userCity != nil && [AppDelegate appDelegate].userInfostruct.userCity.length > 0) {
        self.addessLabel.text = [NSString stringWithFormat:@"地址：%@",[AppDelegate appDelegate].userInfostruct.userCity];
    }
    if ([AppDelegate appDelegate].userInfostruct.room_dou != nil && [AppDelegate appDelegate].userInfostruct.room_dou.length > 0) {
        self.points.text = [NSString stringWithFormat:@"助手豆：%@",[AppDelegate appDelegate].userInfostruct.room_dou];
    }
    if ([AppDelegate appDelegate].userInfostruct.jinbi_balance != nil && [AppDelegate appDelegate].userInfostruct.jinbi_balance.length > 0) {
        self.marginLabel.text = [NSString stringWithFormat:@"保证金：%@",[AppDelegate appDelegate].userInfostruct.jinbi_balance];
    }
}
- (void)awakeWithContext:(id)context {
    [self awakeWithContext:context];
}

@end
