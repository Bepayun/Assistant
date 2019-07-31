//
//  OrderPersonListView.m
//  assistant
//
//  Created by Bepa on 2017/9/15.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "OrderPersonListView.h"

#define kListViewButtonType  1020
@implementation OrderPersonListView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 遮罩
        _blackView = [UIButton buttonWithType:UIButtonTypeCustom];
        _blackView.frame = [[UIApplication sharedApplication] keyWindow].frame;
        self.blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [self.blackView addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.blackView];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
//        [self.blackView addGestureRecognizer:tap];
        //
        self.listview = [[UIImageView alloc]initWithFrame:CGRectMake(40,50,ScreenWidth-80,ScreenHeight-260)];//y:80
        self.listview.backgroundColor = RGBA(234, 239, 242, 1.0);
        self.listview.userInteractionEnabled = YES;
        [self.blackView addSubview:self.listview];
        //
        UILabel *listTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10, self.listview.frame.size.width, 40)];
        listTipsLabel.backgroundColor = [UIColor clearColor];
        listTipsLabel.numberOfLines = 2;
        NSDictionary *attrDict1 = @{ NSForegroundColorAttributeName:RGBA(123, 127, 130, 1.0),NSFontAttributeName: [UIFont systemFontOfSize:16]};
        NSDictionary *attrDict2 = @{ NSForegroundColorAttributeName:RGBA(123, 127, 130, 1.0),NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSMutableAttributedString *str = [[ NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"提示"] attributes:attrDict1];
        [str appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"\n请选择小号接任务" attributes:attrDict2]];
        listTipsLabel.textAlignment = NSTextAlignmentCenter;
        listTipsLabel.attributedText = str;
        [self.listview addSubview:listTipsLabel];
        //
        UIButton *leaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leaveButton.frame = CGRectMake(self.listview.frame.size.width-40, listTipsLabel.frame.origin.y, 30, 30);
        leaveButton.backgroundColor = [UIColor clearColor];
        [leaveButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [leaveButton addTarget:self action:@selector(closeview) forControlEvents:UIControlEventTouchUpInside];
        [self.listview addSubview:leaveButton];
        //
        CGFloat height = self.listview.frame.size.height-125;
        UITableView *XHTableview = [[UITableView alloc]initWithFrame:CGRectMake(15,55,self.listview.frame.size.width-30,height) style:UITableViewStylePlain];
        XHTableview.backgroundColor = [UIColor whiteColor];
        XHTableview.delegate = self;
        XHTableview.dataSource = self;
        XHTableview.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
        XHTableview.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(DeleteTaobaoAccount)];
        self.accountListTabelView = XHTableview;
        [self.listview addSubview:self.accountListTabelView];
        //
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:@"添加账号" forState:UIControlStateNormal];
        [addButton setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
         addButton.backgroundColor = RGBA(125, 126, 127, 1.0);
        [addButton addTarget:self action:@selector(addAccount) forControlEvents:UIControlEventTouchUpInside];
        [self.listview addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.listview.mas_right).with.offset(-15);
            make.top.mas_equalTo(self.accountListTabelView.mas_bottom).with.offset(15);
            make.height.offset(30);
            make.width.mas_equalTo(self.accountListTabelView.mas_width).multipliedBy(0.45);
        }];
        
        UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [certainButton setTitle:@"确定" forState:UIControlStateNormal];
        [certainButton setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        certainButton.backgroundColor = RGBA(45, 173, 254, 1.0);
        [certainButton addTarget:self action:@selector(chooseAccountCertain) forControlEvents:UIControlEventTouchUpInside];
        [self.listview addSubview:certainButton];
        [certainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.listview.mas_left).with.offset(15);
            make.top.mas_equalTo(self.accountListTabelView.mas_bottom).with.offset(15);
            make.height.offset(30);
            make.width.mas_equalTo(self.accountListTabelView.mas_width).multipliedBy(0.45);
        }];
    }
    self.taobaoAccountArray = [NSMutableArray arrayWithCapacity:0];
    self.AccountArray = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTaobaoAccount:) name:KNotificationGetTaobaoAccount object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeleteTaobaoAccount) name:KNotificationDeleteTaobaoAccount object:nil];
    return self;
}
- (void)getTaobaoAccount:(NSNotification *)notice {
    NSDictionary* number = notice.object;
    self.platformtype = [[number objectForKey:@"platform"]intValue];
    self.hidden = NO;
    [self.accountListTabelView.mj_header beginRefreshing];
}
- (void)DeleteTaobaoAccount {
    [TaskHallModel GetAccountWithTaobao:[AppDelegate appDelegate].userInfostruct.UserID withplatform:self.platformtype successful:^(NSMutableArray *array, NSString *msg, int code) {
        [self.accountListTabelView.mj_header endRefreshing];

        if (self.taobaoAccountArray.count > 0) {
            [self.taobaoAccountArray removeAllObjects];
        }
        [self.taobaoAccountArray addObjectsFromArray:array];
        
        [self.accountListTabelView reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taobaoAccountArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier2 = @"accountcell";
    Account_TaobaoCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (!cell) {
        cell = [[Account_TaobaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delagate = self;
    }
    TaskHallModel* model = self.taobaoAccountArray[indexPath.row];
    if (self.platformtype == kTaskHallPlatformTypeTaoBao && [model.plateform_type isEqualToString:@"taobao"]) {
        if (indexPath.row == 0) {
            cell.selectedButton.enabled = NO;
        }else{
            cell.selectedButton.enabled = YES;
        }
        
    } else if (self.platformtype == kTaskHallPlatformTypeJD && [model.plateform_type isEqualToString:@"jd"]) {
        if (indexPath.row == 0) {
            cell.selectedButton.enabled = NO;
        } else {
            cell.selectedButton.enabled = YES;
        }
    } else {
        if (indexPath.row == 0) {
            cell.selectedButton.enabled = NO;
        } else {
            cell.selectedButton.enabled = YES;
        }
    }
    cell.selectedButton.tag = kListViewButtonType+indexPath.row;
    if (cell.selectedButton.enabled == NO) {
        if (_AccountArray.count > 0) {
            [_AccountArray removeAllObjects];
        }
        [_AccountArray addObject:model];
    }
    cell.nameLabel.text = model.taobao_nameStr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Account_TaobaoCell* cell = (Account_TaobaoCell *)[tableView cellForRowAtIndexPath:indexPath];
    for (int i = 0; i<self.taobaoAccountArray.count; i++) {
        UIButton* btn = (UIButton *)[self.accountListTabelView viewWithTag:i+kListViewButtonType];
        if (i == indexPath.row) {
            btn.enabled = NO;
        }else{
            btn.enabled = YES;
        }
        
    }
    TaskHallModel* model = self.taobaoAccountArray[indexPath.row];
    if (cell.selectedButton.enabled == NO) {
        if (_AccountArray.count > 0) {
            [_AccountArray removeAllObjects];
        }
        [_AccountArray addObject:model];
    }
}
- (void)Account_TaobaoCellSelected:(UIButton *)button {
    for (int i = 0; i<self.taobaoAccountArray.count; i++) {
        UIButton* btn = (UIButton *)[self.accountListTabelView viewWithTag:i+kListViewButtonType];
        if (button.tag == btn.tag) {
            btn.enabled = NO;
        }else{
            btn.enabled = YES;
        }
    }
}
- (void)closeview {
    self.hidden = YES;
}
- (void)addAccount {
    [self.delagate addAccountwithTaobaoOrJD];
}
- (void)chooseAccountCertain {
    [self.delagate chooseAccountCertainTaskwithArray:_AccountArray];
    [self closeview];
}
#pragma mark - Gesture
- (void)click:(UIButton *)sender {
//    CGPoint tapLocation = [sender locationInView:self.blackView];
//    CGRect alertFrame = self.listview.frame;
//    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
        [self closeview];
    //}
}

@end
