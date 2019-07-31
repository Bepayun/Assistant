//
//  TaskHallModel.h
//  assistant
//
//  Created by Bepa on 2017/9/5.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TaskHallDataBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^TaskHall_RegistrationDataBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^TaobaoAccountDataBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^OrderTaskDataBlock)(NSString *msg,int code,NSString *saller_id,NSString *taskid);
typedef void (^VerifyAccountDataBlock)(NSArray *cookiesArray,NSString *cookierStr,NSString *msg,int code);

@interface TaskHallModel : NSObject
/**
 * 任务类型
 */
@property (nonatomic, strong) NSString *buy_typeString;

/**
 * 创建时间
 */
@property (nonatomic, strong) NSString *creatTime;

/**
 * 平台类型 （淘宝，京东，其它）
 */
@property (nonatomic, strong) NSString *plateform_type;

/**
 * 特别标注
 */
@property (nonatomic, strong) NSString *remarkString;

/**
 * 委托要求
 */
@property (nonatomic, strong) NSString *commission_concent;
/**
 * 账号接线
 */
@property (nonatomic, strong) NSString *seller_online;
/**
 * 任务类型
 */
@property (nonatomic, strong) NSString *buy_typeStr;
/**
 * 任务id
 */
@property (nonatomic, assign) int  task_id;
/**
 * 小号名称
 */
@property (nonatomic, strong) NSString *taobao_nameStr;
/**
 * 小号等级
 */
@property (nonatomic, strong) NSString *taobao_level;
/**
 * 小号等级名称
 */
@property (nonatomic, strong) NSString *taobao_levelname;
/**
 * 小号名称
 */
@property (nonatomic, strong) NSString *taobao_id;
/**
 * 价格
 */
@property (nonatomic, strong) NSString *product_price;

/**
 * 网页游戏pay_method
 */
@property (nonatomic, strong) NSString *pay_method;

@property (nonatomic, strong) NSString *condition_summary;

/**
 获取大厅列表 GET

 @param roomId        房间ID，room_external_id
 @param platfrom      热门，网络，网页，其他，空字符表示所有
 @param devicetype    pc，电脑任务，phone，手机任务
 @param buytypeString 精品，高级，普通
 @param levelstring   小号等级
 @param type          类型
 @param page          当前第几页
 @param count         每页显示条数
 @param success       成功返回值
 */
+ (void)GetTaskHallListWithueroomid:(NSString *)roomId PlatformType:(NSString *)platfrom Device_type:(NSString *)devicetype buy_type:(NSString *)buytypeString level:(NSString *)levelstring withType:(int)type Page:(int)page pagecount:(int)count sucessful:(TaskHallDataBlock)success;

/**
 获取其他游戏任务 GET

 @param page       当前页码
 @param count      每页条数
 @param paixu      update_time 为最新 , seller_online为在线
 @param devicetype phone 为手机任务， pc为电脑任务
 @param success    成功返回值
 */
+ (void)GetTaskHall_RegistrationListWithuePage:(int)page Pagecount:(int)count Paixu:(NSString *)paixu Device_t:(NSString *)devicetype sucessful:(TaskHall_RegistrationDataBlock)success;

/**
 获取小号列表 GET

 @param userID   用户ID
 @param platform 类型
 @param success  成功返回值
 */
+ (void)GetAccountWithTaobao:(NSString *)userID withplatform:(int)platform successful:(TaobaoAccountDataBlock)success;

/**
 刷手请求接取任务 GET

 @param task_id    任务ID
 @param namestring 热门小号名
 @param roomid     房间号
 @param UID        用户ID
 @param success    成功返回值
 */
+ (void)GetTaskwithtask_id:(int)task_id account_name:(NSString *)namestring UERoomID:(NSString *)roomid  userID:(NSString *)UID  successful:(OrderTaskDataBlock)success;

/**
 刷手小号验证 GET

 @param taskid    任务ID
 @param taobao_id 热门小号ID
 @param userID    接任务者ID
 @param sucess    成功返回值
 */
+ (void)GetTaskAccountVerifywithtask_id:(NSString *)taskid taobaoID:(NSString *)taobao_id withbuyer_id:(NSString *)userID sucessful:(VerifyAccountDataBlock)sucess;
@end
