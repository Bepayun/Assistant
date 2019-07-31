//
//  RecordViewController.m
//  assistant
//
//  Created by Bepa  on 2017/9/5.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableViewCell.h"
#import "RecordModel.h"

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *recordTableView;
@property (nonatomic, strong) NSMutableArray *recordDataArray;

@end

@implementation RecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self BeansRecordDates];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(234, 238, 241);
    self.recordDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createViews];
//    [self createNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BeansRecordDates) name:@"BeansRecordDates" object:nil];

}
- (void)createViews {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bottomView addSubview:titleLabel];
    
    __weak RecordViewController *weakself = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself.view);
        make.height.mas_equalTo(180);
    }];

    UILabel *titleLabelTwo = [[UILabel alloc] init];
    [bottomView addSubview:titleLabelTwo];
    titleLabelTwo.textAlignment = NSTextAlignmentLeft;
    titleLabelTwo.text = @"助手豆使用说明";
    titleLabelTwo.textColor = [UIColor blackColor];
    titleLabelTwo.font = [UIFont systemFontOfSize:17.0f];
    [titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(15);
        make.left.equalTo(bottomView.mas_left).offset(12);
        make.right.equalTo(bottomView);
        make.height.mas_equalTo(22);
    }];
    
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
    titleLabelOne.text = @"1.接任务成功，消耗10个助手豆";
    titleLabelOne.textColor = [UIColor blackColor];
    titleLabelOne.font = [UIFont systemFontOfSize:14.0f];
    titleLabelOne.textAlignment = NSTextAlignmentLeft;
    [titleLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(12);
        make.right.equalTo(bottomView);
        make.top.equalTo(line.mas_top).offset(11);
        make.height.mas_equalTo(20);
    }];
    
    titleLabel.text = @"2.十分钟内取消任务，返还8个助手豆";
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
    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 120 - 75 -64)];

    self.recordTableView.showsVerticalScrollIndicator = NO;
    self.recordTableView.showsHorizontalScrollIndicator = NO;
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.recordTableView];
    self.recordTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(BeansRecordDates)];
    
}
- (void)BeansRecordDates {
    [self.recordTableView.mj_footer endRefreshing];

    [RecordModel BeansRecordWithUserRoomId:[AppDelegate appDelegate].userInfostruct.external_id userId:[AppDelegate appDelegate].userInfostruct.UserID sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        if (self.recordDataArray.count > 0) {
            [self.recordDataArray removeAllObjects];
        }
        if (array.count > 0) {
            [self.recordDataArray addObjectsFromArray:array];
            
        }
        [self.recordTableView reloadData];
        [self.recordTableView.mj_header endRefreshing];
    }];

}
#pragma mark - UITableViewDelegate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[RecordTableViewCell reuseIdentifier]];
    }
    if (self.recordDataArray.count <= 0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecordModel *model = self.recordDataArray[indexPath.row];
    cell.create_timeLabel.text = model.create_time;
    cell.timeStrLabel.text = model.timeStr;
    cell.changeLabel.text = model.change;
    cell.descriptionLabel.text = model.Description;
//    cell.descriptionLabel.text = [self cashWithdrawalForDescription:model.Description;
    int changeNum = [model.change intValue];
    if (changeNum >= 0) {
        [cell.change_imageView setImage:[UIImage imageNamed:@"icon_recharge"]];
        
    } else {
        [cell.change_imageView setImage:[UIImage imageNamed:@"icon_take_order"]];
    }
    
    return cell;
}
- (NSString *)cashWithdrawalForDescription:(NSString *)description {
    if (description.length > 0 && description != nil) {
        NSString *str = [description stringByReplacingOccurrencesOfString:@" 返还 +" withString:@"返还"];
        return str;
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
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"助手豆记录";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
