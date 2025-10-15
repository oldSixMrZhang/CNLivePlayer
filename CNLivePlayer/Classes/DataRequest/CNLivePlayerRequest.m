//
//  CNLivePlayerRequest.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

#import "CNLivePlayerRequest.h"
#import "CommonCrypto/CommonDigest.h"

#import "CNLivePlayerUrl.h"
#import "CNLivePlayerManager.h"

@implementation CNLivePlayerRequest

#pragma mark - 鉴权
// 获取鉴权
+ (void)getAuthentication{
    [self getAuthenticationBlock:^(NSString * _Nullable code, NSError * _Nullable error) {
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"kCNLivePlayerAuthentication"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
}

+ (void)getAuthenticationBlock:(void (^)(NSString * _Nullable code, NSError * _Nullable error))block {
    if(Player_Authentication){
        block?block(@"0", nil):@"";
        return;
    }
    NSDictionary *parameter = @{@"platform_id": [NSBundle mainBundle].bundleIdentifier,
                                @"timestamp": [self getTimestamp],
                                @"appId": Player_AppID};
    NSString *dicString = [NSString stringWithFormat:@"%@&key=%@", [self dictionaryToSignValue:parameter], Player_AppKey];
    NSString *signString = [[self sha1:dicString] uppercaseString];
    
    NSString *url = [NSString stringWithFormat:@"%@?%@&sign=%@", authUrl, [self dictionaryToSignValue:parameter], signString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setTimeoutInterval:30.0];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:urlRequest success:^(NSURLResponse * _Nullable response, id _Nullable data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"errorCode"] forKey:@"kCNLivePlayerAuthentication"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            block?block(dic[@"errorCode"], nil):@"";
        }else{
            block?block(nil, nil):@"";
        }

    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
        block?block(code, error):@"";
    }];
    [task resume];
}

#pragma mark - 点播
// 获取点播播放地址
+ (void)getVodVideoURLWithVideoId:(NSString *)videoId rate:(NSString *)rate block:(nullable ResultsBlock)block{
    NSDictionary *parameter = @{@"appId": Player_AppID,
                                    @"vId": videoId,
                                    @"timestamp": [self getTimestamp],
                                    @"isHLS": @"1",
                                    @"plat": @"i",
                                    @"playType": @"v",
                                    @"rate": rate?rate:@"2",
                                    @"platform_id": [NSBundle mainBundle].bundleIdentifier,
                                    @"channelName": Player_ChannelName,
                                    @"tag": Player_Tag,
                                    @"from": @"apple",
                                    @"sid":Player_UserId,
                                    @"uid": [self getUid]};
    NSString *dicString = [NSString stringWithFormat:@"%@&key=%@", [self dictionaryToSignValue:parameter], Player_AppKey];
       
    NSString *signString = [[self sha1:dicString] uppercaseString];
       
    NSString *url = [NSString stringWithFormat:@"%@?%@&sign=%@", vodUrl, [self dictionaryToSignValue:parameter], signString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setTimeoutInterval:30.0];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:urlRequest success:^(NSURLResponse * _Nullable response, id _Nullable data) {
        block?block(response.URL.absoluteString, nil):@"";
        
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
        block?block(response.URL.absoluteString, error):@"";

    }];
    [task resume];
    
}

#pragma mark - 直播
// 获取直播播放地址
+ (void)getLiveVideoURLWithActivityId:(NSString *)activityId channelId:(NSString *)channelId rate:(NSString *)rate block:(nullable ResultsBlock)block {
    NSDictionary *parameter = @{@"appId": Player_AppID,
                                @"activityId": activityId ? activityId : @"",
                                @"channelId": channelId ? channelId : @"",
                                @"rate": rate ? rate : @"2",
                                @"timestamp": [self getTimestamp],
                                @"isHLS": @"1",
                                @"plat": @"i",
                                @"playType": @"v",
                                @"platform_id": [NSBundle mainBundle].bundleIdentifier,
                                @"channelName": Player_ChannelName,
                                @"tag": Player_Tag,
                                @"from": @"apple",
                                @"sid": Player_UserId,
                                @"uid": [self getUid]};
    [self getVideoURL:liveUrl parameter:parameter block:block];

}

