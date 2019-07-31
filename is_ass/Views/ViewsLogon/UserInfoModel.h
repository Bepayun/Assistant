//
//  UserInfoModel.h
//  assistant
//
//  Created by Bepa on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoginsuccessBlock)(id responseObject,NSString *msg,int code);
typedef void (^RegiestsuccessBlock)(id responseObject,NSString *msg,int code);
typedef void (^EnterRoomsuccessBlock)(id responseObject,NSString *msg,int code);
typedef void (^GetDataFailureBlock)(NSError *error);

@interface UserInfoModel : NSObject

/**
 *  登录 POST
  @param account 账号
  @param password 密码
 */
+ (void)LoginGet_tokenWithAccount:(NSString *)account  PassWord:(NSString *)password success:(LoginsuccessBlock)success;

/**
  注册账号 POST
 @param newaccount 账户名
 @param password 密码
 @param device_Id 设备ID
 @param ipstr ip地址
 @param recommender 注册推荐人助手账号
 */
+ (void)RegisterAccountWithNewaccount:(NSString *)newaccount password:(NSString *)password device_id:(NSString *)device_Id ipdress:(NSString *)ipstr reg_recommender:(NSString *)recommender success:(RegiestsuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

/**
 * 进入房间 POST
 @param room_id 房间ID
 @param userid 用户ID
 @param cardname 用户在房间的名片
 */
+ (void)EnterRoomWithroom_external_id:(NSString *)room_id userId:(NSString *)userid room_card_name:(NSString *)cardname token:(NSString *)client_token success:(EnterRoomsuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;


@end
