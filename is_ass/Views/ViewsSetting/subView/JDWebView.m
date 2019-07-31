//
//  JDWebView.m
//  is_ass
//
//  Created by Bepa  on 2017/9/13.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "JDWebView.h"

@interface JDWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *JDWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *buyerTradesJSStr;
@property (nonatomic, strong) NSString *cookieJSONString;
@property (nonatomic, strong) NSString *dataJSONString;
@property (nonatomic, strong) NSString *jsOrderString;
@property (nonatomic, strong) NSString *jsUserInfoStr;
@property (nonatomic, strong) NSString *homeString;
@property (nonatomic, strong) NSMutableArray *validationAry;//验证数组
@property (nonatomic, assign) int index;

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *valueStr;
@property (nonatomic, strong) NSString *nameStr2;
@property (nonatomic, strong) NSString *valueStr2;
@property (nonatomic, strong) NSString *expiresDate;
@property (nonatomic, strong) NSString *expiresDate2;
@property (nonatomic, strong) NSString *domainStr;
@property (nonatomic, strong) NSString *domainStr2;
@property (nonatomic, strong) NSString *pathStr;

@property (nonatomic, assign) int flag;
@property (nonatomic, assign) int Verifyflag;

@property (nonatomic, assign) BOOL hidWeb;
@property (nonatomic, assign) BOOL bol;
@property (nonatomic, assign) BOOL Verify;

@property (nonatomic, strong) MBProgressHUD *HuD;

@end

