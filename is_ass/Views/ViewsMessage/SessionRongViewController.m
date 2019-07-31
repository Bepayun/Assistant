//
//  SessionRongViewController.m
//  assistant
//
//  Created by Bepa  on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "SessionRongViewController.h"
#import "SessionChatViewController_Rong.h"

@interface SessionRongViewController ()

@property (nonatomic, strong) UIView* navView;
@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIButton* rightButton;
@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, strong) RCConversationModel* tempModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isClick;

- (void)updateBadgeValueForTabBarItem;

@end

@implementation SessionRongViewController

- (id)initWithSessionTypeIsLiveRoomSession:(BOOL)isLiveRoomSession {
    self = [super init];
    if (self) {
        // 设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)
                                            ]];
        // 设置需要将哪些类型的会话在会话列表中聚合显示 (讨论组和群)
        // 聚合会话类型
        [self setCollectionConversationType:@[ @(ConversationType_DISCUSSION),
                                               @(ConversationType_GROUP)]];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        // 设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)
                                            ]];
        
        // 聚合会话类型
        [self setCollectionConversationType:@[
                                               @(ConversationType_DISCUSSION),
                                               @(ConversationType_GROUP)
                                               ]];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCKitDispatchMessageNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, -64, ScreenWidth, ScreenHeight-64)];
    view.backgroundColor = [UIColor whiteColor];
    self.emptyConversationView = view;
    self.navigationController.navigationBarHidden = YES;
    [self refreshConversationTableViewIfNeeded];
    // 定位未读数会话
    self.index = 0;
    
    [self createNav];
    // 接受定位到未读数会话的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GotoNextCoversation) name:@"GotoNextCoversation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCell:) name:@"RefreshConversationList" object:nil];
    
    // 设置tableview的样式
    self.conversationListTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.conversationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
- (void)createNav {
    UIView* navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64.0)];
    navView.backgroundColor = RGB(18, 150, 219);
    [self.view addSubview:navView];
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的消息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(navView.mas_centerX);
        make.bottom.equalTo(navView.mas_bottom).offset(-9);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    self.titleLabel = titleLabel;
    self.navView = navView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * 点击进入会话页面
 *
 * @param conversationModelType 会话类型
 * @param model                 会话数据
 * @param indexPath             indexPath description
*/
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel* )model atIndexPath:(NSIndexPath* )indexPath {
    SessionChatViewController_Rong* sessionChatVC = [[SessionChatViewController_Rong alloc] init];
    sessionChatVC.conversationType = model.conversationType;
    sessionChatVC.targetId = model.targetId;
    sessionChatVC.title = model.conversationTitle;
    sessionChatVC.unReadMessage = model.unreadMessageCount;
    sessionChatVC.enableNewComingMessageIcon = YES;//开启消息提醒
    sessionChatVC.enableUnreadMessageIcon = YES;
    // 单聊是否显示发送方昵称
    if (model.conversationType == ConversationType_PRIVATE) {
        sessionChatVC.displayUserNameInCell = NO;
        
    }
    sessionChatVC.modalPresentationStyle = UIModalPresentationCustom;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionChatVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}
- (void)GotoNextCoversation {
    NSInteger i;
    // 设置contentInset是为了滚动底部的时候，避免conversationListTableView自动回滚
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, self.conversationListTableView.frame.size.height, 0);
    for (i = self.index + 1 ; i < self.conversationListDataSource.count ; i ++) {
        RCConversationModel* model = self.conversationListDataSource[i];
        if (model.unreadMessageCount > 0) {
            NSIndexPath* scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            self.index = i;
            [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
    // 滚动到起始位置
    if (i >= self.conversationListDataSource.count) {
        for (i = 0; i < self.conversationListDataSource.count; i ++) {
            RCConversationModel* model = self.conversationListDataSource[i];
            if (model.unreadMessageCount > 0) {
                NSIndexPath* scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                self.index = i;
                [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }
}
- (void)updateBadgeValueForTabBarItem {
    __weak typeof(self) __weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        if (count > 0) {
            [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:0 badgeValue:count];
        } else {
            [__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:0];
        }
    });
}
- (void)refreshCell:(NSNotification* )notify {
//    NSString* row = [notify object];
//    RCConversationModel* model = [self.conversationListDataSource objectAtIndex:[row intValue]];
//    model.unreadMessageCount = 0;
//    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    });
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self refreshConversationTableViewIfNeeded];
    }];   
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
