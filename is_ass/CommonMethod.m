//
//  CommonMethod.m
//  assistant
//
//  Created by Bepa on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "CommonMethod.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "SessionChatViewController_Rong.h"
#import "TaoBaoWebView.h"
#import "JDWebView.h"

@implementation CommonMethod
#pragma mark 获取本机IP地址
- (NSString* )getIPAddress {
    NSString* address = @"error";
    struct ifaddrs* interfaces = NULL;
    struct ifaddrs* temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in* )temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
#pragma mark - 获取本地版本号
- (NSString* )getLocalVersion {
    NSString* ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSString* str = @"1.0.2";
    return ver;
//    return str;
}
#pragma mark textField根据kNicknameTextLimitLength改变text {
- (void)textFiledEditChangedForTextField:(UITextField* )textField forIsmatching:(ChangedForTextFieldTBlock)ismatching {
    // 键盘输入模式//代替[[UITextInputMode currentInputMode] primaryLanguage]
    UITextInputMode* currentInputMode = textField.textInputMode;
    NSString* lang = currentInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange* selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition* position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            ismatching(YES,YES);
       
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
            ismatching(YES,NO);
        }
        
    } else {  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        ismatching(NO,NO);
    }
}
- (void)textFiledEditChangedForTextView:(UITextView* )textView forIsmatching:(ChangedForTextFieldTBlock)ismatching {
    //键盘输入模式//代替[[UITextInputMode currentInputMode] primaryLanguage]
    UITextInputMode* currentInputMode = textView.textInputMode;
    NSString* lang = currentInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange* selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition* position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            ismatching(YES,YES);
       
        } else {  // 有高亮选择的字符串，则暂不对文字进行统计和限制
            ismatching(YES,NO);
        }
        
    } else {  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        ismatching(NO,NO);
    }
}
#pragma mark ------ }
#pragma mark - 年月日转换成时间戳 {
- (NSString* )formattingTimeString:(NSString* )timeString {
    timeString = [timeString stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    NSString* monthStr = @"";
    if([timeString rangeOfString:@"Jan"].location != NSNotFound) {//_roaldSearchText
        monthStr = @"01";
        
    } else if ([timeString rangeOfString:@"Feb"].location != NSNotFound) {
        monthStr = @"02";
        
    } else if ([timeString rangeOfString:@"Mar"].location != NSNotFound) {
        monthStr = @"03";
        
    } else if ([timeString rangeOfString:@"Apr"].location != NSNotFound) {
        monthStr = @"04";
        
    } else if ([timeString rangeOfString:@"May"].location != NSNotFound) {
        monthStr = @"05";
        
    } else if ([timeString rangeOfString:@"Jun"].location != NSNotFound) {
        monthStr = @"06";
        
    } else if ([timeString rangeOfString:@"Jul"].location != NSNotFound) {
        monthStr = @"07";
        
    } else if ([timeString rangeOfString:@"Aug"].location != NSNotFound) {
        monthStr = @"08";
        
    } else if ([timeString rangeOfString:@"Sep"].location != NSNotFound) {
        monthStr = @"09";
        
    } else if ([timeString rangeOfString:@"Oct"].location != NSNotFound) {
        monthStr = @"10";
        
    } else if ([timeString rangeOfString:@"Nov"].location != NSNotFound) {
        monthStr = @"11";
        
    } else if ([timeString rangeOfString:@"Dec"].location != NSNotFound) {
        monthStr = @"12";
        
    } else {
        return @"error for monthStr Formatting failed";
    }
    
    NSLog(@"monthStr = %@",monthStr);
    
    NSRange GMTRange = [timeString rangeOfString:@"GMT"];
    NSRange hhmmssRange = {GMTRange.location - 9, 8};
    NSString* hhmmssStr = [timeString substringWithRange:hhmmssRange];
    NSLog(@"hhmmssStr = %@",hhmmssStr);
    
    NSRange yearRange = {GMTRange.location - 14,4};
    NSString* yearStr = [timeString substringWithRange:yearRange];
    NSLog(@"yearStr = %@",yearStr);
    
    NSRange dayRange = {GMTRange.location - 21,2};
    NSString* dayStr = [timeString substringWithRange:dayRange];
    NSLog(@"dayStr = %@",dayStr);
    
    //YY:MM:HH:MM:SS
    NSString* timeFormatStr = [NSString stringWithFormat:@"%@:%@:%@:%@",yearStr,monthStr,dayStr,hhmmssStr];
    NSLog(@"timeFormatStr = %@",timeFormatStr);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY:MM:dd:HH:mm:ss"];
    NSDate* date = [formatter dateFromString:timeFormatStr];
    NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}
#pragma mark ---- }
- (void)showHUD:(NSString* )message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD* HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        HuD.label.text = message;
        [HuD hideAnimated:YES afterDelay:0.4];
    });
}
- (void)showHUDOne:(NSString* )message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD* HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        HuD.label.text = message;
        [HuD hideAnimated:YES afterDelay:0.7];
    });
}
- (void)showAlert:(NSString* )message {
    
//    for (UIAlertView* view in [UIApplication sharedApplication].keyWindow.subviews ){
//        if (view.tag != 999) {
//            [view removeFromSuperview];
//        }
//    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
     alert.delegate = self;
     dispatch_async(dispatch_get_main_queue(), ^{
         [alert show];
     });
}
/**
*  字典转成json数据
*/
- (NSString* )convertToJsonData:(NSDictionary* )dict {
    
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString* jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    } else {
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString* mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
/**
*  json数据转成字典
*/
- (id)dictionaryWithJsonString:(NSString* )jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err2;
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments
                     error:&err2];
    if (jsonObject != nil && err2 == nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* deserializedDictionary = (NSDictionary* )jsonObject;
            NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
        }
        //如果jsonObject是数组类
        else if ([jsonObject isKindOfClass:[NSArray class]]) {
            NSArray* deserializedArray = (NSArray* )jsonObject;
            NSLog(@"Dersialized JSON Array = %@", deserializedArray);
        
        } else {
            NSLog(@"I can't deal with it");
        }
    
    } else {
        NSLog(@"解析失败");
    }
    return  jsonObject;
}
#define mark  雇主消息处理 ---- {
/*
*  雇主同意跳转聊天界面
*/
- (void)ToChatViewWithCellerwith:(RCMessage* )content {
    
    SessionChatViewController_Rong* sessionChatVC = [[SessionChatViewController_Rong alloc] init];
    sessionChatVC.conversationType = ConversationType_PRIVATE;
    sessionChatVC.targetId = content.targetId;
    sessionChatVC.title = content.targetId;
//    sessionChatVC.needPopToRootView = YES;
    sessionChatVC.modalPresentationStyle = UIModalPresentationCustom;
    sessionChatVC.hidesBottomBarWhenPushed = YES;
    UIViewController* nav = (UIViewController* )[self getCurrentViewController];
    nav.hidesBottomBarWhenPushed = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
         [nav.navigationController pushViewController:sessionChatVC animated:YES];
    });
    nav.hidesBottomBarWhenPushed = NO;
}
/*
*  根据雇主同意后的小号名在小号列表里面匹配小号ID
*/
- (void)GetTaobaoAccountID {
    
    if (![[[AppDelegate appDelegate].verifyDic objectForKey:@"tbaccount_name"] isKindOfClass:[NSNull class]]) {
        [TaskHallModel GetAccountWithTaobao:[AppDelegate appDelegate].userInfostruct.UserID withplatform:0 successful:^(NSMutableArray* array, NSString* msg, int code) {
            NSString* taobao_ID = @"";
            NSString* str = [[AppDelegate appDelegate].verifyDic objectForKey:@"tbaccount_name"];
            if (array.count > 0) {
                for (int i = 0; i<array.count; i++) {
                    TaskHallModel* model = array[i];
                    if ([model.taobao_nameStr isEqualToString:str]) {
                        if (model.taobao_id != nil) {
                            taobao_ID = model.taobao_id;
                          [self sellerVerifyTaobaoCountwithTaobaoID:taobao_ID];
                        }
                    }
                }
            }
        }];
    }
}
/*
*  请求小号验证，返回cookie
*/
- (void)sellerVerifyTaobaoCountwithTaobaoID:(NSString* )TB_ID {
    if ([[AppDelegate appDelegate].verifyDic allKeys].count > 0) {
        [TaskHallModel GetTaskAccountVerifywithtask_id:nil taobaoID:[NSString stringWithFormat:@"%@",TB_ID] withbuyer_id:[NSString stringWithFormat:@"%@",[[AppDelegate appDelegate].verifyDic objectForKey:@"seller_id"]] sucessful:^(NSArray* cookiesArray,NSString* cookierStr,NSString* msg, int code) {
            if (code == 0) {
                if (cookierStr.length > 0) {
                    [self useCookiesVerifyAccount:cookierStr withArray:cookiesArray];
                    [AppDelegate appDelegate].cookieString = cookierStr;
                }
            }
        }];
    }
}
/**
*  同步小号验证跳转web验证
*/
- (void)useCookiesVerifyAccount:(NSString* )cookierStr withArray:(NSArray* )array {
    if (cookierStr.length > 0) {
      [self pushtoWebViewVerifyAccount:[[AppDelegate appDelegate].verifyDic objectForKey:@"platform"] withcookie:(NSArray* )array];
    }
}
/**
*  验证成功后，通过消息向雇主发送获取的cookie
*/
- (void)SendVerifyMessagewithcookiers {
     self.MBhud.label.text = @"授权成功";
    [self.MBhud hideAnimated:YES afterDelay:0.2];
    RCCommandMessage* mesage = [[RCCommandMessage alloc] init];
    mesage.name = @"BuyerAcceptRemotePay";
    NSString* seller_id = [[AppDelegate appDelegate].verifyDic objectForKey:@"seller_id"];
    int   order_id = [[[AppDelegate appDelegate].verifyDic objectForKey:@"order_id"]intValue];
    NSString* cookierstring = [NSString stringWithFormat:@"%@",[AppDelegate appDelegate].cookieString];
    int   root = 0;
    NSDictionary* dic = @{@"order_id":[NSNumber numberWithInt:order_id],@"content":@"授权成功。",@"cookies":cookierstring,@"root":[NSNumber numberWithInt:root]};
    mesage.data = [[AppDelegate appDelegate].commonmthod convertToJsonData:dic];
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:seller_id
                                       content:mesage //
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                          
                                       }];
}

