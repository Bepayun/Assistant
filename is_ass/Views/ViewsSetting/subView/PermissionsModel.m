//
//  PermissionsModel.m
//  assistant
//
//  Created by Bepa  on 2017/9/7.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "PermissionsModel.h"

@implementation PermissionsModel

/**
 * 提交申请加入组织/申请房间团权限 POST
 */
+ (void)PermissionWithCardRoomName:(NSString* )cardRoomName tuanId:(NSString* )tuanId userId:(NSString* )userId userRoomId:(NSString* )userRoomId qq:(NSString* )qq telephone:(NSString* )telephone success:(PermissionSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL]; 
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary* dic = @{
                          @"client": @"permissions",
                          @"permissions": @"request",
                          @"card_name": [NSString stringWithFormat:@"%@",cardRoomName],
                          @"tuan_id": [NSString stringWithFormat:@"%@",tuanId],
                          @"UserID": [NSString stringWithFormat:@"%@",userId],
                          @"UERoomID": [NSString stringWithFormat:@"%@",userRoomId],
                          @"qq": [NSString stringWithFormat:@"%@",qq],
                          @"telephone": [NSString stringWithFormat:@"%@",telephone],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary* )responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            NSString* msg = [dict objectForKey:@"msg"];
            sucess(responseObject,msg,code);
        }
        
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
        NSLog(@"提交申请加入组织/申请房间团权限 ------ 失败!!!");

    }];
    
}

/**
 * 验证是否可以申请权限 POST
 */
+ (void)PermissionWithUserId:(NSString* )userId userRoomId:(NSString* )userRoomId success:(PermissionJoinSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary* dic = @{
                          @"client": @"permissions",
                          @"permissions": @"status_check",
                          @"UserId": [NSString stringWithFormat:@"%@",userId],
                          @"UERommID": [NSString stringWithFormat:@"%@",userRoomId],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject) {
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary* )responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            NSString* msg = [dict objectForKey:@"msg"];
            sucess(responseObject,msg,code);
        }

        
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
        NSLog(@"验证是否可以申请权限 ------ 失败!!!");
        
    }];
}

/**
 * 获取团名称合集 GET
 */
+ (void)PermissionWithGroupToRoomId:(NSString* )roomExternalId sucessful:(RoomGroupDataBlock)success {
    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary* dic = @{
                          @"room": @"get_tuan_list",
                          @"UERoomID": [NSString stringWithFormat:@"%@",roomExternalId],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject) {
        int code = -1;
        NSMutableArray* dataAry = [NSMutableArray arrayWithCapacity:0];
        
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary* )responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            
            if ([dict objectForKey:@"items"] && ![[dict objectForKey:@"items"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"items"]];
                for (int i = 0 ;i < array.count; i ++) {
                    NSDictionary* tempDict = [array objectAtIndex:i];
                    PermissionsModel* model = [[PermissionsModel alloc] init];
                    
                    NSString* groupNameIdStr = [tempDict objectForKey:@"id"];
                    if (groupNameIdStr && ![groupNameIdStr isKindOfClass:[NSURL class]]) {
                        NSString* tuanIdString = [NSString stringWithFormat:@"%@",groupNameIdStr];
                        model.tuan_id = tuanIdString;
                    }
                    NSString* groupRoomNameStr = [tempDict objectForKey:@"name"];
                    if (groupRoomNameStr && ![groupRoomNameStr isKindOfClass:[NSURL class]]) {
                        NSString* nameString = [NSString stringWithFormat:@"%@",groupRoomNameStr];
                        model.groupName = nameString;
                    }
                    [dataAry addObject:model];
                }
            }
            NSString* msg = [dict objectForKey:@"msg"];
            success(dataAry,msg,code);
        }

        
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
        
        NSLog(@"获取团名称失败");
    }];
    
}

@end
