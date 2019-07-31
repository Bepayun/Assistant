//
//  TaoBaoWebView.m
//  assistant
//
//  Created by Bepa  on 2017/9/13.
//  Copyright © 2017年 Bepa. All rights reserved.
//

#import "TaoBaoWebView.h"

@interface TaoBaoWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext* jsContext;
@property (nonatomic, strong) UIWebView* taoBaoWebView;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, strong) NSString* buyerTradesJSStr;
@property (nonatomic, strong) NSString* cookieJSONString;
@property (nonatomic, strong) NSString* dataJSONString;
@property (nonatomic, strong) NSMutableArray* validationAry; // 验证数组

@property (nonatomic, strong) NSString* nameStr;
@property (nonatomic, strong) NSString* valueStr;
@property (nonatomic, strong) NSString* expiresDate;
@property (nonatomic, strong) NSString* pathStr;
@property (nonatomic, strong) MBProgressHUD* HuD;

@property (nonatomic, assign) BOOL hidWeb;
@property (nonatomic, assign) BOOL verify;

@end

@implementation TaoBaoWebView

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
    //
    self.view.backgroundColor = [UIColor whiteColor];
    // 清除cookies
    NSHTTPCookie* cookie;
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    // 清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache* cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];

    _hidWeb = NO;
    _verify = NO;
    _taoBaoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-64)];
    _taoBaoWebView.delegate = self;
   
    [self.view addSubview: _taoBaoWebView];
    if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
        _verify = YES;
         _taoBaoWebView.hidden = YES;
        [self validationCookiesWithArray:[AppDelegate appDelegate].cookieArray];
        _HuD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _HuD.label.text = @"等待授权..";
        NSLog(@"TAOBAOWebView _HuD.label.text = 等待授权..");
   
    } else {
        _taoBaoWebView.hidden = NO;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kLoginTabBaoURL]];
        [_taoBaoWebView loadRequest:request];
    }
    //
    _validationAry = [NSMutableArray arrayWithCapacity:0];
    self.jsContext = [_taoBaoWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self createNav];
}
#pragma mark - 获取淘宝的cookies
- (void)getTaoBaoCookies {
    
    NSURL* urlString = [NSURL URLWithString:kLoginTabBaoURL];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    NSMutableArray* cookiesAry = [[NSMutableArray alloc] initWithCapacity:0];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        // 转换NSURLResponse成为HTTPResponse
        NSHTTPURLResponse* HTTPResponse = (NSHTTPURLResponse* )response;
        // 获取headerfields
        NSDictionary* fields = [HTTPResponse allHeaderFields]; // 原生NSURLConnection写法
        if (fields != nil && ![fields isKindOfClass:[NSNull class]]){
            NSLog(@"fields = %@",[fields description]);
            NSString* set_cookies = [fields objectForKey:@"Set-Cookie"];
            NSArray* array = [set_cookies componentsSeparatedByString:@";"];
            for (int i = 0; i<array.count; i++) {
                NSString* cookie1 = [array objectAtIndex:i];
                NSArray* cookie1Array = [cookie1 componentsSeparatedByString:@"="];
                if (cookie1Array.count >= 2) {
                    NSString* nameStr = [cookie1Array objectAtIndex:0];
                    NSString* valueStr = [cookie1Array objectAtIndex:1];
                    if ([nameStr hasSuffix:@"Expires"]) {
                       _expiresDate = [[AppDelegate appDelegate].commonmthod formattingTimeString:valueStr];
                    }
                    if ([nameStr hasSuffix:@"Path"]){
                        _pathStr = valueStr;
                    }
                    if ([nameStr hasSuffix:@"ucn"]){
                        _nameStr = nameStr;
                        _valueStr = valueStr;
                        
                    }
                }
            }
        }
        NSHTTPCookieStorage* cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary* jsonCookieDic = [[NSDictionary alloc] init];
        NSDictionary* Dic = [[NSDictionary alloc] init];
        for (NSHTTPCookie* cookie in [cookieJar cookies]) {
//            NSLog(@"cookie%@", cookie);
            if ([cookie isKindOfClass:[NSHTTPCookie class]]) {
                NSString* string = [NSString stringWithFormat:@"%@",cookie];
                //
                NSRange  createRange = [string rangeOfString:@"created:"];
                NSString* createString = [[NSString alloc] init];
                if (createRange.location != NSNotFound) {
                    createString = [string substringFromIndex:createRange.location+createRange.length];
                    NSRange  sftRange = [createString rangeOfString:@" +0000"];
                    if (sftRange.location != NSNotFound) {
                        createString = [createString substringToIndex:sftRange.location];
                    }
                }
                
                //
                NSRange  partitionRange = [string rangeOfString:@"partition:\""];
                NSString* partitionString = [[NSString alloc] init];
                if (partitionRange.location != NSNotFound) {
                    partitionString = [string substringFromIndex:partitionRange.location+partitionRange.length];
                    NSRange  partitionsftRange = [partitionString rangeOfString:@"\" path:"];
                    partitionString = [partitionString  substringToIndex:partitionsftRange.location];
                }

                //
//                NSString* expiresDate = [NSString stringWithFormat:@"%ld", (long)[cookie.expiresDate timeIntervalSince1970]];
                NSDateFormatter* dateF = [[NSDateFormatter alloc] init];
                dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate* creatDate = [dateF dateFromString:createString];
                NSString* createdDate = [NSString stringWithFormat:@"%.f", [creatDate timeIntervalSince1970]];
                
                jsonCookieDic = @{
                                   @"CreationTime": createdDate,
                                   @"Host": [NSString stringWithFormat:@"%@",cookie.domain],
                                   @"Expiry": _expiresDate,
                                   @"IsDomain": @"true",
                                   @"IsHttpOnly": @"false",
                                   @"isSecure": @"false",
                                   @"IsSession": @"false",//android is true
                                   @"LastAccessed": createdDate,
                                   @"Name": [NSString stringWithFormat:@"%@",cookie.name],
                                   @"Path": _pathStr,
                                   @"RawHost": [NSString stringWithFormat:@"%@",cookie.domain],
                                   @"Value":[NSString stringWithFormat:@"%@",cookie.value],
                                   @"Partition": partitionString,
                                   @"version": [NSString stringWithFormat:@"%lu",(unsigned long)cookie.version]
                                   };

                // Set-Cookie里面的name与value
                Dic = @{
                          @"CreationTime": createdDate,
                          @"Host": [NSString stringWithFormat:@"%@",cookie.domain],
                          @"Expiry": _expiresDate,
                          @"IsDomain": @"true",
                          @"IsHttpOnly": @"false",
                          @"isSecure": @"false",
                          @"IsSession": @"false",//android is true
                          @"LastAccessed": createdDate,
                          @"Name": _nameStr,
                          @"Path": _pathStr,
                          @"RawHost": [NSString stringWithFormat:@"%@",cookie.domain],
                          @"Value":_valueStr,
                          @"Partition": partitionString,
                          @"version": [NSString stringWithFormat:@"%lu",cookie.version]
                          };
            }
            NSLog(@"jsonCookieDic------------------------- %@",jsonCookieDic);
            [cookiesAry addObject:jsonCookieDic];
       }

        [cookiesAry addObject:Dic];
        
        NSString* jsonStr = [[NSString alloc] init];
        jsonStr = [cookiesAry JSONString];
        _cookieJSONString = jsonStr;
        NSLog(@"jsonStr----------------- %@",jsonStr);
        
        if (_validationAry.count > 0) {
            [_validationAry removeAllObjects];
        }
        [_validationAry addObjectsFromArray:cookiesAry];
        if (_verify) {
            [self validationCookiesWithArray:cookiesAry];
        }
    }];
}
#pragma mark - 验证淘宝号 {
- (void)validationCookiesWithArray:(NSArray* )array{
    
    // 清除cookies
    NSHTTPCookie* cookie;
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    if (array != nil && array.count > 0) {
        for (NSDictionary* cookie in array){
            NSMutableDictionary* cookieProperties = [NSMutableDictionary dictionary];
            
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
                [cookieProperties setObject:[cookie objectForKey:@"Host"] forKey:NSHTTPCookieDomain];
                
            }
            if ([cookie objectForKey:@"RawHost"] != nil && ![[cookie objectForKey:@"RawHost"] isKindOfClass:[NSNull class]]){
                [cookieProperties setObject:[cookie objectForKey:@"RawHost"] forKey:NSHTTPCookieDomain];
            }
            
            NSHTTPCookie* cookieuser = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithDictionary:cookieProperties]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
            
        }
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kLoginTabBaoURL]];
        [_taoBaoWebView loadRequest:request];
    }
    
}
#pragma mark -------- }

