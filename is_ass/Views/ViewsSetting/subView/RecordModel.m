//
//  RecordModel.m
//  assistant
//
//  Created by Bepa  on 2017/9/11.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

/**
 豆豆记录 GET
 
 @param userRoomId 房间ID
 @param userId     用户ID
 @param success    返回值
 */
+ (void)BeansRecordWithUserRoomId:(NSString *)userRoomId userId:(NSString *)userId sucessful:(BeansRecordDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"room": @"get_pointsrecord",
                          @"UERoomID": [NSString stringWithFormat:@"%@",userRoomId],
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
                    
                    RecordModel *model = [[RecordModel alloc] init];
                    NSString *timestr = [tempDict objectForKey:@"create_time"];
                    if (timestr && ![timestr isKindOfClass:[NSNull class]]) {
                        NSString *timeString = [NSString stringWithFormat:@"%@",timestr];
                        NSArray *array = [timeString componentsSeparatedByString:@" "];
                        model.create_time = [array firstObject];
                        model.timeStr = [array lastObject];
                        
                    }
                    
                    NSString *changestr = [tempDict objectForKey:@"change"];
                    if (changestr && ![changestr isKindOfClass:[NSNull class]]) {
                        NSString *changeString = [NSString stringWithFormat:@"%@",changestr];
                        model.change = changeString;
                    }
                    NSString *descriptionstr = [tempDict objectForKey:@"description"];
                    if (descriptionstr && ![descriptionstr isKindOfClass:[NSNull class]]) {
                        NSString *descriptionString = [NSString stringWithFormat:@"%@",descriptionstr];
                        model.Description = descriptionString;
                    }
                    
                    [dataAry addObject:model];
                }
            }
            NSString *msg = [dict objectForKey:@"msg"];
            success(dataAry,msg,code);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取豆子记录失败");
    }];
}
/**
 我的业绩 GET
 
 @param userId  用户ID
 @param success 返回值
 */
+ (void)MyPerformanceWithUserId:(NSString *)userId sucessful:(MyPerformanceDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"achievement": @"get_achievement_info",
                          @"UserID": [NSString stringWithFormat:@"%@",userId],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };

    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        NSMutableArray *dataAry = [NSMutableArray arrayWithCapacity:0];
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            RecordModel *model = [[RecordModel alloc] init];
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            if ([dict objectForKey:@"income_dou"] && ![[dict objectForKey:@"income_dou"] isKindOfClass:[NSNull class]]) {
                 model.income_dou = [dict objectForKey:@"income_dou"];
            }
            if ([dict objectForKey:@"pre_income_dou"] && ![[dict objectForKey:@"pre_income_dou"] isKindOfClass:[NSNull class]]) {
                model.pre_income_dou = [dict objectForKey:@"pre_income_dou"];
            }
            if ([dict objectForKey:@"user_total"] && ![[dict objectForKey:@"user_total"] isKindOfClass:[NSNull class]]) {
                model.user_total = [dict objectForKey:@"user_total"];
            }
            if ([dict objectForKey:@"user_info"] && ![[dict objectForKey:@"user_info"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"user_info"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"user_info"]];
                for (int i = 0; i < array.count ; i ++) {
                    NSDictionary *tempDict = [array objectAtIndex:i];
                    
                    NSString *useridstr = [tempDict objectForKey:@"UserID"];
                    if (useridstr && ![useridstr isKindOfClass:[NSNull class]]) {
                        NSString *useridString = [NSString stringWithFormat:@"%@",useridstr];
                        model.account = useridString;
                    }
                    NSString *nicknamestr = [tempDict objectForKey:@"nickname"];
                    if (nicknamestr && ![nicknamestr isKindOfClass:[NSNull class]]) {
                        NSString *nicknameString = [NSString stringWithFormat:@"%@",nicknamestr];
                        model.nickName = nicknameString;
                    }
                    NSString *performance_timestr = [tempDict objectForKey:@"create_time"];
                    if (performance_timestr && ![performance_timestr isKindOfClass:[NSNull class]]) {
                        NSString *performance_timeString = [NSString stringWithFormat:@"%@",performance_timestr];
                        model.performance_time = performance_timeString;
                    }
                    [dataAry addObject:model];
                }
            }
            NSString *msg = [dict objectForKey:@"msg"];
            success(dataAry,msg,code);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取我的业绩失败");
    }];
    
}

/**
 金币明细 POST
 
 @param page      当前页码
 @param pagecount 每页条数
 @param type      -1 为全部，0：充值，1：提现，2：发单，3.取消，4：推广，5：接任务
 @param sucess    成功返回参数
 @param failure   失败返回错误码
 */
+ (void)CashWithdrawalWithPage:(int)page pageCount:(int)pagecount type:(int)type success:(CashWithdrawalSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"account": @"get_jinbi_transaction",
                          @"p": [NSString stringWithFormat:@"%d",page],
                          @"count": [NSString stringWithFormat:@"%d",pagecount],
                          @"type": [NSString stringWithFormat:@"%d",type],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
                    RecordModel *model = [[RecordModel alloc] init];
                    
                    // 申请时间
                    NSString *created_timeStr = [tempDict objectForKey:@"created_at"];
                    if (created_timeStr && ![created_timeStr isKindOfClass:[NSNull class]]) {
                        NSString *created_timestr = [NSString stringWithFormat:@"%@",created_timeStr];
                        NSArray *array = [created_timestr componentsSeparatedByString:@" "];
                        model.create_time = [array firstObject];
                        model.timeStr = [array lastObject];
                    }
                    // 金币
                    NSString *amountStr = [tempDict objectForKey:@"amount"];
                    if (amountStr && ![amountStr isKindOfClass:[NSNull class]]) {
                        NSString *amountstr = [NSString stringWithFormat:@"%@",amountStr];
                        model.change = amountstr;
                    }
                    // 状态
                    NSString *commentStr = [tempDict objectForKey:@"comment"];
                    if (commentStr && ![commentStr isKindOfClass:[NSNull class]]) {
                        NSString *commentstr = [NSString stringWithFormat:@"%@",commentStr];
                        model.Description = commentstr;
                    }
                    // type
                    NSString *typeStr = [tempDict objectForKey:@"type"];
                    if (typeStr && ![typeStr isKindOfClass:[NSNull class]]) {
                        NSString *typestr = [NSString stringWithFormat:@"%@",typeStr];
                        model.type = typestr;
                    }
                    [dataAry addObject:model];
                }
            }
            
            NSString *msg = [dict objectForKey:@"msg"];
            NSLog(@"msg----------- %@",msg);
            sucess(dataAry,msg,code);
        }
        NSLog(@"金币提取明细成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"金币提取明细失败");
    }];
}

@end
