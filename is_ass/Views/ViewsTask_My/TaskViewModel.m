//
//  TaskViewModel.m
//  is_ass
//
//  Created by Bepa  on 2017/9/18.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaskViewModel.h"
#import "RCDUtilities.h"

@implementation TaskViewModel

/**
 我的任务 GET
 
 @param userId  用户ID
 @param page    页数
 @param count   每页显示记录条数
 @param success 返回值
 */
+ (void)GetTaskViewWithUserId:(NSString *)userId  page:(int)page pagecount:(int)count sucessful:(TaskViewDataBlock)success {
    
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                           @"task": @"get_buyer_orders",
                           @"UserID": [NSString stringWithFormat:@"%@",userId],
                           @"p": [NSString stringWithFormat:@"%d",page],
                           @"count": [NSString stringWithFormat:@"%d",count],
                           @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token,
                           };
    
    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        NSMutableArray *dataAry =[NSMutableArray arrayWithCapacity:0];
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }

            if ([dict objectForKey:@"items"] && ![[dict objectForKey:@"items"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"items"]];
                for (int i = 0; i < array.count; i ++) {
                    NSDictionary *tempDict = [array objectAtIndex:i];
                    
                    TaskViewModel *model = [[TaskViewModel alloc] init];
                    // 融云userInfo
                    RCUserInfo *user = [RCUserInfo new];
                    
                    NSString *idstr = [tempDict objectForKey:@"id"];
                    if (idstr && ![idstr isKindOfClass:[NSNull class]]) {
                        NSString *idStr = [NSString stringWithFormat:@"%@",idstr];
                        model.Id = idStr;
                    }
                    
                    NSString *create_timestr = [tempDict objectForKey:@"create_time"];
                    if (create_timestr && ![create_timestr isKindOfClass:[NSNull class]]) {
                        NSString *create_timeStr = [NSString stringWithFormat:@"%@",create_timestr];
                        model.create_time = create_timeStr;
                        
                        NSArray *array = [create_timeStr componentsSeparatedByString:@" "];
                        model.create_timeD = [array firstObject];
                        model.timeStr = [array lastObject];
                        
                    }
                    
                    NSString *platformstr = [tempDict objectForKey:@"platform"];
                    if (platformstr && ![platformstr isKindOfClass:[NSNull class]]) {
                        NSString *platform = [NSString stringWithFormat:@"%@",platformstr];
                        model.platform = platform;
                    }

                    NSString *remarkstr = [tempDict objectForKey:@"remark"];
                    if (remarkstr && ![remarkstr isKindOfClass:[NSNull class]]) {
                        NSString *remark = [NSString stringWithFormat:@"%@",remarkstr];
                        model.remark = remark;
                    }
                    
                    NSString *summarystr = [tempDict objectForKey:@"commission_summary"];
                    if (summarystr && ![summarystr isKindOfClass:[NSNull class]]) {
                        NSString *summary = [NSString stringWithFormat:@"%@",summarystr];
                        model.commission_summary = summary;
                    }
                    NSString *summaryStr = [tempDict objectForKey:@"condition_summary"];
                    if (summaryStr && ![summaryStr isKindOfClass:[NSNull class]]) {
                        NSString *summary = [NSString stringWithFormat:@"%@",summaryStr];
                        model.commission_summaryone = summary;
                    }
                    
                    NSString *statestr = [tempDict objectForKey:@"state"];
                    if (statestr && ![statestr isKindOfClass:[NSNull class]]) {
                        NSString *state = [NSString stringWithFormat:@"%@",statestr];
                        model.state = state;
                    }
                    
                    //
                    NSString *buy_typestr = [tempDict objectForKey:@"buy_type"];
                    if (buy_typestr && ![buy_typestr isKindOfClass:[NSNull class]]) {
                        NSString *buy_type = [NSString stringWithFormat:@"%@",buy_typestr];
                        model.buy_type = buy_type;                       
                    }

                    NSString *condition_summarystr = [tempDict objectForKey:@"condition_summary"];
                    if (condition_summarystr && ![condition_summarystr isKindOfClass:[NSNull class]]) {
                        NSString *condition_summary = [NSString stringWithFormat:@"%@",condition_summarystr];
                        model.condition_summary = condition_summary;
                    }
                    
                    NSString *tbaccount_namestr = [tempDict objectForKey:@"tbaccount_name"];
                    if (tbaccount_namestr && ![tbaccount_namestr isKindOfClass:[NSNull class]]) {
                        NSString *tbaccount_name = [NSString stringWithFormat:@"%@",tbaccount_namestr];
                        model.tbaccount_name = tbaccount_name;
                    }
                    
                    NSString *buidStr = [tempDict objectForKey:@"buid"];
                    if (buidStr && ![buidStr isKindOfClass:[NSNull class]]) {
                        NSString *buidstr = [NSString stringWithFormat:@"%@",buidStr];
                        model.buid = buidstr;
                    }
                    
                    NSString *timestr = [tempDict objectForKey:@"update_time"];
                    if (timestr && ![timestr isKindOfClass:[NSNull class]]) {
                        NSString *update_timeStr = [NSString stringWithFormat:@"%@",timestr];
                        NSArray *array = [update_timeStr componentsSeparatedByString:@" "];
                        model.update_time = [array firstObject];
                        model.timeStrb = [array lastObject];

                    }

                    NSString *sellerStr = [tempDict objectForKey:@"seller_room_card_name"];
                    if (sellerStr && ![sellerStr isKindOfClass:[NSNull class]]) {
                        NSString *seller_room_card_name = [NSString stringWithFormat:@"%@",sellerStr];
                        model.seller_room_card_name = seller_room_card_name;
                        user.name = [tempDict objectForKey:@"seller_room_card_name"];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:sellerStr forKey:kRongCloudUserName];
                        [userDefaults synchronize];

                    }
                    
                    NSString *seller_idStr = [tempDict objectForKey:@"seller_id"];
                    if (seller_idStr && ![seller_idStr isKindOfClass:[NSNull class]]) {
                        NSString *seller_id = [NSString stringWithFormat:@"%@",seller_idStr];
                        model.seller_id = seller_id;
                        user.userId = [tempDict objectForKey:@"seller_id"];
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:seller_idStr forKey:kRongCloudUserId];
                        [userDefaults synchronize];
                    }
                    
                    NSString *order_idStr = [tempDict objectForKey:@"order_id"];
                    if (order_idStr && ![order_idStr isKindOfClass:[NSNull class]]) {
                        NSString *order_id = [NSString stringWithFormat:@"%@",order_idStr];
                        model.order_id = order_id;
                    }


                    [dataAry addObject:model];
                }
            }
            NSString *msg = [dict objectForKey:@"msg"];
            success(dataAry,msg,code);
        }
        
        NSLog(@"获取 我的任务 成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取 我的任务 失败");
        
    }];
}

