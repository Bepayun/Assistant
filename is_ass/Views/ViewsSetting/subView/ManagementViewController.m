//
//  ManagementViewController.m
//  is_ass
//
//  Created by Bepa  on 2017/9/5.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "ManagementViewController.h"
#import "ManagementTableViewCell.h"
#import "ManagementModel.h"
#import "TaoBaoWebView.h"
#import "JDWebView.h"

@interface ManagementViewController ()<UITableViewDelegate,UITableViewDataSource,ManagementTableViewCellDelegate>

@property (nonatomic, strong) UITableView *managementTableView;
@property (nonatomic, strong) NSMutableArray *managementDataArray;

@end

@implementation ManagementViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getManagementDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.managementDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self addTableView];
    [self addManagementAccountBtn];
    [self createNav];
}
- (void)addTableView {
    _managementTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 130)];
    self.managementTableView.showsVerticalScrollIndicator = NO;
    self.managementTableView.showsHorizontalScrollIndicator = NO;
    self.managementTableView.delegate = self;
    self.managementTableView.dataSource = self;
    self.managementTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.managementTableView];
    
    self.managementTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(getManagementDatas)];
  
}
- (void)getManagementDatas {
    [self.managementTableView.mj_footer endRefreshing];

    [ManagementModel GetTaoBaoWithUserId:[AppDelegate appDelegate].userInfostruct.UserID sucessful:^(NSMutableArray *array, NSString *msg, int code) {
        
        if (_managementDataArray.count > 0) {
            [self.managementDataArray removeAllObjects ];
        }
        if (array.count > 0) {
            [self.managementDataArray addObjectsFromArray:array];
        }
        [self.managementTableView reloadData];
        [self.managementTableView.mj_header endRefreshing];
        
    }];
    
}
#pragma mark - tableViewDelegate {
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _managementDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ManagementTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[ManagementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ManagementTableViewCell reuseIdentifier]];
    }
    if (_managementDataArray.count <= 0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ManagementModel *model = _managementDataArray[indexPath.row];
    cell.delegate = self;
    
    //删除
    cell.model = model;
    cell.indexPath = indexPath;
    
    if ([model.platform isEqualToString:@"taobao"]) {
        cell.accountNamelabel.text = @"(热门)";
        
    } else if ([model.platform isEqualToString:@"jd"]) {
        cell.accountNamelabel.text = @"(网络)";
        
    } else {
        cell.accountNamelabel.text = @"(其他)";
    }
    
    cell.nicknameLabel.text = model.nickName;
    [cell.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    return cell;
}
- (void)deleteAccountDatas:(ManagementModel *)model indexPath:(NSIndexPath *)indexPath {
    
    [ManagementModel DeleteTaoBaoWithAccountId:model.userID userId:[AppDelegate appDelegate].userInfostruct.UserID sucessful:^(NSString *msg, int codife) {
        
        if (codife == 0) {
           // [_managementTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            [_managementDataArray removeObject:model];
            [_managementTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDeleteTaobaoAccount object:nil];
            NSLog(@"删除成功");
            
        } else {
            [[AppDelegate appDelegate].commonmthod showAlert:@"删除失败!"];
            NSLog(@"删除失败");
        }
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
#pragma mark --------------- }
#pragma mark - 添加淘宝或京东账号Button {
- (void)addManagementAccountBtn {
    UIButton *taobaoBtn = [[UIButton alloc] init];
    taobaoBtn.backgroundColor = RGB(16, 114, 200);
    [self.view addSubview:taobaoBtn];
    [taobaoBtn setTitle:@"+添加热门游戏账号" forState:UIControlStateNormal];
    taobaoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [taobaoBtn addTarget:self action:@selector(pushTaoBaoViewPressed) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *JDBtn = [[UIButton alloc] init];
    JDBtn.backgroundColor = RGB(16, 114, 200);
    [self.view addSubview:JDBtn];
    [JDBtn setTitle:@"+添加网络游戏账号" forState:UIControlStateNormal];
    JDBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [JDBtn addTarget:self action:@selector(pushJDViewPressed) forControlEvents:UIControlEventTouchUpInside];

    CGFloat width = ScreenWidth/2-13;
    CGFloat height = 40;
    CGFloat spacing = 10;
    __weak ManagementViewController *weakself = self;
    [taobaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view.mas_left).offset(spacing);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-spacing);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [JDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.view.mas_right).offset(-spacing);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-spacing);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}
- (void)pushTaoBaoViewPressed {
    [AppDelegate appDelegate].userInfostruct.orderType = 0;
    TaoBaoWebView *taobaoWebView = [[TaoBaoWebView alloc] init];
    taobaoWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taobaoWebView animated:YES];
}
- (void)pushJDViewPressed {
    [AppDelegate appDelegate].userInfostruct.orderType = 0;
    JDWebView *JDwebView = [[JDWebView alloc] init];
    JDwebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:JDwebView animated:YES];
}
#pragma mark --------- }
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"管理任务账号";
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

@end