/**
 *  雇主消息提示
 */
- (void)showMessageFromSeller:(NSString* )message {
    
    if (![[[AppDelegate appDelegate].verifyDic objectForKey:@"platform"] isKindOfClass:[NSNull class]] && ![[[AppDelegate appDelegate].verifyDic objectForKey:@"tbaccount_name"] isKindOfClass:[NSNull class]]) {
        
        [TaskHallModel GetAccountWithTaobao:[AppDelegate appDelegate].userInfostruct.UserID withplatform:0 successful:^(NSMutableArray* array, NSString* msg, int code) {
            NSString* platform = [[AppDelegate appDelegate].verifyDic objectForKey:@"platform"];
            NSString* nickName = [[AppDelegate appDelegate].verifyDic objectForKey:@"tbaccount_name"];
            
            BOOL ishaveUser = NO;
            for (TaskHallModel* model in array) {
                if ([model.taobao_nameStr isEqualToString:nickName] && [model.plateform_type isEqualToString:platform]) {
                    ishaveUser = YES;
                    break;
                }
            }
            if (!ishaveUser) {
                NSString* content = [[NSString alloc] init];
                
                if ([platform isEqualToString:@"taobao"]) {
                    NSString* platfromStr = @"淘宝";
                    content = [NSString stringWithFormat:@"请添加%@%@小号",platfromStr,nickName];
                    [self showHUDOne:content];
                    [self pushTaoBaoViewPressed];
                    
                } else if ([platform isEqualToString:@"jd"]) {
                    NSString* platfromStr = @"京东";
                    content = [NSString stringWithFormat:@"请添加%@%@小号",platfromStr,nickName];
                    [self showHUDOne:content];
                    [self pushJDViewPressed];
                }


            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alert.delegate = self;
                alert.tag = 999;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];
                });
            }
            
        }];
    }
}
/**
 *  雇主同步小号验证跳转web验证
 */
