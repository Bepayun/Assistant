//
//  DetailTaskHeaderView.m
//  assistant
//
//  Created by Bepa  on 2017/9/19.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "DetailTaskHeaderView.h"

@interface DetailTaskHeaderView ()

/**
 * 买的任务的类型 (精品)
 */
@property (nonatomic, strong) UILabel *buy_type;

/**
 * 条件评论
 */
@property (nonatomic, strong) UILabel *condition_summary;

/**
 * 总结 (白号3元)
 */
@property (nonatomic, strong) UILabel *commission_summary;

/**
 * 评论
 */
@property (nonatomic, strong) UILabel *remark;

/**
 * 创建时间
 */
@property (nonatomic, strong) UILabel *create_time;
@property (nonatomic, strong) UILabel *timeStr;

/**
 * 更新时间
 */
@property (nonatomic, strong) UILabel *update_time;
@property (nonatomic, strong) UILabel *timeStrb;

/**
 * 账号
 */
@property (nonatomic, strong) UILabel *tbaccount_name;

@end

@implementation DetailTaskHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}
- (void)createViews {
    _buy_type = [[UILabel alloc] init];
    [self addSubview:_buy_type];
    _buy_type.text = @"";//@"精品";
    _buy_type.textColor = [UIColor blackColor];
    _buy_type.font = [UIFont systemFontOfSize:18.0f];
    _buy_type.textAlignment = NSTextAlignmentLeft;
    
    _condition_summary = [[UILabel alloc] init];
    [self addSubview:_condition_summary];
    _condition_summary.text = @"";//@"天不过2，周不过4，月不过15";
    _condition_summary.textColor = RGB(18, 18, 18);
    _condition_summary.font = [UIFont systemFontOfSize:15.0f];
    _condition_summary.textAlignment = NSTextAlignmentLeft;
    
    _commission_summary = [[UILabel alloc] init];
    [self addSubview:_commission_summary];
    _commission_summary.text = @"";//@"白号3元";
    _commission_summary.textColor = [UIColor lightGrayColor];
    _commission_summary.font = [UIFont systemFontOfSize:15.0f];
    _commission_summary.textAlignment = NSTextAlignmentLeft;
    
    UILabel *remarkBg = [[UILabel alloc] init];
    [self addSubview:remarkBg];
    remarkBg.backgroundColor = RGB(222, 233, 248);
    
    _remark = [[UILabel alloc] init];
    [self addSubview:_remark];
    _remark.text = @"";//@"手机京东测试单2，大家不要接";
    _remark.textColor = RGB(18, 18, 18);
    _remark.font = [UIFont systemFontOfSize:15.0f];
    _remark.textAlignment = NSTextAlignmentLeft;
    
    UILabel *create_timeLabel = [[UILabel alloc] init];
//    create_timeLabel.backgroundColor = [UIColor magentaColor];
    [self addSubview:create_timeLabel];
    create_timeLabel.text = @"创建日期:";
    create_timeLabel.textColor = [UIColor lightGrayColor];
    create_timeLabel.font = [UIFont systemFontOfSize:15.0f];
    create_timeLabel.textAlignment = NSTextAlignmentLeft;
    
    _create_time = [[UILabel alloc] init];
//    _create_time.backgroundColor = [UIColor yellowColor];
    [self addSubview:_create_time];
    _create_time.text = @"";//@"2017-09-04";
    _create_time.textColor = [UIColor lightGrayColor];
    _create_time.font = [UIFont systemFontOfSize:15.0f];
    _create_time.textAlignment = NSTextAlignmentLeft;
    
    _timeStr = [[UILabel alloc] init];
//    _timeStr.backgroundColor = [UIColor blueColor];
    [self addSubview:_timeStr];
    _timeStr.text = @"";//@"15:30:44";
    _timeStr.textColor = [UIColor lightGrayColor];
    _timeStr.font = [UIFont systemFontOfSize:15.0f];
    _timeStr.textAlignment = NSTextAlignmentCenter;

    UILabel *update_timeLabel = [[UILabel alloc] init];
    [self addSubview:update_timeLabel];
    update_timeLabel.text = @"更新日期:";
    update_timeLabel.textColor = [UIColor lightGrayColor];
    update_timeLabel.font = [UIFont systemFontOfSize:15.0f];
    update_timeLabel.textAlignment = NSTextAlignmentLeft;
    
    _update_time = [[UILabel alloc] init];
    [self addSubview:_update_time];
    _update_time.text = @"";//@"2017-09-06";
    _update_time.textColor = [UIColor lightGrayColor];
    _update_time.font = [UIFont systemFontOfSize:15.0f];
    _update_time.textAlignment = NSTextAlignmentLeft;
    
    _timeStrb = [[UILabel alloc] init];
//    _timeStrb.backgroundColor = [UIColor redColor];
    [self addSubview:_timeStrb];
    _timeStrb.text = @"";//@"18:30:03";
    _timeStrb.textColor = [UIColor lightGrayColor];
    _timeStrb.font = [UIFont systemFontOfSize:15.0f];
    _timeStrb.textAlignment = NSTextAlignmentCenter;
    
    _tbaccount_name = [[UILabel alloc] init];
    [self addSubview:_tbaccount_name];
    _tbaccount_name.text = @"";//@"账号：13795229851_p";
    _tbaccount_name.textColor = [UIColor lightGrayColor];
    _tbaccount_name.font = [UIFont systemFontOfSize:15.0f];
    _tbaccount_name.textAlignment = NSTextAlignmentLeft;

    CGFloat height = 20;
    CGFloat width = 80;
    CGFloat spacing = 20;
    __weak DetailTaskHeaderView *weakself = self;
    [_buy_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself).offset(spacing);
        make.left.equalTo(weakself.mas_left).offset(spacing-5);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    
    [_condition_summary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(spacing);
        make.left.equalTo(_buy_type.mas_right).offset(5);
        make.right.equalTo(weakself.mas_right).offset(-(spacing-5));
        make.height.mas_equalTo(height);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    [self addSubview:line];
    line.backgroundColor = RGB(234, 238, 241);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buy_type.mas_bottom).offset(spacing);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(1);
    }];
    [_commission_summary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(spacing+2);
        make.left.equalTo(weakself.mas_left).offset(spacing-5);
        make.right.equalTo(weakself.mas_right).offset(-spacing*2);
        make.height.mas_equalTo(height);
    }];
    
    [remarkBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commission_summary.mas_bottom).offset(spacing+2);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(height);
    }];
    [_remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commission_summary.mas_bottom).offset(spacing+2);
        make.left.equalTo(weakself.mas_left).offset(spacing/2);
        make.height.mas_equalTo(height);
        make.right.equalTo(weakself.mas_right).offset(-(spacing-5));
    }];
    
    UILabel *line1 = [[UILabel alloc] init];
    [self addSubview:line1];
    line1.backgroundColor = RGB(234, 238, 241);
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBg.mas_bottom);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(1);
    }];
    
    [create_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBg.mas_bottom).offset(spacing);
        make.left.equalTo(weakself).offset(spacing/2);
        make.width.mas_equalTo(width-2);
        make.height.mas_equalTo(height);
    }];
    
    [_create_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBg.mas_bottom).offset(spacing/2);
        make.left.equalTo(create_timeLabel.mas_right);
        make.width.mas_equalTo(width+12);
        make.height.mas_equalTo(height);
    }];
    [_timeStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_create_time.mas_bottom);
        make.left.equalTo(create_timeLabel.mas_right).offset(1);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    UILabel *line2 = [[UILabel alloc] init];
    [self addSubview:line2];
    line2.backgroundColor = RGB(234, 238, 241);
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBg.mas_bottom);
        make.left.equalTo(weakself.mas_left).offset(ScreenWidth/2);
        make.height.mas_equalTo(height*3);
        make.width.mas_equalTo(1);
    }];

    
    [update_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBg.mas_bottom).offset(spacing);
        make.left.equalTo(line2.mas_right).offset(spacing/2);
        make.width.mas_equalTo(width-2);
        make.height.mas_equalTo(height);
    }];
    
    [_update_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBg.mas_bottom).offset(spacing/2);
        make.left.equalTo(update_timeLabel.mas_right);
        make.width.mas_equalTo(width+12);
        make.height.mas_equalTo(height);
    }];
    [_timeStrb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_update_time.mas_bottom);
        make.left.equalTo(update_timeLabel.mas_right).offset(1);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    UILabel *line3 = [[UILabel alloc] init];
    [self addSubview:line3];
    line3.backgroundColor = RGB(234, 238, 241);
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(create_timeLabel.mas_bottom).offset(spacing);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(1);
    }];
    
    [_tbaccount_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(spacing);
        make.left.equalTo(weakself.mas_left).offset(spacing/2);
        make.right.equalTo(weakself.mas_right).offset(-spacing*2);
        make.height.mas_equalTo(height);
    }];
    
    
    UILabel *line4 = [[UILabel alloc] init];
    [self addSubview:line4];
    line4.backgroundColor = RGB(234, 238, 241);
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tbaccount_name.mas_bottom).offset(spacing);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(1);
    }];
    
}
- (void)getHeaderDatas {
    if (_model.buy_type != nil && _model.buy_type.length > 0) {
        _buy_type.text = [self detailTaskWithBuy_type:_model.buy_type];
    }
    if (_model.remark != nil && _model.remark.length > 0) {
        _remark.text = _model.remark;
    }
    if (_model.create_timeD != nil && _model.create_timeD.length > 0) {
        _create_time.text = _model.create_timeD;
    }
    if (_model.timeStr != nil && _model.timeStr.length >0) {
        _timeStr.text = _model.timeStr;
    }
    if (_model.update_time != nil && _model.update_time.length > 0) {
        _update_time.text = _model.update_time;
    }
    if (_model.timeStrb != nil && _model.timeStrb.length > 0) {
        _timeStrb.text = _model.timeStrb;
    }
    if ([_model.platform isEqualToString:@"其他游戏"]) {
        if (_model.buid != nil && _model.buid.length > 0) {
            _tbaccount_name.text = [NSString stringWithFormat:@"账号：%@",_model.buid];
        }
        if (_model.commission_summary != nil && _model.commission_summary.length > 0) {
            _commission_summary.text = _model.commission_summary;
        }
        if (_model.condition_summary != nil && _model.condition_summary.length > 0) {
            _condition_summary.text = _model.condition_summary;
        }
        
    } else if ([_model.platform isEqualToString:@"网页游戏"]) {
        if (_model.buid != nil && _model.buid.length > 0) {
            _tbaccount_name.text = [NSString stringWithFormat:@"账号：%@",_model.buid];
        }
        if (_model.commission_summaryone != nil && _model.commission_summaryone.length > 0) {
            _commission_summary.text = _model.commission_summaryone;
        }
    
    } else {
        if (_model.tbaccount_name != nil && _model.tbaccount_name.length > 0) {
            _tbaccount_name.text = [NSString stringWithFormat:@"账号：%@",_model.tbaccount_name];
        }
        if (_model.commission_summary != nil && _model.commission_summary.length > 0) {
            _commission_summary.text = _model.commission_summary;
        }
        if (_model.condition_summary != nil && _model.condition_summary.length > 0) {
            _condition_summary.text = _model.condition_summary;
        }
    }
}
- (NSString *)detailTaskWithBuy_type:(NSString *)buy_type {

    if ([buy_type isEqualToString:@"精刷单"]) {
        return buy_type = @"精品任务";
        
    } else if ([buy_type isEqualToString:@"秒刷单"]) {
        return buy_type = @"高级任务";;
        
    } else if ([buy_type isEqualToString:@"秒拍单"]) {
        return buy_type = @"高级任务";;
        
    } else if ([buy_type isEqualToString:@"浏览单"]) {
        return buy_type = @"普通任务";;
        
    } else {
        return buy_type;
    }
    return @"";
}
- (void)setModel:(TaskViewModel *)model {
    _model = model;
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
