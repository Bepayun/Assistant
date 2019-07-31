//
//  ManagementTableViewCell.h
//  assistant
//
//  Created by Bepa  on 2017/9/15.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagementModel.h"


@protocol ManagementTableViewCellDelegate <NSObject>

- (void)deleteAccountDatas:(ManagementModel *)model indexPath:(NSIndexPath *)indexPath;

@end

@interface ManagementTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ManagementTableViewCellDelegate>delegate;

@property (nonatomic, strong) ManagementModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
/**
 * 账号（淘宝/京东）
 */
@property (nonatomic, strong) UILabel *accountNamelabel;

/**
 * 昵称
 */
@property (nonatomic, strong) UILabel *nicknameLabel;

/**
 * 删除按钮
 */
@property (nonatomic, strong) UIButton *deleteBtn;

+ (NSString *)reuseIdentifier;

@end
