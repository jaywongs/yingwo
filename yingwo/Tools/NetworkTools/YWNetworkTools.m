//
//  XWNetworkTools.m
//  yingwo
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWNetworkTools.h"

@implementation YWNetworkTools



+ (instancetype)shareNetworkToolsWithBaseUrl {
    
    static YWNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURL *url = [NSURL URLWithString:BASE_URL];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        instance = [[self alloc]initWithBaseURL:url sessionConfiguration:config];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];

    });
    return instance;
}

static BOOL networkStatus = YES;

+ (BOOL)networkStauts {

    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络状态");
                networkStatus = NO;
                break;
                
            case 0:
                NSLog(@"无网络");
                networkStatus = NO;
                [SVProgressHUD showErrorStatus:@"网络连接错误" afterDelay:HUD_DELAY];
                break;
                
            case 1:
                NSLog(@"蜂窝数据网");
                networkStatus = YES;
                break;
                
            case 2:
                NSLog(@"WiFi网络");
                networkStatus = YES;
                break;
                
            default:
                break;
        }
        
    }] ;
    
    [manager startMonitoring];
    
    return networkStatus;
}

+ (void)AFNetworkStatus {
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络状态");
                break;
                
            case 0:
                NSLog(@"无网络");
                break;

            case 1:
                NSLog(@"蜂窝数据网");
                break;
                
            case 2:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}

+ (void)cookiesValueWithKey:(NSString *)key{
    NSData *saveCookiesData      = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: saveCookiesData forKey: key];
}

+ (void)loadCookiesWithKey:(NSString *)key {
    
    NSArray *loadCookies               = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:key]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookies in loadCookies){
        [cookieStorage setCookie: cookies];
      //  NSLog(@"%@", cookies);
    }
}

+ (void)deleteCookiesWithKey:(NSString *)key
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name] isEqualToString:key]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}

+ (void)saveDeviceToken:(NSString *)token {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (token.length == 0) {
        
        [userDefault setObject:@"模拟测试" forKey:TOKEN_KEY];
        
    }
    else{
        [userDefault setObject:token forKey:TOKEN_KEY];
    }
    
}

+ (NSString *)getDeviceToken {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken       = [userDefault objectForKey:TOKEN_KEY];
    
    if (deviceToken.length == 0) {
        deviceToken = @"1111111111111111111111111111111111111111111111111111111111111111";
    }

    return deviceToken;
}

+ (void)postDeviceToken {
    
    NSDictionary *parameters = @{@"device_token":[YWNetworkTools getDeviceToken]};

    [YWRequestTool YWRequestPOSTWithURL:DEVICE_TOKEN_URL
                              parameter:parameters
                           successBlock:^(id success) {
                               
                               NSLog(@"device token提交成功～%@",success);
                               
                               
                           } errorBlock:^(id error) {
                               
                           }];

}

@end
