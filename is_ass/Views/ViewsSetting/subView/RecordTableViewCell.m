//
//  RecordTableViewCell.m
//  assistant
//
//  Created by Bepa  on 2017/9/11.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
}
- (void)createViews {
    // s日期create_time
    self.create_timeLabel = [[UILabel alloc] init];
    self.create_timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.create_timeLabel];
    self.create_timeLabel.text = @"";
    self.create_timeLabel.textColor = [UIColor lightGrayColor];
    self.create_timeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.create_timeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.timeStrLabel = [[UILabel alloc] init];
    self.timeStrLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.timeStrLabel];
    self.timeStrLabel.text = @"";
    self.timeStrLabel.textColor = [UIColor lightGrayColor];
    self.timeStrLabel.font = [UIFont systemFontOfSize:14.0f];
    self.timeStrLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat imgViewH = 45;
    self.change_imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.change_imageView];
    [self.change_imageView.layer setMasksToBounds:YES ];
    self.change_imageView.layer.cornerRadius = imgViewH/2;
    
    // 记录数量
    self.changeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.changeLabel];
    self.changeLabel.backgroundColor = [UIColor clearColor];
    self.changeLabel.text = @"";
    self.changeLabel.textColor = [UIColor blackColor];
    self.changeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.changeLabel.textAlignment = NSTextAlignmentLeft;
    
    //
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.descriptionLabel];
    self.descriptionLabel.text = @"";
    self.descriptionLabel.textColor = [UIColor lightGrayColor];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat width = 90;
    CGFloat height = 20;
    CGFloat spacing = 20;
    __weak RecordTableViewCell *weakself = self;
    [self.create_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself).offset(spacing-5);
        make.left.equalTo(weakself);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.timeStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.create_timeLabel.mas_bottom).offset(spacing-10);
        make.left.equalTo(weakself);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.change_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.create_timeLabel.mas_right).offset(spacing/2);
        make.top.equalTo(self.mas_top).offset(spacing-2);
        make.height.width.mas_equalTo(imgViewH);
    }];
   
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.change_imageView.mas_right).offset(spacing+1);
        make.top.equalTo(weakself).offset(spacing-5);
        make.height.mas_equalTo(height);
        make.right.equalTo(self.mas_right).offset(-(spacing/2));
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeLabel.mas_bottom).offset(spacing-10);
        make.left.equalTo(self.change_imageView.mas_right).offset(spacing);
        make.height.mas_equalTo(height);
        make.right.equalTo(self.mas_right).offset(-3);
    }];
    //
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = RGB(234, 238, 241);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentView.mas_left).offset(4);
        make.right.bottom.equalTo(weakself.contentView);
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
