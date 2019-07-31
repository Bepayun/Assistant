//
//  MySetViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "MySetViewController.h"
#import "PersonalHeaderView.h"
#import "MySetViewControllerCell.h"
#import "ManagementViewController.h"
#import "PermissionsViewController.h"
#import "RecordViewController.h"
#import "MyPerformanceViewController.h"
#import "PermissionsModel.h"
#import "RecordsOfConsumptionViewController.h"
#import "AboutTheApplicationViewController.h"
#import "CashWithdrawalViewController.h"
#import "RechargeViewController.h"

@interface MySetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) PersonalHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MySetViewControllerData) name:@"MySetViewControllerData" object:nil];

    [self setupSubViews];
    
    [self createNav];
}
- (void)setupSubViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];//RGBA(231, 239, 242, 1.0);
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //`tableView的头部
    self.headerView = [[PersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    self.tableView.tableHeaderView = self.headerView;
    [self MySetViewControllerData];
}
- (void)MySetViewControllerData {
    
    [self.headerView PersonalHeaderViewData];
}
#pragma mark - tableViewDelegate {
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MySetViewControllerCell *cell = [MySetViewControllerCell cellForTableView:tableView];
    if (indexPath.section == 0) {
        cell.titleLabel.text = @[@"管理小号",@"申请权限",@"豆子记录",@"我的业绩",@"提现",@"充值",@"关于应用"][indexPath.row];
        cell.cellType = CellTypeDefual;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:kApplicationUpdatePromptImage ofType:kPngName]];
        [cell.dotImageView setImage:image];
        
        if (indexPath.row == 0) {
            UIImage *image = [UIImage imageNamed:@"icon_manage_account"];
            cell.imgView.image = image;
            cell.dotImageView.hidden = YES;
        
        } else {
            UIImage *image = [UIImage imageNamed:@"icon_apply_authority"];
            cell.imgView.image = image;
            
            if (indexPath.row == 6) {
                
                if ([AppDelegate appDelegate].commonmthod.getLocalVersion != nil && [AppDelegate appDelegate].commonmthod.getLocalVersion.length > 0 && [AppDelegate appDelegate].version != nil && [AppDelegate appDelegate].version.length > 0) {
                    
                    if (![[AppDelegate appDelegate].commonmthod.getLocalVersion isEqualToString:[AppDelegate appDelegate].version]) {
                        cell.dotImageView.hidden = NO;
                        
                    } else {
                        cell.dotImageView.hidden = YES;
                    }
                }
                
            } else {
                cell.dotImageView.hidden = YES;
            }
        }
    } else {
        cell.cellType = CellTypeExit;
        
        cell.exitBlock = ^(UIButton *sender) {
        [self LeaveLoginState:sender];
        };
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB(234, 238, 241);
    return view;
}
#pragma mark -- section与row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
        
    } else
        
        return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MySetViewControllerCell getCellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //`管理接任务账号
            ManagementViewController *managementVC = [[ManagementViewController alloc] init];
            managementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managementVC animated:YES];

        } else if (indexPath.row == 1) {
            //`申请权限
            [PermissionsModel PermissionWithUserId:[AppDelegate appDelegate].userInfostruct.UserID userRoomId:[AppDelegate appDelegate].userInfostruct.external_id success:^(id responseObject, NSString *msg, int code) {
                if (code == 0) {
                    
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    NSString *status_label = @"";
                    if ([dic objectForKey:@"status_label"] && ![[dic objectForKey:@"status_label"] isKindOfClass:[NSNull class]]) {
                        status_label = [dic objectForKey:@"status_label"];
                    }
                    NSLog(@"%@", dic);
                   
                    if (![status_label isEqualToString:@"权限申请中"] && ![status_label isEqualToString:@"已经申请过权限"]) {
                        PermissionsViewController *permissionsVC = [[PermissionsViewController alloc] init];
                        permissionsVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:permissionsVC animated:YES];
                        //
                    } else {
                        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [progressHUD hideAnimated:YES afterDelay:0.3];
                        if ([status_label isEqualToString:@"权限申请中"] || [status_label isEqualToString:@"已经申请过权限"]) {
                           progressHUD.label.text = status_label;
                        }
                        
                    }
                }
            } getDataFailure:^(NSError *error) {
                
                NSLog(@"申请权限未通过~");
            }];
            
        
        } else if (indexPath.row == 2) {
            //`助手豆记录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BeansRecordDates" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoldCoinDates" object:nil];
//            RecordViewController *recordVC = [[RecordViewController alloc] init];
//            recordVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:recordVC animated:YES];
            
            //'消费记录
            RecordsOfConsumptionViewController *recordsOfConsumptionVC = [[RecordsOfConsumptionViewController alloc] init];
            recordsOfConsumptionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recordsOfConsumptionVC animated:YES];
       
        } else if (indexPath.row == 3) {
            //`我的业绩
            MyPerformanceViewController *myPerformanceVC = [[MyPerformanceViewController alloc] init];
            myPerformanceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myPerformanceVC animated:YES];
        
        } else if (indexPath.row == 4) {
            //`提现
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CashWithdrawalBalanceData" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"GETCashWithdrawalDates" object:nil];
            CashWithdrawalViewController *cashWithdrawalVC = [[CashWithdrawalViewController alloc] init];
            cashWithdrawalVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cashWithdrawalVC animated:YES];
            
        } else if (indexPath.row == 5) {
            //`充值
            self.navigationController.navigationBar.hidden = NO;
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            rechargeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rechargeVC animated:YES];
            self.navigationController.navigationBar.hidden = YES;
            
        } else if (indexPath.row == 6) {
            //`关于应用
            AboutTheApplicationViewController *aboutAppVC = [[AboutTheApplicationViewController alloc] init];
            aboutAppVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutAppVC animated:YES];
            
        }
    }
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"个人中心";
    
}
#pragma mark - 登录或切换账号 {
-(void)LeaveLoginState:(UIButton *)sender{
    
    [self exitLogonPressedOperation:(UIButton *)sender];
}
- (void)exitLogonPressedOperation:(UIButton *)sender {
    NSString *titleString = [sender titleForState:UIControlStateNormal];
    if ([titleString isEqualToString:kLoginButtonName]) {
        UIAlertView *deleteHistoryAlet = [[UIAlertView alloc] initWithTitle:kLoginButtonName message:kExitCurrentAccount delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [deleteHistoryAlet setTag:kMySetExitAlertTag];
        [deleteHistoryAlet show];
        
    }
//        else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"openLoginView" object:nil];
//    }
}
#pragma mark -- UIAlertViewDelegate {
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kMySetExitAlertTag) {
        if (buttonIndex == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openLoginView" object:nil];
            //注销融云
            [[RCIM sharedRCIM] logout];

        } else if (buttonIndex == 0) {
            return;
        }

    }
}
#pragma mark ------ }
#pragma mark --------- }
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
