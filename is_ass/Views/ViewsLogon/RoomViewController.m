//
//  RoomViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RoomViewController.h"

@interface RoomViewController ()<UITextFieldDelegate>

@end

@implementation RoomViewController

- (void)viewDidLoad {
     self.view.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self initViewController];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"进入房间";
    [self addLeftTarget:@selector(leftbuttonpress)];
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
}
- (void)initViewController {
    //
    UILabel *roomnumber = [[UILabel alloc]initWithFrame:CGRectMake(30,60,70, 40)];
    roomnumber.text = @"房间号:";
    roomnumber.textColor = [UIColor lightGrayColor];
    roomnumber.font = [UIFont systemFontOfSize:18];
    roomnumber.textAlignment = NSTextAlignmentRight;
    self.roomnuberLabel = roomnumber;
    [self.view addSubview:self.roomnuberLabel];
    //
    UITextField *roomtextfield = [[UITextField alloc]init];
    roomtextfield.backgroundColor = [UIColor whiteColor];
    roomtextfield.borderStyle = UITextBorderStyleRoundedRect;
    roomtextfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    roomtextfield.keyboardType = UIKeyboardTypeNumberPad;
    roomtextfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    roomtextfield.font = [UIFont systemFontOfSize:16];
    roomtextfield.textColor = [UIColor blackColor];
    roomtextfield.clearButtonMode = UITextFieldViewModeAlways;
    roomtextfield.delegate = self;
    //
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *roomidStr = [userDefault objectForKey:kUserDefaultKeyRoomID];
    roomtextfield.text = roomidStr;
    self.roomnuber_textfield = roomtextfield;
    [self.roomnuber_textfield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.roomnuber_textfield];
    [self.roomnuber_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomnuberLabel.mas_right).offset(15);
        make.height.equalTo(self.roomnuberLabel.mas_height).multipliedBy(1);
        make.width.offset(ScreenWidth-self.roomnuberLabel.frame.size.width-90);
        make.top.equalTo(self.roomnuberLabel.mas_top).offset(0);
    }];
    //
    UIButton *enterBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBuuton.backgroundColor = RGBA(18, 150, 219, 1.0f);
    [enterBuuton setTitle:@"进入房间" forState:UIControlStateNormal];
    [enterBuuton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBuuton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.enterRoombutton = enterBuuton;
    [self.enterRoombutton addTarget:self action:@selector(enterRoomNow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterRoombutton];
    [self.enterRoombutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.width.offset(ScreenWidth-60);
        make.top.equalTo(self.roomnuberLabel.mas_bottom).offset(30);
        make.height.offset(40);
    }];

}
- (void)enterRoomNow:(UIButton *)sender {
    if (self.roomnuber_textfield.text.length > 0) {
        [self EnterRoomWithRoom_ID];
    }
}
- (void)EnterRoomWithRoom_ID {
    MBProgressHUD *HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HuD.label.text = @"开始进入房间..";
    [UserInfoModel EnterRoomWithroom_external_id:self.roomnuber_textfield.text userId:[AppDelegate appDelegate].userInfostruct.UserID room_card_name:nil token:[AppDelegate appDelegate].userInfostruct.client_token success:^(id responseObject, NSString *msg, int code) {
        if (code == 0) {
            HuD.label.text = msg;
            //融云
            if (self.delegate) {
                [self.delegate sendRongCouldToken:[AppDelegate appDelegate].userInfostruct.Im_token];
            }

            [self enterRoomSucessful];
        
        } else {
            HuD.label.text = msg;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [HuD hideAnimated:YES afterDelay:0.2];
        });
    } getDataFailure:^(NSError *error) {
         HuD.label.text = @"进入房间失败..";
         dispatch_async(dispatch_get_main_queue(), ^{
            [HuD hideAnimated:YES afterDelay:0.4];
         });
        [self dismissViewControllerAnimated:self completion:nil];
        
    }];
}

- (void)enterRoomSucessful {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeLogView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETTaskHallData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETTaskHallData_Registration" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MySetViewControllerData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetTaskViewData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendTabbarControllerIndex" object:nil];
}
- (void)leftbuttonpress {
    [self dismissViewControllerAnimated:self completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.roomnuber_textfield resignFirstResponder];
}
- (void)tapAction {
    [self.roomnuber_textfield resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"ROOMVC 释放");
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
