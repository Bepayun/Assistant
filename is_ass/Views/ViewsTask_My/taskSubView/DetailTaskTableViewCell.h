//
//  DetailTaskTableViewCell.h
//  assistant
//
//  Created by Bepa  on 2017/9/19.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTaskTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;

+ (NSString *)reuseIdentifier;

@end
