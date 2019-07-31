//
//  PerformanceHeaderView.m
//  is_ass
//
//  Created by Bepa  on 2017/9/12.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "PerformanceHeaderView.h"

@interface PerformanceHeaderView ()

@property (nonatomic, strong) UILabel *present_Dou;
@property (nonatomic, strong) UILabel *yesterday_Dou;
@property (nonatomic, strong) UILabel *user_total;

@end

@implementation PerformanceHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createViews];
    }
    return self;
}
- (void)createViews {
    UIView *headerView = [[UIView alloc] init];
    [self addSubview:headerView];
    __weak PerformanceHeaderView *weakself = self;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakself);
        make.height.mas_equalTo(110);
        
    }];
    // 当前
    UILabel *presentLabel = [[UILabel alloc] init];
    //    presentLabel.backgroundColor = [UIColor magentaColor];
    [headerView addSubview:presentLabel];
    presentLabel.text = @"当前";
    presentLabel.textColor = [UIColor blackColor];
    presentLabel.textAlignment = NSTextAlignmentLeft;
    presentLabel.font = [UIFont systemFontOfSize:14.0f];
    //
    UILabel *present_Dou = [[UILabel alloc] init];
    //    present_Dou.backgroundColor = [UIColor redColor];
    [headerView addSubview:present_Dou];
    present_Dou.text = @"0豆";
    present_Dou.textColor = [UIColor blackColor];
    present_Dou.textAlignment = NSTextAlignmentCenter;
    present_Dou.font = [UIFont systemFontOfSize:14.0f];
    self.present_Dou = present_Dou;
    //昨天
    UILabel *yesterdayLabel = [[UILabel alloc] init];
    //    yesterdayLabel.backgroundColor = [UIColor magentaColor];
    [headerView addSubview:yesterdayLabel];
    yesterdayLabel.text = @"昨天";
    yesterdayLabel.textColor = [UIColor blackColor];
    yesterdayLabel.textAlignment = NSTextAlignmentLeft;
    yesterdayLabel.font = [UIFont systemFontOfSize:14.0f];
    //
    UILabel *yesterday_Dou = [[UILabel alloc] init];
    //    yesterday_Dou.backgroundColor = [UIColor redColor];
    [headerView addSubview:yesterday_Dou];
    yesterday_Dou.text = @"0豆";
    yesterday_Dou.textColor = [UIColor blackColor];
    yesterday_Dou.textAlignment = NSTextAlignmentCenter;
    yesterday_Dou.font = [UIFont systemFontOfSize:14.0f];
    self.yesterday_Dou = yesterday_Dou;
    //总人数Account
    UILabel *totalNumberOfLabel = [[UILabel alloc] init];
    //    totalNumberOfLabel.backgroundColor = [UIColor magentaColor];
    [headerView addSubview:totalNumberOfLabel];
    totalNumberOfLabel.text = @"总人数";
    totalNumberOfLabel.textColor = [UIColor blackColor];
    totalNumberOfLabel.textAlignment = NSTextAlignmentLeft;
    totalNumberOfLabel.font = [UIFont systemFontOfSize:14.0f];
    //
    UILabel *user_total = [[UILabel alloc] init];
    //    totalNumberOfLabel.backgroundColor = [UIColor redColor];
    [headerView addSubview:user_total];
    user_total.text = @"0个";
    user_total.textColor = [UIColor blackColor];
    user_total.textAlignment = NSTextAlignmentCenter;
    user_total.font = [UIFont systemFontOfSize:14.0f];
    self.user_total = user_total;
    
    CGFloat height = 20;
    CGFloat width = 40;
    CGFloat spacing = 25;
    [presentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.top.equalTo(headerView.mas_top).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width-5);
    }];
    [present_Dou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(presentLabel.mas_right);
        make.top.equalTo(headerView.mas_top).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width+30);
    }];
    //
    [yesterdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(present_Dou.mas_right).offset(10);
        make.top.equalTo(headerView.mas_top).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    [yesterday_Dou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yesterdayLabel.mas_right);
        make.top.equalTo(headerView.mas_top).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width+30);
    }];
    //
    [totalNumberOfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yesterday_Dou.mas_right).offset(spacing-5);
        make.top.equalTo(headerView.mas_top).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width+10);
    }];
    [user_total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalNumberOfLabel.mas_right);
        make.top.equalTo(headerView.mas_top).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width+30);
    }];
    
    // 昵称
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [headerView addSubview:nicknameLabel];
    nicknameLabel.text = @"昵称";
    nicknameLabel.textColor = [UIColor blackColor];
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    nicknameLabel.font = [UIFont systemFontOfSize:15.0f];
    
    //账号
    UILabel *accountLabel = [[UILabel alloc] init];
    [headerView addSubview:accountLabel];
    accountLabel.text = @"账号";
    accountLabel.textColor = [UIColor blackColor];
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.font = [UIFont systemFontOfSize:15.0f];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [headerView addSubview:timeLabel];
    timeLabel.text = @"时间";
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UILabel *line = [[UILabel alloc] init];
    [headerView addSubview:line];
    line.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat heightLabel = 18;
    CGFloat widthLabel = 60;
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(spacing);
        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
        make.height.mas_equalTo(heightLabel);
        make.width.mas_equalTo(widthLabel);
    }];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nicknameLabel.mas_right).offset(spacing);
        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
        make.height.mas_equalTo(heightLabel);
        make.width.mas_equalTo(widthLabel);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLabel.mas_right).offset(widthLabel-10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
        make.height.mas_equalTo(heightLabel);
        make.width.mas_equalTo(widthLabel);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(nicknameLabel.mas_top).offset(-(spacing-3));
    }];

}
- (void)setModel:(RecordModel *)model {
    if (model.income_dou != nil && model.income_dou.length > 0) {
        self.present_Dou.text = [NSString stringWithFormat:@"%@豆",model.income_dou];
    }
    if (model.pre_income_dou != nil && model.pre_income_dou.length > 0) {
        self.yesterday_Dou.text = [NSString stringWithFormat:@"%@豆",model.pre_income_dou];
    }
    if (model.user_total != nil && model.user_total.length > 0) {
        self.user_total.text = [NSString stringWithFormat:@"%@个",model.user_total];
    } 
}

- (void)awakeWithContext:(id)context {
    [self awakeWithContext:context];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
