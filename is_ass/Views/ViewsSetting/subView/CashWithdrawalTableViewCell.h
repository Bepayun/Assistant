//
//  CashWithdrawalTableViewCell.h
//  assistant
//
//  Created by Bepa  on 2017/10/31.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashWithdrawalTableViewCell : UITableViewCell

/**
 * 申请时间
 */
@property (nonatomic, strong) UILabel* timeLabel;

/**
 * 提现数量
 */
@property (nonatomic, strong) UILabel* numLabel;

/**
 * 状态
 */
@property (nonatomic, strong) UILabel* stateLabel;

+ (NSString *)reuseIdentifier;

@end
