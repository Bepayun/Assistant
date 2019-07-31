//
//  CommonMethod.h
//  assistant
//
//  Created by Bepa on 2017/9/4.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

typedef void (^ChangedForTextFieldTBlock)(BOOL ismatching,BOOL isposition);

@interface CommonMethod : NSObject {
    
}
@property(nonatomic,strong)MBProgressHUD* MBhud;
/**
 *   获取本机ip
 *   @return ip(String)
 */
- (NSString* )getIPAddress;

/**
 *  获取本地版本号
 *  @return version（String）
 */
- (NSString* )getLocalVersion;

/**
 *  textField根据kNicknameTextLimitLength改变text
 */
- (void)textFiledEditChangedForTextField:(UITextField* )textField forIsmatching:(ChangedForTextFieldTBlock)ismatching;
- (void)textFiledEditChangedForTextView:(UITextView* )textView forIsmatching:(ChangedForTextFieldTBlock)ismatching;

/**
 *  年月日转换成时间戳
 */
- (NSString* )formattingTimeString:(NSString* )timeString;

/**
 *  UIAlertView
 *  @param message 提示内容
 */
- (void)showAlert:(NSString* )message;

/**
*  HUD
 *  @param message 提示内容
 */
- (void)showHUD:(NSString* )message;

/**
 *  字典转成json数据
 */
- (NSString* )convertToJsonData:(NSDictionary* )dict;

/**
 *  json数据转成字典
 */
- (id)dictionaryWithJsonString:(NSString* )jsonString;

#pragma mark 雇主消息处理 {
/**
 *  雇主同意跳转聊天界面
 */
- (void)ToChatViewWithCellerwith:(RCMessage* )content;

/**
*  雇主消息提示
 */
- (void)showMessageFromSeller:(NSString* )message;

/**
 *  雇主向雇主发送同步消息
 */
- (void)SendVerifyMessagewithcookiers;
#pragma mark --- }

@end
