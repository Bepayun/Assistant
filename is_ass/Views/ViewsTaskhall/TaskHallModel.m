                                                                                                 //
//  TaskHallModel.m
//  assistant
//
//  Created by Bepa on 2017/9/5.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaskHallModel.h"

@implementation TaskHallModel

/**
 请求任务大厅列表 GET

 @param roomId        房间ID，room_external_id
 @param platfrom      热门，网络，网页，其他，空字符表示所有
 @param devicetype    pc，电脑任务，phone，手机任务
 @param buytypeString 精品，高级，普通
 @param levelstring   小号等级
 @param type          类型
 @param page          当前第几页
 @param count         每页显示条数
 @param success       成功返回值
 */
+ (void)GetTaskHallListWithueroomid:(NSString *)roomId PlatformType:(NSString *)platfrom Device_type:(NSString *)devicetype buy_type:(NSString *)buytypeString level:(NSString *)levelstring withType:(int)type Page:(int)page pagecount:(int)count sucessful:(TaskHallDataBlock)success {
    
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (type == 1) {
        if (buytypeString.length > 0) {
          dic = @{
                  @"task": @"get_shared_tasks",
                  @"device_type": [NSString stringWithFormat:@"%@",devicetype],
                  @"UERoomID": [NSString stringWithFormat:@"%@",roomId],
                  @"platform": [NSString stringWithFormat:@"%@",platfrom],
                  @"p": [NSString stringWithFormat:@"%d",page],
                  @"count": [NSString stringWithFormat:@"%d",count],
                  @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token,
                  @"buy_type": [NSString stringWithFormat:@"%@",buytypeString],
                  @"levels": [NSString stringWithFormat:@"%@",levelstring]
                  };
       
        } else if (platfrom == nil ) {
          dic = @{
                  @"task": @"get_shared_tasks",
                  @"device_type": [NSString stringWithFormat:@"%@",devicetype],
                  @"UERoomID": [NSString stringWithFormat:@"%@",roomId],
                  @"platform": [NSString stringWithFormat:@"%@",platfrom],
                  @"p": [NSString stringWithFormat:@"%d",page],
                  @"count": [NSString stringWithFormat:@"%d",count],
                  @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token};
       
        } else {
          dic = @{
                  @"task": @"get_shared_tasks",
                  @"device_type": [NSString stringWithFormat:@"%@",devicetype],
                  @"UERoomID": [NSString stringWithFormat:@"%@",roomId],
                  @"platform": [NSString stringWithFormat:@"%@",platfrom],
                  @"p": [NSString stringWithFormat:@"%d",page],
                  @"count": [NSString stringWithFormat:@"%d",count],
                  @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token,
                  @"levels": [NSString stringWithFormat:@"%@",levelstring]};
        }
    } else {
         dic = @{
                 @"task": @"get_shared_tasks",
                 @"device_type": [NSString stringWithFormat:@"%@",devicetype],
                 @"UERoomID": [NSString stringWithFormat:@"%@",roomId],
                 @"platform": [NSString stringWithFormat:@"%@",platfrom],
                 @"p": [NSString stringWithFormat:@"%d",page],
                 @"count": [NSString stringWithFormat:@"%d",count],
                 @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token};
    }
    AFHTTPSessionManager *manster = [AFHTTPSessionManager manager];
    [manster GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int errorInt = -1;
        NSMutableArray *abbarray = [[NSMutableArray alloc] initWithCapacity:0];
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)responseObject;
           
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
            
            if ([dict objectForKey:@"items"] && ![[dict objectForKey:@"items"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"items"]];
                
                for (int i = 0; i<array1.count; i++) {
                    NSDictionary *tempDict = [array1 objectAtIndex:i];
                    //
                    TaskHallModel *recommendData = [[TaskHallModel alloc] init];
                    NSString *name_string = [tempDict objectForKey:@"remark"];
                    if (name_string && ![name_string isKindOfClass:[NSNull class]]) {
                        NSString *string1 = [NSString stringWithFormat:@"%@",name_string];
                        recommendData.commission_concent = string1;
                    }
                    NSString *picid_string = [tempDict objectForKey:@"create_time"];
                    if (picid_string && ![picid_string isKindOfClass:[NSNull class]]) {
                        NSString *string2 = [NSString stringWithFormat:@"%@",picid_string];
                        NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        recommendData.creatTime = string3;
                    }
                    NSString *commission_summary_string = [tempDict objectForKey:@"commission_summary"];
                    if (commission_summary_string  && ![commission_summary_string  isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",commission_summary_string];
                        recommendData.remarkString = string4;
                    }
                    NSString *platform_string = [tempDict objectForKey:@"platform"];
                    if (platform_string && ![platform_string isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",platform_string];
                        recommendData.plateform_type = string4;
                    }
                    NSString *taskid_string = [tempDict objectForKey:@"id"];
                    if (taskid_string && ![taskid_string isKindOfClass:[NSNull class]]) {
                        recommendData.task_id = [taskid_string intValue];
                    }

                    NSString *online_string = [tempDict objectForKey:@"seller_online"];
                    if (online_string && ![online_string isKindOfClass:[NSNull class]]) {
                        recommendData.seller_online = online_string;
                    }
                    NSString *price_string = [tempDict objectForKey:@"product_price"];
                    if (price_string && ![price_string isKindOfClass:[NSNull class]]) {
                        recommendData.product_price = price_string;
                    }
                    NSString *buy_type_string = [tempDict objectForKey:@"buy_type"];
                    if (buy_type_string && ![buy_type_string isKindOfClass:[NSNull class]]) {
                        recommendData.buy_typeStr = buy_type_string;
                    }
                    //网页 condition_summary 与 pay_method
                    NSString *pay_methodStr = [tempDict objectForKey:@"pay_method"];
                    if (pay_methodStr && ![pay_methodStr isKindOfClass:[NSNull class]]) {
                        recommendData.pay_method = pay_methodStr;
                    }
                    NSString *condition_summaryStr = [tempDict objectForKey:@"condition_summary"];
                    if (condition_summaryStr && ![condition_summaryStr isKindOfClass:[NSNull class]]) {
                        recommendData.condition_summary = condition_summaryStr;
                    }
                    [abbarray addObject:recommendData];
                    // [recommendData release];
                }
            }
              NSString *msg = [dict objectForKey:@"msg"];
              success(abbarray,msg,errorInt);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
/**
 获取其他游戏任务 GET
 
 @param page       当前页码
 @param count      每页条数
 @param paixu      update_time 为最新 , seller_online为在线
 @param devicetype phone 为手机任务， pc为电脑任务
 @param success    成功返回值
 */
+ (void)GetTaskHall_RegistrationListWithuePage:(int)page Pagecount:(int)count Paixu:(NSString *)paixu Device_t:(NSString *)devicetype sucessful:(TaskHall_RegistrationDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"task": @"get_reg_tasks",
                          @"p": [NSString stringWithFormat:@"%d",page],
                          @"count": [NSString stringWithFormat:@"%d",count],
                          @"paixu": [NSString stringWithFormat:@"%@",paixu],
                          @"device_t": [NSString stringWithFormat:@"%@",devicetype],
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
                    TaskHallModel *model = [[TaskHallModel alloc] init];
                    NSString *name_string = [tempDict objectForKey:@"remark"];
                    if (name_string && ![name_string isKindOfClass:[NSNull class]]) {
                        NSString *string1 = [NSString stringWithFormat:@"%@",name_string];
                        model.commission_concent = string1;
                    }
                    NSString *picid_string = [tempDict objectForKey:@"create_time"];
                    if (picid_string && ![picid_string isKindOfClass:[NSNull class]]) {
                        NSString *string2 = [NSString stringWithFormat:@"%@",picid_string];
                        NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        model.creatTime = string3;
                    }
                    NSString *commission_summary_string = [tempDict objectForKey:@"commission_summary"];
                    if (commission_summary_string  && ![commission_summary_string  isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",commission_summary_string];
                        model.remarkString = string4;
                    }
                    NSString *platform_string = [tempDict objectForKey:@"platform"];
                    if (platform_string && ![platform_string isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",platform_string];
                        model.plateform_type = string4;
                    }
                    NSString *taskid_string = [tempDict objectForKey:@"id"];
                    if (taskid_string && ![taskid_string isKindOfClass:[NSNull class]]) {
                        model.task_id = [taskid_string intValue];
                    }
                    
                    NSString *online_string = [tempDict objectForKey:@"seller_online"];
                    if (online_string && ![online_string isKindOfClass:[NSNull class]]) {
                        model.seller_online = online_string;
                    }
                    NSString *buy_type_string = [tempDict objectForKey:@"buy_type"];
                    if (buy_type_string && ![buy_type_string isKindOfClass:[NSNull class]]) {
                        model.buy_typeStr = buy_type_string;
                    }
                    NSString *pay_methodStr = [tempDict objectForKey:@"pay_method"];
                    if (pay_methodStr && ![pay_methodStr isKindOfClass:[NSNull class]]) {
                        model.pay_method = pay_methodStr;
                    }
                    NSString *price_string = [tempDict objectForKey:@"product_price"];
                    if (price_string && ![price_string isKindOfClass:[NSNull class]]) {
                        model.product_price = price_string;
                    }
                    [dataAry addObject:model];
                }
            }
            NSString *msg = [dict objectForKey:@"msg"];
            success(dataAry, msg, code);
        }
        
        
        NSLog(@"获取其他游戏任务成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取其他游戏任务失败");
    }];
}
/**
 获取小号列表 GET
 
 @param userID   用户ID
 @param platform 类型
 @param success  成功返回值
 */
