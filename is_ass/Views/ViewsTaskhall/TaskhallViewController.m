//
//  TalkhallViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaskhallViewController.h"
#import "TaskhallTableViewCell.h"
#import "CustomAlertView.h"
#import "OrderPersonListView.h"
#import "SessionChatViewController_Rong.h"
#import "JDWebView.h"
#import "TaoBaoWebView.h"
//#import "VerifyWebView.h"
#import "CancelAlert.h"

#define kDataCount  20

@interface TaskhallViewController ()<UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate,OrderDelegate,OrderPersonListDelegate>{
    UITableView *taskHallTableView;
    int tasklistpage;
    int type;
}
@property(nonatomic,strong)CustomAlertView *AlertView;
//@property(nonatomic,strong)NSString *conditionPlatform;
//@property(nonatomic,strong)NSString *level;
//@property(nonatomic,strong)NSString *buy_type;
@property(nonatomic,strong)OrderPersonListView *orderView;

@end

@implementation TaskhallViewController
@synthesize accountType;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _isCondition = NO;
    self.conditionPlatform = @"";
//    [self createNav];
    [self initViewController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTaskHallData) name:@"GETTaskHallData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenView) name:KNotificationCloseWaitView object:nil];
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"任务大厅";
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton setImage:[UIImage imageNamed:@"setup_Img"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(ChangePlatformType:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initViewController {
    tasklistpage = 0;
    self.tasklistArray = [[NSMutableArray alloc]init];
    self.OrderArray = [[NSMutableArray alloc]init];
    taskHallTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49-55) style:UITableViewStylePlain];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    taskHallTableView.delegate = self;
    taskHallTableView.dataSource = self;
    taskHallTableView.showsVerticalScrollIndicator = NO;
    taskHallTableView.showsHorizontalScrollIndicator = NO;
    taskHallTableView.backgroundColor = [UIColor whiteColor];
    taskHallTableView.estimatedRowHeight = (ScreenHeight-64-49);
    taskHallTableView.rowHeight = UITableViewAutomaticDimension;
    taskHallTableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    taskHallTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(GetTaskHallData)];
    taskHallTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetMoreTaskHallData)];
    [self.view addSubview:taskHallTableView];
 
}
- (void)refreshTaskHallData {
    if(!taskHallTableView.mj_header.isRefreshing){
      [taskHallTableView.mj_header beginRefreshing];
    }
}
- (void)GetTaskHallData {
    
    if (_isCondition) {
        type = 1;
   
    } else {
        type = 0;
    }
     tasklistpage = 1;
    [taskHallTableView.mj_footer endRefreshing];
    [TaskHallModel GetTaskHallListWithueroomid:[AppDelegate appDelegate].userInfostruct.external_id PlatformType:self.conditionPlatform Device_type:@"phone" buy_type:self.buy_type level:self.level withType:type Page:tasklistpage pagecount:kDataCount sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        if (array.count > 0) {
            if (self.tasklistArray.count > 0) {
                [self.tasklistArray removeAllObjects];
            }
            
            for (TaskHallModel *model in array) {
                if ([model.plateform_type isEqualToString:@"注册"]) {
//                    continue;
                } else {
                    
                    [self.tasklistArray addObject:model];
                }
            }
//                if (self.tasklistArray.count > 0) {
//                    [self.tasklistArray removeAllObjects];
//                }
//                [self.tasklistArray addObjectsFromArray:array];
            } else {
                if (self.tasklistArray.count > 0) {
                    [self.tasklistArray removeAllObjects];
                }
            }
            [taskHallTableView.mj_header endRefreshing];
            tasklistpage = tasklistpage+1;
         [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [taskHallTableView reloadData];
         }];
    }];
}
- (void)GetMoreTaskHallData {
    
    if (_isCondition) {
        type = 1;
    
    } else {
        type = 0;
        self.conditionPlatform = @"";
        self.level = @"";
        self.buy_type = @"";
    }
    [TaskHallModel GetTaskHallListWithueroomid:[AppDelegate appDelegate].userInfostruct.external_id PlatformType:self.conditionPlatform Device_type:@"phone" buy_type:self.buy_type level:self.level withType:type Page:tasklistpage pagecount:kDataCount sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        if (array.count > 0) {
            for (TaskHallModel *model in array) {
                if ([model.plateform_type isEqualToString:@"注册"]) {
//                    continue;
                } else {
                    [self.tasklistArray addObject:model];
                    tasklistpage = tasklistpage+1;
                }
            }
          
        } else {
          [taskHallTableView.mj_footer resetNoMoreData];
        }
          [taskHallTableView.mj_footer endRefreshing];
         [[NSOperationQueue mainQueue]addOperationWithBlock:^{
             [taskHallTableView reloadData];
         }];
    }];
}
- (void)ChangePlatformType:(UIButton *)btn {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomAlertView" object:nil];
    [self.view  addSubview:self.AlertView];
    self.AlertView.hidden = NO;
    
}
//-(CustomAlertView *)AlertView{
//    if (!_AlertView) {
//        _AlertView = [[CustomAlertView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
//        _AlertView.delegate = self;
//    }
//    return _AlertView;
//}
- (OrderPersonListView *)orderView {
    if (!_orderView) {
        _orderView = [[OrderPersonListView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
        _orderView.delagate = self;
    }
    return _orderView;
}
/*选择列表条件
 */
- (void)buy_type:(NSString *)buytypestr andlevel:(NSString *)levelstr withPlatform:(NSString *)platform {
    _isCondition = YES;
    self.conditionPlatform = platform;
    self.level = levelstr;
    self.buy_type = buytypestr;
    self.AlertView.hidden = YES;
    [self GetTaskHallData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasklistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskhallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskhallTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[TaskhallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TaskhallTableViewCell reuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.platformIcon.image = nil;
    TaskHallModel *model = self.tasklistArray[indexPath.row];
    cell.date.text = model.creatTime;
//    cell.pay_method.text = model.pay_method;
    if ([model.pay_method isEqualToString:@"收货返"]) {
        cell.pay_method.text = @"垫付任务";
        cell.product_price.text = [NSString stringWithFormat:@"金币:%@",model.product_price];
    
    } else {
        cell.pay_method.text = model.pay_method;
        cell.product_price.text = @"";
    }
    
    
    cell.taskInfoLabel.text = [NSString stringWithFormat:@"%@账号 %@ %@",model.seller_online,model.buy_typeStr,model.remarkString];
    cell.content.text = [NSString stringWithFormat:@"%@",model.commission_concent];
    if ([model.plateform_type isEqualToString:@"淘宝"]) {
        cell.platformIcon.image = [UIImage imageNamed:@"car"];
        cell.OrderButton.tag = kTaskHallPlatformTypeTaoBao;
   
    } else if ([model.plateform_type isEqualToString:@"京东"]) {
        cell.platformIcon.image = [UIImage imageNamed:@"dog"];//icon_register
        cell.OrderButton.tag = kTaskHallPlatformTypeJD;
        
    } else if ([model.plateform_type isEqualToString:@"拼多多"]) {
        cell.OrderButton.tag = kTaskHallPlatformTypePinDouDou;
        cell.platformIcon.image = [UIImage imageNamed:@"pig"];
        cell.taskInfoLabel.text = [NSString stringWithFormat:@"%@账号 %@ %@",model.seller_online,model.buy_typeStr,model.remarkString];
   
    } else if ([model.plateform_type isEqualToString:@"注册"]) {
        cell.OrderButton.tag = kTaskHallPlatformTypeOther;
        cell.platformIcon.image = [UIImage imageNamed:@"dragon.jpg"];
        cell.pay_method.text = @"";
        
    }
            
    cell.taskid = model.task_id;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
/*请求小号列表
 */
- (void)Order_TakingBegin:(int)platform_type withTask_id:(int)task {
     accountType = platform_type;
    _taskid_taskhall = task;
    [AppDelegate appDelegate].userInfostruct.orderType = 6;
    if (platform_type == kTaskHallPlatformTypeOther) {
        if (self.orderView != nil) {
           self.orderView.hidden = YES;
        }
        [self chooseAccountCertainTaskwithArray:nil];
    
    } else if (platform_type == kTaskHallPlatformTypePinDouDou) {
        if (self.orderView != nil) {
            self.orderView.hidden = YES;
        }
        [self chooseAccountCertainTaskwithArray:nil];
        
    } else {
        [self.view addSubview:self.orderView];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationGetTaobaoAccount object:@{@"platform":[NSNumber numberWithInt:platform_type]}];

    }
}
- (void)test {
//    [AppDelegate appDelegate].userInfostruct.orderType = 6;
//    TaoBaoWebView *taobaoWebView = [[TaoBaoWebView alloc] init];
//    taobaoWebView.view.frame = CGRectMake(0,-500, ScreenWidth,300);
    
    　　// addChildViewController回调用[child willMoveToParentViewController:self] ，但是不会调用didMoveToParentViewController，所以需要显示调用
    
   // [self addChildViewController:taobaoWebView];
    //[[UIApplication sharedApplication].keyWindow addSubview:taobaoWebView.view];
     //[self.view bringSubviewToFront:self.navigationController];
    //self.view = taobaoWebView;
    //self.hidesBottomBarWhenPushed = YES;

}
/*添加小号响应
 */
- (void)addAccountwithTaobaoOrJD {
    if ( self.accountType == kTaskHallPlatformTypeTaoBao) {
        [self pushTaoBaoViewPressed];
   
    } else if ( self.accountType == kTaskHallPlatformTypeJD){
        [self pushJDViewPressed];
    
    } else {
        
    }
}
/*接任务请求开始
 */
- (void)chooseAccountCertainTaskwithArray:(NSArray *)array {
//    self.orderView.hidden = NO;
    if (array.count > 0) {
        if (self.OrderArray.count > 0) {
          [self.OrderArray removeAllObjects];
        }
        [self.OrderArray addObjectsFromArray:array];
        TaskHallModel *model = array[0];
        [TaskHallModel GetTaskwithtask_id:_taskid_taskhall account_name:model.taobao_nameStr UERoomID:[AppDelegate appDelegate].userInfostruct.external_id userID:[AppDelegate appDelegate].userInfostruct.UserID successful:^(NSString *msg, int code,NSString *saller_id,NSString *taskid) {
            if (code == 0) {
                [CancelAlert showMessage:@"等待雇主响应,请稍后.." withClickedBlock:^{
                    [self sendCancelMessagewithsallerID:saller_id withTaskid:taskid];
                }];
           
            } else {
               [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                  MBProgressHUD *HuD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                  HuD.mode =  MBProgressHUDModeText;
                  HuD.label.text = msg;
                  [HuD hideAnimated:YES afterDelay:0.9];
               }];
            }
        }];
   
    } else {
        [TaskHallModel GetTaskwithtask_id:_taskid_taskhall account_name:nil UERoomID:[AppDelegate appDelegate].userInfostruct.external_id userID:[AppDelegate appDelegate].userInfostruct.UserID successful:^(NSString *msg, int code,NSString *saller_id,NSString *taskid) {
            if (code == 0) {
                [CancelAlert showMessage:@"等待雇主响应,请稍后.." withClickedBlock:^{
                    [self sendCancelMessagewithsallerID:saller_id withTaskid:taskid];
                }];
           
            } else {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                   MBProgressHUD *HuD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                   HuD.mode =  MBProgressHUDModeText;
                   HuD.label.text = msg;
                   [HuD hideAnimated:YES afterDelay:0.9];
                }];
            }
        }];
    }
}
/*刷手取消请求
 */
- (void)sendCancelMessagewithsallerID:(NSString *)SellerId withTaskid:(NSString *)task_id {
     RCCommandMessage *mesage = [[RCCommandMessage alloc]init];
     mesage.name = @"BuyerCancelRequest";
      int taskID = [task_id intValue];
     NSDictionary *dic = @{@"task_id":[NSNumber numberWithInt:taskID],@"reject_reason":[NSString stringWithFormat:@"接任务者取消了任务请求."]};
     mesage.data = [[AppDelegate appDelegate].commonmthod convertToJsonData:dic];
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:SellerId
                                       content:mesage //
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功");
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"%ld",(long)nErrorCode);
                                       }];
}
- (void)hiddenView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CancelAlert HiddenView];
    });
}
/* 添加淘宝小号
 */
- (void)pushTaoBaoViewPressed {
    [AppDelegate appDelegate].userInfostruct.orderType = 0;
    TaoBaoWebView *taobaoWebView = [[TaoBaoWebView alloc] init];
    taobaoWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taobaoWebView animated:YES];
}
/*添加京东小号
 */
- (void)pushJDViewPressed {
    [AppDelegate appDelegate].userInfostruct.orderType = 0;
    JDWebView *JDwebView = [[JDWebView alloc] init];
    JDwebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:JDwebView animated:YES];
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
