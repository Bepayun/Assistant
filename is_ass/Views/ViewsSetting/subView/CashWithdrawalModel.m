//
//  CashWithdrawalModel.m
//  assistant
//
//  Created by Bepa  on 2017/11/6.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "CashWithdrawalModel.h"

@implementation CashWithdrawalModel

/**
 金币余额 POST
 
 @param sucess  成功返回参数
 @param failure 失败返回参数
 */
+ (void)CashWithdrawalBalanceSuccess:(CashWithdrawalNumSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"account": @"get_jinbi_balance",
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        CashWithdrawalModel *model = [[CashWithdrawalModel alloc] init];
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
           
            if ([dict objectForKey:@"balance"] && ![[dict objectForKey:@"balance"] isKindOfClass:[NSNull class]]) {
                model.balance = [dict objectForKey:@"balance"];
            }
            NSString *msg = [dict objectForKey:@"msg"];
            sucess(responseObject,msg,code);
        }
        NSLog(@"金币余额 ------ 成功!!!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"金币余额 ------ 失败!!!");
        
    }];
}
/**
 金币提取 POST
 
 @param alipayaccount 支付宝账户
 @param userName      姓名
 @param goldCoinNum   提取金币数量
 @param sucess        成功返回参数
 @param failure       失败返回错误码
 */
+ (void)CashWithdrawalBtnWithAlipayAccount:(NSString *)alipayaccount userName:(NSString *)userName GoldCoinNum:(NSString *)goldCoinNum success:(CashWithdrawalBtnSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"account": @"jinbi_exchange_apply",
                          @"zfb": [NSString stringWithFormat:@"%@",alipayaccount],
                          @"username": [NSString stringWithFormat:@"%@",userName],
                          @"num": [NSString stringWithFormat:@"%@",goldCoinNum],
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            NSString *msg = [dict objectForKey:@"msg"];
            sucess(responseObject,msg,code);
        }
        NSLog(@"金币提取 ------ 成功!!!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"金币提取 ------ 失败!!!");
        
    }];
}

/**
 金币提取列表
 
 @param page      当前页数
 @param pagecount 每页条数
 @param all       0:取个人的全部提现记录 1:为超级管理人员取得所有人提现记录
 @param ststus    此字段只有在all=1 才会生效 默认状态是pending-----已发放:'finish' 申请中='pending'
 @param sucess    成功返回参数
 @param failure   失败返回错误码
 */
+ (void)CashWithdrawalListWithPage:(int)page pageCount:(int)pagecount all:(NSString *)all status:(NSString *)ststus success:(CashWithdrawalListSuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"account": @"jinbi_exchange_list",
                          @"p": [NSString stringWithFormat:@"%d",page],
                          @"count": [NSString stringWithFormat:@"%d",pagecount],
                          @"all": [NSString stringWithFormat:@"%@",all],
                          @"status": [NSString stringWithFormat:@"%@",ststus],
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
                    CashWithdrawalModel *model = [[CashWithdrawalModel alloc] init];
                    
                    // 支付宝
                    NSString *accountStr = [tempDict objectForKey:@"account"];
                    if (accountStr && ![accountStr isKindOfClass:[NSNull class]]) {
                        NSString *accountstr = [NSString stringWithFormat:@"%@",accountStr];
                        model.account = accountstr;
                    }
                    // 姓名
                    NSString *account_nameStr = [tempDict objectForKey:@"account_name"];
                    if (account_nameStr && ![account_nameStr isKindOfClass:[NSNull class]]) {
                        NSString *account_namestr = [NSString stringWithFormat:@"%@",account_nameStr];
                        model.account_name = account_namestr;
                    }
                    // 申请时间
                    NSString *created_timeStr = [tempDict objectForKey:@"created_at"];
                    if (created_timeStr && ![created_timeStr isKindOfClass:[NSNull class]]) {
                        NSString *created_timestr = [NSString stringWithFormat:@"%@",created_timeStr];
                        model.created_time = created_timestr;
                    }
                    // 提现数量
                    NSString *amountStr = [tempDict objectForKey:@"amount"];
                    if (amountStr && ![amountStr isKindOfClass:[NSNull class]]) {
                        NSString *amountstr = [NSString stringWithFormat:@"%@",amountStr];
                        model.amount = amountstr;
                    }
                    // 状态
                    NSString *statusStr = [tempDict objectForKey:@"status"];
                    if (statusStr && ![statusStr isKindOfClass:[NSNull class]]) {
                        NSString *statustr = [NSString stringWithFormat:@"%@",statusStr];
                        model.status = statustr;
                    }
                    // id
                    NSString *idStr = [tempDict objectForKey:@"id"];
                    if (idStr && ![idStr isKindOfClass:[NSNull class]]) {
                        NSString *idstr = [NSString stringWithFormat:@"%@",idStr];
                        model.ID = idstr;
                    }
                    // user_id
                    NSString *user_idStr = [tempDict objectForKey:@"user_id"];
                    if (user_idStr && ![user_idStr isKindOfClass:[NSNull class]]) {
                        NSString *user_idstr = [NSString stringWithFormat:@"%@",user_idStr];
                        model.user_id = user_idstr;
                    }
                    [dataAry addObject:model];
                }
            }
            
            NSString *msg = [dict objectForKey:@"msg"];
            sucess(dataAry,msg,code);
        }
        NSLog(@"金币提取列表成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"金币提取列表失败");
    }];
    
}
@end
