//
//  RegiestViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RegiestViewController.h"

@interface RegiestViewController ()<UITextFieldDelegate>

@end

@implementation RegiestViewController

- (void)viewDidLoad {
     self.view.backgroundColor = [UIColor whiteColor];
    [self initViewControllerView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"注册";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(leftbuttonpress)];
}
- (void)initViewControllerView {
    // 账号
    UILabel* account = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, ScreenWidth/4-20, 40)];
    account.backgroundColor = [UIColor clearColor];
    account.text = @"账号:";
    account.textColor = RGBA(133, 133, 133, 1.0);
    account.textAlignment = NSTextAlignmentRight;
    account.font = [UIFont systemFontOfSize:16];
    self.accountLabel = account;
    [self.view addSubview:self.accountLabel];
    
    UITextField* accountfield = [[UITextField alloc]init];
    accountfield.backgroundColor = [UIColor whiteColor];
    accountfield.borderStyle = UITextBorderStyleRoundedRect;
    accountfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    accountfield.keyboardType = UIKeyboardTypeASCIICapable;
    accountfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    accountfield.placeholder = @"输入要注册的账号";
    accountfield.font = [UIFont systemFontOfSize:16];
    accountfield.textColor = [UIColor blackColor];
    accountfield.clearButtonMode = UITextFieldViewModeAlways;
    accountfield.delegate = self;
    self.accountTextField = accountfield;
    [self.view addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.accountLabel.mas_right).offset(20);
        make.width.offset(ScreenWidth/4*3-35);
        make.top.height.equalTo(self.accountLabel);
    }];
    // 密码
    UILabel* codelabel = [[UILabel alloc]init];
    codelabel.text = @"密码:";
    codelabel.textColor = RGBA(133, 133, 133, 1.0);
    codelabel.textAlignment = NSTextAlignmentRight;
    codelabel.font = [UIFont systemFontOfSize:16];
    self.passcodeLabel = codelabel;
    [self.view addSubview:self.passcodeLabel];
    [self.passcodeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.width.height.equalTo(self.accountLabel);
        make.top.equalTo(self.accountLabel.mas_bottom).offset(25);
    }];
    
    UITextField* codefield = [[UITextField alloc]init];
    codefield.backgroundColor = [UIColor whiteColor];
    codefield.borderStyle = UITextBorderStyleRoundedRect;
    codefield.autocorrectionType = UITextAutocapitalizationTypeNone;
    codefield.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    codefield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    codefield.placeholder = @"输入密码";
    codefield.font = [UIFont systemFontOfSize:16];
    codefield.textColor = [UIColor blackColor];
    codefield.clearButtonMode = UITextFieldViewModeAlways;
    codefield.delegate = self;
    self.passcodeTextfield = codefield;
    [self.view addSubview:self.passcodeTextfield];
    [self.passcodeTextfield mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.width.height.equalTo(self.accountTextField);
        make.top.equalTo(self.passcodeLabel);
    }];
    //密码确认
    UILabel* recurcode = [[UILabel alloc]init];
    recurcode.text = @"重复密码:";
    recurcode.textColor = RGBA(133, 133, 133, 1.0);
    recurcode.textAlignment = NSTextAlignmentRight;
    recurcode.font = [UIFont systemFontOfSize:16];
    self.passcode_AgainLabel = recurcode;
    [self.view addSubview:self.passcode_AgainLabel];
    [self.passcode_AgainLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.passcodeLabel.mas_bottom).offset(25);
        make.left.width.height.equalTo(self.passcodeLabel);
    }];
    
    UITextField* recurfield = [[UITextField alloc]init];
    recurfield.backgroundColor = [UIColor whiteColor];
    recurfield.borderStyle = UITextBorderStyleRoundedRect;
    recurfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    recurfield.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    recurfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    recurfield.placeholder = @"输入密码";
    recurfield.font = [UIFont systemFontOfSize:16];
    recurfield.textColor = [UIColor blackColor];
    recurfield.clearButtonMode = UITextFieldViewModeAlways;
    recurfield.delegate = self;
    self.passcode_AgainTextfield = recurfield;
    [self.view addSubview:self.passcode_AgainTextfield];
    [self.passcode_AgainTextfield mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.passcode_AgainLabel.mas_top).offset(0);
        make.left.width.height.equalTo(self.passcodeTextfield);
    }];
    // 推荐人
    UILabel* recommenLabel = [[UILabel alloc]init];
    recommenLabel.text = @"推荐人:";
    recommenLabel.textColor = RGBA(133, 133, 133, 1.0);
    recommenLabel.textAlignment = NSTextAlignmentRight;
    recommenLabel.font = [UIFont systemFontOfSize:16];
    self.recommendedLabel = recommenLabel;
    [self.view addSubview:self.recommendedLabel];
    [self.recommendedLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.passcode_AgainLabel.mas_bottom).offset(25);
        make.left.width.height.equalTo(self.passcode_AgainLabel);
    }];
    
    UITextField* recommentfield = [[UITextField alloc]init];
    recommentfield.backgroundColor = [UIColor whiteColor];
    recommentfield.borderStyle = UITextBorderStyleRoundedRect;
    recommentfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    recommentfield.keyboardType = UIKeyboardTypeASCIICapable;
    recommentfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    recommentfield.placeholder = @"输入推荐人助手账号";
    recommentfield.font = [UIFont systemFontOfSize:16];
    recommentfield.textColor = [UIColor blackColor];
    recommentfield.clearButtonMode = UITextFieldViewModeAlways;
    recommentfield.delegate = self;
    self.recommendedTexfield = recommentfield;
    [self.view addSubview:self.recommendedTexfield];
    [self.recommendedTexfield mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.recommendedLabel.mas_top).offset(0);
        make.left.width.height.equalTo(self.passcode_AgainTextfield);
    }];
    
    [self.accountTextField addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.passcodeTextfield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.passcode_AgainTextfield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.recommendedTexfield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    
    // 确认，取消按钮
    UIButton* confirmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbtn.layer.masksToBounds = YES;
    confirmbtn.layer.cornerRadius = 4;
    confirmbtn.layer.borderWidth = 1;
    confirmbtn.layer.borderColor = [UIColor blackColor].CGColor;
    [confirmbtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmbtn addTarget:self action:@selector(ConfirmButtonTouchUpInSideEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.Reg_confirmButton = confirmbtn;
    [self.view addSubview:self.Reg_confirmButton];
    [self.Reg_confirmButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.recommendedLabel.mas_bottom).offset(40);
        make.left.offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    
    UIButton* cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbtn.layer.masksToBounds = YES;
    cancelbtn.layer.cornerRadius = 4;
    cancelbtn.layer.borderWidth = 1;
    cancelbtn.layer.borderColor = [UIColor blackColor].CGColor;
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelbtn addTarget:self action:@selector(CancelRegiestEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.Reg_canncelButton = cancelbtn;
    [self.view addSubview:self.Reg_canncelButton];
    [self.Reg_canncelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.offset(ScreenWidth-90);
        make.top.width.height.equalTo(self.Reg_confirmButton);
    }];
}
- (void)ConfirmButtonTouchUpInSideEvent:(UIButton* )button {
    if (self.accountTextField.text.length > 0 && self.passcodeTextfield.text.length > 0) {
        
        [self RegiestAccountStart];
    
    } else {
        
    }
}
- (void)RegiestAccountStart {
    
    MBProgressHUD* HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HuD.label.text = @"注册请求开始..";
    NSString* ipStr = @"";
    if ([AppDelegate appDelegate].userInfostruct.loginip != nil && [AppDelegate appDelegate].userInfostruct.loginip.length > 0) {
        ipStr = [AppDelegate appDelegate].userInfostruct.loginip;
    }
    [UserInfoModel RegisterAccountWithNewaccount:self.accountTextField.text password:self.passcodeTextfield.text device_id:nil ipdress:ipStr reg_recommender:self.recommendedTexfield.text success:^(id responseObject, NSString* msg, int code) {
        if (code == 0) {
            [self regiestAccountSucessful];
            HuD.label.text = msg;
        
        } else {
             HuD.label.text = msg;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [HuD hideAnimated:YES afterDelay:0.2];
        });
    } getDataFailure:^(NSError* error) {
         HuD.label.text = @"注册失败..";
         dispatch_async(dispatch_get_main_queue(), ^{
            [HuD hideAnimated:YES afterDelay:0.4];
         });
    }];
}
- (void)regiestAccountSucessful {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[AppDelegate appDelegate].loginViewController loginStart];
}
- (void)CancelRegiestEvent:(UIButton* )button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)leftbuttonpress {
    [self dismissViewControllerAnimated:self completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch* >* )touches withEvent:(UIEvent* )event {
    [self.accountTextField resignFirstResponder];
    [self.passcodeTextfield resignFirstResponder];
    [self.passcode_AgainTextfield resignFirstResponder];
    [self.recommendedTexfield resignFirstResponder];
}
- (void)tapAction {
    [self.accountTextField resignFirstResponder];
    [self.passcodeTextfield resignFirstResponder];
    [self.passcode_AgainTextfield resignFirstResponder];
    [self.recommendedTexfield resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
