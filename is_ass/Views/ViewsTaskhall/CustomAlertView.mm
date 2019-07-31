//
//  CustomAlertView.m
//  DefinedSelf
//
//  Created by Bepa on 2017/9/5.
//  Copyright © 2017年  All rights reserved.
//

#import "CustomAlertView.h"

#define kmaxLevel   12
#pragma mark AlertViewCell {
@interface AlertViewCell : UICollectionViewCell {

    UILabel *namelabel;
    UIButton *platformButton;
}
@property (nonatomic, strong)UILabel *namelabel;
@property (nonatomic, strong)UIButton *platformButton;
@property (nonatomic, strong)NSIndexPath *alertpath;
@property (weak, nonatomic) id<ChangeButtonDelegate> delegate;


@end

@implementation AlertViewCell
@synthesize namelabel;
@synthesize platformButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(3, 10, 20, 20);
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 2;
        button.layer.borderColor = RGBA(48, 48, 48, 1.0).CGColor;
        [button setImage:[UIImage imageNamed:@"platform_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"typeBtn"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
         self.platformButton = button;
        [self.contentView addSubview:self.platformButton];
        //
        UILabel *task_type = [[UILabel alloc]initWithFrame:CGRectMake(self.platformButton.frame.origin.x+self.platformButton.frame.size.width+2, 10,40, 20)];
        task_type.textAlignment = NSTextAlignmentLeft;
        task_type.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
        task_type.font = [UIFont systemFontOfSize:10.0f];
        self.namelabel = task_type;
        self.namelabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.namelabel];
    }
    
    return self;
}
- (void)buttonClick:(UIButton *)btn {
    [self.delegate changebuttonState:self.alertpath];
     btn.selected = !btn.selected;
}
@end
#pragma mark ---- }
@interface AlertViewSectionView : UICollectionReusableView {
    UILabel *keyLabel;
}
@property (nonatomic, retain) UILabel *keyLabel;

