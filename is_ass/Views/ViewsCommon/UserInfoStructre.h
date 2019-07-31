//
//  UserInfoStructre.h
//  assistant
//
//  Created by Bepa on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoStructre : NSObject{
    
    NSString* UserID;
    NSString* client_token;
}
/// 用户ID
@property (nonatomic, strong) NSString* UserID;
/// 获取到的client_token
@property (nonatomic, strong) NSString* client_token;
/// 账户
@property (nonatomic, strong) NSString* Account;
/// ip
@property (nonatomic, strong) NSString* loginip;
/// 密码
@property (nonatomic, strong) NSString* passWord;
/// 昵称
@property (nonatomic, strong) NSString* nickName;
/// 房间号
@property (nonatomic, strong) NSString* roomID;
/// 保证金
@property (nonatomic, strong) NSString* jinbi_balance;
/// 加任务的房间号
@property(nonatomic, strong) NSString* external_id;

/// IM_token
@property (nonatomic, strong) NSString* Im_token;
/// 助手豆数量
@property (nonatomic, strong) NSString* room_dou;
/// 用户城市
@property (nonatomic, strong) NSString* userCity;
/// 经度
@property (nonatomic, assign) double userlongitude;
/// 纬度
@property (nonatomic, assign) double userlatitude;
/// 雇主id
@property (nonatomic, strong) NSString* sellerID;

/// 接任务时添加小号的Type
@property (nonatomic, assign) int orderType;

@property (nonatomic, strong) NSString* nowVersion;

@end