- (void)pushtoWebViewVerifyAccount:(NSString* )platform withcookie:(NSArray* )array {
    [AppDelegate appDelegate].userInfostruct.orderType = 6;
    if ([AppDelegate appDelegate].cookieArray.count > 0) {
        [[AppDelegate appDelegate].cookieArray removeAllObjects];
    }
    if (array.count > 0) {
        [[AppDelegate appDelegate].cookieArray addObjectsFromArray:array];
    }
    if ([platform isEqualToString:@"taobao"]) {
        [self pushTaoBaoViewPressed];
    }else if ([platform isEqualToString:@"jd"]){
        [self pushJDViewPressed];
    }
}
#pragma mark }

/* 
 *  添加淘宝小号
 */
- (void)pushTaoBaoViewPressed {
  
    TaoBaoWebView* taobaoWebView = [[TaoBaoWebView alloc] init];
    taobaoWebView.hidesBottomBarWhenPushed = YES;
    UIViewController* currentView = [self getCurrentViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [currentView.navigationController pushViewController:taobaoWebView animated:YES];
        
    });

}
/*
 *  添加京东小号
 */
- (void)pushJDViewPressed {
    JDWebView* JDwebView = [[JDWebView alloc] init];
    JDwebView.hidesBottomBarWhenPushed = YES;
    UIViewController* currenController = [self getCurrentViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
    [currenController.navigationController pushViewController:JDwebView animated:YES];
    });
}
- (UIViewController* )findBestViewController:(UIViewController* )vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    
    } else if([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController* ) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController* ) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController* ) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
- (UIViewController* )getCurrentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}
- (void)alertView:(UIAlertView* )alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            
            [self GetTaobaoAccountID];
            self.MBhud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
          
        } else if (buttonIndex == 0) {
            RCCommandMessage* mesage = [[RCCommandMessage alloc]init];
            mesage.name = @"BuyerRejectRemotePay";//取消同步验证
            NSString* seller_id = [[AppDelegate appDelegate].verifyDic objectForKey:@"seller_id"];
            int   order_id = [[[AppDelegate appDelegate].verifyDic objectForKey:@"order_id"]intValue];
            NSDictionary* dic = @{@"order_id":[NSNumber numberWithInt:order_id],@"content":@"无法验证小号账号，远程付款授权失败，请稍后再试。"};
            mesage.data = [[AppDelegate appDelegate].commonmthod convertToJsonData:dic];
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                              targetId:seller_id
                                               content:mesage //
                                           pushContent:nil
                                              pushData:nil
                                               success:^(long messageId) {
                                                   NSLog(@"发送成功");
                                               } error:^(RCErrorCode nErrorCode, long messageId) {
                                                   NSLog(@"%ld",(long)nErrorCode);
                                               }];
        }
    }
}

@end
