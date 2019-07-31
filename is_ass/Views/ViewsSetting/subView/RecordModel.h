//
//  RecordModel.h
//  is_ass
//
//  Created by Bepa  on 2017/9/11.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CashWithdrawalSuccessBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^GetDataFailureBlock)(NSError *error);
typedef void (^BeansRecordDataBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^MyPerformanceDataBlock)(NSMutableArray *array,NSString *msg,int code);

@interface RecordModel : NSObject

/**
 * 房间ID
 */
@property (nonatomic, strong) NSString *userRoomId;

/**
 * 用户ID
 */
@property (nonatomic, strong) NSString *userId;

/**
 * 创建日期
 */
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *timeStr;

/**
 * 接任务记录数字
 */
@property (nonatomic, strong) NSString *change;

/**
 * 任务状态展示内容
 */
@property (nonatomic, strong) NSString *Description;


/**
 * 我的业绩 昵称
 */
@property (nonatomic, strong) NSString *nickName;

/**
 * 我的业绩 账号
 */
@property (nonatomic, strong) NSString *account;

/**
 * 我的业绩 时间
 */
@property (nonatomic, strong) NSString *performance_time;

/**
 * 我的业绩 当前豆
 */
@property (nonatomic, strong) NSString *income_dou;
/**
 * 我的业绩 昨天豆
 */
@property (nonatomic, strong) NSString *pre_income_dou;
/**
 * 我的业绩 总人数
 */
@property (nonatomic, strong) NSString *user_total;

/**
 * 金币明细 类型
 */
@property (nonatomic, strong) NSString *type;

/**
 豆豆记录 GET

 @param userRoomId 房间ID
 @param userId     用户ID
 @param success    返回值
 */
+ (void)BeansRecordWithUserRoomId:(NSString *)userRoomId userId:(NSString *)userId sucessful:(BeansRecordDataBlock)success;

/**
 我的业绩 GET

 @param userId  用户ID
 @param success 返回值
 */
+ (void)MyPerformanceWithUserId:(NSString *)userId sucessful:(MyPerformanceDataBlock)success;

/**
 金币明细 POST
 
 @param page      当前页码
 @param pagecount 每页条数
 @param type      -1 为全部，0：充值，1：提现，2：发单，3.取消，4：推广，5：接任务
 @param sucess    成功返回参数
 @param failure   失败返回错误码
 */
+ (void)CashWithdrawalWithPage:(int)page pageCount:(int)pagecount type:(int)type success:(CashWithdrawalSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

@end