/**
 取消任务  GET
 
 @param userId  用户ID
 @param orderId 雇主ID
 @param success 成功返回值
 */
+ (void)CancelTheOrderViewWithUserId:(NSString *)userId  orderId:(NSString *)orderId sucessful:(CancelTheOrderDataBlock)success{
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"task": @"set_order_state",
                          @"state": @"buyer_request_cancel",
                          @"platform": @"",//taobao,jd
                          @"device_type": @"ios",
                          @"UserID": [NSString stringWithFormat:@"%@",userId],
                          @"order_id": [NSString stringWithFormat:@"%@",orderId],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            NSString *msg = [dict objectForKey:@"msg"];
            success(msg,code);
        }
        NSLog(@"取消任务成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"取消任务失败");
    }];
}

/**
 申请仲裁 POST
 
 @param userId       用户ID
 @param orderId      雇主ID
 @param chatData     聊天数据，现在实际情况，可以传空值
 @param createReason 申请理由
 @param sucess       成功返回值
 @param failure      失败返回
 */
+ (void)ArbitrateWithUserId:(NSString *)userId orderId:(NSString *)orderId chatData:(NSString *)chatData createReason:(NSString *)createReason success:(ArbitrateSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"task": @"arbitrate",
                          @"UserID": [NSString stringWithFormat:@"%@",userId],
                          @"order_id": [NSString stringWithFormat:@"%@",orderId],
                          @"chat_data": [NSString stringWithFormat:@"%@",chatData],
                          @"create_reason": [NSString stringWithFormat:@"%@",createReason],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            NSString *msg = [dic objectForKey:@"msg"];
            sucess(responseObject,msg,code);
        }
        
        NSLog(@"申请仲裁成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"申请仲裁失败");
    }];
}

@end
