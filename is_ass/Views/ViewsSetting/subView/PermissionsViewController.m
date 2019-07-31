//
//  PermissionsViewController.m
//  is_ass
//
//  Created by Bepa  on 2017/9/5.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#define kNicknameLimitCount 6
#import "PermissionsViewController.h"
#import "PermissionsModel.h"

@interface PermissionsViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phonefield;
@property (nonatomic, strong) UITextField *nicknamefield;
@property (nonatomic, strong) UITextField *qqfield;
@property (nonatomic, strong) UIButton    *groupBtn;
@property (nonatomic, strong) UILabel     *groupName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *permissionDataAry;
@property (nonatomic, strong) NSString       *groupId;

@end

@implementation PermissionsViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPermissionGuropRoomNameDate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.groupId = [[NSString alloc] init];
    _permissionDataAry = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
    [self createNav];
    
}
- (void)createViews {
    //`手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
    [self.view addSubview:phoneLabel];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.font = [UIFont systemFontOfSize:17.0f];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *phonefield = [[UITextField alloc] init];
    phonefield.backgroundColor = [UIColor lightGrayColor];
    phonefield.backgroundColor = [UIColor whiteColor];
    phonefield.borderStyle = UITextBorderStyleRoundedRect;
    phonefield.autocorrectionType = UITextAutocapitalizationTypeNone;
    phonefield.keyboardType = UIKeyboardTypeASCIICapable;
    phonefield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    phonefield.placeholder = @"请输入手机号";
    phonefield.font = [UIFont systemFontOfSize:17.0f];
    phonefield.textColor = [UIColor blackColor];
    phonefield.clearButtonMode = UITextFieldViewModeAlways;
    phonefield.delegate = self;
    self.phonefield = phonefield;
    self.phonefield.delegate = self;
    [self.view addSubview:phonefield];
    //`我的昵称（限制6个字符）
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [self.view addSubview:nicknameLabel];
    nicknameLabel.text = @"我的昵称（限制6个字符）";
    nicknameLabel.textColor = [UIColor blackColor];
    nicknameLabel.font = [UIFont systemFontOfSize:17.0f];
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *nicknamefield = [[UITextField alloc] init];
    nicknamefield.backgroundColor = [UIColor lightGrayColor];
    nicknamefield.backgroundColor = [UIColor whiteColor];
    nicknamefield.borderStyle = UITextBorderStyleRoundedRect;
    nicknamefield.autocorrectionType = UITextAutocapitalizationTypeNone;
    nicknamefield.keyboardType = UIKeyboardTypeDefault;
    nicknamefield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    nicknamefield.placeholder = @"请输入昵称";
    nicknamefield.font = [UIFont systemFontOfSize:17.0f];
    nicknamefield.textColor = [UIColor blackColor];
    nicknamefield.clearButtonMode = UITextFieldViewModeAlways;
    nicknamefield.delegate = self;
    self.nicknamefield = nicknamefield;
    self.nicknamefield.delegate = self;
    [self.view addSubview:nicknamefield];
    [nicknamefield addTarget:self action:@selector(cTextFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    //`我的QQ
    UILabel *qqLabel = [[UILabel alloc] init];
    [self.view addSubview:qqLabel];
    qqLabel.text = @"我的QQ";
    qqLabel.textColor = [UIColor blackColor];
    qqLabel.font = [UIFont systemFontOfSize:17.0f];
    qqLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *qqfield = [[UITextField alloc] init];
    qqfield.backgroundColor = [UIColor lightGrayColor];
    qqfield.backgroundColor = [UIColor whiteColor];
    qqfield.borderStyle = UITextBorderStyleRoundedRect;
    qqfield.autocorrectionType = UITextAutocapitalizationTypeNone;
    qqfield.keyboardType = UIKeyboardTypeASCIICapable;
    qqfield.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    qqfield.placeholder = @"请输入QQ";
    qqfield.font = [UIFont systemFontOfSize:17.0f];
    qqfield.textColor = [UIColor blackColor];
    qqfield.clearButtonMode = UITextFieldViewModeAlways;
    qqfield.delegate = self;
    self.qqfield = qqfield;
    self.qqfield.delegate = self;
    [self.view addSubview:qqfield];
    
    [self.phonefield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.nicknamefield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    [self.qqfield addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchDown];
    
    //`所在团
    UILabel *groupLabel = [[UILabel alloc] init];
    [self.view addSubview:groupLabel];
    groupLabel.text = @"所在团";
    groupLabel.textColor = [UIColor blackColor];
    groupLabel.font = [UIFont systemFontOfSize:17.0f];
    groupLabel.textAlignment = NSTextAlignmentLeft;
    //手机号
    __weak PermissionsViewController *weakself = self;
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view).offset(30);
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(ScreenWidth-70);
    }];
    [phonefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.top.equalTo(phoneLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(ScreenWidth-70);
    }];
    //昵称
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phonefield.mas_bottom).offset(17);
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(ScreenWidth-70);
    }];
    [nicknamefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.top.equalTo(nicknameLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(ScreenWidth-70);
    }];
    //我的QQ
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicknamefield.mas_bottom).offset(17);
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(ScreenWidth-70);
    }];
    [qqfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qqLabel.mas_centerX);
        make.top.equalTo(qqLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(ScreenWidth-70);
    }];

    //团
    [groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqfield.mas_bottom).offset(17);
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(ScreenWidth-70);
    }];
    
    UIButton *groupBtn = [[UIButton alloc] init];
    [self.view addSubview:groupBtn];
    [groupBtn.layer setMasksToBounds:YES];
    [groupBtn.layer setBorderWidth:1.0];
    [groupBtn.layer setBorderColor:RGB(18, 150, 219).CGColor];
    self.groupBtn = groupBtn;
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [self.view addSubview:sendBtn];
    //
    UILabel *groupName = [[UILabel alloc] init];
    [self.view addSubview:groupName];
    self.groupName = groupName;
    groupName.text = @"";
    groupName.textAlignment = NSTextAlignmentLeft;
    groupName.textColor = [UIColor blackColor];
    groupName.font = [UIFont systemFontOfSize:15.0f];
    
    [groupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupBtn.mas_top).offset(5);
        make.left.equalTo(groupBtn.mas_left).offset(14);
        make.width.mas_offset(150);
        make.height.mas_offset(20);
    }];
    
    UIImageView *groupImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop_down"]];
    [self.view addSubview:groupImgView];
    [groupImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupBtn.mas_top).offset(5);
        make.right.equalTo(groupBtn.mas_right).offset(-7);
        make.width.mas_offset(16);
        make.height.mas_offset(20);
    }];
    
    [groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(groupLabel.mas_centerX);
        make.top.equalTo(groupLabel.mas_bottom).offset(7);
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(ScreenWidth-80);
    }];
    [self.groupBtn addTarget:self action:@selector(groupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addGroupTableView];
    
    //`发送申请
    [sendBtn setTitle:@"发送申请" forState:UIControlStateNormal];
    sendBtn.backgroundColor = RGB(18, 150, 219);
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [sendBtn.layer setMasksToBounds:YES];
    [sendBtn.layer setBorderWidth:1.0];
    [sendBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 6;
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupBtn.mas_bottom).offset(28);
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    [sendBtn addTarget:self action:@selector(applyForSuccessClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)applyForSuccessClick:(UIButton *)sender {
    
    if (self.phonefield.text.length > 0 && self.nicknamefield.text.length > 0 && self.qqfield.text.length > 0) {
        
        [self applyForPressedOperation:sender];
        
    }
}
- (void)applyForPressedOperation:(UIButton *)sender {
    NSString *titleStr = [sender titleForState:UIControlStateNormal];
    if ([titleStr isEqualToString:@"发送申请"]) {
        UIAlertView *applyForStr = [[UIAlertView alloc] initWithTitle:@"您是否确认发送申请" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [applyForStr setTag:10101];
        [applyForStr show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10101) {
        if (buttonIndex == 0) {
            return;
        } else if (buttonIndex == 1) {
            [self applyForAndjoinOrganization];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.nicknamefield isExclusiveTouch] && ![self.phonefield isExclusiveTouch] && ![self.qqfield isExclusiveTouch]) {
        [self.nicknamefield resignFirstResponder];
        [self.phonefield resignFirstResponder];
        [self.qqfield resignFirstResponder];
    }
}
- (void)tapAction {
    [self.nicknamefield resignFirstResponder];
    [self.phonefield resignFirstResponder];
    [self.qqfield resignFirstResponder];
}
#pragma mark -- 提交申请
- (void)applyForAndjoinOrganization {
    
    [PermissionsModel PermissionWithCardRoomName:self.nicknamefield.text tuanId:self.groupId userId:[AppDelegate appDelegate].userInfostruct.UserID userRoomId:[AppDelegate appDelegate].userInfostruct.external_id qq:self.qqfield.text telephone:self.phonefield.text success:^(id responseObject, NSString *msg, int code) {
        if (code == 0) {
            NSLog(@"提交申请成功");
            [[AppDelegate appDelegate].commonmthod showAlert:@"发送成功"];
        
        } else {
            NSLog(@"提交申请失败");
            [[AppDelegate appDelegate].commonmthod showAlert:@"提交申请失败,请重新申请"];
        }
        
    } getDataFailure:^(NSError *error) {
        
    }];
    
}
- (void)getPermissionGuropRoomNameDate {

    [PermissionsModel PermissionWithGroupToRoomId:[AppDelegate appDelegate].userInfostruct.external_id sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (self.permissionDataAry.count > 0) {
            [self.permissionDataAry removeAllObjects];
        }
        [self.permissionDataAry addObjectsFromArray:array];
        _groupName.text = [[array firstObject] groupName];
        _groupId = [[array firstObject] tuan_id];
        
        [_tableView reloadData];
    }];
}
- (void)groupBtnClick {
    _tableView.hidden = !_tableView.hidden;
}
- (void)addGroupTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-80, 4*30) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView.layer setMasksToBounds:YES];
    [_tableView.layer setBorderWidth:1.0];
    [_tableView.layer setBorderColor:RGB(18, 150, 219).CGColor];
    _tableView.hidden = YES;
    
    [self.view addSubview:_tableView];
    //去掉多余的线条
    _tableView.tableFooterView = [[UIView alloc]init];
    __weak PermissionsViewController *weakself = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupBtn.mas_bottom);
        make.left.equalTo(weakself.view.mas_left).offset(35);
        make.height.mas_equalTo(30*4);
        make.width.mas_equalTo(ScreenWidth-80);
    }];
}
#pragma mark - tableViewDelegate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.permissionDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_permissionDataAry.count <= 0) {
        return cell;
    }
    PermissionsModel *model= self.permissionDataAry[indexPath.row];
    cell.textLabel.text = model.groupName;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PermissionsModel *model= self.permissionDataAry[indexPath.row];
    if (_groupName.text != nil && _groupName.text.length > 0) {
        _groupName.text = [NSString stringWithFormat:@"%@",model.groupName];
    }
    self.groupId = model.tuan_id;
    _tableView.hidden = YES;
}
#pragma mark -------- }
#pragma mark -- UITextFieldDelegate {
- (void)cTextFiledEditChanged:(UITextField *)textField {
    [[AppDelegate appDelegate].commonmthod textFiledEditChangedForTextField:textField forIsmatching:^(BOOL ismatching, BOOL isposition) {
        if (ismatching) {
            if (isposition) {
                NSString *toBeString = textField.text;
                if (toBeString.length > kNicknameLimitCount) {
                    textField.text = [toBeString substringToIndex:kNicknameLimitCount];
                }
                
            }
        } else {
            
        }
        
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
#pragma mark -------- }
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"申请权限";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phonefield resignFirstResponder];
    [self.nicknamefield resignFirstResponder];
    [self.qqfield resignFirstResponder];
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
