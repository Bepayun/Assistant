//
//  UpdateAppWebView.m
//  is_ass
//
//  Created by Bepa  on 2017/10/23.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "UpdateAppWebView.h"

@interface UpdateAppWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *updateWebView;

@end

@implementation UpdateAppWebView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIWebView *updateWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-64)];
        updateWebView.hidden = NO;
        updateWebView.delegate = self;
        [self addSubview:updateWebView];
         self.updateWebView = updateWebView;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://fir.im/2gjl"]];
        [updateWebView loadRequest:request];
    }
    return self;
}

@end