- (BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSRange range = [request.URL.absoluteString rangeOfString:@"//buyertrade.taobao.com"];
    
    
        if (range.location != NSNotFound) {
            if (_hidWeb) {
                [self getTaoBaoCookies];
                _hidWeb = NO;
                return NO;
                
            }else{
                
                if (_validationAry.count > 0) {
                      _taoBaoWebView.hidden = YES;
                      self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
                      [self.view addSubview:self.activityIndicator];
                      self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                      [self.activityIndicator startAnimating];
                      [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
                      [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker* make) {
                        make.centerX.equalTo(self.view.mas_centerX);
                        make.centerY.equalTo(self.view.mas_centerY);
                      }];
                    }
                _verify = YES;
                return YES;
            }
        }
    NSRange rangeb = [request.URL.absoluteString rangeOfString:@"/login.jhtml"];
    if (rangeb.location != NSNotFound) {
        
    }else{
        _hidWeb = YES;
    }
    return YES;
}
- (void)timerStop {
    [self.activityIndicator stopAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView* )webView {
    NSRange range = [webView.request.URL.absoluteString rangeOfString:@"//buyertrade.taobao.com"];
    if (range.location != NSNotFound) {
        if ( [AppDelegate appDelegate].userInfostruct.orderType == 6 && _verify) {
            [AppDelegate appDelegate].userInfostruct.orderType = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationVerifySuccess object:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                _HuD.label.text = @"授权成功..";
                NSLog(@"TAOBAOWebView _HuD.label.text = 授权成功..");
                [_HuD hideAnimated:YES];
                [self popViewControllerPressed];
                 self.navigationController.navigationBarHidden = NO;
            });
            
        }
    }
    NSRange rangeb = [webView.request.URL.absoluteString rangeOfString:@"//login.m.taobao.com/login"];
    if (rangeb.location != NSNotFound) {
        if ([AppDelegate appDelegate].userInfostruct.orderType == 6) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _HuD.label.text = @"授权失败,...";
                NSLog(@"TAOBAOWebView _HuD.label.text = 授权失败..");
                [_HuD hideAnimated:YES afterDelay:0.3];
                _taoBaoWebView.hidden = NO;
                self.navigationController.navigationBarHidden = NO;
            });
        }
        return;
    }
    NSLog(@"webViewDidFinishLoad:");
    //获取网页title:NSString* lJs2 = @"document.title";
    NSString* thisHtml = @"document.documentElement.innerHTML";
    NSString* thisHtmlSource = [webView stringByEvaluatingJavaScriptFromString:thisHtml];
    NSRange rangea = [thisHtmlSource rangeOfString:@"var data = JSON.parse('"];
    if (rangea.location != NSNotFound) {

        NSString* rangestr = [thisHtmlSource substringFromIndex:rangea.length+rangea.location];
        NSRange rangeb = [rangestr rangeOfString:@"</script>"];
        if (rangeb.location != NSNotFound) {
            
            NSString* buyerTradesJSStr = [rangestr substringToIndex:rangeb.location];
            _buyerTradesJSStr = buyerTradesJSStr;
            NSLog(@"buyerTradesJSStr---------- %@",buyerTradesJSStr);
        
            NSURLRequest* requestTwo = [NSURLRequest requestWithURL:[NSURL URLWithString:kJoinTabBaoURL]];
            [_taoBaoWebView loadRequest:requestTwo];
            
            return;
        }
    }
    
    NSString* jsString = [webView stringByEvaluatingJavaScriptFromString:@"var tmp={}; if(document.getElementById('new-rate-content').innerHTML.indexOf('卖家累积信用') != -1){tmp.IsSeller=true;}else{tmp.IsSeller=false;} var c=document.getElementsByClassName('box-bd')[0].children[0]; tmp.AccountName=c.children[1].textContent; var e=c.lastElementChild.firstElementChild; if(e){tmp.Verification=e.firstElementChild.getAttribute('title');}else{tmp.Verification='';} tmp.Rate=parseInt(document.getElementsByClassName('ico-buyer')[0].children[0].textContent); c=document.getElementsByClassName('tb-rate-table'); c=c[c.length-2].children[1]; d=c.children[0]; tmp.GoodRatesWeek=1*d.children[1].textContent; tmp.GoodRatesMonth=1*d.children[2].textContent; tmp.GoodRatesHalfYear=1*d.children[3].textContent; d=c.children[1]; tmp.NeutralRatesWeek=1*d.children[1].textContent; tmp.NeutralRatesMonth=1*d.children[2].textContent; tmp.NeutralRatesHalfYear=1*d.children[3].textContent; d=c.children[2]; tmp.BadRatesWeek=1*d.children[1].textContent; tmp.BadRatesMonth=1*d.children[2].textContent; tmp.BadRatesHalfYear=1*d.children[3].textContent; d=c.children[3]; tmp.TotalRatesWeek=1*d.children[1].textContent; tmp.TotalRatesMonth=1*d.children[2].textContent; tmp.TotalRatesHalfYear=1*d.children[3].textContent;JSON.stringify(tmp);"];
    
    NSDictionary* dictone;
    if (jsString != nil && jsString.length > 0) {
        dictone =  [self dictionaryWithJsonString:jsString];
        [dictone setValue:_buyerTradesJSStr forKey:@"BuyerTrades"];
    
    } else { //JS无数据时
        dictone = @{
                    @"GoodRatesHalfYear": @"",
                    @"GoodRatesWeek": @"",
                    @"BadRatesWeek": @"",
                    @"NeutralRatesHalfYear": @"",
                    @"TotalRatesHalfYear": @"",
                    @"GoodRatesMonth": @"",
                    @"IsSeller": @"false",
                    @"TotalRatesMonth": @"",
                    @"BuyerTrades": [NSString stringWithFormat:@"%@",_buyerTradesJSStr],
                    @"Verification": @"",
                    @"TotalRatesWeek": @"",
                    @"AccountName": @"",
                    @"NeutralRatesMonth": @"",
                    @"NeutralRatesWeek": @"",
                    @"BadRatesMonth": @"",
                    @"Rate": @"",
                    @"BadRatesHalfYear": @"",
                    };
    }
    
    
    NSString* dataJSONString = [dictone JSONString];
    _dataJSONString = dataJSONString;

    if (_buyerTradesJSStr != nil && _buyerTradesJSStr.length > 0) {
        [self submitManagementAccountDatas];
    }
}
- (NSDictionary* )dictionaryWithJsonString:(NSString* )jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark - 提交管理小号
- (void)submitManagementAccountDatas {

    NSString* URLString = [NSString stringWithFormat:@"%@",KASSURL];
    NSDictionary* dic = @{
                           @"Cookies": _cookieJSONString,
                           @"Data": _dataJSONString,
                           @"platform": @"taobao",
                           };
    NSString* postData = [dic JSONString];
    NSDictionary* dict = @{
        @"task": @"login_tbaccount",
        @"device_type": @"ios",
        @"post_data": postData,
        @"HTTP_CLIENT_TOKEN": [AppDelegate appDelegate].userInfostruct.client_token
                          };
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager POST:URLString parameters:dict progress:nil success:^(NSURLSessionDataTask*  _Nonnull task, id  _Nullable responseObject) {
        
        int code = -1;
        if (responseObject && ![responseObject isKindOfClass:[NSNull class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary* )responseObject;
            
            if ([dict objectForKey:@"code"] && ![[dict objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                code = [[dict objectForKey:@"code"] intValue];
            }
            
            if (code == 0) {
                if ([AppDelegate appDelegate].userInfostruct.orderType == 6 && _verify) {
                    [AppDelegate appDelegate].userInfostruct.orderType = 0;
                    [AppDelegate appDelegate].cookieString = _cookieJSONString;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationGetTaobaoAccount object:@{@"platform":[NSNumber numberWithInt:kTaskHallPlatformTypeTaoBao]}];
                    [self popViewControllerPressed];
                    
                } else {
                  [[AppDelegate appDelegate].commonmthod showAlert:@"添加成功!"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationGetTaobaoAccount object:@{@"platform":[NSNumber numberWithInt:kTaskHallPlatformTypeTaoBao]}];
                  [self popViewControllerPressed];
                }
                NSLog(@"success");

            } else {
                [[AppDelegate appDelegate].commonmthod showAlert:@"添加失败，请重新操作."];
                [self popViewControllerPressed];
            }
           
        }
        
    } failure:^(NSURLSessionDataTask*  _Nullable task, NSError*  _Nonnull error) {
    
        NSLog(@"error");
    }];
  
}
- (void)createNav {
    self.navigationController.navigationBar.translucent = NO;
    self.titleLabel.text = @"登录热门游戏";
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
