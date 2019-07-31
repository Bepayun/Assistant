//
//  TaskhallViewController_Registration.m
//  assistant
//
//  Created by Bepa  on 2017/10/31.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaskhallViewController_Registration.h"
#import "TaskhallTableViewCell.h"
#import "CustomAlertView.h"
#import "OrderPersonListView.h"
#import "SessionChatViewController_Rong.h"
#import "JDWebView.h"
#import "TaoBaoWebView.h"
#import "CancelAlert.h"

#define kDataCount 20

@interface TaskhallViewController_Registration ()<UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate,OrderDelegate,OrderPersonListDelegate>

@property (nonatomic, strong) UITableView *taskHallTableView_Registration;
@property (nonatomic, assign) int tasklistpage;
@property (nonatomic, assign) int type;

//@property (nonatomic, strong) CustomAlertView *AlertView;
//@property (nonatomic, strong) NSString *conditionPlatform;
//@property (nonatomic, strong) NSString *level;
//@property (nonatomic, strong) NSString *buy_type;
//@property (nonatomic, strong) OrderPersonListView *orderView;

@end

@implementation TaskhallViewController_Registration
@synthesize accountType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _isCondition = NO;
    _tasklistpage = 0;
    self.tasklistArray = [NSMutableArray arrayWithCapacity:0];
    self.OrderArray = [NSMutableArray arrayWithCapacity:0];
    self.conditionPlatform = @"";
    
    [self createViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTaskHallData) name:@"GETTaskHallData_Registration" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenView) name:KNotificationCloseWaitView object:nil];
}
- (void)createViews {
    self.taskHallTableView_Registration = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 48 - 55)];
    self.taskHallTableView_Registration.delegate = self;
    self.taskHallTableView_Registration.dataSource = self;
    self.taskHallTableView_Registration.showsVerticalScrollIndicator = NO;
    self.taskHallTableView_Registration.showsHorizontalScrollIndicator = NO;
    self.taskHallTableView_Registration.backgroundColor = [UIColor whiteColor];
    self.taskHallTableView_Registration.estimatedRowHeight = (ScreenHeight-64 -48);
    self.taskHallTableView_Registration.rowHeight = UITableViewAutomaticDimension;
    self.taskHallTableView_Registration.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.taskHallTableView_Registration.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(GetTaskHallData)];
    self.taskHallTableView_Registration.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetMoreTaskHallData)];
    [self.view addSubview:self.taskHallTableView_Registration];

    
}
- (void)refreshTaskHallData {
    if (!_taskHallTableView_Registration.mj_header.isRefreshing) {
        [_taskHallTableView_Registration.mj_header beginRefreshing];
    }
}
- (void)GetTaskHallData {
    if (_isCondition) {
        _type = 1;
    
    } else {
        _type = 0;
    }
    _tasklistpage = 1;
    [_taskHallTableView_Registration.mj_footer endRefreshing];
    
    [TaskHallModel GetTaskHall_RegistrationListWithuePage:self.tasklistpage Pagecount:kDataCount Paixu:@"" Device_t:@"phone" sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (array.count > 0) {
            if (self.tasklistArray.count > 0) {
                [self.tasklistArray removeAllObjects];
            }
            [self.tasklistArray addObjectsFromArray:array];
            
        } else {
            if (self.tasklistArray.count > 0) {
                [self.tasklistArray removeAllObjects];
            }
        }
        [self.taskHallTableView_Registration.mj_header endRefreshing];
        _tasklistpage ++;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.taskHallTableView_Registration reloadData];
        }];

    }];
}
- (void)GetMoreTaskHallData {
    if (_isCondition) {
        _type = 1;
    
    } else {
        _type = 0;
        self.conditionPlatform = @"";
        self.level = @"";
        self.buy_type = @"";
    }
    
    [TaskHallModel GetTaskHall_RegistrationListWithuePage:self.tasklistpage Pagecount:kDataCount Paixu:@"" Device_t:@"phone" sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        if (array.count > 0) {
            [self.tasklistArray addObjectsFromArray:array];
            _tasklistpage ++;
            
        } else {
            [_taskHallTableView_Registration.mj_footer resetNoMoreData];
        }
        [_taskHallTableView_Registration.mj_footer endRefreshing];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.taskHallTableView_Registration reloadData];
        }];

    }];
}
//- (OrderPersonListView *)orderView {
//    if (!_orderView) {
//        _orderView = [[OrderPersonListView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
//        _orderView.delagate = self;
//    }
//    return _orderView;
//}
#pragma mark - taskHallTableView_Registration delegate {
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
//    if ([model.plateform_type isEqualToString:@"淘宝"]) {
//        cell.platformIcon.image = [UIImage imageNamed:@"TB_icon"];
//        cell.OrderButton.tag = kTaskHallPlatformTypeTaoBao;
//
//    } else if ([model.plateform_type isEqualToString:@"京东"]) {
//        cell.platformIcon.image = [UIImage imageNamed:@"JD_icon"];//icon_register
//        cell.OrderButton.tag = kTaskHallPlatformTypeJD;
//
//    } else {
    cell.OrderButton.tag = kTaskHallPlatformTypeOther;
    cell.platformIcon.image = [UIImage imageNamed:@"dragon.jpg"];
//    }
    cell.taskid = model.task_id;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
#pragma mark ----------------  }
/*
 * 请求小号列表
 */
- (void)Order_TakingBegin:(int)platform_type withTask_id:(int)task {
    accountType = platform_type;
    _taskid_taskhall = task;
    if (platform_type == kTaskHallPlatformTypeOther) {
//        if (self.orderView != nil) {
//            self.orderView.hidden = YES;
//        }
        [self chooseAccountCertainTaskwithArray:nil];
    } else if (platform_type == kTaskHallPlatformTypePinDouDou) {
        [self chooseAccountCertainTaskwithArray:nil];
    }
}
/*
 * 接任务请求开始
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
/*
 * 刷手取消请求
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
//        [CancelAlert HiddenView];
    });
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
