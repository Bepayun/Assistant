//
//  LoginViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "LoginViewController.h"
#import "RoomViewController.h"

@interface LoginViewController ()<RoomViewControllerDelegate, RCIMUserInfoDataSource>

@end

@implementation LoginViewController

- (void)viewDidLoad {
     self.view.backgroundColor = [UIColor blueColor];
    [self initControllerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLoginViewFromsuperview) name:@"closeLogView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView) name:@"openLoginView" object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initControllerView {

    UIImageView* cIVew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    cIVew.backgroundColor = RGBA(46, 173, 252, 1.0f);
    cIVew.userInteractionEnabled = YES;
    self.backview = cIVew;
    [self.view addSubview:self.backview];
    //
    UIImage* iconImage = [UIImage imageNamed:@"logo@2x"];
    UIImageView* iconimage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-iconImage.size.width)/2, 80, iconImage.size.width, iconImage.size.height)];
    iconimage.image = iconImage;
    self.IconImageView = iconimage;
    [self.backview addSubview:self.IconImageView];
    // 账号
    UITextField* account = [[UITextField alloc]initWithFrame:CGRectMake(20, self.IconImageView.frame.origin.y+self.IconImageView.frame.size.height+60,ScreenWidth-40, 40)];
    account.backgroundColor = [UIColor clearColor];
    account.placeholder = KLoginAccountTips;
    account.borderStyle = UITextBorderStyleNone; // 边框样式
    account.autocorrectionType = UITextAutocapitalizationTypeNone;
    account.keyboardType = UIKeyboardTypeASCIICapable;
    account.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    account.font = [UIFont systemFontOfSize:14];
    account.textColor = [UIColor blackColor];
    [account setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    account.clearButtonMode = UITextFieldViewModeAlways;
    //    account.clearButtonMode = UITextFieldViewModeAlways;
    // 自定义清空按钮
    UIButton* clearbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearbutton1 setImage:[UIImage imageNamed:@"logonClose@2x"] forState:UIControlStateNormal];
    [clearbutton1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [clearbutton1 addTarget:self action:@selector(clearAccountTextFieldContextPressed) forControlEvents:UIControlEventTouchUpInside];
    account.rightView = clearbutton1;
    account.rightViewMode = UITextFieldViewModeWhileEditing;
    [account addTarget:self action:@selector(textFieldEndOnExitPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [account addTarget:self action:@selector(textFieldBeginPressed:) forControlEvents:UIControlEventEditingDidBegin];
    [account addTarget:self action:@selector(textFieldContextsChage:) forControlEvents:UIControlEventEditingChanged];
    [account addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    account.enablesReturnKeyAutomatically = YES;
    //
    UIImage* loginuserImage = [UIImage imageNamed:@"loginUserName@2x"];
    UIView* left = [[UIView alloc]initWithFrame:CGRectMake(0, 0,loginuserImage.size.width+5, loginuserImage.size.height)];
    UIImageView* accountLeftView = [[UIImageView alloc]initWithImage:loginuserImage];
    [left addSubview:accountLeftView];
    account.leftView = left;
    account.leftViewMode = UITextFieldViewModeAlways;
    //
    self.Account_Numbertextfield = account;
    [self.backview addSubview:self.Account_Numbertextfield];
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(20, self.Account_Numbertextfield.frame.origin.y+self.Account_Numbertextfield.frame.size.height+1,self.Account_Numbertextfield.frame.size.width, 0.5)];
    line1.backgroundColor = RGBA(255, 255, 255, 0.7);
    [self.backview addSubview:line1];
    // 密码
    UITextField* codefield = [[UITextField alloc]init];
    codefield.backgroundColor = [UIColor clearColor];
    codefield.placeholder = KLoginPassCodeTips;
    codefield.borderStyle = UITextBorderStyleNone;
    codefield.autocorrectionType = UITextAutocapitalizationTypeNone;
    codefield.keyboardType = UIKeyboardTypeASCIICapable;
    codefield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    codefield.font = [UIFont systemFontOfSize:14];
    codefield.textColor = [UIColor blackColor];
//    codefield.clearButtonMode = UITextFieldViewModeAlways;
    // 自定义清空按钮
    UIButton* clearbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearbutton2 setImage:[UIImage imageNamed:@"logonClose@2x"] forState:UIControlStateNormal];
    [clearbutton2 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [clearbutton2 addTarget:self action:@selector(clearAccountTextFieldContextPasswordPressed) forControlEvents:UIControlEventTouchUpInside];
    codefield.rightView = clearbutton2;
    codefield.rightViewMode = UITextFieldViewModeWhileEditing;

    codefield.secureTextEntry = YES; // 密码输入
    //
    UIImage* loginpasswordImage = [UIImage imageNamed:@"loginPassword@2x"];
    UIView* leftcodeview = [[UIView alloc]initWithFrame:CGRectMake(0, 0,loginpasswordImage.size.width+5, loginpasswordImage.size.height)];
    UIImageView* codeLeftView = [[UIImageView alloc]initWithImage:loginpasswordImage];
    [leftcodeview addSubview:codeLeftView];
    codefield.leftView = leftcodeview;
    codefield.leftViewMode = UITextFieldViewModeAlways;
    //
    [codefield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [codefield addTarget:self action:@selector(textFieldEndOnExitPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [codefield addTarget:self action:@selector(textFieldBeginPressed:) forControlEvents:UIControlEventEditingDidBegin];
    [codefield addTarget:self action:@selector(textFieldContextsChage:) forControlEvents:UIControlEventEditingChanged];
    [codefield addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    codefield.enablesReturnKeyAutomatically = YES;
    self.PassCodetextField = codefield;
    [self.backview addSubview:self.PassCodetextField];
    [self.PassCodetextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.Account_Numbertextfield.mas_bottom).offset(20);
        make.left.width.height.equalTo(self.Account_Numbertextfield);
    }];
    [self.Account_Numbertextfield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.PassCodetextField addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* accountStr = [userDefault objectForKey:kUserDefaultKeyaccount];
    NSString* passwordStr = [userDefault objectForKey:kUserDefaultKeyPassWord];
    self.Account_Numbertextfield.text = accountStr;
    self.PassCodetextField.text = passwordStr;
    
    UIView* line2 = [[UIView alloc]init];
    line2.backgroundColor = RGBA(255, 255, 255, 0.7);
    [self.backview addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.PassCodetextField.mas_bottom).offset(0);
        make.width.left.equalTo(self.PassCodetextField);
        make.height.offset(0.5);
    }];
    // 登录按钮
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = RGBA(0, 105, 217, 0.9);
    [loginBtn setTitle:KLoginButtonTips forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn addTarget:self action:@selector(LoginStart:) forControlEvents:UIControlEventTouchUpInside];
     self.LogInbutton = loginBtn;
    [self.backview addSubview:self.LogInbutton];
    [self.LogInbutton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(line2.mas_bottom).offset(20);
        make.left.width.height.equalTo(self.PassCodetextField);
    }];
    //注册
    UIButton* newaccoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newaccoutBtn.backgroundColor = [UIColor clearColor];
    newaccoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    newaccoutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [newaccoutBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [newaccoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newaccoutBtn addTarget:self action:@selector(registerNewAccount:) forControlEvents:UIControlEventTouchUpInside];
     self.RegisterButton = newaccoutBtn;
    [self.backview addSubview:self.RegisterButton];
    [self.RegisterButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.LogInbutton.mas_left).offset(3);
        make.top.equalTo(self.LogInbutton.mas_bottom).offset(10);
        make.width.equalTo(self.LogInbutton.mas_width).multipliedBy(0.5);
        make.height.offset(30);
    }];
    //
    UILabel* versionLabel = [[UILabel alloc]init];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
//#ifdef APP_RELEASE_TAGERS
    NSString* nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [AppDelegate appDelegate].userInfostruct.nowVersion = nowVersion;
//#else
//    NSString* nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
//#endif

    versionLabel.text = nowVersion;
    self.VersionLabel = versionLabel;
    [self.backview addSubview:self.VersionLabel];
    [self.VersionLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.width.equalTo(self.view.mas_width).multipliedBy(1);
        make.height.offset(30);
    }];
}
- (void)clearAccountTextFieldContextPressed {
    self.Account_Numbertextfield.text = @"";
    self.PassCodetextField.text = @"";
}
- (void)clearAccountTextFieldContextPasswordPressed {
    self.PassCodetextField.text = @"";
}
#pragma mark TextFieldAction{
- (void)textFieldEndOnExitPressed:(id)sendr {
    //hasLogonKeyboard = YES;
    
    UITextField* textField = (UITextField* )sendr;
    if (textField == self.Account_Numbertextfield) {
        //[self.PassCodetextField becomeFirstResponder];
    }
    else {
        //CGRect mainScreen = [[UIScreen mainScreen] bounds];
        //[self setViewFrames:CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height) cmview:backview];
    }
}
- (void)textFieldBeginPressed:(id)sender {
    //hasLogonKeyboard = YES;
    
    UITextField* cTextField = (UITextField* )sender;
    //由于在ios6上，键盘无法输入，得添加以下内容
    if (!cTextField.window.isKeyWindow) {
        //[cTextField.window makeKeyAndVisible];
    }
    //[self setViewFrames:CGRectMake(0, kOriginY, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) cmview:backview];
    //[self setContolResetFrame];
}
- (void)textFieldContextsChage:(id)sender {
    if ([self.Account_Numbertextfield.text length] < 1) {
       // self.PassCodetextField.text = @"";
    }
}
- (void)textFieldEndEditing:(id)sender {
    //hasLogonKeyboard = NO;
    //[self performSelector:@selector(textFieldEndEditing_Delay) withObject:nil afterDelay:0.5];
}
#pragma mark --- }
#pragma magk 登录 {
- (void)LoginStart:(UIButton* )button {
    if (self.Account_Numbertextfield.text.length > 0 && self.PassCodetextField.text.length > 0) {
        [self loginStart];
   
    } else {
        MBProgressHUD* HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        HuD.mode =  MBProgressHUDModeText;
        HuD.label.text = @"账号或密码不能为空";
        dispatch_async(dispatch_get_main_queue(), ^{
             [HuD hideAnimated:YES afterDelay:0.4];
        });
    }
}
- (void)loginStart {
    MBProgressHUD* HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HuD.label.text = @"开始登录..";
    [UserInfoModel LoginGet_tokenWithAccount:self.Account_Numbertextfield.text PassWord:self.PassCodetextField.text success:^(id responseObject, NSString* msg, int code) {
        if (code == 0) {
          [self loginSuccessful];
           HuD.label.text = msg;
        
        } else {
           HuD.label.text = msg;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           [HuD hideAnimated:YES];
        });
    }];
}
- (void)loginSuccessful {
    RoomViewController* roomviewController = [[RoomViewController alloc]init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:roomviewController];
    roomviewController.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
    [[AppDelegate appDelegate] anUpdatedVersionOne];

}
- (void)sendRongCouldToken:(NSString* )rongCouldToken {
    //request 融云Token
    //1初始化
    [[RCIM sharedRCIM] initWithAppKey:kRongCloudAppKey];
    //设置当前用户信息
    RCUserInfo* myInfo = [[RCUserInfo alloc] init];
    myInfo.userId = [NSString stringWithFormat:@"%@", [AppDelegate appDelegate].userInfostruct.UserID];
    myInfo.name = [AppDelegate appDelegate].userInfostruct.nickName;
//            NSString* imageUrlString = [[AppDelegate appDelegate].appViewService getHeadImagePathForIconIdex:appDelegatePlatformUserStructure.selfIconIndex forUserId:[userId intValue] forSizeType:2];
//            myInfo.portraitUri = imageUrlString;
    [[RCIM sharedRCIM] setCurrentUserInfo:myInfo];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];//用户信息提供者代理
    [[RCIM sharedRCIM] setEnableMessageAttachUserInfo:YES];//每条消息带用户信息
    [[RCIM sharedRCIM] setEnablePersistentUserInfoCache:YES];//持久化用户和群组信息
    //    [self addPlatformUserStructureObserver_KVO];//注册观察者
    
    [[RCIM sharedRCIM] connectWithToken:rongCouldToken success:^(NSString* userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        NSLog(@"登录融云成功 融云用户 ID：%@",userId);
        [[NSNotificationCenter defaultCenter] postNotificationName:RCKitDispatchMessageNotification object:nil];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        
    }];
}
- (void)getUserInfoWithUserId:(NSString* )userId completion:(void (^)(RCUserInfo* ))completion {
    
    RCUserInfo* user = [RCUserInfo new];
    if (userId == nil || userId.length > 0) {
        user.userId = userId;
        user.portraitUri = @"";
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        NSString* rongname = [userDefault objectForKey:kRongCloudUserName];
        if (rongname != nil && rongname.length > 0) {
            user.name = rongname;
        } else {
            user.name = @"";
        }
        
        
        return completion(user);
    }
    return completion(nil);
}


#pragma mark --- }
#pragma mark 跳转到注册页面 {
- (void)registerNewAccount:(UIButton* )button {
     RegiestViewController* regiestview = [[RegiestViewController alloc]init];
     UINavigationController* navregiest = [[UINavigationController alloc]initWithRootViewController:regiestview];
     [self presentViewController:navregiest animated:YES completion:nil];
}
#pragma mark --- }
- (void)removeLoginViewFromsuperview {
    self.view.alpha = 0.0;
}
- (void)showLoginView {
    self.view.alpha = 1.0;
}
- (void)touchesBegan:(NSSet<UITouch* >* )touches withEvent:(UIEvent* )event {
    [self.Account_Numbertextfield resignFirstResponder];
    [self.PassCodetextField resignFirstResponder];
}
- (void)tapAction {
    [self.Account_Numbertextfield resignFirstResponder];
    [self.PassCodetextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"LOGINVC 释放");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue* )segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
