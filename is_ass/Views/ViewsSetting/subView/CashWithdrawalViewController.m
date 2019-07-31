//
//  CashWithdrawalViewController.m
//  assistant
//
//  Created by Bepa  on 2017/10/31.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "CashWithdrawalViewController.h"
#import "CashWithdrawalTableViewCell.h"
#import "CashWithdrawalModel.h"

#define kDataCount 20

@interface CashWithdrawalViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIView      *cashWithdrawalView;
@property (nonatomic, strong) UITextField *alipayField;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *cashCoinField;

@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UITableView *cashWithdrawalTableView;
@property (nonatomic, strong) NSMutableArray *cashWithdrawalArray;
@property (nonatomic, assign) int goldCoinNum;
@property (nonatomic, assign) int listpage;
@property (nonatomic, assign) BOOL bol;

@end

@implementation CashWithdrawalViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCashWithdrawalDates];
    [self getCashWithdrawalBalanceData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCashWithdrawalBalanceData) name:@"CashWithdrawalBalanceData" object:nil];
    self.cashWithdrawalArray = [NSMutableArray arrayWithCapacity:0];
    self.listpage = 0;
    self.goldCoinNum = 0;
    
    [self createControllerView];
    [self createCashWithdrawalView];
    [self createNav];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCashWithdrawalDates) name:@"GETCashWithdrawalDates" object:nil];
}
#pragma mark - createCashWithdrawalView {
- (void)createCashWithdrawalView {
    UIView *cashWithdrawalView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height - 40, ScreenWidth, ScreenHeight - self.headerView.frame.size.height-20)];
    cashWithdrawalView.backgroundColor = [UIColor whiteColor];
    self.cashWithdrawalView = cashWithdrawalView;
    cashWithdrawalView.hidden = YES;
    [self.view addSubview:cashWithdrawalView];
    
    // 支付宝
    UILabel *alipayLabel = [[UILabel alloc] init];
    alipayLabel.backgroundColor = [UIColor clearColor];
    [cashWithdrawalView addSubview:alipayLabel];
    alipayLabel.text = @"支付宝：";
    alipayLabel.textColor = [UIColor blackColor];
    alipayLabel.font = [UIFont systemFontOfSize:17.0f];
    alipayLabel.textAlignment = NSTextAlignmentRight;
    
    UITextField *alipayfield = [[UITextField alloc] init];
    alipayfield.backgroundColor = [UIColor lightGrayColor];
    alipayfield.backgroundColor = [UIColor whiteColor];
    alipayfield.borderStyle = UITextBorderStyleRoundedRect;
    alipayfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    alipayfield.keyboardType = UIKeyboardTypeDefault;
    alipayfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    alipayfield.placeholder = @"";
    alipayfield.font = [UIFont systemFontOfSize:16.0f];
    alipayfield.textColor = [UIColor blackColor];
    alipayfield.clearButtonMode = UITextFieldViewModeAlways;
    alipayfield.layer.masksToBounds = YES;
    alipayfield.borderStyle =  UITextBorderStyleRoundedRect;
    alipayfield.layer.cornerRadius = 6.0;
    alipayfield.layer.borderWidth = 1;
    alipayfield.layer.borderColor = ([UIColor blackColor]).CGColor;
    self.alipayField = alipayfield;
    self.alipayField.delegate = self;
    [cashWithdrawalView addSubview:alipayfield];
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    [cashWithdrawalView addSubview:nameLabel];
    nameLabel.text = @"姓名：";
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:17.0f];
    nameLabel.textAlignment = NSTextAlignmentRight;
    
    UITextField *userNamefield = [[UITextField alloc] init];
    userNamefield.backgroundColor = [UIColor lightGrayColor];
    userNamefield.backgroundColor = [UIColor whiteColor];
    userNamefield.borderStyle = UITextBorderStyleRoundedRect;
    userNamefield.autocorrectionType = UITextAutocapitalizationTypeNone;
    userNamefield.keyboardType = UIKeyboardTypeDefault;
    userNamefield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    userNamefield.placeholder = @"";
    userNamefield.font = [UIFont systemFontOfSize:16.0f];
    userNamefield.textColor = [UIColor blackColor];
    userNamefield.clearButtonMode = UITextFieldViewModeAlways;
    userNamefield.layer.masksToBounds = YES;
    userNamefield.borderStyle =  UITextBorderStyleRoundedRect;
    userNamefield.layer.cornerRadius = 6.0;
    userNamefield.layer.borderWidth = 1;
    userNamefield.layer.borderColor = ([UIColor blackColor]).CGColor;
    self.userNameField = userNamefield;
    self.userNameField.delegate = self;
    [cashWithdrawalView addSubview:userNamefield];
    // 提现金额
    UILabel *cashCoinLabel = [[UILabel alloc] init];
    cashCoinLabel.backgroundColor = [UIColor clearColor];
    [cashWithdrawalView addSubview:cashCoinLabel];
    cashCoinLabel.text = @"提现金额：";
    cashCoinLabel.textColor = [UIColor blackColor];
    cashCoinLabel.font = [UIFont systemFontOfSize:17.0f];
    cashCoinLabel.textAlignment = NSTextAlignmentRight;
    
    UITextField *cashCoinfield = [[UITextField alloc] init];
    cashCoinfield.backgroundColor = [UIColor lightGrayColor];
    cashCoinfield.backgroundColor = [UIColor whiteColor];
    cashCoinfield.borderStyle = UITextBorderStyleNone;
    cashCoinfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    cashCoinfield.keyboardType = UIKeyboardTypeNumberPad;
    cashCoinfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    cashCoinfield.placeholder = @"";
    cashCoinfield.font = [UIFont systemFontOfSize:16.0f];
    cashCoinfield.textColor = [UIColor blackColor];
    cashCoinfield.clearButtonMode = UITextFieldViewModeAlways;
    cashCoinfield.layer.masksToBounds = YES;
    cashCoinfield.borderStyle =  UITextBorderStyleRoundedRect;
    cashCoinfield.layer.cornerRadius = 6.0;
    cashCoinfield.layer.borderWidth = 1;
    cashCoinfield.layer.borderColor = ([UIColor blackColor]).CGColor;
    self.cashCoinField = cashCoinfield;
    self.cashCoinField.delegate = self;
    [cashWithdrawalView addSubview:cashCoinfield];
    
    [self.alipayField addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.userNameField addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.cashCoinField addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    
    //支付宝
    [alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashWithdrawalView.mas_top).offset(60);
        make.left.equalTo(cashWithdrawalView.mas_left).offset(22);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    [alipayfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashWithdrawalView.mas_top).offset(60);
        make.left.equalTo(alipayLabel.mas_right).offset(6);
        make.right.equalTo(cashWithdrawalView.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    //姓名
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alipayLabel.mas_bottom).offset(10);
        make.left.equalTo(cashWithdrawalView.mas_left).offset(22);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    [userNamefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alipayfield.mas_bottom).offset(10);
        make.left.equalTo(nameLabel.mas_right).offset(6);
        make.right.equalTo(cashWithdrawalView.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    // 提现金额
    [cashCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.equalTo(cashWithdrawalView.mas_left).offset(12);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    [cashCoinfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNamefield.mas_bottom).offset(10);
        make.left.equalTo(cashCoinLabel.mas_right).offset(6);
        make.right.equalTo(cashWithdrawalView.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    // Create cancel button
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cashWithdrawalView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 6.0;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = ([UIColor blackColor]).CGColor;
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // Create submit button
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.backgroundColor = [UIColor clearColor];
    [cashWithdrawalView addSubview:submitBtn];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 6.0;
    submitBtn.layer.borderWidth = 1;
    submitBtn.layer.borderColor = ([UIColor blackColor]).CGColor;
    [submitBtn addTarget:self action:@selector(submitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashCoinLabel.mas_bottom).offset(18);
        make.left.equalTo(cashCoinfield.mas_left).offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(65);
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashCoinfield.mas_bottom).offset(18);
        make.right.equalTo(cashWithdrawalView.mas_right).offset(-20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(65);
    }];
}
- (void)emptyingTextField {
    self.alipayField.text = @"";
    self.userNameField.text = @"";
    self.cashCoinField.text = @"";
}
#pragma mark - 取消按钮响应の事件
- (void)cancelBtnPressed {
    [self tapAction];
    self.cashWithdrawalView.hidden = YES;
    [self emptyingTextField];
}
#pragma mark - 提交按钮响应の事件
- (void)submitBtnPressed:(UIButton *)sender {
    [self tapAction];
    if (self.alipayField.text != nil && self.alipayField.text.length > 0 && self.userNameField.text != nil && self.userNameField.text.length > 0 && self.cashCoinField.text != nil && self.cashCoinField.text > 0) {
        [self submitBtnPressedOperation:sender];

    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate appDelegate].commonmthod showAlert:@"支付宝或姓名或者提现金额不能为空"];
        });
    }
    
    