@implementation JDWebView

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
        self.navigationController.navigationBarHidden = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
        self.navigationController.navigationBarHidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];

    self.view.backgroundColor = [UIColor whiteColor];
    _hidWeb = NO;
    _bol = NO;
    _Verify = NO;
    _flag = 1;
    _Verifyflag = 0;
    
    _dataJSONString = [[NSString alloc] init];
    _validationAry = [NSMutableArray arrayWithCapacity:0];
    _JDWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _JDWebView.delegate = self;
    [self.view addSubview:_JDWebView];
    
    if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
         _Verifyflag = 1;
        _Verify = YES;
        _JDWebView.hidden = YES;
        [self validationCookies:[AppDelegate appDelegate].cookieArray];
        _HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _HuD.label.text = @"等待授权..";
        NSLog(@"JDWebView _HuD.label.text = 等待授权..");
        
    } else {
        _JDWebView.hidden = NO;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kLoginJDURL]];
        [_JDWebView loadRequest:request];
    }
   
    self.jsContext = [_JDWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [self createNav];
}
#pragma mark - 获取京东的cookies
- (void)getJDCookies {
    
    NSURL *urlString = [NSURL URLWithString:kJoinJDURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSMutableArray *cookiesAry = [[NSMutableArray alloc] initWithCapacity:0];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //转换NSURLResponse成为HTTPResponse
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        //获取headerfields
        NSDictionary *fields = [HTTPResponse allHeaderFields];//原生NSURLConnection写法
        if (fields != nil && ![fields isKindOfClass:[NSNull class]]) {
            NSLog(@"fields = %@",[fields description]);
            
            if ([fields objectForKey:@"Set-Cookie"] && ![[fields objectForKey:@"Set-Cookie"] isKindOfClass:[NSNull class]]) {
                NSString *set_cookies = [fields objectForKey:@"Set-Cookie"];
                NSArray *ary = [set_cookies componentsSeparatedByString:@";"];
                NSRange pathRange = [set_cookies rangeOfString:@"Path="];
                if (pathRange.location != NSNotFound) {
                    NSString *pathStr = [set_cookies substringFromIndex:pathRange.location + pathRange.length];
                    NSRange pathRangeb = [pathStr rangeOfString:@","];
                    if (pathRangeb.location != NSNotFound) {
                        pathStr = [pathStr substringToIndex:pathRangeb.location];
                    }
                    _pathStr = pathStr;
                }

                for (int i = 0; i < ary.count; i ++) {
                    NSString *expstr = [ary objectAtIndex:i];
                    NSRange expRange = [expstr rangeOfString:@"Expires="];

                    if ([expstr rangeOfString:@"2017"].location != NSNotFound) {
                        if (expRange.location != NSNotFound) {
                            NSString *expStr = [expstr substringFromIndex:expRange.location + expRange.length];
                            if (expStr != nil && expStr.length > 0) {
                                _expiresDate = [[AppDelegate appDelegate].commonmthod formattingTimeString:expStr];
                            }
                        }
                    }
                    
//                    if ([expstr rangeOfString:@"2019"].location != NSNotFound) {
//                        if (expRange.location != NSNotFound) {
//                            NSString *expStr = [expstr substringFromIndex:expRange.location + expRange.length];
//                            if (expStr != nil && expStr.length > 0) {
//                                _expiresDate2 = [[AppDelegate appDelegate].commonmthod formattingTimeString:expStr];
//                            }
//                        }
//                    }

                    //domain
                    NSRange range = [expstr rangeOfString:@"Domain="];
                    if (range.location != NSNotFound) {
                        
                        if ([expstr rangeOfString:@".jd.com"].location != NSNotFound) {
                            _domainStr = [expstr substringFromIndex:range.location + range.length];
                        }
//                        if ([expstr rangeOfString:@".360buy.com"].location != NSNotFound) {
//                            _domainStr2 = [expstr substringFromIndex:range.location + range.length];
//                        }
                    }
                    
                    // sid
                    NSRange pathR = [expstr rangeOfString:@"Path=/, "];
                    NSRange range1 = [expstr rangeOfString:@"sid="];
                    NSRange range2 = [expstr rangeOfString:@"USER_FLAG_CHECK="];
                    if (range1.location != NSNotFound) {
                        NSString *namestr = [expstr substringFromIndex:pathR.location + pathR.length];
                        NSArray *array = [namestr componentsSeparatedByString:@"="];
                        if (array.count > 0) {
                            NSString *nameStr = [array objectAtIndex:0];
                            NSString *valueStr = [array objectAtIndex:1];
                            if ([nameStr hasSuffix:@"sid"]) {
                                _nameStr = nameStr;
                                _valueStr = valueStr;
                            }
                        }
                    }
//                    if (pathR.location != NSNotFound) {
//                        if (range2.location != NSNotFound) {
//                            NSString *namestr = [expstr substringFromIndex:pathR.location + pathR.length];
//                            NSArray *array = [namestr componentsSeparatedByString:@"="];
//                            if (array.count > 0) {
//                                NSString *nameStr = [array objectAtIndex:0];
//                                NSString *valueStr = [array objectAtIndex:1];
//                                if ([nameStr hasSuffix:@"USER_FLAG_CHECK"]) {
//                                    _nameStr2 = nameStr;
//                                    _valueStr2 = valueStr;
//                                }
//                            }
//                        }
//
//                    }
                }
            }
        }
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary *jsonCookieDic = [[NSDictionary alloc] init];
        NSDictionary *Dic = [[NSDictionary alloc] init];
//        NSDictionary *Dic2 = [[NSDictionary alloc] init];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            //            NSLog(@"cookie%@", cookie);
            if ([cookie isKindOfClass:[NSHTTPCookie class]]) {
                NSString *string = [NSString stringWithFormat:@"%@",cookie];
                //
                NSRange  createRange = [string rangeOfString:@"created:"];
                NSString *createdDate = [[NSString alloc] init];
                if (createRange.location != NSNotFound) {
                    NSString *createString = [string substringFromIndex:createRange.location+createRange.length];
                    NSRange  sftRange = [createString rangeOfString:@" +0000"];
                    if (sftRange.location != NSNotFound) {
                        createString = [createString substringToIndex:sftRange.location];
                        
                        //
//                NSString *expiresDate = [NSString stringWithFormat:@"%ld", (long)[cookie.expiresDate timeIntervalSince1970]];
                        NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
                        dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                        NSDate *creatDate = [dateF dateFromString:createString];
                        createdDate = [NSString stringWithFormat:@"%.f", [creatDate timeIntervalSince1970]];
                    }
                }
                
                //
                NSRange  partitionRange = [string rangeOfString:@"partition:\""];
                NSString *partitionString = [[NSString alloc] init];
                if (partitionRange.location != NSNotFound) {
                    partitionString = [string substringFromIndex:partitionRange.location+partitionRange.length];
                    NSRange  partitionsftRange = [partitionString rangeOfString:@"\" path:"];
                    if (partitionsftRange.location != NSNotFound) {
                        partitionString = [partitionString  substringToIndex:partitionsftRange.location];
                    }
                    
                }
                
                if (_expiresDate != nil && _expiresDate.length > 0) {
                    
                    jsonCookieDic = @{
                                       @"CreationTime": createdDate,
                                       @"Host": _domainStr,//[NSString stringWithFormat:@"%@",cookie.domain],
                                       @"Expiry": _expiresDate,
                                       @"IsDomain": @"true",
                                       @"IsHttpOnly": @"false",
                                       @"isSecure": @"false",
                                       @"IsSession": @"false",//android is true
                                       @"LastAccessed": createdDate,
                                       @"Name": [NSString stringWithFormat:@"%@",cookie.name],
                                       @"Path": _pathStr,
                                       @"RawHost": [NSString stringWithFormat:@"%@",cookie.domain],
                                       @"Value": [NSString stringWithFormat:@"%@",cookie.value],
                                       @"Partition": partitionString,
                                       @"version": [NSString stringWithFormat:@"%lu",(unsigned long)cookie.version]
                                       };
                    
                    // Set-Cookie里面的name与value
                    Dic = @{
                             @"CreationTime": createdDate,
                             @"Host": _domainStr,//[NSString stringWithFormat:@"%@",cookie.domain],
                             @"Expiry": _expiresDate,
                             @"IsDomain": @"true",
                             @"IsHttpOnly": @"false",
                             @"isSecure": @"false",
                             @"IsSession": @"false",//android is true
                             @"LastAccessed": createdDate,
                             @"Name": _nameStr,
                             @"Path": _pathStr,
                             @"RawHost": [NSString stringWithFormat:@"%@",cookie.domain],//_domainStr,
                             @"Value": _valueStr,
                             @"Partition": partitionString,
                             @"version": [NSString stringWithFormat:@"%lu",(unsigned long)cookie.version]
                             };
                    
//                    Dic2 = @{
//                             @"CreationTime": createdDate,
//                             @"Host": _domainStr2,//[NSString stringWithFormat:@"%@",cookie.domain],
//                             @"Expiry": _expiresDate2,
//                             @"IsDomain": @"true",
//                             @"IsHttpOnly": @"false",
//                             @"isSecure": @"false",
//                             @"IsSession": @"false",//android is true
//                             @"LastAccessed": createdDate,
//                             @"Name": _nameStr2,
//                             @"Path": _pathStr,
//                             @"RawHost": [NSString stringWithFormat:@"%@",cookie.domain],//_domainStr,
//                             @"Value": _valueStr2,
//                             @"Partition": partitionString,
//                             @"version": [NSString stringWithFormat:@"%lu",(unsigned long)cookie.version]
//                             };
                }
            }
            NSLog(@"jsonCookieDic------------------------- %@",jsonCookieDic);
            [cookiesAry addObject:jsonCookieDic];
        }
        
        [cookiesAry addObject:Dic];
//        [cookiesAry addObject:Dic2];
        
        NSString *jsonStr = [[NSString alloc] init];
        jsonStr = [cookiesAry JSONString];
        _cookieJSONString = jsonStr;
        NSLog(@"jsonStr----------------- %@",jsonStr);
        if (_validationAry.count > 0) {
            [_validationAry removeAllObjects];
        }
        [_validationAry addObjectsFromArray:cookiesAry];
       
        if (_Verify && _Verifyflag > 0) {
           [self validationCookies:_validationAry];
        }
    }];
}

