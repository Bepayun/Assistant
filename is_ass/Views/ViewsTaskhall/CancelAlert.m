//
//  CustomAlert.m
//  AuctionShop_iOS
//
//  Created by Wangys on 16/8/5.
//  Copyright © 2016年 Wangys. All rights reserved.
//

#import "CancelAlert.h"

#define kColorMainRed [UIColor redColor]  //通用的红色

static CGFloat const kTitleStringFontSize = 19;
static CGFloat const kTipsStringFontSize = 16;
static CGFloat const kDoneBtnFontSize = 16;

static CGFloat const kAnimationDutation = 0.25;
static CGFloat const kCornerRadius = 4;


@interface CancelAlert()

@property(nonatomic,weak) UIButton *bgButton;

@property(nonatomic,weak) UIView *contentView;
@property(nonatomic,weak) UILabel *titleLabel, *tipsLable;
@property(nonatomic,weak) UIButton *button;
@property(nonatomic,weak) UIButton *doneBtn;

@property(nonatomic,strong) NSString *title, *message, *buttonTitle;
@property(nonatomic,assign) BOOL coverCanClicked;

@end

@implementation CancelAlert

+ (CancelAlert *)sharedAlert
{
    static CancelAlert *sharedAlert;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAlert = [[CancelAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedAlert;
}

#pragma mark - Show methods

//+ (void)showMessage:(NSString *)message
//{
//    CancelAlert *alert = [self sharedAlert];
//    
//    [alert showWithTitle:@"提示" tips:message btnTitle:@"确定" btnClickBlock:nil coverCanClick:YES];
//    [alert show];
//}

+ (void)showMessage:(NSString *)message
   withClickedBlock:(BtnClickedBlock)btnClickedBlock
{
     CancelAlert *alert = [self sharedAlert];
     alert.hidden = NO;
     alert.btnClickedBlock = btnClickedBlock;
    [alert showWithTitle:@"提示" tips:message btnTitle:@"取消等待" btnClickBlock:btnClickedBlock coverCanClick:NO];
    [alert show];
}
+ (void)HiddenView{
     CancelAlert *alert = [self sharedAlert];
     alert.hidden = YES;
}
#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

#pragma mark - Getter

- (UIButton *)bgButton
{
    if (!_bgButton) {
        UIButton *bgButton = [[UIButton alloc] init];
        bgButton.backgroundColor = [UIColor blackColor];
        [bgButton addTarget:self action:@selector(bgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        _bgButton = bgButton;
    }
    return _bgButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor blueColor];
        contentView.layer.cornerRadius = kCornerRadius;
        contentView.layer.masksToBounds = YES;
        
        contentView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        [self.bgButton addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UILabel *)tipsLable
{
    if (!_tipsLable) {
        UILabel *tipsLable = [[UILabel alloc] initWithFrame:CGRectZero];
        tipsLable.backgroundColor = [UIColor clearColor];
        tipsLable.adjustsFontSizeToFitWidth = YES;
        tipsLable.textAlignment = NSTextAlignmentCenter;
        tipsLable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        tipsLable.numberOfLines = 0;
        tipsLable.minimumScaleFactor = 0.7;
        
        tipsLable.textColor = RGBA(116, 121, 126, 1.0);
        tipsLable.font = [UIFont systemFontOfSize:kTipsStringFontSize];
        [self.contentView addSubview:tipsLable];
        _tipsLable = tipsLable;
    }
    return _tipsLable;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.textColor = RGBA(116, 121, 126, 1.0);
        titleLabel.font = [UIFont boldSystemFontOfSize:kTitleStringFontSize];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIButton *)doneBtn
{
    if (!_doneBtn) {
        UIButton *doneBtn = [[UIButton alloc] init];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:kDoneBtnFontSize];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneBtn.backgroundColor = RGBA(45, 173, 254, 1.0);
        [self.contentView addSubview:doneBtn];
        [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn = doneBtn;
    }
    return _doneBtn;
}

#pragma mark - Instance methods

- (void)showWithTitle:(NSString *)title
                 tips:(NSString *)tips
             btnTitle:(NSString *)btnTitle
        btnClickBlock:(BtnClickedBlock)btnClickedBlock
        coverCanClick:(BOOL)isCoverCanClick
{
    self.titleLabel.text = title;
    self.tipsLable.text = tips;
    [self.doneBtn setTitle:btnTitle forState:UIControlStateNormal];

    if (btnClickedBlock) {
        self.btnClickedBlock = btnClickedBlock;
        [self.doneBtn addTarget:self action:@selector(btnClickedBlock) forControlEvents:UIControlEventTouchUpInside];
    }
    if(isCoverCanClick){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    [self setupFrame];
}


- (void)setupFrame
{
    CGFloat marginToScreenLeft = 20;
    
    CGFloat marginToContentViewLeft = 20;
    CGFloat marginToContentViewTop = 20;
    
    CGFloat contentViewWidth = [UIScreen mainScreen].bounds.size.width - 2*marginToScreenLeft;
    
    CGFloat padding = 20;
    CGFloat subViewWidth = contentViewWidth-2*marginToContentViewLeft;
    
    //bgBtn
    self.bgButton.frame = self.bounds;
    
    //titleLabel
    self.titleLabel.frame = CGRectMake(marginToContentViewLeft, marginToContentViewTop, subViewWidth, 20);
    
    //tipsLabel
    NSString *tipsString = self.tipsLable.text;
    CGFloat tipsStringHeight;
    if (tipsString) {
        CGSize constraintSize = CGSizeMake(subViewWidth, [UIScreen mainScreen].bounds.size.height*0.6);
        
       CGRect tipsStringRect = [tipsString boundingRectWithSize:constraintSize
                                          options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:@{NSFontAttributeName: self.tipsLable.font}
                                          context:NULL];
        tipsStringHeight = tipsStringRect.size.height;
    }else{
        tipsStringHeight = 40;
    }
    
    self.tipsLable.frame = CGRectMake(marginToContentViewLeft, CGRectGetMaxY(self.titleLabel.frame)+5, subViewWidth, tipsStringHeight);

    //doneBtn
    CGFloat doneBtnW = subViewWidth-20;
    CGFloat doneBtnH = 44;
    CGFloat doneBtnX = (contentViewWidth-doneBtnW)/2;
    self.doneBtn.frame = CGRectMake(doneBtnX, CGRectGetMaxY(self.tipsLable.frame)+80, doneBtnW, doneBtnH);
    
    //contentView
    CGFloat contentViewHeight = CGRectGetMaxY(self.doneBtn.frame)+padding+60;
    CGFloat contentViewX = (self.frame.size.width-contentViewWidth)/2;
    CGFloat contentViewY = (self.frame.size.height-contentViewHeight)/2;
    self.contentView.frame = CGRectMake(contentViewX, contentViewY, contentViewWidth, contentViewHeight);
}

#pragma mark - Show & Dismiss

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    [window.layer removeAllAnimations];
    [window addSubview:self];
    [self showBackground];
    [self showAlertAnimation];
}

- (void)lightColor
{
    self.bgButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    self.contentView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    self.doneBtn.alpha = 0.1;
    self.tipsLable.alpha = 0.1;
    self.titleLabel.alpha = 0.1;
}

- (void)darkColor
{
    self.bgButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.doneBtn.alpha = 1.0;
    self.tipsLable.alpha = 1.0;
    self.titleLabel.alpha = 1.0;
}

- (void)showBackground
{
    [self lightColor];
    [UIView animateWithDuration:kAnimationDutation animations:^{
        [self darkColor];
    }];
    NSLog(@"self=%@",self);
}

-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kAnimationDutation;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.contentView.layer addAnimation:animation forKey:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimationDutation animations:^{
        [self lightColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Button Actions

- (void)bgButtonClicked
{
    [self dismiss];
}

- (void)doneBtnClicked
{
    if (self.btnClickedBlock) {
        self.btnClickedBlock();
    }
    [self dismiss];
}


@end
