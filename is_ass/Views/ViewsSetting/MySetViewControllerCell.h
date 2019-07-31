//
//  MySetViewControllerCell.h
//  assistant
//
//  Created by Bepa  on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellType) {
    
    CellTypeDefual = 0,
    
    CellTypeExit
    
};

typedef void(^ExitBlock)(UIButton *sender);   // block

@interface MySetViewControllerCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, assign) CellType    cellType;
@property (nonatomic, copy)   ExitBlock   exitBlock;

+ (MySetViewControllerCell *)cellForTableView:(UITableView *)tableView;
+ (CGFloat)getCellHeight;

@end