//    else if (self.alipayField.text == nil) {
//        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [progressHUD hideAnimated:YES afterDelay:0.3];
//        progressHUD.label.text = @"您不满足申请提现的条件";
//        [[AppDelegate appDelegate].commonmthod showAlert:@"支付宝不能为空"];
//
//    } else if (self.userNameField.text == nil) {
//        [[AppDelegate appDelegate].commonmthod showAlert:@"姓名不能为空"];
//
//    } else if (self.cashCoinField.text == nil) {
//        [[AppDelegate appDelegate].commonmthod showAlert:@"提现金额不能为空"];
//    }
}
- (void)submitBtnPressedOperation:(UIButton *)sender {
   
    NSString *titleStr = [sender titleForState:UIControlStateNormal];
    if ([titleStr isEqualToString:@"提交"]) {
        [self tapAction];
        UIAlertView *applyForStr = [[UIAlertView alloc] initWithTitle:@"您是否确认提交" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [applyForStr setTag:10222];
        [applyForStr show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10222) {
        if (buttonIndex == 0) {
            return;
        } else if (buttonIndex == 1) {
            [self applyForManagerInformation];
        }
    }
}
#pragma mark - 提交申请提现信息
- (void)applyForManagerInformation {
    if (self.alipayField.text.length > 0 && self.userNameField.text.length > 0 && self.cashCoinField.text.length > 0) {
        NSString *cashcoin = self.cashCoinField.text;
        if (self.goldCoinNum >= [cashcoin intValue]) {
            NSLog(@"%d",[cashcoin intValue]);
        
            [CashWithdrawalModel CashWithdrawalBtnWithAlipayAccount:self.alipayField.text userName:self.userNameField.text GoldCoinNum:self.cashCoinField.text success:^(id responseObject, NSString *msg, int code) {
                if (code == 0) {
                    NSLog(@"提交申请提现成功");
                    [self tapAction];
//                    [[AppDelegate appDelegate].commonmthod showAlert:@"发送成功"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [progressHUD hideAnimated:YES afterDelay:0.3];
                        progressHUD.label.text = @"申请提现成功";
                    });
                    [self getCashWithdrawalDates];
                    _cashWithdrawalView.hidden = YES;
                    [self emptyingTextField];
                    
                } else {
                    NSLog(@"提交申请提现失败");
                    [self tapAction];
                    [[AppDelegate appDelegate].commonmthod showAlert:@"提交申请提现失败,请重新申请"];
                }
                
            } getDataFailure:^(NSError *error) {
                
            }];
            
        } else {
            [[AppDelegate appDelegate].commonmthod showAlert:@"提交申请提现金额大于余额,请重新设置金额"];
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.alipayField isExclusiveTouch] && ![self.userNameField isExclusiveTouch] && ![self.cashCoinField isExclusiveTouch]) {
        [self.alipayField resignFirstResponder];
        [self.userNameField resignFirstResponder];
        [self.cashCoinField resignFirstResponder];
    }
}
- (void)tapAction {
    [self.alipayField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    [self.cashCoinField resignFirstResponder];
}
#pragma mark ---- }
- (void)createControllerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 115)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    [self.view addSubview:headerView];
    //
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = RGB(234, 238, 241);
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(3);
        make.centerX.equalTo(headerView.mas_centerX).offset(15);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(1);
    }];
    //
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    NSString *str = @"0";
    NSString *contentStr = [NSString stringWithFormat:@"可提现余额：%@个金币",str];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    if (str.length == 1) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 1)];
    }
    contentLabel.attributedText = attributeString;
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(18);
        make.left.equalTo(headerView.mas_left).offset(5);
        make.right.equalTo(line.mas_left).offset(-1);
        make.height.mas_equalTo(32);
    }];
    //`提现按钮
    UIButton *cashWithdrawalBtn = [[UIButton alloc] init];
    cashWithdrawalBtn.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:cashWithdrawalBtn];
    [cashWithdrawalBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    [cashWithdrawalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cashWithdrawalBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cashWithdrawalBtn.layer.shadowOffset =  CGSizeMake(1, 1);
    cashWithdrawalBtn.layer.shadowOpacity = 0.8;
    cashWithdrawalBtn.layer.shadowColor =  [UIColor lightGrayColor].CGColor;
    [cashWithdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(20);
        make.right.equalTo(headerView.mas_right).offset(-20*2-15);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(64);
    }];
    self.bol = NO;
    [cashWithdrawalBtn addTarget:self action:@selector(cashWithdrawalPressed) forControlEvents:UIControlEventTouchUpInside];
    //
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = RGB(229, 233, 237);
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(15);
        make.left.right.equalTo(headerView);
        make.height.mas_equalTo(10);
    }];
    //`申请时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:timeLabel];
    timeLabel.text = @"申请时间";
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    //`提现数量
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:numLabel];
    numLabel.text = @"提现数量";
    numLabel.textColor = [UIColor blackColor];
    numLabel.font = [UIFont systemFontOfSize:14.0f];
    numLabel.textAlignment = NSTextAlignmentCenter;
    //`状态
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:stateLabel];
    stateLabel.text = @"状态";
    stateLabel.textColor = [UIColor blackColor];
    stateLabel.font = [UIFont systemFontOfSize:14.0f];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(headerView.mas_left).offset(8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(headerView.mas_centerX).offset(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(numLabel.mas_right).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *lineOne = [[UILabel alloc] init];
    lineOne.backgroundColor = RGB(234, 238, 241);
    [headerView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headerView);
        make.height.mas_equalTo(1);
    }];
    
    //` create cashWithdrawalTableView
    self.cashWithdrawalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, ScreenWidth, ScreenHeight - headerView.frame.size.height-60)];
    [self.view addSubview:self.cashWithdrawalTableView];
    self.cashWithdrawalTableView.delegate = self;
    self.cashWithdrawalTableView.dataSource = self;
    self.cashWithdrawalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cashWithdrawalTableView.showsVerticalScrollIndicator = NO;
    self.cashWithdrawalTableView.showsHorizontalScrollIndicator = NO;
    self.cashWithdrawalTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCashWithdrawalDates)];
    self.cashWithdrawalTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreCashWithdrawalDates)];

}
#pragma mark - CashWithdrawalBalanceSuccess
- (void)getCashWithdrawalBalanceData {
    [CashWithdrawalModel CashWithdrawalBalanceSuccess:^(id responseObject, NSString *msg, int code) {
        if (code == 0) {
            NSLog(@"获取余额成功");
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSString *str = @"";
            if ([dic objectForKey:@"balance"] && ![[dic objectForKey:@"balance"] isKindOfClass:[NSNull class]]) {
                str = [dic objectForKey:@"balance"];
                self.goldCoinNum = [str intValue];
                NSLog(@"self.goldCoinNumself.goldCoinNum----%d",self.goldCoinNum);
            }
            NSLog(@"str.length##%ld",(unsigned long)str.length);
            NSString *contentStr = [NSString stringWithFormat:@"可提现余额：%@个金币",str];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];
            if (str.length == 1) {
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 1)];
                
            } else if (str.length == 2) {
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 2)];
                
            } else if (str.length == 3) {
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 3)];
                
            } else if (str.length == 4) {
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 4)];
            }
            else if (str.length == 5) {
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 5)];
            }
            self.contentLabel.attributedText = attributeString;
            
        } else {
            NSLog(@"获取余额失败");
        }
    } getDataFailure:^(NSError *error) {
        
    }];
}
#pragma mark --- 申请提现按钮の响应事件
- (void)cashWithdrawalPressed {
    if (!_bol) {
       
        if (self.goldCoinNum > 0) {
            self.cashWithdrawalView.hidden = NO;
            
        } else {
            MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [progressHUD hideAnimated:YES afterDelay:0.3];
            progressHUD.label.text = @"对不起您的金币为0,不能申请提现!";
        }
         _bol = YES;
        
    } else {
        _bol = NO;
        self.cashWithdrawalView.hidden = YES;
    }
    
}
#pragma mark - cashWithdrawalTableView delegate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cashWithdrawalArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CashWithdrawalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CashWithdrawalTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[CashWithdrawalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CashWithdrawalTableViewCell reuseIdentifier]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.cashWithdrawalArray.count <= 0) {
        return cell;
    }
    CashWithdrawalModel *model = self.cashWithdrawalArray[indexPath.row];
    cell.timeLabel.text = model.created_time;
    cell.numLabel.text = model.amount;
    cell.stateLabel.text = model.status;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
