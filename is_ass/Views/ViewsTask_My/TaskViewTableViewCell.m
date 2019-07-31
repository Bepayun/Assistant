//
//  TaskViewTableViewCell.m
//  assistant
//
//  Created by Bepa  on 2017/9/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaskViewTableViewCell.h"

@implementation TaskViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
}
- (void)createViews {
    // 接任务时间
    _create_timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_create_timeLabel];
    _create_timeLabel.text = @"";
    _create_timeLabel.textColor = [UIColor lightGrayColor];
    _create_timeLabel.font = [UIFont systemFontOfSize:14.0f];
    _create_timeLabel.textAlignment = NSTextAlignmentLeft;
    // 接任务类型
    _platformLabel = [[UILabel alloc] init];
//    _platformLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_platformLabel];
    _platformLabel.text = @"";
    _platformLabel.textColor = [UIColor blackColor];
    _platformLabel.font = [UIFont systemFontOfSize:18.0f];
    _platformLabel.textAlignment = NSTextAlignmentLeft;
    // 描述
    _remarkLabel = [[UILabel alloc] init];
//    _remarkLabel.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:_remarkLabel];
    _remarkLabel.text = @"";
    _remarkLabel.textColor = [UIColor lightGrayColor];
    _remarkLabel.font = [UIFont systemFontOfSize:14.0f];
    _remarkLabel.textAlignment = NSTextAlignmentLeft;
    // 总结
    _summaryLabel = [[UILabel alloc] init];
//    _summaryLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_summaryLabel];
    _summaryLabel.text = @"";
    _summaryLabel.textColor = [UIColor lightGrayColor];
    _summaryLabel.font = [UIFont systemFontOfSize:12.0f];
    _summaryLabel.textAlignment = NSTextAlignmentLeft;
    // 接任务的状态
    CGFloat fontSize = 14.0f;
    if (SCREEN_MODE_IPHONE6x) {
        fontSize = 14.0f;
    }
    _stateLabel = [[UILabel alloc] init];
//    _stateLabel.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:_stateLabel];
    _stateLabel.text = @"";
    _stateLabel.textColor = [UIColor blackColor];
    _stateLabel.font = [UIFont systemFontOfSize:fontSize];
    _stateLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat height = 20;
    CGFloat width = 100;
    CGFloat spacing = 20;
    CGFloat spacing1 = spacing/2-8;
    CGFloat width1 = width+8;
    if (SCREEN_MODE_IPHONE6x) {
        width1 = width+30;
        spacing1 = spacing/2;
    }
    __weak TaskViewTableViewCell *weakself = self;
    [_create_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView).offset(10);
        make.left.equalTo(weakself.contentView.mas_left).offset(spacing);
        make.right.equalTo(weakself.contentView.mas_right).offset(-(spacing*3));
        make.height.mas_equalTo(height);
    }];
    
    [_platformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_create_timeLabel.mas_bottom).offset(spacing);
        make.left.equalTo(weakself.contentView.mas_left).offset(spacing);
        make.height.mas_equalTo(height+2);
        make.width.mas_equalTo(width/2+40);//width/2+5
    }];
    
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.platformLabel.mas_bottom).offset(spacing);
        make.left.equalTo(weakself.contentView.mas_left).offset(spacing);
        make.right.equalTo(weakself.contentView.mas_right).offset(-spacing/2);
        make.height.mas_equalTo(height);
    }];
    
    [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.create_timeLabel.mas_bottom).offset(spacing);
        make.left.equalTo(self.platformLabel.mas_right).offset(spacing/2-8);
        make.height.mas_equalTo(height+2);
        make.width.mas_equalTo(width+30);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_create_timeLabel.mas_bottom).offset(spacing);
        make.right.equalTo(weakself.contentView.mas_right).offset(-spacing1);
        make.height.mas_equalTo(height+2);
        make.left.equalTo(self.summaryLabel.mas_right);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = RGB(234, 238, 241);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
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
