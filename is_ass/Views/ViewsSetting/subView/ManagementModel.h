//
//  ManagementModel.h
//  assistant
//
//  Created by Bepa  on 2017/9/15.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GainTaoBaoDataBlock)(NSMutableArray* array,NSString* msg,int code);
typedef void (^DeleteTaoBaoDataBlock)(NSString* msg,int code);

@interface ManagementModel : NSObject

/**
 * 用户ID
 */
@property (nonatomic, strong) NSString* userID;

/**
 * 用户昵称
 */
@property (nonatomic, strong) NSString* nickName;

/**
 * 淘宝或者京东
 */
@property (nonatomic, strong) NSString* platform;

@property (nonatomic, strong) NSString* rate_level;
@property (nonatomic, strong) NSString* rate_level_label;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* update_time;
@property (nonatomic, strong) NSString* update_timestamp;

/**
 获取淘宝小号 GET
 
 @param userId     用户ID
 @param success    返回值
 */
+ (void)GetTaoBaoWithUserId:(NSString* )userId sucessful:(GainTaoBaoDataBlock)success;

/**
 删除淘宝小号 GET
 
 @param accountId     小号记录ID
 @param userId        用户ID
 @param success       返回值
 */
+ (void)DeleteTaoBaoWithAccountId:(NSString* )accountId  userId:(NSString* )userId sucessful:(DeleteTaoBaoDataBlock)success;


@end