@end
@implementation AlertViewSectionView
@synthesize keyLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *task_type = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, ScreenWidth-40, 20)];
        task_type.textAlignment = NSTextAlignmentLeft;
        task_type.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
        task_type.font = [UIFont systemFontOfSize:13];
        self.keyLabel = task_type;
        [self addSubview:keyLabel];
        //}
    }
    return self;
}
@end

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DefaultStringPressed) name:@"CustomAlertView" object:nil];
        //创建遮罩
        _blackView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
        self.blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [self addSubview:self.blackView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self.blackView addGestureRecognizer:tap];
        //
        self.alertview = [[UIImageView alloc]initWithFrame:CGRectMake(20,30,ScreenWidth-20*2,ScreenHeight-180)];
        self.alertview.backgroundColor = [UIColor whiteColor];
        self.alertview.userInteractionEnabled = YES;
        self.alertview.alpha = 1.0;
        [self.blackView addSubview:self.alertview];
        //
        _tipLable = [[UILabel alloc]initWithFrame:CGRectMake(20,20,self.alertview.frame.size.width-80,20)];
        _tipLable.textAlignment = NSTextAlignmentLeft;
        [_tipLable setBackgroundColor:[UIColor clearColor]];
        [_tipLable setFont:[UIFont boldSystemFontOfSize:16]];
        _tipLable.text = @"请设置";
        [_tipLable setTextColor:[UIColor colorWithRed:91/255.0 green:93/255.0 blue:95/255.0 alpha:1.0]];
        [self.alertview addSubview:_tipLable];
        
        UIButton *leaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leaveButton.frame = CGRectMake(self.alertview.frame.size.width-40, self.tipLable.frame.origin.y, 30, 30);
        leaveButton.backgroundColor = [UIColor whiteColor];
        [leaveButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [leaveButton addTarget:self action:@selector(blackClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertview addSubview:leaveButton];
        //
        UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(20, self.tipLable.frame.origin.y+self.tipLable.frame.size.height+10, ScreenWidth-40,20)];
        type.text = @"任务平台:";
        type.textAlignment = NSTextAlignmentLeft;
        type.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
        type.font = [UIFont systemFontOfSize:13.0f];
        self.platformLabel = type;
        [self.alertview addSubview:self.platformLabel];
        
        UIButton *platformButton = [UIButton buttonWithType:UIButtonTypeCustom];
        platformButton.frame = CGRectMake(type.frame.origin.x, type.frame.origin.y+type.frame.size.height+8,90, 30);
        platformButton.layer.masksToBounds = YES;
        platformButton.layer.borderWidth = 1;
        platformButton.layer.borderColor = RGBA(117, 173, 234, 1.0).CGColor;
        self.platformString = @"热门游戏";
        [platformButton setTitle:@"热门游戏" forState:UIControlStateNormal];
        [platformButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [platformButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         platformButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        platformButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 还可增设间距
        CGFloat spacing = 35.0;
        spacing = 15.0;
        // 图片右移
        CGSize imageSize = platformButton.imageView.image.size;
        platformButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width*1.6-spacing, 0.0, 0.0);
        // 文字左移
        CGSize titleSize = platformButton.titleLabel.frame.size;
        platformButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width*2 - spacing);
        [platformButton addTarget:self action:@selector(platformBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.platformBtn = platformButton;
        [self.alertview addSubview:self.platformBtn];

        //
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        [flowLayout  setScrollDirection:UICollectionViewScrollDirectionVertical];//垂直滚动
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10,self.platformBtn.frame.origin.y+self.platformBtn.frame.size.height+5,self.alertview.frame.size.width-10,200) collectionViewLayout:flowLayout];
        collectionView.alwaysBounceVertical = YES;//当不够一屏的话也能滑动
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:[UIColor clearColor]];
        //注册复用cell(cell的类型和标识符)(可以注册多个复用cell, 一定要保证重用标示符是不一样的)注册到了collectionView的复用池里
        [collectionView registerClass:[AlertViewCell class] forCellWithReuseIdentifier:@"AlertCell"];
        [collectionView registerClass:[AlertViewSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"alertView"];
        self.platformCollection = collectionView;
        self.platformCollection.scrollEnabled = NO;
        [self.alertview addSubview:self.platformCollection];
        //
        UIButton *submitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitbtn.frame = CGRectMake(20,self.alertview.frame.size.height-50,(self.alertview.frame.size.width-60)/2,30);
        [submitbtn setTitle:@"提交" forState:UIControlStateNormal];
        submitbtn.backgroundColor = RGBA(45, 173, 253, 1.0);
        [submitbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitbtn addTarget:self action:@selector(submitHttpswithchangeCondition:) forControlEvents:UIControlEventTouchUpInside];
         self.submitButton = submitbtn;
         self.submitButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.alertview addSubview:self.submitButton];
        //
        
        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelbtn.frame = CGRectMake(self.submitButton.frame.origin.x+self.submitButton.frame.size.width+20,self.alertview.frame.size.height-50,(self.alertview.frame.size.width-60)/2,30);
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
         cancelbtn.backgroundColor = RGBA(125, 126, 127, 1.0);
        [cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(blackClick) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = cancelbtn;
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.alertview addSubview:self.cancelButton];
        //
        self.platformArray = [NSMutableArray arrayWithCapacity:0];
        [self addGroupPlatformTypeView];
    }
    return self;
}
- (void)DefaultStringPressed {
    self.platformString = @"热门游戏";
    [self.platformBtn setTitle:self.platformString forState:UIControlStateNormal];
}
- (void)addGroupPlatformTypeView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.platformBtn.frame.origin.x,self.platformBtn.frame.origin.y+self.platformBtn.frame.size.height,self.platformBtn.frame.size.width, 30*4)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = RGBA(45, 173, 253, 1.0).CGColor;
    self.typeView = view;
    self.typeView.hidden = YES;
    [self.alertview addSubview:self.typeView];
    NSArray *titlearray = @[@"热门游戏",@"网络游戏",@"网页游戏",@"其他游戏"];
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,30*i, self.typeView.frame.size.width, 30);
        [button setTitle:[NSString stringWithFormat:@"%@",[titlearray objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitleColor:RGBA(48, 48, 48, 1.0) forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button addTarget:self action:@selector(Group_platformButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeView addSubview:button];
    }
    [self initTabbao];
    [self.platformCollection reloadData];
}
- (void)initTabbao {
    [self.platformArray removeAllObjects];
    [self.platformArray addObject:@[@"精品",@"高级",@"普通"]];
    [self.platformArray addObject:@[@"1级",@"10级",@"20级",@"30级",@"40级",@"50级",@"60级",@"70级",@"80级",@"90级",@"100级"]];
}
- (void)Group_platformButtonClick:(UIButton *)button {
    self.platformCollection.tag = button.tag;
    [self changeViewType:button.tag];
    self.typeView.hidden = !self.typeView.hidden;
//    NSString *str = (button.tag == 0?@"淘宝":((button.tag == 1)?@"京东":@"其他"));
    NSString *str = @"";
    if (button.tag == 0) {
        str = @"热门游戏";
    
    } else if (button.tag == 1) {
        str = @"网络游戏";
   
    } else if (button.tag == 2) {
        str = @"网页游戏";
    
    } else {
        str = @"其他游戏";
    }
    [self.platformBtn setTitle:str forState:UIControlStateNormal];
}
- (void)changeViewType:(NSInteger)type {
    [self.platformArray removeAllObjects];
    if (type == 0) {
        [self.platformArray addObject:@[@"精品",@"高级",@"普通"]];
        [self.platformArray addObject:@[@"1级",@"10级",@"20级",@"30级",@"40级",@"50级",@"60级",@"70级",@"80级",@"90级",@"100级"]];
        self.platformString = @"热门游戏";
   
    } else if (type == 1) {
        [self.platformArray addObject:@[@"精品",@"高级",@"普通"]];
        [self.platformArray addObject:@[@"新手",@"青铜",@"白银",@"黄金",@"王者"]];//白号=新手 铜牌=青铜 银牌=白银 金牌=黄金 钻石=王者
        self.platformString = @"网络游戏";
   
    } else if (type == 2) {
        [self.platformArray addObject:@[@"精品",@"高级",@"普通"]];
        self.platformString = @"网页游戏";
   
    } else {
        [self.platformArray addObject:@[@"立返",@"待审"]];
        self.platformString = @"其他游戏";
        
        self.levelindex = 0;
    }
    [self.platformCollection reloadData];
}
- (void)platformBtnClick:(UIButton *)btn {
    self.typeView.hidden = !self.typeView.hidden;
}
- (void)submitHttpswithchangeCondition:(UIButton *)submitBtn {
    if (_isLevel) {
        self.levelindex = 0;
    }
    [self.delegate buy_type:self.buy_type andlevel:[NSString stringWithFormat:@"%ld",(long)self.levelindex] withPlatform:self.platformString];
    [self replaceView];
}
- (void)replaceView {
    [self initTabbao];
    [self.platformBtn setTitle:@"热门游戏" forState:UIControlStateNormal];
    [self.platformCollection reloadData];
    self.buy_type = nil;
    self.levelindex = 0;
    self.platformString = nil;
    _isLevel = NO;
}
- (void)blackClick {
    [self cancleView];
    [self replaceView];
}
- (void)cancleView {
    self.hidden = YES;
}
#pragma mark UICollectionViewDataSource {
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.platformArray.count;
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.platformArray.count > 0) {
       NSArray *array = [self.platformArray objectAtIndex:section];
       return array.count;
    }

    return 1;
}
//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        AlertViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlertCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AlertViewCell alloc] init];
        }
        cell.delegate = self;
        cell.platformButton.titleLabel.text = [NSString stringWithFormat:@"%@",self.platformArray[indexPath.section][indexPath.row]];
        cell.platformButton.selected = NO;
        cell.alertpath = indexPath;
        CGRect nameRect = cell.namelabel.frame;
        if (indexPath.section == 0) {
            nameRect.size.width = 40;
       
        } else {
            nameRect.size.width = 30;
        }
         cell.namelabel.frame = nameRect;
         cell.namelabel.text = [NSString stringWithFormat:@"%@",self.platformArray[indexPath.section][indexPath.row]];
        return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            AlertViewSectionView *homeViewSectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"alertView" forIndexPath:indexPath];
            //{
            for (UIView *headerView in homeViewSectionView.subviews) {
                if ([headerView isEqual:[UILabel class]]) {
                    [headerView removeFromSuperview];
                }
            }
            //}
            if (indexPath.section == 0) {
                homeViewSectionView.keyLabel.text = @"任务方式:";
           
            } else {
                homeViewSectionView.keyLabel.text = @"账号等级:";
            }
            return homeViewSectionView;
        }
    }
    //
    UICollectionReusableView *homeViewSectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"alertView" forIndexPath:indexPath];
    return homeViewSectionView;
}
//返回头headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.alertview.frame.size.width, 40);
}
//定义每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake((self.alertview.frame.size.width-30)/4.5,30);
    
    } else {
        return CGSizeMake((self.alertview.frame.size.width-30)/((collectionView.tag == 1)?6:6.3),30);
    }
}
//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0,2.0,0.0,2.0);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

        return 10.0f;
}
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //AlertViewCell *selectcell = (AlertViewCell *)[self.platformCollection cellForItemAtIndexPath:indexPath];
}
- (void)changebuttonState:(NSIndexPath *)dexpath {
    AlertViewCell *selectcell = (AlertViewCell *)[self.platformCollection cellForItemAtIndexPath:dexpath];
    _isLevel = YES;
    if (dexpath.section == 0) {
        if (!selectcell.platformButton.selected) {
            if (![self.buy_type isKindOfClass:[NSNull class]] && ![self.buy_type isEqualToString:@"(null)"] && self.buy_type != nil) {
                NSString *str = self.buy_type;
                self.buy_type = [NSString stringWithFormat:@"%@,'%@'",str,selectcell.namelabel.text];
           
            } else {
                self.buy_type = [NSString stringWithFormat:@"'%@'",selectcell.namelabel.text];
            }
       
        } else {
            if (![self.buy_type isKindOfClass:[NSNull class]] && ![self.buy_type isEqualToString:@"(null)"] && self.buy_type != nil) {
                NSString *str = self.buy_type;
                NSString *strUrl = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",'%@'",selectcell.namelabel.text] withString:@""];
                self.buy_type = [NSString stringWithFormat:@"%@",strUrl];
            }
        }
    } else {
        if (!selectcell.platformButton.selected) {
            if (self.levelindex <= kmaxLevel && self.levelindex >= dexpath.row) {
                self.levelindex = (int)dexpath.row;
            }
        
        } else {
            if (self.levelindex >= dexpath.row) {
                self.levelindex = (int)dexpath.row;
            }
        }
    }
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
     UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
     [cell setBackgroundColor:[UIColor redColor]];
     
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark}
#pragma mark - Gesture
- (void)click:(UITapGestureRecognizer *)sender {
     CGPoint tapLocation = [sender locationInView:self.blackView];
//    CGPoint tapLocation2 = [sender locationInView:self.platformCollection];
     CGRect alertFrame = self.alertview.frame;
    //CGRect fram = self.platformCollection.frame;
     if (!CGRectContainsPoint(alertFrame, tapLocation)) {
        [self cancleView];
     }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
