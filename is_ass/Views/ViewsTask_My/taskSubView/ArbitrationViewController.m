//
//  ArbitrationViewController.m
//  assistant
//
//  Created by Bepa  on 2017/9/20.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "ArbitrationViewController.h"

@interface ArbitrationViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITextField *sellerNameTextField;
@property (nonatomic, strong) UITextView  *contentTextView;
@property (nonatomic, strong) UILabel     *textViewLabel;

@end

@implementation ArbitrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(234, 238, 241);

    [self createViews];
    
    [self createNav];
    
}
- (void)createViews {
    // 仲裁对象
    UILabel *objLabel = [[UILabel alloc] init];
    [self.view addSubview:objLabel];
    objLabel.text = @"仲裁对象";
    objLabel.textColor = RGB(109, 109, 109);
    objLabel.font = [UIFont systemFontOfSize:17.0f];
    objLabel.textAlignment = NSTextAlignmentLeft;
    //
    UITextField *sellerNameTextField = [[UITextField alloc] init];
    sellerNameTextField.backgroundColor = [UIColor whiteColor];
    sellerNameTextField.text = _model.seller_room_card_name;
    [self.view addSubview:sellerNameTextField];
    sellerNameTextField.textColor = [UIColor blackColor];
    sellerNameTextField.contentVerticalAlignment = NSTextAlignmentLeft;
    sellerNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    sellerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    sellerNameTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    sellerNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    sellerNameTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    sellerNameTextField.font = [UIFont systemFontOfSize:17.0f];
    sellerNameTextField.delegate = self;
    self.sellerNameTextField = sellerNameTextField;
    // 申请理由
    UILabel *reasonLabel = [[UILabel alloc] init];
    [self.view addSubview:reasonLabel];
    reasonLabel.text = @"申请理由";
    reasonLabel.textColor = RGB(109, 109, 109);
    reasonLabel.font = [UIFont systemFontOfSize:17.0f];
    reasonLabel.textAlignment = NSTextAlignmentLeft;
    //
    UITextView *contentTextView = [[UITextView alloc] init];
    [self.view addSubview:contentTextView];
    contentTextView.delegate = self;
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.textColor = [UIColor blackColor];
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.font = [UIFont systemFontOfSize:17.0f];
    self.contentTextView = contentTextView;
    
    UILabel *textViewLabel = [[UILabel alloc] init];
    [self.view addSubview:textViewLabel];
    textViewLabel.text = @"申请仲裁的理由（原因）";
    textViewLabel.textColor = [UIColor lightGrayColor];
    textViewLabel.font = [UIFont systemFontOfSize:17.0f];
    textViewLabel.hidden = NO;
    self.textViewLabel = textViewLabel;

    //
    UIButton *arbitrationBtn = [[UIButton alloc] init];
    arbitrationBtn.backgroundColor = RGB(16, 114, 200);
    [self.view addSubview:arbitrationBtn];
    [arbitrationBtn setTitle:@"申请仲裁" forState:UIControlStateNormal];
    [arbitrationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    arbitrationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [arbitrationBtn addTarget:self action:@selector(arbitrationBtnPressed) forControlEvents:UIControlEventTouchUpInside];

    CGFloat spacing = 25;
    CGFloat height = 25;
    CGFloat width = 100;
    
    __weak ArbitrationViewController *weakself = self;
    [objLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view).offset(spacing);
        make.left.equalTo(weakself.view.mas_left).offset(spacing-5);
        make.height.mas_equalTo(height-5);
        make.width.mas_equalTo(width);
    }];
    
    [sellerNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(objLabel.mas_bottom).offset(spacing);
        make.left.equalTo(weakself.view.mas_left).offset(spacing-5);
        make.right.equalTo(weakself.view.mas_right).offset(-(spacing-5));
        make.height.mas_equalTo(height*2);
    }];
    
    [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sellerNameTextField.mas_bottom).offset(spacing);
        make.left.equalTo(weakself.view.mas_left).offset(spacing-5);
        make.height.mas_equalTo(height-5);
        make.width.mas_equalTo(width);
    }];
    
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonLabel.mas_bottom).offset(spacing);
        make.left.equalTo(weakself.view.mas_left).offset(spacing-5);
        make.right.equalTo(weakself.view.mas_right).offset(-(spacing-5));
        make.height.mas_equalTo(ScreenHeight/3);
    }];
    [textViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonLabel.mas_bottom).offset(spacing+10);
        make.left.equalTo(weakself.view.mas_left).offset(spacing);
        make.width.mas_equalTo(width*2);
        make.height.mas_equalTo(height-5);
    }];
 
    [arbitrationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentTextView.mas_bottom).offset(spacing*2);
        make.left.equalTo(weakself.view.mas_left).offset(spacing-5);
        make.right.equalTo(weakself.view.mas_right).offset(-(spacing-5));
        make.height.mas_equalTo(height*2);
    }];
}
- (void)arbitrationBtnPressed {
    UIAlertView *deleteHistoryAlet = [[UIAlertView alloc] initWithTitle:@"是否申请仲裁?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteHistoryAlet setTag:10110];
    [deleteHistoryAlet show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10110) {
        if (buttonIndex == 1) {
            if (_contentTextView.text != nil && _contentTextView.text.length > 0) {
                
                [TaskViewModel ArbitrateWithUserId:[AppDelegate appDelegate].userInfostruct.UserID orderId:_model.order_id chatData:[NSString stringWithFormat:@""] createReason:_contentTextView.text success:^(id responseObject, NSString *msg, int code) {
                    NSDictionary *dict = (NSDictionary *)responseObject;
                    NSString *msgstr = [dict objectForKey:@"msg"];
                    if (code == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            progressHUD.label.text = msgstr;//@"提交成功";
                            [progressHUD hideAnimated:YES afterDelay:0.3];
                         });
                        
                    } else {
                        NSLog(@"申请仲裁失败");
                    }
                    
                } getDataFailure:^(NSError *error) {
                    
                    
                }];
            
            } else {
                [[AppDelegate appDelegate].commonmthod showAlert:@"申请理由不能为空。"];
            }
            
        } else if (buttonIndex == 0) {
            return;
        }
        
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.contentTextView.text length] == 0) {
        [_textViewLabel setHidden:NO];
        
    } else {
        [_textViewLabel setHidden:YES];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.sellerNameTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"申请仲裁";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
