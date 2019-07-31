//
//  DetailTaskTableViewCell.m
//  assistant
//
//  Created by Bepa  on 2017/9/19.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "DetailTaskTableViewCell.h"

@implementation DetailTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
}
- (void)createViews {
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    __weak DetailTaskTableViewCell *weakself = self;
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView).offset(25);
        make.left.equalTo(weakself.contentView.mas_left).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(150);
    }];
    
    _arrowImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_arrowImgView];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.right.equalTo(weakself.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(18);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = RGB(234, 238, 241);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself.contentView);
        make.bottom.equalTo(weakself.contentView);
        make.height.mas_equalTo(1);
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
