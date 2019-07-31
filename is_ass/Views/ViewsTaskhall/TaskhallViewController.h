//
//  TalkhallViewController.h
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RootViewController.h"

@interface TaskhallViewController : RootViewController

@property (nonatomic, strong) NSString* conditionPlatform;
@property (nonatomic, strong) NSString* level;
@property (nonatomic, strong) NSString* buy_type;

@property (nonatomic, strong) NSMutableArray* tasklistArray;
@property (nonatomic, assign) BOOL isCondition;
@property (nonatomic, assign) int accountType;
@property (nonatomic, assign) int taskid_taskhall;
@property (nonatomic, strong) NSMutableArray* OrderArray;


@end
