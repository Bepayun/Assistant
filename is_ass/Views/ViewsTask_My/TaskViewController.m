//
//  TaskViewController.m
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskViewTableViewCell.h"
#import "TaskViewModel.h"
#import "DetailTaskViewController.h"

#define kDataCounnt  15

@interface TaskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView     *taskTableView;
@property (nonatomic, strong) NSMutableArray  *taskDataAry;
@property (nonatomic, assign) int page;

@end

@implementation TaskViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self GetTaskViewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.taskDataAry = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetTaskViewData) name:@"GetTaskViewData" object:nil];
    [self createTableViews];
    
    [self createNav];
}
- (void)createTableViews {
    _taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_taskTableView];
    _taskTableView.delegate = self;
    _taskTableView.dataSource = self;
    _taskTableView.showsVerticalScrollIndicator = NO;
    _taskTableView.showsHorizontalScrollIndicator = NO;
    _taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _taskTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(GetTaskViewData)];
    _taskTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetMoreTaskViewData)];
}
- (void)GetTaskViewData {
    _page = 1;
    [_taskTableView.mj_footer endRefreshing];
    
    [TaskViewModel GetTaskViewWithUserId:[AppDelegate appDelegate].userInfostruct.UserID page:_page pagecount:kDataCounnt sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (self.taskDataAry.count > 0) {
            [self.taskDataAry removeAllObjects];
        }

        if (array.count > 0) {
            [self.taskDataAry addObjectsFromArray:array];
        }
        [self.taskTableView reloadData];
        [self.taskTableView.mj_header endRefreshing];
        _page ++;
    }];
}
- (void)GetMoreTaskViewData {
    [TaskViewModel GetTaskViewWithUserId:[AppDelegate appDelegate].userInfostruct.UserID  page:_page pagecount:kDataCounnt sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        if (array.count > 0) {
            [self.taskDataAry addObjectsFromArray:array];
            [self.taskTableView reloadData];
            _page ++;
            
        } else {
            [self.taskTableView.mj_footer resetNoMoreData];
        }
        [self.taskTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - tableViewDelagate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskViewTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[TaskViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TaskViewTableViewCell reuseIdentifier]];
    }
    if (_taskDataAry.count <= 0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TaskViewModel *model = _taskDataAry[indexPath.row];
    
    cell.create_timeLabel.text = [NSString stringWithFormat:@"接任务时间:%@",model.create_time];
    cell.platformLabel.text = [NSString stringWithFormat:@"(%@)",model.platform];
//    cell.platformLabel.text = [self taskViewControllerWithPlatfrom:model.platform];
    cell.remarkLabel.text = model.remark;
    
    cell.stateLabel.text = [self taskViewControllerWithState:model.state];
    if ([model.platform isEqualToString:@"网页游戏"]) {
        cell.summaryLabel.text = model.commission_summaryone;
    } else {
        cell.summaryLabel.text = model.commission_summary;
    }
    
    
    return cell;
}
- (NSString *)taskViewControllerWithState:(NSString *)state {
    
    if ([state isEqualToString:@"做单中"]) {
        return state = @"做任务中";
        
    } else if ([state isEqualToString:@"拍单完成"]) {
        return state = @"接任务完成";;
        
    } else if ([state isEqualToString:@"卖家已发货"]) {
        return state = @"雇主已发货";;
        
//    } else if ([state isEqualToString:@"已签收"]) {
//        return state = @"已签收";;
        
//    } else if ([state isEqualToString:@"已完成"]) {
//        return state = @"已完成";;
        
    } else if ([state isEqualToString:@"申请取消订单"]) {
        return state = @"申请取消任务";;
        
    } else if ([state isEqualToString:@"卖家同意取消订单"]) {
        return state = @"雇主同意取消任务";;
        
//    } else if ([state isEqualToString:@"管理介入取消"]) {
//        return state = @"管理介入取消";;
        
    } else if ([state isEqualToString:@"买家请求取消"]) {
        return state = @"接任务人请求取消";;
        
//    } else if ([state isEqualToString:@"仲裁中"]) {
//        return state = @"仲裁中";;
//
//    } else if ([state isEqualToString:@"已被仲裁"]) {
//        return state = @"已被仲裁";;
//
//    } else if ([state isEqualToString:@"等待防售后生效"]) {
//        return state = @"等待防售后生效";;
//
//    } else if ([state isEqualToString:@"已收货"]) {
//        return state = @"已收货";;
//
    } else {
        return state;
    }
    return @"";
}
- (NSString *)taskViewControllerWithPlatfrom:(NSString *)platfrom {

    if ([platfrom isEqualToString:@"热门游戏"]) {
        return platfrom = @"热门";
        
    } else if ([platfrom isEqualToString:@"网络游戏"]) {
        return platfrom = @"网络";;
        
    } else if ([platfrom isEqualToString:@"网页游戏"]) {
        return platfrom = @"网页";
        
    } else if ([platfrom isEqualToString:@"其他游戏"]) {
        return platfrom = @"其他";
    
    } else {
        return platfrom;
    }
    
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTaskViewController *detailTaskVC = [[DetailTaskViewController alloc] init];
    detailTaskVC.model = _taskDataAry[indexPath.row];
    detailTaskVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailTaskVC animated:YES];
}
#pragma mark --------------- }
#pragma mark - 修改状态栏
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"我的任务";
    
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
