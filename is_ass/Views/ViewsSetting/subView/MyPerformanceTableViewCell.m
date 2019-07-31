//
//  MyPerformanceTableViewCell.m
//  assistant
//
//  Created by Bepa  on 2017/9/12.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "MyPerformanceTableViewCell.h"

@implementation MyPerformanceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
}
- (void)createViews {
    //昵称
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nickNameLabel];
    self.nickNameLabel.text = @"";
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel.font = [UIFont systemFontOfSize:14.0f];
    
    //账号
    self.accountLabel = [[UILabel alloc] init];
    self.accountLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.accountLabel];
    self.accountLabel.text = @"";
    self.accountLabel.textColor = [UIColor blackColor];
    self.accountLabel.textAlignment = NSTextAlignmentCenter;
    self.accountLabel.font = [UIFont systemFontOfSize:14.0f];
    //时间
    self.create_timeLabel = [[UILabel alloc] init];
    self.create_timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.create_timeLabel];
    self.create_timeLabel.text = @"";
    self.create_timeLabel.textColor = [UIColor blackColor];
    self.create_timeLabel.textAlignment = NSTextAlignmentLeft;
    self.create_timeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    CGFloat height = 20;
    CGFloat width = 95;
    CGFloat spacing = 10;
    __weak MyPerformanceTableViewCell *weakself = self;
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).offset(15);
        make.left.equalTo(weakself.contentView).offset(3);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).offset(15);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(spacing);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    [self.create_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).offset(15);
        make.left.equalTo(self.accountLabel.mas_right).offset(spacing+2);
        make.height.mas_equalTo(height);
        make.right.equalTo(weakself.contentView.mas_right).offset(-3);
    }];
}
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
