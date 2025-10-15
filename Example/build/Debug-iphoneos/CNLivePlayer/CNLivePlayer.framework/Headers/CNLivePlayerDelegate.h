//
//  CNLivePlayerDelegate.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/10/24.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

/**
 * 播放器协议
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIView;
@class UIImageView;
@class CNLivePlayer;
/**
 发送队列的代理协议。
 
 @since v1.0.0
 */
@protocol CNLivePlayerDelegate <NSObject>

@optional

/**
 告知代理对象 CNLivePlayer 即将开始进入后台播放任务
 
 @param player 调用该代理方法的 CNLivePlayer 对象
 
 @since v1.0.0
 */
- (void)playerWillBeginBackgroundTask:(nonnull CNLivePlayer *)player;

/**
 告知代理对象 CNLivePlayer 即将结束后台播放状态任务
 
 @param player 调用该方法的 CNLivePlayer 对象
 
 @since v1.0.0
 */
- (void)playerWillEndBackgroundTask:(nonnull CNLivePlayer *)player;

/**
 告知代理对象播放器状态变更
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param state  变更之后的 CNLivePlayer 状态
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player statusDidChange:(CNLivePlayerStatus)state;

/**
 告知代理对象播放器因错误停止播放
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param error  携带播放器停止播放错误信息的 NSError 对象  code  -1  鉴权失败    -2  获取url失败

 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player stoppedWithError:(nullable NSError *)error;

/**
 点播已缓冲区域
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param timeRange  CMTime , 表示从0时开始至当前缓冲区域，单位秒。
 
 @warning 仅对点播有效
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player loadedTimeRange:(CMTime)timeRange;

/**
 回调将要渲染的帧数据
 该功能只支持直播
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param frame 将要渲染帧 YUV 数据。
 CVPixelBufferGetPixelFormatType 获取 YUV 的类型。
 软解为 kCVPixelFormatType_420YpCbCr8Planar.
 硬解为 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange.
 @param pts 显示时间戳 单位ms
 @param sarNumerator
 @param sarDenominator
 其中sar 表示 storage aspect ratio
 视频流的显示比例 sarNumerator sarDenominator
 @discussion sarNumerator = 0 表示该参数无效
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator;

/**
 回调音频数据
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param audioBufferList 音频数据
 @param audioStreamDescription 音频格式信息
 @param pts 显示时间戳 是解码器进行显示帧时相对于SCR（系统参考）的时间戳。SCR可以理解为解码器应该开始从磁盘读取数据时的时间
 @param sampleFormat 采样位数 枚举：CNLivePlayerAVSampleFormat
 @return audioBufferList 音频数据
 
 @since v1.0.0
 */
- (nonnull AudioBufferList *)player:(nonnull CNLivePlayer *)player willAudioRenderBuffer:(nonnull AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(CNLivePlayerAVSampleFormat)sampleFormat;

/**
 回调 SEI 数据
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param SEIData SEI数据
 @param ts 含有SEI数据的视频帧对应的时间戳
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player SEIData:(nullable NSData *)SEIData ts:(int64_t)ts;

/**
 音视频渲染首帧回调通知
 
 @param player 调用该方法的 CNLivePlayer 对象
 @param firstRenderType 音视频首帧回调通知类型
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player firstRender:(CNLivePlayerFirstRenderType)firstRenderType;

/**
 视频宽高数据回调通知

 @param player 调用该方法的 CNLivePlayer 对象
 @param width 视频流宽
 @param height 视频流高
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player width:(int)width height:(int)height;

/**
 seekTo 完成的回调通知
 
 @param player 调用该方法的 CNLivePlayer 对象
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player seekToCompleted:(BOOL)isCompleted;

/**
 switchRate 完成的回调通知
 
 @param player 调用该方法的 CNLivePlayer 对象
 
 @since v1.0.0
 */
- (void)player:(nonnull CNLivePlayer *)player switchRateCompleted:(BOOL)isCompleted;

@end

NS_ASSUME_NONNULL_END
