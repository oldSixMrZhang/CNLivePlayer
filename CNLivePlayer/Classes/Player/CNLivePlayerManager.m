//
//  CNLivePlayerManager.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

#import "CNLivePlayerManager.h"
#import "CNLivePlayerRequest.h"
#import "CNLivePlayerDBTool.h"

@interface CNLivePlayerManager()
/**
 *  应用ID（只读）
 */
@property (nonatomic, copy, readwrite) NSString *appId;

/**
 *  应用KEY（只读）
 */
@property (nonatomic, copy, readwrite) NSString *appKey;

/**
 *  是否是测试环境
 */
@property (nonatomic, assign, readwrite) BOOL isTestEnvironment;

/**
 *  用户ID
 */
@property (nonatomic, copy, readwrite) NSString *userId;

/**
 *  ChannelName 网++定制
 */
@property (nonatomic, copy, readwrite) NSString *channelName;

/**
 *  tag 网++定制
 */
@property (nonatomic, copy, readwrite) NSString *tag;

/**
 *  from 网++定制
 */
@property (nonatomic, copy, readwrite) NSString *from;

@end

@implementation CNLivePlayerManager
static CNLivePlayerManager *_instance = nil;

+ (CNLivePlayerManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        //清除播放器鉴权缓存
        [CNLivePlayerManager clearAuthentication];
        [[CNLivePlayerDBTool shared] createTable];

    });
    
    return _instance;
}

- (void)initWithAppId:(NSString *)appId appKey:(NSString *)appKey {
    [self initWithAppId:appId appKey:appKey isTestEnvironment:NO];
}

- (void)initWithAppId:(NSString *)appId appKey:(NSString *)appKey isTestEnvironment:(BOOL)isTestEnvironment {
    _instance.appId  = appId ? appId : @"";
    _instance.appKey = appKey ? appKey : @"";
    _instance.isTestEnvironment = isTestEnvironment;
    [CNLivePlayerRequest getAuthentication];
}

/**
* @abstract      初始化直播云SDK(该方法默认正式环境)
* @param         appId              在open.cnlive.com网站申请得到的appId
* @param         appKey             在open.cnlive.com网站申请得到的appKey
* @warning       必传参数
*
*/
+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey{
    [[CNLivePlayerManager manager] initWithAppId:appId appKey:appKey];
}

/**
*
* @abstract      初始化直播云SDK
* @param         appId              在open.cnlive.com网站申请得到的appId
* @param         appKey             在open.cnlive.com网站申请得到的appKey
* @param         isTestEnvironment  YES:测试环境  NO:正式环境
* @warning       必传参数
*
*/
+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey isTestEnvironment:(BOOL)isTestEnvironment{
    [[CNLivePlayerManager manager] initWithAppId:appId appKey:appKey isTestEnvironment:isTestEnvironment];
}

// 版本号
+ (NSString *)getVersion {
    return @"0.0.1";
}

//清空鉴权
+ (void)clearAuthentication {
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCNLivePlayerAuthentication"];
    if (auth) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kCNLivePlayerAuthentication"];
    }
    
}

#pragma mark - Getter方法
- (NSString *)appId{
    return _appId?_appId:@"";
}

- (NSString *)appKey{
    return _appKey?_appKey:@"";
}

- (NSString *)userId{
    return _userId?_userId:@"";
}

- (NSString *)tag{
    return _tag?_tag:@"";
}

- (NSString *)channelName{
    return _channelName?_channelName:@"";
}

- (BOOL)isAuthentication{
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCNLivePlayerAuthentication"];
    return [auth isEqualToString:@"0"];
}

@end
