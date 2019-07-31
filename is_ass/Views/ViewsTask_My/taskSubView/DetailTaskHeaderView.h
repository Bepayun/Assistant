//
//  DetailTaskHeaderView.h
//  is_ass
//
//  Created by Bepa  on 2017/9/19.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskViewModel.h"

@interface DetailTaskHeaderView : UIView

@property (nonatomic, strong) TaskViewModel *model;

- (void)getHeaderDatas;

@end
