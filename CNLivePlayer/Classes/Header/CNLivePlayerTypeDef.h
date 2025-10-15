//
//  CNLivePlayerTypeDef.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zCNLive on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

/**
 * 播放器枚举
 */

#ifndef CNLivePlayerTypeDef_h
#define CNLivePlayerTypeDef_h

/**
 @brief 音频采样格式
 
 @since v0.0.1
 */
typedef NS_ENUM(NSInteger, CNLivePlayerAVSampleFormat) {
    CNLivePlayerAV_SAMPLE_FMT_NONE = -1,
    CNLivePlayerAV_SAMPLE_FMT_U8,          ///< unsigned 8 bits
    CNLivePlayerAV_SAMPLE_FMT_S16,         ///< signed 16 bits
    CNLivePlayerAV_SAMPLE_FMT_S32,         ///< signed 32 bits
    CNLivePlayerAV_SAMPLE_FMT_FLT,         ///< float
    CNLivePlayerAV_SAMPLE_FMT_DBL,         ///< double
    
    CNLivePlayerAV_SAMPLE_FMT_U8P,         ///< unsigned 8 bits, planar
    CNLivePlayerAV_SAMPLE_FMT_S16P,        ///< signed 16 bits, planar
    CNLivePlayerAV_SAMPLE_FMT_S32P,        ///< signed 32 bits, planar
    CNLivePlayerAV_SAMPLE_FMT_FLTP,        ///< float, planar
    CNLivePlayerAV_SAMPLE_FMT_DBLP,        ///< double, planar
    
    CNLivePlayerAV_SAMPLE_FMT_NB           ///< Number of sample formats. DO NOT USE if linking dynamically
};

/**
 @brief 播放画面旋转模式
 
 @since v0.0.1
 */

typedef NS_ENUM(NSInteger, CNLivePlayerRotationsMode) {
    CNLivePlayerNoRotation, // 无旋转
    CNLivePlayerRotateLeft, // 向左旋
    CNLivePlayerRotateRight, // 向右旋
    CNLivePlayerFlipVertical, // 垂直翻转
    CNLivePlayerFlipHorizonal, // 水平翻转
    CNLivePlayerRotate180 // 旋转 180 度
};

/**
 @brief CNLivePlayer 的播放状态
 
 @since v1.0.0
 */
typedef NS_ENUM(NSInteger, CNLivePlayerStatus) {
    
    /**
     CNLivePlayer 未知状态，只会作为 init 后的初始状态，开始播放之后任何情况下都不会再回到此状态。
     @since v1.0.0
     */
    CNLivePlayerStatusUnknow = 0,
    
    /**
     CNLivePlayer 正在准备播放所需组件，在调用 -play 方法时出现。
     
     @since v1.0.0
     */
    CNLivePlayerStatusPreparing,
    
    /**
     CNLivePlayer 播放组件准备完成，准备开始播放，在调用 -play 方法时出现。
     
     @since v1.0.0
     */
    CNLivePlayerStatusReady,
    
    /**
     CNLivePlayer 播放组件准备完成，准备开始连接
     
     @warning 请勿在此状态时，调用 playWithURL 切换 URL 操作
     
     @since v0.0.1
     */
    CNLivePlayerStatusOpen,
    
    /**
     @abstract CNLivePlayer 缓存数据为空状态。
     
     @discussion 特别需要注意的是当推流端停止推流之后，CNLivePlayer 将出现 caching 状态直到 timeout 后抛出 timeout 的 error 而不是出现 CNLivePlayerStatusStopped 状态，因此在直播场景中，当流停止之后一般做法是使用 IM 服务告知播放器停止播放，以达到即时响应主播断流的目的。
     
     @since v1.0.0
     */
    CNLivePlayerStatusCaching,
    
    /**
     CNLivePlayer 正在播放状态。
     
     @since v1.0.0
     */
    CNLivePlayerStatusPlaying,
    
    /**
     CNLivePlayer 暂停状态。
     
     @since v1.0.0
     */
    CNLivePlayerStatusPaused,
    
    /**
     @abstract CNLivePlayer 停止状态
     @discussion 该状态仅会在回放时播放结束出现，RTMP 直播结束并不会出现此状态
     
     @since v1.0.0
     */
    CNLivePlayerStatusStopped,
    
    /**
     CNLivePlayer 错误状态，播放出现错误时会出现此状态。
     
     @since v1.0.0
     */
    CNLivePlayerStatusError,
    
    /**
     *  CNLivePlayer 自动重连的状态
     */
    CNLivePlayerStateAutoReconnecting,
    
    /**
     *  CNLivePlayer 播放完成（该状态只针对点播有效）
     */
    CNLivePlayerStatusCompleted,
    
};

/**
 @brief 播放器音视频首帧数据类型
 
 @since v0.0.1
 */

typedef NS_ENUM(NSInteger, CNLivePlayerFirstRenderType) {
    CNLivePlayerFirstRenderTypeVideo = 0, // 视频
    CNLivePlayerFirstRenderTypeAudio // 音频
};

/**
 @brief 播放器数据类型
 
 @since v0.0.1
 */

typedef NS_ENUM(NSInteger, CNLivePlayerDataType) {
    CNLivePlayerDataTypeVod = 0,  // 点播
    CNLivePlayerDataTypeLive,     // 直播
    CNLivePlayerDataTypeAudio     // 音频
};

/**
 @brief 视频清晰度
 
 @since v0.0.1
 */
typedef enum : NSUInteger {
    /**
     *  蓝光
     */
    kCNLiveClarity_1080P,
    /**
     *  超清
     */
    kCNLiveClarity_720P,
    /**
     *  高清
     */
    kCNLiveClarity_480P,
    /**
     *  流畅
     */
    kCNLiveClarity_360P,
    
} CNLiveClarityLevel;

/**
 *  主播直播状态
 */
typedef NS_ENUM(NSUInteger, CNLiveAnchorStatus) {
    ///主播直播中
    CNLiveAnchorStatusLiving = 0,
    ///主播已离开
    CNLiveAnchorStatusLeaving,
    ///直播已结束
    CNLiveAnchorStatusEnd,
    ///直播错误
    CNLiveAnchorStatusError
};

#endif /* CNLivePlayerTypeDef_h */
