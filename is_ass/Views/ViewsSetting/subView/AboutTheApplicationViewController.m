//
//  AboutTheApplicationViewController.m
//  is_ass
//
//  Created by Bepa  on 2017/10/17.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "AboutTheApplicationViewController.h"
#import "AppUpdateContentView.h"

@interface AboutTheApplicationViewController ()

@property (nonatomic, strong) UILabel *editionLabel;
@property (nonatomic, strong) AppUpdateContentView *contentView;
@property (nonatomic, strong) NSString *phoneversion;

@end

@implementation AboutTheApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self cerateViews];
    [self createNav];
}
- (void)cerateViews {
    
    __weak AboutTheApplicationViewController *weakSelf = self;
    UIImage *image = [UIImage imageNamed:@"logo@2x"];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = image;
    imageview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(55);
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(-15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    UIImage *newimage = [UIImage imageNamed:@"new"];
    UIImageView *newImageView = [[UIImageView alloc] init];
    newImageView.backgroundColor = [UIColor clearColor];
    newImageView.image = newimage;
    [self.view addSubview:newImageView];
    [newImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(55);
        make.left.equalTo(imageview.mas_right);
        make.width.mas_equalTo(newimage.size.width);
        make.height.mas_equalTo(newimage.size.height);
    }];
    //
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    label.text = @"当前版本：";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageview.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(-20);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *editionLabel = [[UILabel alloc] init];
    editionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:editionLabel];
    editionLabel.text = [AppDelegate appDelegate].commonmthod.getLocalVersion;
    editionLabel.textColor = [UIColor lightGrayColor];
    editionLabel.font = [UIFont systemFontOfSize:14.0f];
    editionLabel.textAlignment = NSTextAlignmentLeft;
    [editionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageview.mas_bottom).offset(10);
        make.left.equalTo(label.mas_right);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(18);
    }];
    
    UIButton *updateBtn = [[UIButton alloc] init];
    updateBtn.backgroundColor = RGB(201, 201, 201);
    [self.view addSubview:updateBtn];
    [updateBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    updateBtn.layer.shadowOffset =  CGSizeMake(1, 1);
    updateBtn.layer.shadowOpacity = 0.8;
    updateBtn.layer.shadowColor =  [UIColor lightGrayColor].CGColor;
    
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [updateBtn addTarget:self action:@selector(updateApplyPressed) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)updateApplyPressed {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progressHUD hideAnimated:YES afterDelay:0.3];
//    progressHUD.label.text = @"正在检查更新...";
    if ([AppDelegate appDelegate].commonmthod.getLocalVersion != nil && [AppDelegate appDelegate].commonmthod.getLocalVersion.length > 0 && [AppDelegate appDelegate].version != nil && [AppDelegate appDelegate].version.length > 0) {
        
        
        
        if (![[AppDelegate appDelegate].commonmthod.getLocalVersion isEqualToString:[AppDelegate appDelegate].version]) {
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.contentView = [[AppUpdateContentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
//                self.contentView.hidden = NO;
//                [self.view addSubview:self.contentView];
//            });
            [[AppDelegate appDelegate] anUpdatedVersionOne];
        
        } else {
            
            progressHUD.label.text = @"当前是最新版本";
        }
    }
    
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"检查版本";
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
