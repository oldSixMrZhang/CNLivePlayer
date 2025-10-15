//
//  CNLivePlayer.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

/**
 * 播放器
 */

#import <UIKit/UIKit.h>
#import <PLPlayerKit/PLPlayerKit.h>      // 播放器
#import "CNLivePlayerTypeDef.h"          // 枚举类型
#import "CNLivePlayerDelegate.h"         // 协议

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock) (void);
typedef void (^FailureBlock) (NSError *error);

@interface CNLivePlayer : NSObject

- (instancetype)initWithUrl:(NSString *)url;

#pragma mark - 视频
#pragma mark - 使用视讯云平台 直接通过节目id播放
/**
 初始化点播播放器  初始化成功后才能对播放器进行设置

 @param videoId 视频Id
 @param success 初始化成功block
 @param failure 初始化失败block 回调一个NSError的对象

 @return 返回CNLivePlayer对象
 
 @since v0.0.1
 */
- (instancetype)initVodPlayWithVideoId:(NSString *)videoId success:(SuccessBlock _Nullable)success failure:(FailureBlock _Nullable)failure;
- (instancetype)initVodPlayWithVideoId:(NSString *)videoId;

/**
 初始化直播播放器

 @param videoId 视频Id
 @param activityId 活动Id
 @param success 初始化成功block
 @param failure 初始化失败block 回调一个NSError的对象

 @return 返回CNLivePlayer对象
 
 @since v0.0.1
 */
- (instancetype)initLivePlayWithVideoId:(NSString *)videoId activityId:(NSString *)activityId success:(SuccessBlock _Nullable)success failure:(FailureBlock _Nullable)failure;
- (instancetype)initLivePlayWithVideoId:(NSString *)videoId activityId:(NSString *)activityId;

#pragma mark - 切换视频
/**
切换视频

@param videoId  视频id
@param type         视频类型         vod 点播视频     live 直播视频

@since v0.0.1
*/
- (void)switchVideo:(NSString *)videoId type:(CNLivePlayerDataType)type;

#pragma mark - 切换码率
/**
切换码率

@param level 视频清晰度

@since v0.0.1
*/
- (void)switchRate:(CNLiveClarityLevel)level;

/*
 开始播放
 @return 是否成功播放

 @since v0.0.1
 */
- (BOOL)play;

/*
 暂停播放当前视频
 
 @since v0.0.1
 */
- (void)pause;

/*
 继续播放当前视频
 
 @since v0.0.1
 */
- (void)resume;

/*
 结束当前视频的播放
 
 @since v0.0.1
 */
- (void)stop;

@property (nonatomic, strong) PLPlayer *player;

/**
 代理对象，用于告知播放器状态改变或其他行为，对象需实现 CNLivePlayerDelegate 协议
 
 @since v0.0.1
 */
@property (nonatomic, weak, nullable) id<CNLivePlayerDelegate> delegate;

/*
可以通过frame设置view大大小

@since v0.0.1
 */
@property(nonatomic, assign) CGRect frame;

/*
 包含视频播放内容的VIEW（只读）
 可以通过frame设置view大大小
 
 @since v0.0.1
 */
@property (nonatomic, strong, readonly) UIView *view;

/*
 支持后台播放
 
 @since v0.0.1
 */
@property (nonatomic, assign) BOOL backgroundPlayEnable;

/**
 @abstract      需要播放的 URL
 
 @discussion    目前支持 http(s) (url 以 http:// https:// 开头) 与 rtmp (URL 以 rtmp:// 开头) 协议。
 
 @since v1.0.0
 */
@property (nonatomic, copy, nonnull, readonly) NSURL *URL;

/**
 CNLivePlayer 的播放状态
 
 @since v1.0.0
 */
@property (nonatomic, assign, readonly) CNLivePlayerStatus status;

/**
 指示当前 CNLivePlayer 是否处于正在播放状态
 
 @since v1.0.0
 */
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;

@end

NS_ASSUME_NONNULL_END
