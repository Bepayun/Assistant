//
//  CashWithdrawalTableViewCell.m
//  assistant
//
//  Created by Bepa  on 2017/10/31.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "CashWithdrawalTableViewCell.h"

@implementation CashWithdrawalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
}
- (void)createViews {
    //·申请时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.text = @"";
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    //·提现数量
    self.numLabel = [[UILabel alloc] init];
    self.numLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.numLabel];
    self.numLabel.text = @"";
    self.numLabel.textColor = [UIColor blackColor];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.font = [UIFont systemFontOfSize:14.0f];
    
    //·状态
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.stateLabel];
    self.stateLabel.text = @"";
    self.stateLabel.textColor = [UIColor blackColor];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    
    CGFloat height = 20;
    CGFloat width = 95;
    CGFloat spacing = 10;
     __weak CashWithdrawalTableViewCell *weakself = self;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(15);
        make.left.equalTo(weakself.mas_left).offset(3);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width + 45);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(15);
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(15);
        make.right.equalTo(weakself.mas_right).offset(-11);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width-10);
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
