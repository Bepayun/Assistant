//
//  PermissionsModel.h
//  assistant
//
//  Created by Bepa  on 2017/9/7.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PermissionSuccessBlock)(id responseObject,NSString* msg,int code);
typedef void (^PermissionJoinSuccessBlock)(id responseObject,NSString* msg,int code);
typedef void (^GetDataFailureBlock)(NSError* error);
typedef void (^RoomGroupDataBlock)(NSMutableArray* array,NSString* msg,int code);

@interface PermissionsModel : NSObject

// 昵称
@property (nonatomic, strong) NSString* card_roomName;
// 团ID
@property (nonatomic, strong) NSString* tuan_id;
// 用户ID
@property (nonatomic, strong) NSString* userID;
// 房间ID
@property (nonatomic, strong) NSString* userRoomID;
// qq
@property (nonatomic, strong) NSString* qq;
// 手机号
@property (nonatomic, strong) NSString* telephoneNum;
// 带IS的房间号
@property (nonatomic, strong) NSString* roomExternalId;

// 团_团 ID
@property (nonatomic, strong) NSString* groupId;
// 房间昵称
@property (nonatomic, strong) NSString* groupName;

/**
 * 验证是否可以申请权限 POST
 @param userId 用户ID
 @param userRoomId 房间ID
 
 */
+ (void)PermissionWithUserId:(NSString* )userId userRoomId:(NSString* )userRoomId success:(PermissionJoinSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

/**
 * 提交申请加入组织/申请房间团权限 POST
 @param cardRoomName 账户名
 @param tuanId 团ID
 @param userId 用户ID
 @param userRoomId 房间ID
 @param qq QQ
 @param telephone 手机号
 */
+ (void)PermissionWithCardRoomName:(NSString* )cardRoomName tuanId:(NSString* )tuanId userId:(NSString* )userId userRoomId:(NSString* )userRoomId qq:(NSString* )qq telephone:(NSString* )telephone success:(PermissionSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure;

/**
 * 获取团名称合集 GET
 @param roomExternalId 带IS的房间号

 */
+ (void)PermissionWithGroupToRoomId:(NSString* )roomExternalId sucessful:(RoomGroupDataBlock)success;

@end
