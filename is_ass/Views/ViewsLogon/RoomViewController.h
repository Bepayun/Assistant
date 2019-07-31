//
//  RoomViewController.h
//  assistant
//
//  Created by Bepa  on 2017/8/29.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "RootViewController.h"

@protocol RoomViewControllerDelegate <NSObject>

- (void)sendRongCouldToken:(NSString* )rongCouldToken;

@end


@interface RoomViewController : RootViewController
@property (nonatomic, weak) id<RoomViewControllerDelegate>delegate;

@property (strong, nonatomic) UILabel* roomnuberLabel; ///< 房间号
@property (strong, nonatomic) UITextField* roomnuber_textfield;
@property (strong, nonatomic) UIButton* enterRoombutton;

@end