// 获取播放地址
+ (void)getVideoURL:(nullable NSString *)URL parameter:(nullable NSDictionary *)parameter block:(nullable ResultsBlock)block{
    NSString *dicString = [NSString stringWithFormat:@"%@&key=%@", [self dictionaryToSignValue:parameter], Player_AppKey];
       
    NSString *signString = [[self sha1:dicString] uppercaseString];
       
    NSString *videoUrl = [NSString stringWithFormat:@"%@?%@&sign=%@", vodUrl, [self dictionaryToSignValue:parameter], signString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:videoUrl]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setTimeoutInterval:30];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                NSError *error = connectionError.userInfo[NSUnderlyingErrorKey];
                NSString *videoUrl302 = error.userInfo[NSURLErrorFailingURLStringErrorKey];
                if (!videoUrl302 || ![videoUrl302 isKindOfClass:[NSString class]] || videoUrl302.length <= 0) {
                    videoUrl302 = nil;
                }
                block?block(videoUrl302, nil):@"";
                
            } else if (response) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                block?block([httpResponse.URL absoluteString], nil):@"";

            } else {
                NSString *domain = @"com.CNLive.Application.ErrorDomain";
                NSString *desc = @"获取播放地址错误";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
                NSError *error = [NSError errorWithDomain:domain code:8888 userInfo:userInfo];
                block?block(videoUrl, error):@"";
                
            }
        });
    }];
}

#pragma mark - 公共方法
+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request success:(void (^)(NSURLResponse * _Nullable, id _Nullable))success failure:(void (^)(NSURLResponse * _Nullable, NSError * _Nullable))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(response,error);
            }
            else {
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if (httpResponse.statusCode < 400) {
                        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        success(httpResponse, jsonObj);
                    }
                    else {
                        NSError *failureError = [NSError errorWithDomain:NSURLErrorDomain code:httpResponse.statusCode userInfo:httpResponse.allHeaderFields];
                        failure(httpResponse, failureError);
                    }
                }
                else {
                    failure(response, error);
                }
            }
        });
    }];
    
    return task;
}

#pragma mark - 工具方法
+ (NSString *)dictionaryToSignValue:(NSDictionary*)parameter {
    //对所有传入参数按照字段名的 ASCII 码从小到大排序
    NSArray *keyArr = [parameter allKeys];
    NSArray *arr = [keyArr sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *string1 = [[NSMutableString alloc]init];
    for (int i = 0; i < arr.count; i++) {
        NSString *parameterString = parameter[[arr objectAtIndex:i]];
        if (parameterString.length > 0) {
            [string1 appendString:[NSString stringWithFormat:@"%@=%@&",[arr objectAtIndex:i],parameter[[arr objectAtIndex:i]]]];
        }
        
    }
    if (string1.length > 0) {
        [string1 deleteCharactersInRange:NSMakeRange(string1.length-1, 1)];
    }
    
    return string1;
}

+ (NSString *)sha1:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    while ([[output substringToIndex:1] isEqualToString:@"0"]) {
        output = [[NSMutableString alloc] initWithString:[output substringFromIndex:1]];
    }
    return output;
}

+ (NSString *)getUid{
    NSString *uid = @"";
    NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
    if ([defauts objectForKey:@"kCNLiveUserDefaultsUIDKey"]) {
        uid = [[defauts objectForKey:@"kCNLiveUserDefaultsUIDKey"] copy];
        return uid;
    }
    else{
        NSString *stamp = [NSString stringWithFormat:@"%.3f", [[NSDate date]  timeIntervalSince1970]];
        stamp = [stamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSString *idfv = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        uid = [NSString stringWithFormat:@"%@_%@", idfv, stamp];
        
        [defauts setObject:uid forKey:@"kCNLiveUserDefaultsUIDKey"];
        [defauts synchronize];
    }
    return uid;
}

+ (NSString *)getTimestamp{
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)time];
    return timeString;
}

@end
