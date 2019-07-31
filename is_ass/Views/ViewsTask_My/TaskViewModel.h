//
//  TaskViewModel.h
//  is_ass
//
//  Created by Bepa  on 2017/9/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TaskViewDataBlock)(NSMutableArray *array,NSString *msg,int code);
typedef void (^CancelTheOrderDataBlock)(NSString *msg,int code);
typedef void (^ArbitrateSuccessBlock)(id responseObject,NSString *msg,int code);
typedef void (^GetDataFailureBlock)(NSError *error);

@interface TaskViewModel : NSObject

/**
 * id
 */
@property (nonatomic, strong) NSString *Id;

/**
 * 创建时间
 */
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *create_timeD;
@property (nonatomic, strong) NSString *timeStr;

/**
 * 任务类型 热门/网络
 */
@property (nonatomic, strong) NSString *platform;

/**
 * 评论
 */
@property (nonatomic, strong) NSString *remark;

/**
 * 总结
 */
@property (nonatomic, strong) NSString *commission_summary;

/**
 * 网页 总结
 */
@property (nonatomic, strong) NSString *commission_summaryone;

/**
 * 任务状态
 */
@property (nonatomic, strong) NSString *state;

// ******************************** 取消任务 ******************************** //

// ******************************** 取消任务 ******************************** //

// ******************************** 我的任务的详情页 ******************************** //
/**
 * 买的任务的类型 (精品)
 */
@property (nonatomic, strong) NSString *buy_type;
// ******************************** 我的任务的详情页 ******************************** //

/**
 * 条件评论
 */
@property (nonatomic, strong) NSString *condition_summary;

/**
 * 更新时间
 */
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *timeStrb;

/**
 * 账号
 */
@property (nonatomic, strong) NSString *tbaccount_name;

/**
 * 账号 其他游戏
 */
@property (nonatomic, strong) NSString *buid;

/**
 * 申请对象
 */
@property (nonatomic, strong) NSString *seller_room_card_name;

/**
 * 联系雇主传入的ID
 */
@property (nonatomic, strong) NSString *seller_id;

/**
 我的任务 GET

 @param userId  用户ID
 @param page    页数
 @param count   每页显示记录条数
 @param success 返回值
 */
+ (void)GetTaskViewWithUserId:(NSString *)userId  page:(int)page pagecount:(int)count sucessful:(TaskViewDataBlock)success;

/**
 取消任务  GET

 @param userId  用户ID
 @param orderId 雇主ID
 @param success 成功返回值
 */
+ (void)CancelTheOrderViewWithUserId:(NSString *)userId  orderId:(NSString *)orderId sucessful:(CancelTheOrderDataBlock)success;


// ******************************** 申请仲裁 ******************************** //

/**
 * 雇主ID
 */
@property (nonatomic, strong) NSString *order_id;
/**
 申请仲裁 POST

 @param userId       用户ID
 @param orderId      雇主ID
 @param chatData     聊天数据，现在实际情况，可以传空值
 @param createReason 申请理由
 @param sucess       成功返回值
 @param failure      失败返回
 */
+ (void)ArbitrateWithUserId:(NSString *)userId orderId:(NSString *)orderId chatData:(NSString *)chatData createReason:(NSString *)createReason success:(ArbitrateSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

@end
