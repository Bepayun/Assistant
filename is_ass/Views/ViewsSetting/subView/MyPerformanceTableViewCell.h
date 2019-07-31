//
//  MyPerformanceTableViewCell.h
//  is_ass
//
//  Created by Bepa  on 2017/9/12.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface MyPerformanceTableViewCell : UITableViewCell

@property (nonatomic, strong) RecordModel *model;
/**
 * 昵称
 */
@property (nonatomic, strong) UILabel *nickNameLabel;

/**
 * 账号
 */
@property (nonatomic, strong) UILabel *accountLabel;

/**
 * 时间
 */
@property (nonatomic, strong) UILabel *create_timeLabel;

+ (NSString *)reuseIdentifier;

@end
