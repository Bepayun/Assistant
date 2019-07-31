//
//  UserInfoModel.m
//  assistant
//
//  Created by Bepa on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel


#pragma mark 登录 --- {
/**
 *   登录 POST
 @param account 账号
 @param password 密码
 */
+ (void)LoginGet_tokenWithAccount:(NSString* )account  PassWord:(NSString* )password success:(LoginsuccessBlock)success{
    NSString* ipStr = @"";
    if ([AppDelegate appDelegate].userInfostruct.loginip != nil && [AppDelegate appDelegate].userInfostruct.loginip.length > 0) {
        ipStr = [AppDelegate appDelegate].userInfostruct.loginip;
    }
    
    NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary* dic = @{@"account":@"get_token",@"device_id":deviceID,@"useraccount":[NSString stringWithFormat:@"%@",account],@"password":[NSString stringWithFormat:@"%@",password],@"ip":[NSString stringWithFormat:@"%@",ipStr]};
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject){
        int errorInt = -1;
        NSString* token = @"";
        NSString* userid = @"";
        NSString* cityName = @"";
        NSString* jinbi_balance = @"";
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dict = (NSDictionary* )responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
            if (errorInt == 0) {
               if ([dict objectForKey:@"client_token"] && ![[dict objectForKey:@"client_token"] isKindOfClass:[NSNull class]]) {
                  token  = [dict objectForKey:@"client_token"];
               }
               if ([dict objectForKey:@"userid"] && ![[dict objectForKey:@"userid"] isKindOfClass:[NSNull class]]) {
                  userid = [dict objectForKey:@"userid"];
               }
               if ([dict objectForKey:@"location"] && ![[dict objectForKey:@"location"] isKindOfClass:[NSNull class]]) {
                   cityName = [dict objectForKey:@"location"];
               }
                if ([dict objectForKey:@"jinbi_balance"] && ![[dict objectForKey:@"jinbi_balance"] isKindOfClass:[NSNull class]]) {
                    jinbi_balance = [dict objectForKey:@"jinbi_balance"];
                }
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                // 登陆成功后把用户名存储到UserDefault
                [userDefaults setObject:account forKey:kUserDefaultKeyaccount];
                [userDefaults setObject:password forKey:kUserDefaultKeyPassWord];
                [userDefaults synchronize]; // 这里建议同步存
            }
            NSString* msg = [dict objectForKey:@"msg"];
            success(responseObject,msg,errorInt);
            [AppDelegate appDelegate].userInfostruct.UserID = userid;
            [AppDelegate appDelegate].userInfostruct.client_token = token;
            [AppDelegate appDelegate].userInfostruct.userCity = cityName;
            [AppDelegate appDelegate].userInfostruct.jinbi_balance = jinbi_balance;
            NSLog(@"dictdictdictdictdictdict-------- %@",dict);
        }
        
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
            success(nil,@"登录失败",500);
    }];
}
#pragma mark --- }
#pragma mark 注册 --- {
/**
*   注册账号 POST
 @param newaccount 账户名
 @param password 密码
 @param device_Id 设备ID
 @param ipstr ip地址
 @param recommender 注册推荐人助手账号
 */
