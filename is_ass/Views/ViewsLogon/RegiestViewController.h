//
//  RegiestViewController.h
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RootViewController.h"

@interface RegiestViewController : RootViewController

@property(nonatomic,strong)UILabel* accountLabel;
@property(nonatomic,strong)UITextField* accountTextField;
@property(nonatomic,strong)UILabel* passcodeLabel;
@property(nonatomic,strong)UITextField* passcodeTextfield;
//
@property(nonatomic,strong)UILabel* passcode_AgainLabel;
@property(nonatomic,strong)UITextField * passcode_AgainTextfield;
//
@property(nonatomic,strong)UILabel* recommendedLabel;
@property(nonatomic,strong)UITextField* recommendedTexfield;
//
@property(nonatomic,strong)UIButton* Reg_confirmButton;
@property(nonatomic,strong)UIButton* Reg_canncelButton;

@end
