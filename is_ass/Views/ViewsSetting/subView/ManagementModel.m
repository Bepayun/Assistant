//
//  ManagementModel.m
//  assistant
//
//  Created by Bepa  on 2017/9/15.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "ManagementModel.h"

@implementation ManagementModel

/**
 获取淘宝小号 GET
 
 @param userId     用户ID
 @param success    返回值
 */
+ (void)GetTaoBaoWithUserId:(NSString *)userId sucessful:(GainTaoBaoDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"task": @"get_tbaccounts",
                          @"UserID": [NSString stringWithFormat:@"%@",userId],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        NSMutableArray *dataAry = [NSMutableArray arrayWithCapacity:0];
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            if ([dict objectForKey:@"items"] && ![[dict objectForKey:@"items"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"items"]];
                for (int i = 0; i < array.count; i ++) {
                    NSDictionary *tempDict = [array objectAtIndex:i];
                    
                    ManagementModel *model = [[ManagementModel alloc] init];
                    NSString *idstr = [tempDict objectForKey:@"id"];
                    if (idstr && ![idstr isKindOfClass:[NSNull class]]) {
                        NSString *idStr = [NSString stringWithFormat:@"%@",idstr];
                        model.userID = idStr;
                    }

                    NSString *platformstr = [tempDict objectForKey:@"platform"];
                    if (platformstr && ![platformstr isKindOfClass:[NSNull class]]) {
                        NSString *platformStr = [NSString stringWithFormat:@"%@",platformstr];
                        model.platform = platformStr;
                    }
                    NSString *nicknamestr = [tempDict objectForKey:@"name"];
                    if (nicknamestr && ![nicknamestr isKindOfClass:[NSNull class]]) {
                        NSString *nameStr = [NSString stringWithFormat:@"%@",nicknamestr];
                        model.nickName = nameStr;
                    }
                    [dataAry addObject:model];
                }
            }
          
            NSString *msg = [dict objectForKey:@"msg"];
            success(dataAry,msg,code);
        }
        
        NSLog(@"获取淘宝小号成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取淘宝小号失败");
    }];
}


/**
 删除淘宝小号 GET
 
 @param accountId     小号记录ID
 @param userId        用户ID
 @param success       返回值
 */
+ (void)DeleteTaoBaoWithAccountId:(NSString *)accountId  userId:(NSString *)userId sucessful:(DeleteTaoBaoDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"task": @"delete_tbaccount",
                          @"id": [NSString stringWithFormat:@"%@",accountId],
                          @"UserID": [NSString stringWithFormat:@"%@",userId],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
        }
        NSString *msg = @"";
        success(msg,code);
        
        NSLog(@"删除成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除失败");
    }];
}

@end
