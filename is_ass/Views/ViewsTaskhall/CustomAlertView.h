//
//  CustomAlertView.h
//  DefinedSelf
//
//  Created by Bepa on 2017/9/5.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@class AlertViewCell;
@protocol ChangeButtonDelegate <NSObject>

-(void)changebuttonState:(NSIndexPath *)dexpath;
@end

@protocol CustomAlertViewDelegate<NSObject>
@optional
-(void)buy_type:(NSString *)buytypestr andlevel:(NSString *)levelstr withPlatform:(NSString *)platform;
@end

@interface CustomAlertView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,ChangeButtonDelegate>
@property (nonatomic,strong)UIView   *blackView;//遮罩 黑
@property (strong,nonatomic)UIImageView    *alertview;//alertView
@property (nonatomic,strong)UILabel    *tipLable;
@property (nonatomic,strong)UILabel    *platformLabel;//平台
@property (nonatomic,strong)UIButton   *platformBtn;
@property (weak,  nonatomic)id<CustomAlertViewDelegate> delegate;
@property (nonatomic,retain)UIView   *typeView;
@property (nonatomic,retain)UIButton *submitButton;
@property (nonatomic,retain)UIButton *cancelButton;
@property (nonatomic,retain)UICollectionView *platformCollection;
@property (nonatomic,retain)NSMutableArray *platformArray;
@property (nonatomic,retain)NSString *buy_type;
@property (nonatomic,retain)NSString *level;
@property (nonatomic,retain)NSString *platformString;
@property (nonatomic,assign)int levelindex;
@property (nonatomic,assign)BOOL isLevel;

@end
