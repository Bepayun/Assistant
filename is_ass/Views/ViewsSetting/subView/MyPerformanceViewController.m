//
//  MyPerformanceViewController.m
//  is_ass
//
//  Created by Bepa  on 2017/9/5.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "MyPerformanceViewController.h"
#import "MyPerformanceTableViewCell.h"
#import "PerformanceHeaderView.h"
#import "RecordModel.h"

@interface MyPerformanceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PerformanceHeaderView *headerView;
@property (nonatomic, strong) UITableView *myPerformanceTableView;
@property (nonatomic, strong) NSMutableArray *myPerformanceDateArray;

@end

@implementation MyPerformanceViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPerformanceDates];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myPerformanceDateArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createControllerView];
    [self createNav];
}
- (void)createControllerView {
    //tableview的头部
    _headerView = [[PerformanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    [self.view addSubview:_headerView];
    
    //tableview
    _myPerformanceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height+_headerView.frame.origin.y, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_myPerformanceTableView];
    _myPerformanceTableView.delegate = self;
    _myPerformanceTableView.dataSource = self;
    _myPerformanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myPerformanceTableView.showsVerticalScrollIndicator = NO;
    _myPerformanceTableView.showsHorizontalScrollIndicator = NO;
    _myPerformanceTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPerformanceDates)];
    
}

#pragma mark - tableViewDelegate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myPerformanceDateArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPerformanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyPerformanceTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[MyPerformanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyPerformanceTableViewCell reuseIdentifier]];
    }
    if (self.myPerformanceDateArray.count <= 0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecordModel *model = self.myPerformanceDateArray[indexPath.row];
    cell.nickNameLabel.text = model.nickName;
    cell.accountLabel.text = model.account;
    cell.create_timeLabel.text = model.performance_time;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
#pragma mark -------------- }
- (void)getPerformanceDates {
    [_myPerformanceTableView.mj_footer endRefreshing];
    
    [RecordModel MyPerformanceWithUserId:[AppDelegate appDelegate].userInfostruct.UserID sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        if (_myPerformanceDateArray.count > 0) {
            [self.myPerformanceDateArray removeAllObjects];
        }
        if (array.count > 0) {
            
            [self.myPerformanceDateArray addObjectsFromArray:array];
             RecordModel *model = self.myPerformanceDateArray[0];
            //tableView头部取数据
            [self.headerView setModel:model];
        }
        [self.myPerformanceTableView reloadData];
        [self.myPerformanceTableView.mj_header endRefreshing];
    }];
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"我的业绩";
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