+ (void)GetAccountWithTaobao:(NSString *)userID withplatform:(int)platform successful:(TaobaoAccountDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{
            @"task": @"get_tbaccounts",
            @"UserID": [NSString stringWithFormat:@"%@",userID],
            @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
            };
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
  
    [manger GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int errorInt = -1;
        NSMutableArray *abbarray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)responseObject;
           
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
            
            if ([dict objectForKey:@"items"] && ![[dict objectForKey:@"items"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"items"]];
                
                for (int i = 0; i<array1.count; i++) {
                    NSDictionary *tempDict = [array1 objectAtIndex:i];
                    //
                    TaskHallModel *recommendData = [[TaskHallModel alloc] init];
                    NSString *name_string = [tempDict objectForKey:@"name"];
                    if (name_string && ![name_string isKindOfClass:[NSNull class]]) {
                        NSString *string1 = [NSString stringWithFormat:@"%@",name_string];
                        recommendData.taobao_nameStr = string1;
                    }
                    NSString *rate_level_string = [tempDict objectForKey:@"rate_level_label"];
                    if (rate_level_string && ![rate_level_string isKindOfClass:[NSNull class]]) {
                        recommendData.taobao_levelname = rate_level_string;
                    }
                    NSString *level_string = [tempDict objectForKey:@"rate_level"];
                    if (level_string  && ![level_string  isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",level_string];
                        recommendData.taobao_level = string4;
                    }
                    NSString *platform_string = [tempDict objectForKey:@"platform"];
                    if (platform_string && ![platform_string isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",platform_string];
                        recommendData.plateform_type = string4;
                    }
                    NSString *id_string = [tempDict objectForKey:@"id"];
                    if (id_string && ![id_string isKindOfClass:[NSNull class]]) {
                        NSString *string4 = [NSString stringWithFormat:@"%@",id_string];
                        recommendData.taobao_id = string4;
                    }
                   
                    if (platform == kTaskHallPlatformTypeTaoBao && [recommendData.plateform_type isEqualToString:@"taobao"]) {
                        [abbarray addObject:recommendData];
                    
                    } else if (platform == kTaskHallPlatformTypeJD && [recommendData.plateform_type isEqualToString:@"jd"]) {
                        [abbarray addObject:recommendData];
                   
                    } else if (platform == 0) {
                        [abbarray addObject:recommendData];
                    }
               }
            }

        }
        success(abbarray,nil,errorInt);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
/**
 刷手请求接取任务 GET
 
 @param task_id    任务ID
 @param namestring 淘宝小号名
 @param roomid     房间号
 @param UID        用户ID
 @param success    成功返回值
 */
+ (void)GetTaskwithtask_id:(int)task_id account_name:(NSString *)namestring UERoomID:(NSString *)roomid  userID:(NSString *)UID  successful:(OrderTaskDataBlock)success {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{
            @"task": @"grab_task",
            @"UserID": [NSString stringWithFormat:@"%@",UID],
            @"task_id": [NSString stringWithFormat:@"%d",task_id],
            @"tbaccount_name": [NSString stringWithFormat:@"%@",namestring],
            @"UERoomID": [NSString stringWithFormat:@"%@",roomid],
            @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
            };
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
   
    [manger GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int errorInt = -1;
        //NSMutableArray *abbarray = [[NSMutableArray alloc] initWithCapacity:0];
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
            if ([dict objectForKey:@"seller_id"] && ![[dict objectForKey:@"seller_id"] isKindOfClass:[NSNull class]]) {
                [AppDelegate appDelegate].userInfostruct.sellerID = [dict objectForKey:@"seller_id"];
            }
            NSString *task_id = [dict objectForKey:@"task_id"];
            NSString *msg = [dict objectForKey:@"msg"];
            success(msg,errorInt,[AppDelegate appDelegate].userInfostruct.sellerID,task_id);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
/**
 刷手小号验证 GET
 
 @param taskid    任务ID
 @param taobao_id 热门小号ID
 @param userID    接任务者ID
 @param sucess    成功返回值
 */
+ (void)GetTaskAccountVerifywithtask_id:(NSString *)taskid taobaoID:(NSString *)taobao_id withbuyer_id:(NSString *)userID sucessful:(VerifyAccountDataBlock)sucess {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{
            @"task": @"get_tbaccount_info",
            @"buyer_id": [NSString stringWithFormat:@"%@",userID],
            @"task_id": [NSString stringWithFormat:@"%@",taskid],
            @"id": [NSString stringWithFormat:@"%@",taobao_id],
            @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
            };
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger.securityPolicy setAllowInvalidCertificates:YES];
   
    [manger GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int errorInt = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            NSString *jsonString2 = @"";
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]){
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
           
            if ([dict objectForKey:@"tbaccount"] && ![[dict objectForKey:@"tbaccount"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"tbaccount"] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *taobaoDic = [dict objectForKey:@"tbaccount"];
              
                if ([taobaoDic objectForKey:@"cookies"] && ![[taobaoDic objectForKey:@"cookies"] isKindOfClass:[NSNull class]]) {
                    NSString *cookierstring = [taobaoDic objectForKey:@"cookies"];
                    cookierstring = [cookierstring stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                    NSString *jsonString1 = [cookierstring substringToIndex:[cookierstring length] - 1];
                    jsonString2 = [jsonString1 substringFromIndex:1];
                   
                    id cookier = [[AppDelegate appDelegate].commonmthod dictionaryWithJsonString:jsonString2];
                    if ([cookier isKindOfClass:[NSArray class]]){
                        [array addObjectsFromArray:cookier];
                    }
                }
            }
            NSString *msg = [dict objectForKey:@"msg"];
            sucess(array,jsonString2,msg,errorInt);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           sucess(nil,nil,nil,110);
    }];
}
@end
