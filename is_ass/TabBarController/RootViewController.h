//
//  RootViewController.h
//  is_ass
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel  *titleLabel;

//`设置响应方法
- (void)addLeftTarget:(SEL)selector;
- (void)addRightTarget:(SEL)selector;
//设置导航栏颜色 
-(void)setnavigationBarcolor:(UIColor *)color andalph:(BOOL)alph;

@end
