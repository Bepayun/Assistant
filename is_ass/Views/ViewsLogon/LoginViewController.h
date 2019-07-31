//
//  LoginViewController.h
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RootViewController.h"

@interface LoginViewController : UIViewController 
{
    
}
@property(nonatomic,assign)UIImageView* IconImageView; // 图标
@property(nonatomic,assign)UITextField* Account_Numbertextfield; // 账号
@property(nonatomic,assign)UITextField* PassCodetextField; // 密码
@property(nonatomic,assign)UIButton* RegisterButton; // 注册账号
@property(nonatomic,assign)UIButton* LogInbutton; ///< 登录
@property(nonatomic,assign)UILabel* VersionLabel;
@property (nonatomic, retain) UIImageView*  backview;

- (void)loginStart;

@end
