//
//  GoldCoinViewController.m
//  assistant
//
//  Created by Bepa  on 2017/10/17.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "GoldCoinViewController.h"
#import "RecordTableViewCell.h"
#import "RecordModel.h"

#define kDataCount 20

@interface GoldCoinViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *goldCoinTableView;
@property (nonatomic, strong) NSMutableArray *goldCoinDataArray;
@property (nonatomic, assign) int listpage;

@end

@implementation GoldCoinViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getGoldCoinDates];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(234, 238, 241);
    self.goldCoinDataArray = [NSMutableArray arrayWithCapacity:0];
    self.listpage = 0;
    
    [self createViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGoldCoinDates) name:@"BeansRecordDates" object:nil];
}
- (void)createViews {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    __weak GoldCoinViewController *weakself = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself.view);
        make.height.mas_equalTo(180);
    }];
    //
    UILabel *titleLabelTwo = [[UILabel alloc] init];
    [bottomView addSubview:titleLabelTwo];
    titleLabelTwo.textAlignment = NSTextAlignmentLeft;
    titleLabelTwo.text = @"金币说明";
    titleLabelTwo.textColor = [UIColor blackColor];
    titleLabelTwo.font = [UIFont systemFontOfSize:17.0f];
    [titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(15);
        make.left.equalTo(bottomView.mas_left).offset(12);
        make.right.equalTo(bottomView);
        make.height.mas_equalTo(22);
    }];
    //
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = RGB(234, 238, 241);
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(titleLabelTwo.mas_bottom).offset(11);
        make.height.mas_equalTo(1);
    }];
    //
    UILabel *titleLabelOne = [[UILabel alloc] init];
    [bottomView addSubview:titleLabelOne];
    titleLabelOne.text = @"1.金币和RMB的比例是1：1";
    titleLabelOne.textColor = [UIColor blackColor];
    titleLabelOne.font = [UIFont systemFontOfSize:14.0f];
    titleLabelOne.textAlignment = NSTextAlignmentLeft;
    [titleLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(12);
        make.right.equalTo(bottomView);
        make.top.equalTo(line.mas_bottom).offset(11);
        make.height.mas_equalTo(20);
    }];
    //
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:titleLabel];
    titleLabel.text = @"2.请管好自己账号密码,不要泄露给他人,以防被盗";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(12);
        make.right.equalTo(bottomView);
        make.top.equalTo(titleLabelOne.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self initControllerView];
    
}
- (void)initControllerView {
    
    //    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 120 - 75)];
    self.goldCoinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 120 - 75 -64)];
    
    self.goldCoinTableView.showsVerticalScrollIndicator = NO;
    self.goldCoinTableView.showsHorizontalScrollIndicator = NO;
    self.goldCoinTableView.delegate = self;
    self.goldCoinTableView.dataSource = self;
    self.goldCoinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.goldCoinTableView];
    self.goldCoinTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(getGoldCoinDates)];
    self.goldCoinTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreGoldCoinDates)];
    
}
#pragma mark - 金币明细数据の请求
- (void)getGoldCoinDates {
    _listpage = 1;
    [self.goldCoinTableView.mj_footer endRefreshing];
    
    [RecordModel CashWithdrawalWithPage:_listpage pageCount:kDataCount type:-1 success:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (array.count > 0) {
            if (self.goldCoinDataArray.count > 0) {
                [self.goldCoinDataArray removeAllObjects];
            }
            [self.goldCoinDataArray addObjectsFromArray:array];
        
        } else {
            if (self.goldCoinDataArray.count > 0) {
                [self.goldCoinDataArray removeAllObjects];
            }
        }
        [self.goldCoinTableView.mj_header endRefreshing];
        _listpage ++;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.goldCoinTableView reloadData];
        }];
        
        NSLog(@"金币明细数据请求成功");
    } getDataFailure:^(NSError *error) {
        
        NSLog(@"金币明细数据请求失败");
    }];
}
- (void)getMoreGoldCoinDates {
    
    [RecordModel CashWithdrawalWithPage:_listpage pageCount:kDataCount type:-1 success:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (array.count > 0) {
            [self.goldCoinDataArray addObjectsFromArray:array];
            _listpage ++;
        
        } else {
            [self.goldCoinTableView.mj_footer resetNoMoreData];
        }
        [self.goldCoinTableView.mj_footer endRefreshing];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.goldCoinTableView reloadData];
        }];
        NSLog(@"金币明细数据请求成功");
    } getDataFailure:^(NSError *error) {
        
        NSLog(@"金币明细数据请求失败");
    }];
}
#pragma mark - UITableViewDelegate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goldCoinDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[RecordTableViewCell reuseIdentifier]];
    }
    if (self.goldCoinDataArray.count <= 0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecordModel *model = self.goldCoinDataArray[indexPath.row];
    cell.create_timeLabel.text = model.create_time;
    cell.timeStrLabel.text = model.timeStr;
    cell.changeLabel.text = model.change;
    cell.descriptionLabel.text = [self cashWithdrawalType:model.type forChange:model.change] ;
    int changeNum = [model.change intValue];
    if (changeNum >= 0) {
        [cell.change_imageView setImage:[UIImage imageNamed:@"icon_recharge"]];
        
    } else {
        [cell.change_imageView setImage:[UIImage imageNamed:@"icon_take_order"]];
    }
    
    return cell;
}
- (NSString *)cashWithdrawalType:(NSString *)type forChange:(NSString *)change {
    int a = [change intValue];
    unsigned int b = abs(a);
    if ([type isEqualToString:@"充值"]) {
        return [NSString stringWithFormat:@"充值了%d个金币", b];
    
    } else if ([type isEqualToString:@"提现"]) {
        return [NSString stringWithFormat:@"提现了%d个金币", b];
    
    } else if ([type isEqualToString:@"发单"]) {
        return [NSString stringWithFormat:@"发布任务消耗了%d个金币", b];
    
    } else if ([type isEqualToString:@"取消"]) {
        return [NSString stringWithFormat:@"取消任务返还%d个金币", b];
   
    } else if ([type isEqualToString:@"推广"]) {
        return [NSString stringWithFormat:@"推广奖励%d个金币", b];
    
    } else if ([type isEqualToString:@"接任务"]) {
        return [NSString stringWithFormat:@"接取任务增加%d个金币", b];
    }
    
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
#pragma mark -------------- }
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
