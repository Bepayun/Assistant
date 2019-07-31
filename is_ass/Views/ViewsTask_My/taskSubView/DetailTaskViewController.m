//
//  DetailTaskViewController.m
//  assistant
//
//  Created by Bepa  on 2017/9/19.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "DetailTaskViewController.h"
#import "DetailTaskTableViewCell.h"
#import "TaskViewModel.h"
#import "DetailTaskHeaderView.h"
#import "SessionChatViewController_Rong.h"
#import "ArbitrationViewController.h"

@interface DetailTaskViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView* detailTaskTableView;
@property (nonatomic, strong) DetailTaskHeaderView* headerView;

@end

@implementation DetailTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableViews];
    [self createNav];
}
- (void)createTableViews {
    
    _detailTaskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_detailTaskTableView];
    _detailTaskTableView.delegate = self;
    _detailTaskTableView.dataSource = self;
    _detailTaskTableView.scrollEnabled = NO;
    _detailTaskTableView.showsVerticalScrollIndicator = NO;
    _detailTaskTableView.showsHorizontalScrollIndicator = NO;
    _detailTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTaskTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // stableView的头部
    self.headerView = [[DetailTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 267)];
    self.headerView.model = _model;
    self.detailTaskTableView.tableHeaderView = self.headerView;
    [self.headerView getHeaderDatas];
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"我的任务";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - detailTaskTableView的delegate {
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell* )tableView:(UITableView* )tableView cellForRowAtIndexPath:(NSIndexPath* )indexPath {
    DetailTaskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[DetailTaskTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[DetailTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[DetailTaskTableViewCell reuseIdentifier]];
    }
    if (indexPath.section == 0) {
        cell.titleLabel.text = @[@"联系雇主",@"申请仲裁",@"取消任务"][indexPath.row];
        
        if (indexPath.row == 2) {
            cell.titleLabel.textColor = [UIColor lightGrayColor];
        }
    }
    cell.arrowImgView.image = [UIImage imageNamed:@"arrow"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath* )indexPath {
    return 72;
}
- (UIView* )tableView:(UITableView* )tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (void)tableView:(UITableView* )tableView didSelectRowAtIndexPath:(NSIndexPath* )indexPath {
    if (indexPath.row == 0) {
        // 联系雇主
        SessionChatViewController_Rong* sessionChatVC = [[SessionChatViewController_Rong alloc] init];
        sessionChatVC.conversationType = ConversationType_PRIVATE;
        sessionChatVC.targetId = _model.seller_id;
        sessionChatVC.title = _model.seller_room_card_name;
        sessionChatVC.modalPresentationStyle = UIModalPresentationCustom;
        sessionChatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sessionChatVC animated:YES];
        
    } else if (indexPath.row == 1) {
        // 申请仲裁
        ArbitrationViewController* arbitrationVC = [[ArbitrationViewController alloc] init];
        arbitrationVC.model = _model;
        arbitrationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:arbitrationVC animated:YES];

    } else if (indexPath.row == 2) {
        UIAlertView* deleteHistoryAlet = [[UIAlertView alloc] initWithTitle:@"是否确认取消?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [deleteHistoryAlet setTag:20000];
        [deleteHistoryAlet show];
    }
}

#pragma mark --------------------------    }
#pragma mark -- UIAlertViewDelegate {
- (void)alertView:(UIAlertView* )alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 20000) {
        if (buttonIndex == 1) {
            
            [TaskViewModel CancelTheOrderViewWithUserId:[AppDelegate appDelegate].userInfostruct.UserID orderId:_model.order_id sucessful:^(NSString* msg, int code) {
                
                if (code == 0) {
                    if ([msg isEqualToString:@"ok"]) {
                        [[AppDelegate appDelegate].commonmthod showAlert:@"取消任务成功"];
                        NSLog(@"取消任务成功");
                            
                    } else {
                        [[AppDelegate appDelegate].commonmthod showAlert:msg];
                    }
                    
                } else {
                    [[AppDelegate appDelegate].commonmthod showAlert:@"取消任务失败，请重新取消。"];
                    NSLog(@"取消任务失败");
                }
            }];
            return;
            
        } else if (buttonIndex == 0) {
            return;
        }
        
    }
}
#pragma mark ------ }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
