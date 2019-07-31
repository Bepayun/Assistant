//
//  UserInfoStructre.m
//  assistant
//
//  Created by Bepa on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "UserInfoStructre.h"

@implementation UserInfoStructre
@synthesize UserID;
@synthesize client_token;
@synthesize Account;
@synthesize loginip;
@synthesize passWord;
@synthesize nickName;
@synthesize roomID;
@synthesize Im_token;
@synthesize room_dou;
@synthesize userCity;
@synthesize userlatitude;
@synthesize userlongitude;
@synthesize orderType;
@synthesize nowVersion;
@synthesize jinbi_balance;

- (id)init {
    self = [super init];
    if (self) {
       self.UserID = @"";
       self.client_token = @"";
       self.Account = @"";
       self.loginip = @"";
       self.passWord = @"";
       self.nickName = @"";
       self.roomID = @"";
       self.Im_token = @"";
       self.room_dou = @"";
       self.userCity = @"";
       self.userlatitude = 0.0;
       self.userlongitude = 0.0;
       self.sellerID = @"";
       self.orderType = 0;
       self.nowVersion = @"";
        
       self.jinbi_balance = @"";
    }
    return self;
}

@end