+ (void)RegisterAccountWithNewaccount:(NSString* )newaccount password:(NSString* )password device_id:(NSString* )device_Id ipdress:(NSString* )ipstr reg_recommender:(NSString* )recommender success:(RegiestsuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure{
    NSString* ipStr = @"";
    if ([AppDelegate appDelegate].userInfostruct.loginip != nil && [AppDelegate appDelegate].userInfostruct.loginip.length > 0) {
        ipStr = [AppDelegate appDelegate].userInfostruct.loginip;
    }
    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL]; // KASSURL
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary* dic = @{@"account":@"register",@"useraccount":[NSString stringWithFormat:@"%@",newaccount],@"password":[NSString stringWithFormat:@"%@",password],@"device_id":[NSString stringWithFormat:@"%@",device_Id],@"ip":[NSString stringWithFormat:@"%@",ipStr],@"reg_recommender":[NSString stringWithFormat:@"%@",recommender]};
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject){
        int errorInt = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dict = (NSDictionary* )responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
            if ([dict objectForKey:@"client_token"] && ![[dict objectForKey:@"client_token"] isKindOfClass:[NSNull class]]) {
               [AppDelegate appDelegate].userInfostruct.client_token = [dict objectForKey:@"client_token"];
            }
            if ([dict objectForKey:@"userid"] && ![[dict objectForKey:@"userid"] isKindOfClass:[NSNull class]]) {
               [AppDelegate appDelegate].userInfostruct.UserID = [dict objectForKey:@"userid"];
            }
            if (errorInt == 0) {
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                // 登陆成功后把用户名存储到UserDefault
                [userDefaults setObject:newaccount forKey:kUserDefaultKeyaccount];
                [userDefaults setObject:password forKey:kUserDefaultKeyPassWord];
                [userDefaults synchronize]; // 这里建议同步存
                [AppDelegate appDelegate].loginViewController.Account_Numbertextfield.text = newaccount;
                [AppDelegate appDelegate].loginViewController.PassCodetextField.text = password;
                // [[AppDelegate appDelegate].loginViewController loginStart];
            }
            NSString* msg = [dict objectForKey:@"msg"];
            sucess(responseObject,msg,errorInt);
        }
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
        failure(error);
    }];
    
}
#pragma mark --- }
#pragma mark 进入房间 --- {
/**
*  进入房间 POST
 @param room_id 房间ID
 @param userid 用户ID
 @param cardname 用户在房间的名片
 */
+ (void)EnterRoomWithroom_external_id:(NSString* )room_id userId:(NSString* )userid room_card_name:(NSString* )cardname token:(NSString* )client_token success:(RegiestsuccessBlock)sucess getDataFailure:(GetDataFailureBlock)failure{
    
    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL]; // KASSURL
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary* dic = @{@"room":@"enter",@"room_external_id":[NSString stringWithFormat:@"IS%@",room_id],@"UserID":[NSString stringWithFormat:@"%@",userid],@"room_card_name":[NSString stringWithFormat:@"%@",room_id],@"HTTP_CLIENT_TOKEN":[NSString stringWithFormat:@"%@",client_token]};
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject){
        
        int errorInt = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dict = (NSDictionary* )responseObject;
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                errorInt = [[dict objectForKey:@"code"] intValue];
            }
            if ([[dict objectForKey:@"im"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary* ImDict = [dict objectForKey:@"im"];
                [AppDelegate appDelegate].userInfostruct.Im_token = [ImDict objectForKey:@"token"];
            }

            [AppDelegate appDelegate].userInfostruct.roomID = room_id;
            
            if ([[dict objectForKey:@"room"] isKindOfClass:[NSDictionary class]]) {
               NSDictionary* ImDict = [dict objectForKey:@"room"];
               [AppDelegate appDelegate].userInfostruct.external_id = [ImDict objectForKey:@"external_id"];
            }
            if ([dict objectForKey:@"member"] && ![[dict objectForKey:@"member"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"member"] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary* memberDic = [dict objectForKey:@"member"];
                [AppDelegate appDelegate].userInfostruct.roomID = [memberDic objectForKey:@"card_name"];
                [AppDelegate appDelegate].userInfostruct.room_dou = [memberDic objectForKey:@"room_dou"];
                
            }

            if (errorInt == 0) {
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                // 登陆成功后把用户名存储到UserDefault
                [userDefaults setObject:room_id forKey:kUserDefaultKeyRoomID];
                [userDefaults synchronize]; // 这里建议同步存
                NSString* msg = [dict objectForKey:@"msg"];
                sucess(responseObject,msg,errorInt);
            } else {
                NSLog(@"登录失败");
            }
        }
        
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
        failure(error);
    }];
}
#pragma mark --- }
@end
