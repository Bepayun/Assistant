//
//  TaskViewTableViewCell.h
//  is_ass
//
//  Created by Bepa  on 2017/9/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskViewTableViewCell : UITableViewCell

/**
 * 接任务时间
 */
@property (nonatomic, strong) UILabel *create_timeLabel;

/**
 * 接任务类型 （热门/网络）
 */
@property (nonatomic, strong) UILabel *platformLabel;

/**
 * 总结
 */
@property (nonatomic, strong) UILabel *summaryLabel;

/**
 * 描述
 */
@property (nonatomic, strong) UILabel *remarkLabel;

/**
 * 接任务状态
 */
@property (nonatomic, strong) UILabel *stateLabel;

+ (NSString *)reuseIdentifier;

@end
