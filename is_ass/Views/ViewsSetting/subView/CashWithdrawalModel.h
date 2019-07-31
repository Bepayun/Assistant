//
//  CashWithdrawalModel.h
//  assistant
//
//  Created by Bepa  on 2017/11/6.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CashWithdrawalNumSuccessBlock)(id responseObject,NSString *msg,int code);
typedef void (^CashWithdrawalListSuccessBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^CashWithdrawalBtnSuccessBlock)(id responseObject,NSString *msg,int code);
typedef void (^GetDataFailureBlock)(NSError *error);

@interface CashWithdrawalModel : NSObject

/**
 * 提现余额、金币
 */
@property (nonatomic, strong) NSString *balance;

/**
 * id
 */
@property (nonatomic, strong) NSString *ID;

/**
 * 用户ID
 */
@property (nonatomic, strong) NSString *user_id;

/**
 * 姓名
 */
@property (nonatomic, strong) NSString *account_name;

/**
 * 申请时间
 */
@property (nonatomic, strong) NSString *created_time;

/**
 * 提现数量
 */
@property (nonatomic, strong) NSString *amount;

/**
 * 状态
 */
@property (nonatomic, strong) NSString *status;

/**
 * 支付宝
 */
@property (nonatomic, strong) NSString *account;

/**
 金币余额 POST

 @param sucess  成功返回参数
 @param failure 失败返回参数
 */
+ (void)CashWithdrawalBalanceSuccess:(CashWithdrawalNumSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

/**
 金币提取 POST

 @param alipayaccount 支付宝账户
 @param userName      姓名
 @param goldCoinNum   提取金币数量
 @param sucess        成功返回参数
 @param failure       失败返回错误码
 */
+ (void)CashWithdrawalBtnWithAlipayAccount:(NSString *)alipayaccount userName:(NSString *)userName GoldCoinNum:(NSString *)goldCoinNum success:(CashWithdrawalBtnSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

/**
 金币提取列表
 
 @param page      当前页数
 @param pagecount 每页条数
 @param all       0:取个人的全部提现记录 1:为超级管理人员取得所有人提现记录
 @param ststus    此字段只有在all=1 才会生效 默认状态是pending-----已发放:'finish' 申请中='pending'
 @param sucess    成功返回参数
 @param failure   失败返回错误码
 */
+ (void)CashWithdrawalListWithPage:(int)page pageCount:(int)pagecount all:(NSString *)all status:(NSString *)ststus success:(CashWithdrawalListSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;
@end
