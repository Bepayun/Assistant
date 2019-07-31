//
//  Account_TaobaoCell.h
//  assistant
//
//  Created by Bepa on 2017/9/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Account_TaobaoCellDelegate <NSObject>

-(void)Account_TaobaoCellSelected:(UIButton *)button;

@end

@interface Account_TaobaoCell : UITableViewCell

@property (weak,nonatomic) id <Account_TaobaoCellDelegate>delagate;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *selectedButton;

@end
