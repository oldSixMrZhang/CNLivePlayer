//
//  CNLivePlayerRequest.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

/**
 * 数据请求
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ResultsBlock) (NSString * _Nullable videoUrl, NSError * _Nullable error);

@interface CNLivePlayerRequest : NSObject

#pragma mark - 鉴权
// 获取鉴权
+ (void)getAuthentication;
+ (void)getAuthenticationBlock:(void (^)(NSString * _Nullable code, NSError * _Nullable error))block;

#pragma mark - 点播
// 获取点播播放地址
+ (void)getVodVideoURLWithVideoId:(NSString *)videoId rate:(NSString *)rate block:(nullable ResultsBlock)block;

#pragma mark - 直播
// 获取直播播放地址
+ (void)getLiveVideoURLWithActivityId:(NSString *)activityId channelId:(NSString *)channelId rate:(NSString *)rate block:(nullable ResultsBlock)block;

#pragma mark - 公共方法
// 获取播放地址
+ (void)getVideoURL:(nullable NSString *)URL parameter:(nullable NSDictionary *)parameter block:(nullable ResultsBlock)block;

+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request success:(void (^)(NSURLResponse * _Nullable, id _Nullable))success failure:(void (^)(NSURLResponse * _Nullable, NSError * _Nullable))failure;

@end

NS_ASSUME_NONNULL_END
