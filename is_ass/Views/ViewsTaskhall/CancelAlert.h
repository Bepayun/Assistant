//
//  CustomAlert.h
//  AuctionShop_iOS
//
//  Created by Wangys on 16/8/5.
//  Copyright © 2016年 Wangys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickedBlock)();


@interface CancelAlert : UIView

@property(nonatomic,copy) BtnClickedBlock btnClickedBlock;

/**
 *  Show methods,default. Dismiss if click anywhere.
 */
//+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message
   withClickedBlock:(BtnClickedBlock)btnClickedBlock;
+ (void)HiddenView;
@end
