//
//  CNLivePlayerManager.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

/**
 * 播放器管理类
 * 设置appId和appKey
 */

#import <Foundation/Foundation.h>

#define Player_AppID                 [CNLivePlayerManager manager].appId
#define Player_AppKey                [CNLivePlayerManager manager].appKey
#define Player_UserId                [CNLivePlayerManager manager].userId
#define Player_Tag                   [CNLivePlayerManager manager].tag
#define Player_ChannelName           [CNLivePlayerManager manager].channelName
#define Player_TestEnvironment       [CNLivePlayerManager manager].isTestEnvironment
#define Player_Authentication        [CNLivePlayerManager manager].isAuthentication

NS_ASSUME_NONNULL_BEGIN

@interface CNLivePlayerManager : NSObject

+ (CNLivePlayerManager *)manager;

/**
 *  应用ID（只读）
 */
@property (nonatomic, copy, readonly) NSString *appId;

/**
 *  应用KEY（只读）
 */
@property (nonatomic, copy, readonly) NSString *appKey;

/**
 *  是否是测试环境
 */
@property (nonatomic, assign, readonly) BOOL isTestEnvironment;

/**
 *  用户ID
 */
@property (nonatomic, copy, readonly) NSString *userId;

/**
 *  ChannelName 网++定制
 */
@property (nonatomic, copy, readonly) NSString *channelName;

/**
 *  tag 网++定制
 */
@property (nonatomic, copy, readonly) NSString *tag;

/**
 *  from 网++定制
 */
@property (nonatomic, copy, readonly) NSString *from;

/**
 *  isAuthentication 是否鉴权成功
 */
@property (nonatomic, assign, readonly) BOOL isAuthentication;

/**
* @abstract      初始化直播云SDK(该方法默认正式环境)
* @param         appId              在open.cnlive.com网站申请得到的appId
* @param         appKey             在open.cnlive.com网站申请得到的appKey
* @warning       必传参数
*
*/
+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey;

/**
*
* @abstract      初始化直播云SDK
* @param         appId              在open.cnlive.com网站申请得到的appId
* @param         appKey             在open.cnlive.com网站申请得到的appKey
* @param         isTestEnvironment  YES:测试环境  NO:正式环境
* @warning       必传参数
*
*/
+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey isTestEnvironment:(BOOL)isTestEnvironment;

/**
*
* 获取版本号
*
* @return 获取版本号
*
*/
+ (NSString *)getVersion;

@end

NS_ASSUME_NONNULL_END
