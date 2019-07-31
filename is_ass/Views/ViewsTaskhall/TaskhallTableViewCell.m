//
//  TaskhallTableViewCell.m
//  AutoCellHeight
//
//  Created by Bepa on 2017/09/01.
//  Copyright © 2017年 . All rights reserved.
//

#import "TaskhallTableViewCell.h"

@implementation TaskhallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *leftImageView = [[UIImageView alloc]init];
        leftImageView.layer.masksToBounds = YES;
        leftImageView.layer.cornerRadius = 3;
        self.platformIcon = leftImageView;
        [self addSubview:self.platformIcon];
        [self.platformIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.equalTo(@10);
            make.top.equalTo(@10);
        }];
        
        self.taskInfoLabel = [[UILabel alloc]init];
        self.taskInfoLabel.numberOfLines = 0;
        self.taskInfoLabel.backgroundColor = [UIColor clearColor];//RGBA(255, 255, 255, 1);
        self.taskInfoLabel.textColor = RGBA(55, 55,46, 1);
        self.taskInfoLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.taskInfoLabel];
        [self.taskInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftImageView.mas_centerY);
            make.left.equalTo(leftImageView.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-110, 20));
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBA(206,206,206, 1);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_left);
            make.top.equalTo(leftImageView.mas_bottom).offset(10);
            make.height.offset(0.5);
            make.width.offset(ScreenWidth-80);
        }];
        
        self.pay_method = [[UILabel alloc] init];
        self.pay_method.backgroundColor = RGBA(255, 255, 255, 1);
        self.pay_method.textColor = RGBA(45, 51,46, 1);
        self.pay_method.font = [UIFont systemFontOfSize:12.0f];
        self.pay_method.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.pay_method];
        [self.pay_method mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
        }];
        
        self.content = [[UILabel alloc]init];
        self.content.numberOfLines = 0;
        self.content.backgroundColor = RGBA(255, 255, 255, 1);
        self.content.textColor = RGBA(45, 51,46, 1);
        self.content.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(15);
            make.bottom.equalTo(@-15);
            make.left.equalTo(leftImageView.mas_left).offset(0);
            make.width.offset(ScreenWidth-80);
        }];

        self.product_price = [[UILabel alloc] init];
        self.product_price.numberOfLines = 0;
        self.product_price.textAlignment = NSTextAlignmentCenter;
        self.product_price.backgroundColor = [UIColor clearColor];
        self.product_price.textColor = [UIColor blackColor];
        self.product_price.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:self.product_price];
        [self.product_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pay_method.mas_bottom).offset(1);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(50);
        }];
        
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.backgroundColor = RGBA(117, 173, 234, 1.0);
        [Button setTitle:@"接任务" forState:UIControlStateNormal];
        [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         Button.titleLabel.font = [UIFont systemFontOfSize:12];
        [Button addTarget:self action:@selector(OrderBegin:) forControlEvents:UIControlEventTouchUpInside];
         self.OrderButton = Button;
        [self addSubview:_OrderButton];
        [_OrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(lineView.mas_right).with.offset(10);
//            make.top.equalTo(leftImageView.mas_bottom).with.offset(0);
            make.top.equalTo(self.product_price.mas_bottom).offset(1);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.offset(50);
            make.height.offset(30);
        }];
        
        self.date = [[UILabel alloc]init];
        self.date.numberOfLines = 0;
        self.date.backgroundColor = RGBA(255, 255, 255, 1);
        self.date.textColor = RGBA(133, 133,133, 1);
        self.date.font = [UIFont systemFontOfSize:12];
        self.date.adjustsFontSizeToFitWidth = YES;
        self.date.numberOfLines = 1;
        [self addSubview:self.date];
        [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.content.mas_right).with.offset(10);
//            make.top.equalTo(self.content.mas_top).with.offset(2);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
//            make.size.mas_equalTo(_OrderButton);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(50);
        }];
    }
    return self;
}
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
-(void)OrderBegin:(UIButton *)btn{
    [self.delegate Order_TakingBegin:(int)btn.tag withTask_id:self.taskid];
}
@end
