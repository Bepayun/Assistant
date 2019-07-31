//
//  TaskhallTableViewCell.h
//  AutoCellHeight
//
//  Created by Bepa on 2017/09/01.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OrderDelegate <NSObject>
/**
 *   platform_type 1010 淘宝  1011 京东 1012 其它
 */
-(void)Order_TakingBegin:(int)platform_type withTask_id:(int)task;

@end

@interface TaskhallTableViewCell : UITableViewCell

+ (NSString* )reuseIdentifier;

@property (weak, nonatomic)   id<OrderDelegate> delegate;
@property (nonatomic, strong) UILabel* content;
@property (nonatomic, strong) UILabel* date;
@property (nonatomic, strong) UILabel* pay_method;
@property (nonatomic, strong) UILabel* product_price;
@property (nonatomic, strong) UILabel* taskInfoLabel;
@property (nonatomic, strong) UIImageView* platformIcon;
@property (nonatomic, strong) UIButton* OrderButton;
@property (nonatomic, strong) TaskHallModel* taskModel;
@property (nonatomic, assign) int taskid;


@end
