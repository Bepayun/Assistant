//
//  RecordTableViewCell.h
//  assistant
//
//  Created by Bepa  on 2017/9/11.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface RecordTableViewCell : UITableViewCell

@property (nonatomic, strong) RecordModel *recordModel;

/**
 * 日期
 */
@property (nonatomic, strong) UILabel *create_timeLabel;

/**
 * 时间
 */
@property (nonatomic, strong) UILabel *timeStrLabel;

/**
 * 图片
 */
@property (nonatomic, strong) UIImageView *change_imageView;

/**
 * 接任务记录数字
 */
@property (nonatomic, strong) UILabel *changeLabel;

/**
 * 任务状态展示内容
 */
@property (nonatomic, strong) UILabel *descriptionLabel;

+ (NSString *)reuseIdentifier;

@end