#pragma mark - 验证京东号 {
- (void)validationCookies:(NSArray*)array {
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }

    if (array != nil && array.count > 0) {
        for (NSDictionary *cookie in array) {
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            
            if ([cookie objectForKey:@"Name"] != nil && ![[cookie objectForKey:@"Name"] isKindOfClass:[NSNull class]]){
                [cookieProperties setObject:[cookie objectForKey:@"Name"] forKey:NSHTTPCookieName];
            }
            if ([cookie objectForKey:@"Value"] != nil && ![[cookie objectForKey:@"Value"] isKindOfClass:[NSNull class]]){
                [cookieProperties setObject:[cookie objectForKey:@"Value"] forKey:NSHTTPCookieValue];
            }
            if ([cookie objectForKey:@"Path"] != nil && ![[cookie objectForKey:@"Path"] isKindOfClass:[NSNull class]]){
                [cookieProperties setObject:[cookie objectForKey:@"Path"] forKey:NSHTTPCookiePath];
            }
            if ([cookie objectForKey:@"Host"] != nil && ![[cookie objectForKey:@"Host"] isKindOfClass:[NSNull class]]){
//                [cookieProperties setObject:@".jd.com" forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:[cookie objectForKey:@"Host"] forKey:NSHTTPCookieDomain];
            }
            if ([cookie objectForKey:@"RawHost"] != nil && ![[cookie objectForKey:@"RawHost"] isKindOfClass:[NSNull class]]) {
                [cookieProperties setObject:[cookie objectForKey:@"RawHost"] forKey:NSHTTPCookieDomain];
            }
            
            NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithDictionary:cookieProperties]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
            
        }
    }
     _hidWeb = NO;
    NSURLRequest *request;
    if (_Verifyflag == 1) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:kJoinJDURL]];
        _Verifyflag = 2;
    }
    [_JDWebView loadRequest:request];


}
#pragma mark - 做隐藏处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSRange range = [request.URL.absoluteString rangeOfString:@"//www.jd.com"];

    if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
        range = [request.URL.absoluteString rangeOfString:@"//passport.jd.com"];
        if (range.location != NSNotFound && _hidWeb) {
            
            //_JDWebView.hidden = YES;
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
            [self.view addSubview:self.activityIndicator];
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [self.activityIndicator startAnimating];
            [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
            [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.centerY.equalTo(self.view.mas_centerY);
            }];
            
        }
        NSRange rangeb = [request.URL.absoluteString rangeOfString:@"/uc/login"];
        if (rangeb.location != NSNotFound) {
            _hidWeb = YES;
        }
        NSRange rangec = [request.URL.absoluteString rangeOfString:@"center/list.action"];
        if (rangec.location != NSNotFound) {
            _JDWebView.hidden = YES;
        }
        
    }else{
        
        if (range.location != NSNotFound && _hidWeb) {
            
            //_JDWebView.hidden = YES;
            _flag = 2;
            [self getJDCookies];
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
            [self.view addSubview:self.activityIndicator];
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [self.activityIndicator startAnimating];
            [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
            [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.centerY.equalTo(self.view.mas_centerY);
            }];
        }
        NSRange rangeb = [request.URL.absoluteString rangeOfString:@"/uc/login"];
        if (rangeb.location != NSNotFound) {
            _hidWeb = YES;
        }
        NSRange rangec = [request.URL.absoluteString rangeOfString:@"center/list.action"];
        if (rangec.location != NSNotFound) {
          
            _JDWebView.hidden = YES;
        }
    }

    return YES;
}
- (void)timerStop {
    [self.activityIndicator stopAnimating];
}
#pragma mark - webView 完成加载的方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSRange rangeb = [webView.request.URL.absoluteString rangeOfString:@"//passport.jd.com"];
    if (rangeb.location != NSNotFound) {
        if (_Verify && _Verifyflag == 3) {
            _Verify = NO;
            _Verifyflag = 0;
            _JDWebView.hidden = NO;
            if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                    _HuD.label.text = @"授权失败,...";
                    NSLog(@"JDWebView _HuD.label.text = 授权失败..");

                    [_HuD hideAnimated:YES afterDelay:0.3];
                    self.navigationController.navigationBarHidden = NO;
                });
            }else{
                [self.activityIndicator stopAnimating];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kJoinJDURL]];
                [_JDWebView loadRequest:request];
            }
            return;
        }
    }
    NSRange rangec = [webView.request.URL.absoluteString rangeOfString:@"center/list.action"];
    if (rangec.location != NSNotFound) {
        if (_flag == 3) {
            if (_Verifyflag == 0) {
                _Verify = YES;
                _Verifyflag = 1;
                [self validationCookies:_validationAry];
                 return;
            }
        }else{
            _Verify = NO;
        }
        if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
            [AppDelegate appDelegate].userInfostruct.orderType = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationVerifySuccess object:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                _HuD.label.text = @"授权成功..";
                NSLog(@"JDWebView _HuD.label.text = 授权成功..");
                [_HuD hideAnimated:YES];
                [self popViewControllerPressed];
                self.navigationController.navigationBarHidden = NO;
            });
        }
    }
    NSRange range = [webView.request.URL.absoluteString rangeOfString:@"//m.jd.com"];
    if (range.location != NSNotFound) {
        if (_Verify && _Verifyflag == 2){
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOrderJDURL]];
            [_JDWebView loadRequest:request];
            _Verifyflag = 3;
            return;
        }
    }
     NSLog(@"webViewDidFinishLoad:");
    if (_flag == 2) {

        _flag = 3;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOrderJDURL]];
        [_JDWebView loadRequest:request];
    }
    else if (_flag == 3) {
        _flag = 4;
        
        NSString *jsOrderStr = [webView stringByEvaluatingJavaScriptFromString:@"var dups=[]; var tmp={OrdersDay:0, OrdersWeek:0, OrdersMonth:0}; var d=document.getElementsByClassName('dealtime'); for(var i in d){if(!d[i].textContent) continue; if(dups.indexOf(d[i].textContent)!=-1)continue; dups.push(d[i].textContent); var t=new Date(d[i].textContent.replace(/-/g,'/'));var dt=(new Date()-t)/1000/3600/24; if(dt<1.0) tmp.OrdersDay+=1; if(dt<7.0) tmp.OrdersWeek+=1; if(dt<30.0) tmp.OrdersMonth+=1;}JSON.stringify(tmp);JSON.stringify(tmp);"];
        NSLog(@"jsOrderString --------------%@",jsOrderStr);
   
        _jsOrderString = jsOrderStr;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kuserInfoJDURL]];
        [_JDWebView loadRequest:request];
    }
    else if (_flag == 4) {
        _flag = 5;
        
        NSString *csString = [webView stringByEvaluatingJavaScriptFromString:@"var tmp={Gender:0,AccountName:''};if(document.body.innerHTML.indexOf('if(0==0){')>0){tmp.Gender=1}if(document.body.innerHTML.indexOf('if(1==0){')>0){tmp.Gender=2}tmp.AccountName=document.getElementById('nickName').value;JSON.stringify(tmp);"];
        NSLog(@"jsString --------------%@",csString);
        _jsUserInfoStr = csString;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:khomeJDURL]];
        [_JDWebView loadRequest:request];

    } else if (_flag == 5) {
        _flag = 6;
        NSString *homeString = [webView stringByEvaluatingJavaScriptFromString:@"var tmp={RateLevel:0};var current_level_name=document.getElementById('home-u-level').getAttribute('data-id-u-levelname');var levels=['注册会员','注册会员','铜牌会员','银牌会员','金牌会员','钻石会员'];var current_level=levels.indexOf(current_level_name);tmp.RateLevel=current_level>0?current_level:0;JSON.stringify(tmp);"];
        _homeString = homeString;
    }
    
    NSDictionary *dictone;
    NSString *dataJSONString = @"";
    NSString *str = @"";
    if (_homeString != nil && _homeString.length > 0) {
        str = [_jsOrderString stringByAppendingString:_jsUserInfoStr];
        str = [str stringByAppendingString:_homeString];
        NSString *dataStr = [str stringByReplacingOccurrencesOfString:@"}{" withString:@","];
        dictone =  [self dictionaryWithJsonString:dataStr];
        [dictone setValue:@"" forKey:@"Verification"];
        dataJSONString = [dictone JSONString];
        _dataJSONString = dataJSONString;
        
    } else { //JS无数据时 _jsOrderString = nil
   
       str =  _jsUserInfoStr;
       dictone =  [self dictionaryWithJsonString:str];
       [dictone setValue:@"" forKey:@"OrdersWeek"];
       [dictone setValue:@"" forKey:@"WaitRate"];
       [dictone setValue:@"" forKey:@"WaitConfirm"];
       [dictone setValue:@"" forKey:@"WaitPay"];
       [dictone setValue:@"" forKey:@"OrdersMonth"];
       [dictone setValue:@"" forKey:@"OrdersDay"];
       [dictone setValue:@"" forKey:@"Verification"];
        dataJSONString = [dictone JSONString];
    }
    
    if (_dataJSONString != nil && _dataJSONString.length > 0 && _flag == 6 && !_bol) {
        _flag = 7;
        [self submitManagementAccountDatas];
    } 
}
#pragma mark - 京东Data的获取
- (void)getJDData {
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    NSDictionary *dic = @{
                          @"task": @"get_scripts",
                          @"platform": @"jd",
                          @"device_type": @"ios",
                          @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            NSString *jsDataString = @"";
            NSDictionary *dictone;
            if ([dict objectForKey:@"data"] && ![[dict objectForKey:@"data"] isKindOfClass:[NSNull class]] && [[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"data"]];

                for (int i = 0; i < array.count; i ++) {
                    NSDictionary *tempDict = [array objectAtIndex:i];
                    
                    NSString *pathstr = [tempDict objectForKey:@"path"];
                    if (pathstr && ![pathstr isKindOfClass:[NSNull class]]) {
                        NSString *path = [NSString stringWithFormat:@"%@",pathstr];

                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
                        [_JDWebView loadRequest:request];
                    }
                    
                    NSString *scriptstr = [tempDict objectForKey:@"script"];
                    if (scriptstr && ![scriptstr isKindOfClass:[NSNull class]]) {
//                        scriptstr = [scriptstr stringByAppendingString:@"JSON.stringify(tmp);"];
                        NSString *tmpStr = [_JDWebView stringByEvaluatingJavaScriptFromString:scriptstr];
                        jsDataString =  [jsDataString stringByAppendingString:tmpStr];
                        jsDataString = [jsDataString stringByReplacingOccurrencesOfString:@"}{" withString:@","];
                        
                    }
                }
            }
            
            dictone = [self dictionaryWithJsonString:jsDataString];
            [dictone setValue:@"" forKey:@"Verification"];
            _dataJSONString = [dictone JSONString];


        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
#pragma mark 字典转JSON字符串方法
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - 提交管理小号
- (void)submitManagementAccountDatas {
    _bol = YES;
    NSString *URLString = [NSString stringWithFormat:@"%@",KASSURL];//KASSURL
    NSDictionary *dic = @{
                          @"Cookies": _cookieJSONString,
                          @"Data": _dataJSONString,
                          @"platform": @"jd",
                          };
    NSString *postData = [dic JSONString];
    NSDictionary *dict = @{
                           @"task": @"login_tbaccount",
                           @"device_type": @"ios",
                           @"post_data": postData,
                           @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager POST:URLString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
//            NSString *msg = [dict objectForKey:@"msg"];
            if (code == 0) {
                if (  [AppDelegate appDelegate].userInfostruct.orderType == 6 && _Verify) {
                      [AppDelegate appDelegate].userInfostruct.orderType = 0;
                }
                _bol = YES;
                [[AppDelegate appDelegate].commonmthod showAlert:@"添加成功!"];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationGetTaobaoAccount object:@{@"platform":[NSNumber numberWithInt:kTaskHallPlatformTypeJD]}];
                [self popViewControllerPressed];
                NSLog(@"success");
                
            } else {
                _bol = NO;
                [[AppDelegate appDelegate].commonmthod showAlert:@"添加失败，请重新操作."];
                [self popViewControllerPressed];
            }
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _bol = NO;
        NSLog(@"error");
    }];
    
}

- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"登录网络游戏";
    [self.leftButton setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(popViewControllerPressed)];
}
- (void)popViewControllerPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