#pragma mark --------  }
#pragma mark --- 数据の请求
- (void)getCashWithdrawalDates {
    _listpage = 1;
    [self.cashWithdrawalTableView.mj_footer endRefreshing];
    
    [CashWithdrawalModel CashWithdrawalListWithPage:self.listpage pageCount:kDataCount all:@"0" status:@"" success:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (array.count > 0) {
            if (self.cashWithdrawalArray.count > 0) {
                [self.cashWithdrawalArray removeAllObjects];
            }
            [self.cashWithdrawalArray addObjectsFromArray:array];
            
        } else {
            if (self.cashWithdrawalArray.count > 0) {
                [self.cashWithdrawalArray removeAllObjects];
            }
        }
        [self.cashWithdrawalTableView.mj_header endRefreshing];
        _listpage ++;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.cashWithdrawalTableView reloadData];
        }];
        
        NSLog(@"金币提取列表数据请求成功");
    } getDataFailure:^(NSError *error) {
        
        NSLog(@"金币提取列表数据请求失败");
    }];
}
- (void)getMoreCashWithdrawalDates {
    
    [CashWithdrawalModel CashWithdrawalListWithPage:self.listpage pageCount:kDataCount all:@"0" status:@"" success:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (array.count > 0) {
            [self.cashWithdrawalArray addObjectsFromArray:array];
            _listpage ++;
        
        } else {
            [self.cashWithdrawalTableView.mj_footer resetNoMoreData];
        }
        [self.cashWithdrawalTableView.mj_footer endRefreshing];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.cashWithdrawalTableView reloadData];
        }];
        
        NSLog(@"金币提取列表数据请求成功");
    } getDataFailure:^(NSError *error) {
        
        NSLog(@"金币提取列表数据请求失败");
    }];
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"申请提现";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
