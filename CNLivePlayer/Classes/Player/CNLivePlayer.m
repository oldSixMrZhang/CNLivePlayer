//
//  CNLivePlayer.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2019 CNLive. All rights reserved.
//

#import "CNLivePlayer.h"
#import "CNLivePlayerManager.h"
#import "CNLivePlayerDBTool.h"
#import "CNLivePlayerModel.h"

#import "CNLivePlayerRequest.h"
#import "CommonCrypto/CommonDigest.h"
#import "CNLivePlayerUrl.h"
#import <CNLiveMsgTools/CNLiveMsgManager.h>

#define PlayerStringToKey(a, b) [NSString stringWithFormat:@"%@:%@",a,b]

@interface CNLivePlayer ()<PLPlayerDelegate>{
    // 点播视频
    NSString * _videoId;
    
    // 直播视频
    NSString * _activityId;
    NSString * _channelId;

    NSString * _type;
    // 1-流畅，2-标清，3-高清，4-超清，默认为2
    NSString *_rate;
    BOOL _switchRate;
    CMTime _switchRateTime;
    
    //聊天室ID
    NSString *_roomId;

}
@property (nonatomic, strong) PLPlayerOption *option;
@property (nonatomic, strong) PLPlayer *switchPlayer;
@property (nonatomic, strong, readwrite) UIView *view;

@end

@implementation CNLivePlayer
//收到消息通知
NSString * const MsgToolsPlayerReceiveNotification = @"CNLiveMsgToolsPlayerReceiveNotification";
//获取主播状态通知
NSString * const CNLiveAnchorStatusChangedNotification = @"CNLiveAnchorStatusChangedNotification";

- (instancetype)initWithUrl:(NSString *)url{
    self = [super init];
       if (self) {
           _switchRate = NO;
           NSURL *URL = [NSURL URLWithString:url];
           self.player = [[PLPlayer alloc]initWithURL:URL option:self.option];
           self.player.delegate = self;
           [self.view addSubview:self.player.playerView];
       }
       return self;
}

#pragma mark - 初始化方法
/**
初始化点播播放器  初始化成功后才能对播放器进行设置

@param videoId 视频ID
@param success 初始化成功block
@param failure 初始化失败block 回调一个NSError的对象

@return 返回CNLivePlayer对象

@since v0.0.1
*/
- (instancetype)initVodPlayWithVideoId:(NSString *)videoId success:(SuccessBlock)success failure:(FailureBlock)failure{
    self = [super init];
    if (self) {
        _switchRate = NO;
        _videoId = videoId;
        _activityId = @"";
        _channelId = @"";
        _type = @"vod";
        _rate = @"2";
        [self getCacheURLSuccess:success failure:failure];
    }
    return self;
}
- (instancetype)initVodPlayWithVideoId:(NSString *)videoId{
    return [self initVodPlayWithVideoId:videoId success:nil failure:nil];
}

/**
初始化直播播放器

@param activityId 活动ID
@param channelId 频道ID（或主播ID）注意: 活动ID／频道ID 不能同时为空
@param success 初始化成功block
@param failure 初始化失败block 回调一个NSError的对象

@return 返回CNLivePlayer对象

@since v0.0.1
*/
- (instancetype)initLivePlayWithActivityId:(NSString *)activityId channelId:(NSString *)channelId success:(SuccessBlock _Nullable)success failure:(FailureBlock _Nullable)failure{
    self = [super init];
    if (self) {
        _switchRate = NO;
        _activityId = activityId;
        _channelId = channelId;
        _videoId = @"";
        _type = @"live";
        _rate = @"2";
        [self getCacheURLSuccess:success failure:failure];
    }
    return self;
}
- (instancetype)initLivePlayWithActivityId:(NSString *)activityId channelId:(NSString *)channelId{
    return [self initLivePlayWithActivityId:activityId channelId:channelId success:nil failure:nil];
}
- (instancetype)initLivePlayWithActivityId:(NSString *)activityId channelId:(NSString *)channelId
                                   success:(SuccessBlock _Nullable)success failure:(FailureBlock _Nullable)failure isAgree:(BOOL)isAgree anchorStatus:(AnchorStatus)anchorStatus {
    self = [super init];
    if (self) {
        _switchRate = NO;
        _activityId = activityId;
        _channelId = channelId;
        _videoId = @"";
        _type = @"live";
        _rate = @"2";
        [self getCacheURLSuccess:success failure:failure];
        if (isAgree) {
            [self initRCloudWithAppId:Player_AppID appKey:Player_AppKey connectResult:anchorStatus];
        }
    }
    return self;
    
}
/**
初始化播放器

@since v0.0.1
*/
- (void)createPlayerWithUrl:(NSString *)url{
    NSURL *URL = [NSURL URLWithString:url];
    if (_switchRate) { //切换码率
        self.switchPlayer = [[PLPlayer alloc]initWithURL:URL option:self.option];
        _switchPlayer.delegate = self;
        _switchPlayer.playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _switchPlayer.playerView.contentMode = UIViewContentModeScaleAspectFit;
        _switchPlayer.launchView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cnlive_player_bg"]];
        [_switchPlayer play];
        [self.view addSubview:self.switchPlayer.playerView];
        [self.view bringSubviewToFront:self.player.playerView];
    }
    else{
        if(self.player){ // 切换视频
            [self.player playWithURL:URL sameSource:NO];
        }
        else{
            self.player = [[PLPlayer alloc]initWithURL:URL option:self.option];
            _player.delegate = self;
            _player.playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _player.playerView.contentMode = UIViewContentModeScaleAspectFit;
            _player.launchView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cnlive_player_bg"]];
            [_player play];
            [self.view addSubview:self.player.playerView];
        }
    }
}

- (void)dealloc {
    [self removeRCloudNotificationObservers];
    NSLog(@"CNLivePlayer --> dealloc");
}

#pragma mark - 切换视频
/**
切换视频

@param videoId 视频id

@since v0.0.1
*/
- (void)switchVideo:(NSString *)videoId type:(CNLivePlayerDataType)type {
    [self switchVideo:videoId rate:@"2" type:type];
}

/**
切换视频

@param videoId  视频id             直播视频videoId  <-  activityId:channelId      点播视频videoId  <-  videoId
@param rate         视频码率        默认是@"2"
@param type         视频类型         vod 点播视频     live 直播视频

@since v0.0.1
*/
- (void)switchVideo:(NSString *)videoId rate:(NSString *)rate type:(CNLivePlayerDataType)type{
    if ([_videoId isEqualToString:videoId]) {
           return;
    }

    if ([rate isEqualToString:@""]||!rate) {
        _rate = @"2";
        
    }else{
        _rate = rate;

    }
    _switchRate = NO;
    switch (type) {
        case CNLivePlayerDataTypeVod:
        {
            _videoId = videoId;
            _activityId = @"";
            _channelId = @"";
            _type = @"vod";
        }
            break;
            
        case CNLivePlayerDataTypeLive:
        {
            NSArray *array = [videoId componentsSeparatedByString:@":"];
            if(array.count >= 2){
                _activityId = array[0];
                _channelId = array[1];
            }
            _videoId = @"";
            _type = @"live";
        }
            break;
            
        case CNLivePlayerDataTypeAudio:
        {
            _videoId = videoId;
            _type = @"vod";
        }
            break;
            
    }
    [self getCacheURLSuccess:nil failure:nil];
    
}

#pragma mark - 切换码率
/**
切换码率

@param level 视频清晰度

@since v0.0.1
*/
- (void)switchRate:(CNLiveClarityLevel)level{
    if (_switchRate) {
        return;
    }
    _switchRate = YES;
    // 1-流畅，2-标清，3-高清，4-超清，默认为2
    switch (level) {
        case kCNLiveClarity_1080P:
        {
            if ([_rate isEqualToString:@"4"]) return;
            _rate = @"4";
        }
            break;
        case kCNLiveClarity_720P:
        {
            if ([_rate isEqualToString:@"3"]) return;
            _rate = @"3";
        }
            break;
        case kCNLiveClarity_480P:
        {
            if ([_rate isEqualToString:@"2"]) return;
            _rate = @"2";
        }
            break;
        case kCNLiveClarity_360P:
        {
            if ([_rate isEqualToString:@"1"]) return;
            _rate = @"1";
        }
            break;
    }
    // 预加载2s
    int64_t seconds = self.player.currentTime.value+2*self.player.currentTime.timescale;
    int32_t timeScale = self.player.currentTime.timescale;
    _switchRateTime = CMTimeMake(seconds, timeScale);
    [self getCacheURLSuccess:nil failure:nil];

}

#pragma mark - 查找本地是否有缓存url
//播放地址
- (void)getCacheURLSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    // 有鉴权
    if(Player_Authentication){
        // 有缓存
        id data = [[CNLivePlayerDBTool shared] searchInTable:PlayerStringToKey(_videoId, _rate)];
        CNLivePlayerModel *model = (CNLivePlayerModel *)data;
        if (![model isEmpty]) {
            [self createPlayerWithUrl:model.url];
            if(Player_TestEnvironment){
                NSLog(@"CNLivePlayer初始化成功 --> 缓存数据");
            }
            success?success():@"";
        }
        // 无缓存
        else{
            // 请求视频url
            [self getVideoURLSuccess:success failure:failure];
        }
    }
    // 无鉴权
    else{
        __weak typeof(self) weakSelf = self;
        [CNLivePlayerRequest getAuthenticationBlock:^(NSString * _Nullable code,  NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf){
                return ;
            }
            if([code isEqualToString:@"0"]){
                // 鉴权成功
                // 请求视频url
                [strongSelf getVideoURLSuccess:success failure:failure];
            }else{
                // 鉴权失败
                if(Player_TestEnvironment){
                     NSLog(@"CNLivePlayer初始化失败 --> 鉴权失败");
                 }
                if(strongSelf->_switchRate){//切换码率
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                        [strongSelf.delegate player:strongSelf switchRateCompleted:NO];
                    }
                    strongSelf->_switchRate = NO;
                }
                else{
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:stoppedWithError:)]) {
                        NSError *customError = [NSError errorWithDomain:@"AuthenticationFailed" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"鉴权失败",NSLocalizedFailureReasonErrorKey:error.localizedFailureReason?error.localizedFailureReason:@"鉴权失败",
                        }];
                        [strongSelf.delegate player:strongSelf stoppedWithError:customError];
                    }
                }
                failure?failure(error):@"";
            }
        }];
    }

}

#pragma mark - 获取播放地址
- (void)getVideoURLSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    if([_type isEqualToString:@"vod"]){
        //点播播放地址
        __weak typeof(self) weakSelf = self;
        [CNLivePlayerRequest getVodVideoURLWithVideoId:_videoId rate:_rate block:^(NSString * _Nonnull videoUrl, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf){
                return ;
            }
            if(!error){
                [strongSelf createPlayerWithUrl:videoUrl];
                if(Player_TestEnvironment){
                    NSLog(@"CNLivePlayer初始化成功 --> 请求数据");
                }
                CNLivePlayerModel *model = [[CNLivePlayerModel alloc]initWithID:PlayerStringToKey(strongSelf->_videoId, strongSelf->_rate) url:videoUrl];
                [[CNLivePlayerDBTool shared] insertTable:model];
                success?success():@"";
            }else{
                // 获取url失败
                if(Player_TestEnvironment){
                     NSLog(@"CNLivePlayer初始化失败 --> 获取url失败");
                 }
                if(strongSelf->_switchRate){//切换码率
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                        [strongSelf.delegate player:strongSelf switchRateCompleted:NO];
                    }
                    strongSelf->_switchRate = NO;
                }else{
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:stoppedWithError:)]) {
                        NSError *customError = [NSError errorWithDomain:@"GetUrlFailed" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"获取url失败",NSLocalizedFailureReasonErrorKey:error.localizedFailureReason?error.localizedFailureReason:@"获取url失败"}];
                        [strongSelf.delegate player:strongSelf stoppedWithError:customError];
                    }
                }
                failure?failure(error):@"";
            }
        }];

    }else if([_type isEqualToString:@"live"]){
        //直播播放地址
        __weak typeof(self) weakSelf = self;
        [CNLivePlayerRequest getLiveVideoURLWithActivityId:_activityId channelId:_channelId rate:_rate block:^(NSString * _Nonnull videoUrl, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf){
                return ;
            }
            if(!error){
                [strongSelf createPlayerWithUrl:videoUrl];
                if(Player_TestEnvironment){
                    NSLog(@"CNLivePlayer初始化成功 --> 请求数据");
                }
                CNLivePlayerModel *model = [[CNLivePlayerModel alloc]initWithID:PlayerStringToKey(strongSelf->_videoId, strongSelf->_rate) url:videoUrl];
                [[CNLivePlayerDBTool shared] insertTable:model];
                success?success():@"";
            }else{
                // 获取url失败
                if(Player_TestEnvironment){
                     NSLog(@"CNLivePlayer初始化失败 --> 获取url失败");
                 }
                if(strongSelf->_switchRate){//切换码率
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                        [strongSelf.delegate player:strongSelf switchRateCompleted:NO];
                    }
                    strongSelf->_switchRate = NO;
                }else{
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(player:stoppedWithError:)]) {
                        NSError *customError = [NSError errorWithDomain:@"GetUrlFailed" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"获取url失败",NSLocalizedFailureReasonErrorKey:error.localizedFailureReason?error.localizedFailureReason:@"获取url失败"}];
                        [strongSelf.delegate player:strongSelf stoppedWithError:customError];
                    }
                }
                failure?failure(error):@"";
            }
        }];

    }

}

#pragma mark - 对外工具方法
/*
 播放当前视频
 
 @since v0.0.1
 */
- (BOOL)play {
    return [self.player play];
}

/*
 暂停播放当前视频
 
 @since v0.0.1
 */
- (void)pause {
    [self.player pause];
}

/*
 继续播放当前视频
 
 @since v0.0.1
 */
- (void)resume{
    [self.player resume];

}

/*
 结束当前视频的播放
 
 @since v0.0.1
 */
- (void)stop {
    [self.player stop];
    _player = nil;
}

#pragma mark - 懒加载
- (PLPlayerOption *)option{
    if(!_option){
        _option = [PLPlayerOption defaultOption];
        [_option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [_option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [_option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [_option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        if (Player_TestEnvironment) {
            [_option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];

        }else{
            [_option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
            
        }
        
    }
    return _option;
}

- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor blackColor];
    }
    return _view;
}

#pragma mark - Getter方法
- (NSURL *)URL {
    return _player.URL;
}

- (CNLivePlayerStatus)status {
    CNLivePlayerStatus playerState;
    switch (_player.status) {
        case PLPlayerStatusUnknow:
        {
            playerState = CNLivePlayerStatusUnknow;
        }
            break;
        case PLPlayerStatusPreparing:
        {
            playerState = CNLivePlayerStatusPreparing;
        }
            break;
        case PLPlayerStatusReady:
        {
            playerState = CNLivePlayerStatusReady;
        }
            break;
        case PLPlayerStatusOpen:
        {
            playerState = CNLivePlayerStatusOpen;
        }
            break;
            
        case PLPlayerStatusCaching:
        {
            playerState = CNLivePlayerStatusCaching;
        }
            break;
        case PLPlayerStatusPlaying:
        {
            playerState = CNLivePlayerStatusPlaying;
        }
            break;
        case PLPlayerStatusPaused:
        {
            playerState = CNLivePlayerStatusPaused;
        }
            break;
        case PLPlayerStatusStopped:
        {
            playerState = CNLivePlayerStatusStopped;
        }
            break;
        case PLPlayerStatusError:
        {
            playerState = CNLivePlayerStatusError;
        }
            break;
        case PLPlayerStateAutoReconnecting:
        {
            playerState = CNLivePlayerStateAutoReconnecting;
        }
            break;
        case PLPlayerStatusCompleted:
        {
            playerState = CNLivePlayerStatusCompleted;
        }
            break;
    }
    return playerState;
}

- (BOOL)playing {
    return _player.playing;
}

#pragma mark - Setter方法
- (void)setFrame:(CGRect)frame{
    _frame = frame;
    if ((frame.size.width == 0.0)&&(frame.size.height == 0.0)) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16.0);
    }
    _view.frame = frame;
    _player.playerView.frame = frame;
}
- (void)setDelegate:(id<CNLivePlayerDelegate>)delegate{
    _delegate = delegate;
    _player.delegate = self;
}

/*
支持后台播放

@since v0.0.1
*/
- (void)setBackgroundPlayEnable:(BOOL)backgroundPlayEnable{
    _player.backgroundPlayEnable = backgroundPlayEnable;
}

#pragma mark - 代理
/**
 告知代理对象 PLPlayer 即将开始进入后台播放任务
 
 @param player 调用该代理方法的 PLPlayer 对象
 
 @since v1.0.0
 */
- (void)playerWillBeginBackgroundTask:(nonnull PLPlayer *)player{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerWillBeginBackgroundTask:)]) {
        [self.delegate playerWillBeginBackgroundTask:self];
    }
}

/**
 告知代理对象 PLPlayer 即将结束后台播放状态任务
 
 @param player 调用该方法的 PLPlayer 对象
 
 @since v2.1.1
 */
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerWillEndBackgroundTask:)]) {
        [self.delegate playerWillEndBackgroundTask:self];
    }
}

/**
 告知代理对象播放器状态变更
 
 @param player 调用该方法的 PLPlayer 对象
 @param state  变更之后的 PLPlayer 状态
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    CNLivePlayerStatus playerState;
    switch (state) {
        case PLPlayerStatusUnknow:
        {
            playerState = CNLivePlayerStatusUnknow;
        }
            break;
        case PLPlayerStatusPreparing:
        {
            playerState = CNLivePlayerStatusPreparing;
        }
            break;
        case PLPlayerStatusReady:
        {
            playerState = CNLivePlayerStatusReady;
        }
            break;
        case PLPlayerStatusOpen:
        {
            playerState = CNLivePlayerStatusOpen;
        }
            break;
            
        case PLPlayerStatusCaching:
        {
            playerState = CNLivePlayerStatusCaching;
        }
            break;
        case PLPlayerStatusPlaying:
        {
            if(player == self.switchPlayer&&_switchRate){
                // 点播切换码率
                if([_type isEqualToString:@"vod"]){
                    [self.switchPlayer seekTo:_switchRateTime];
                }
                // 直播切换码率
                else if ([_type isEqualToString:@"live"]){
                    PLPlayer *temp = self.player;
                    self.player = self.switchPlayer;
                    self.switchPlayer = temp;
                    [self.switchPlayer.playerView removeFromSuperview];
                    self.switchPlayer = nil;
                    // 切换码率完成
                    if (self.delegate && [self.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                        [self.delegate player:self switchRateCompleted:YES];
                    }
                    _switchRate = NO;

                }
            }
            playerState = CNLivePlayerStatusPlaying;
        }
            break;
        case PLPlayerStatusPaused:
        {
            playerState = CNLivePlayerStatusPaused;
        }
            break;
        case PLPlayerStatusStopped:
        {
            playerState = CNLivePlayerStatusStopped;
        }
            break;
        case PLPlayerStatusError:
        {
            if(player == self.switchPlayer&&_switchRate){
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                    [self.delegate player:self switchRateCompleted:NO];
                }
                _switchRate = NO;
            }
            playerState = CNLivePlayerStatusError;
        }
            break;
        case PLPlayerStateAutoReconnecting:
        {
            playerState = CNLivePlayerStateAutoReconnecting;
        }
            break;
        case PLPlayerStatusCompleted:
        {
            playerState = CNLivePlayerStatusCompleted;
        }
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:statusDidChange:)]) {
        [self.delegate player:self statusDidChange:playerState];
    }
}

/**
 告知代理对象播放器因错误停止播放
 
 @param player 调用该方法的 PLPlayer 对象
 @param error  携带播放器停止播放错误信息的 NSError 对象
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:stoppedWithError:)]) {
        [self.delegate player:self stoppedWithError:error];
    }
}

/**
 点播已缓冲区域
 
 @param player 调用该方法的 PLPlayer 对象
 @param timeRange  CMTime , 表示从0时开始至当前缓冲区域，单位秒。
 
 @warning 仅对点播有效
 
 @since v2.4.1
 */
- (void)player:(nonnull PLPlayer *)player loadedTimeRange:(CMTime)timeRange{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:loadedTimeRange:)]) {
        [self.delegate player:self loadedTimeRange:timeRange];
    }
}

/**
回调将要渲染的帧数据
该功能只支持直播

@param player 调用该方法的 PLPlayer 对象
@param frame 将要渲染帧 YUV 数据。
CVPixelBufferGetPixelFormatType 获取 YUV 的类型。
软解为 kCVPixelFormatType_420YpCbCr8Planar.
硬解为 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange.
@param pts 显示时间戳 单位ms
@param sarNumerator  分子
@param sarDenominator 分母
其中sar 表示 storage aspect ratio
视频流的显示比例 sarNumerator sarDenominator
@discussion sarNumerator = 0 表示该参数无效

@since v2.4.3
*/
- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:willRenderFrame:pts:sarNumerator:sarDenominator:)]) {
        [self.delegate player:self willRenderFrame:frame pts:pts sarNumerator:sarNumerator sarDenominator:sarDenominator];
    }
}

/**
 回调音频数据
 
 @param player 调用该方法的 PLPlayer 对象
 @param audioBufferList 音频数据
 @param audioStreamDescription 音频格式信息
 @param pts 显示时间戳 是解码器进行显示帧时相对于SCR（系统参考）的时间戳。SCR可以理解为解码器应该开始从磁盘读取数据时的时间
 @param sampleFormat 采样位数 枚举：PLPlayerAVSampleFormat
 @return audioBufferList 音频数据
 
 @since v2.4.3
 */
- (nonnull AudioBufferList *)player:(nonnull PLPlayer *)player willAudioRenderBuffer:(nonnull AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
    CNLivePlayerAVSampleFormat format;
    switch (sampleFormat) {
        case PLPlayerAV_SAMPLE_FMT_NONE:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_NONE;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_U8:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_U8;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_S16:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_S16;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_S32:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_S32;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_FLT:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_FLT;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_DBL:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_DBL;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_U8P:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_U8P;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_S16P:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_S16P;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_S32P:
        {
             format = CNLivePlayerAV_SAMPLE_FMT_S32P;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_FLTP:
        {
             format = CNLivePlayerAV_SAMPLE_FMT_FLTP;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_DBLP:
        {
             format = CNLivePlayerAV_SAMPLE_FMT_DBLP;
        }
            break;
        case PLPlayerAV_SAMPLE_FMT_NB:
        {
            format = CNLivePlayerAV_SAMPLE_FMT_NB;
        }
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:willAudioRenderBuffer:asbd:pts:sampleFormat:)]) {
        return [self.delegate player:self willAudioRenderBuffer:audioBufferList asbd:audioStreamDescription pts:pts sampleFormat:format];
    }
    return nil;
}

/**
 回调 SEI 数据
 
 @param player 调用该方法的 PLPlayer 对象
 @param SEIData SEI数据
 @param ts 含有SEI数据的视频帧对应的时间戳
 @since v3.4.0
 */
- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData ts:(int64_t)ts{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:SEIData:ts:)]) {
        [self.delegate player:self SEIData:SEIData ts:ts];
    }
}

/**
 音视频渲染首帧回调通知
 
 @param player 调用该方法的 PLPlayer 对象
 @param firstRenderType 音视频首帧回调通知类型
 
 @since v3.2.1
 */
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType{
    CNLivePlayerFirstRenderType renderType;
    switch (firstRenderType) {
        case PLPlayerFirstRenderTypeVideo:
        {
            renderType = CNLivePlayerFirstRenderTypeVideo;
        }
            break;
        case PLPlayerFirstRenderTypeAudio:
        {
            renderType = CNLivePlayerFirstRenderTypeAudio;
        }
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:firstRender:)]) {
        [self.delegate player:self firstRender:renderType];
    }
}

/**
 视频宽高数据回调通知

 @param player 调用该方法的 PLPlayer 对象
 @param width 视频流宽
 @param height 视频流高
 
 @since v3.3.0
 */
- (void)player:(nonnull PLPlayer *)player width:(int)width height:(int)height{
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:width:height:)]) {
        [self.delegate player:self width:width height:height];
    }
}

/**
 seekTo 完成的回调通知
 
 @param player 调用该方法的 PLPlayer 对象
 
 @since v3.3.0
 */
- (void)player:(nonnull PLPlayer *)player seekToCompleted:(BOOL)isCompleted{
    if (_switchRate) {
        if (isCompleted) {
            PLPlayer *temp = self.player;
            self.player = self.switchPlayer;
            self.switchPlayer = temp;
            [self.switchPlayer.playerView removeFromSuperview];
            self.switchPlayer = nil;
            // 切换码率完成
            if (self.delegate && [self.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                [self.delegate player:self switchRateCompleted:YES];
            }
        }else{
            // 切换码率失败
            if (self.delegate && [self.delegate respondsToSelector:@selector(player:switchRateCompleted:)]) {
                [self.delegate player:self switchRateCompleted:NO];
            }
        }
        _switchRate = NO;
        return;

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:seekToCompleted:)]) {
        [self.delegate player:self seekToCompleted:isCompleted];
    }
}
#pragma mark - 直播获取主播状态
#pragma mark - 初始化RM
- (void)initRCloudWithAppId:(NSString *)appId appKey:(NSString *)appKey connectResult:(AnchorStatus)anchorStatus {
    [[CNLiveMsgManager sharedCNLiveMsgManager] initCNLiveMsgToolsWithAppKey:appKey appId:appId];
    //连接RM服务器
    [[CNLiveMsgManager sharedCNLiveMsgManager] justOnLineSuccess:^(NSString *toolsId) {
        //加入聊天室
        [self joinRoomResult:anchorStatus];
        
    } error:^(NSInteger errors) {
        if (anchorStatus) {
            anchorStatus(CNLiveAnchorStatusError);
        }
    }];
    
}

//加入聊天室
- (void)joinRoomResult:(AnchorStatus)anchorStatus {
    [self addRCloudNotificationObservers];
    
    NSString *contentId = _activityId ? _activityId : _channelId;
    if (![_channelId containsString:@"_"]) {
        NSString *spId = [[Player_AppID componentsSeparatedByString:@"_"] firstObject];
        contentId = [NSString stringWithFormat:@"%@_%@", spId, _channelId];
    }
    
    _roomId = [NSString stringWithFormat:@"CNLiveAnchorStatus_%@",contentId];
    
    //加入聊天室
    [[CNLiveMsgManager sharedCNLiveMsgManager] gatherIfNullCreate:_roomId messageCount:1 success:^(NSString *targetId) {
        if (anchorStatus) {
            anchorStatus(CNLiveAnchorStatusLiving);
        }
                                              
    } error:^(NSInteger errors, NSString *targetId) {
        if (anchorStatus) {
            anchorStatus(CNLiveAnchorStatusError);
        }
                                  
    }];
    
}

//重新获取主播状态（离开/已结束）
- (void)retryToGetAnchorStatusResult:(AnchorStatus)anchorStatus {
    [self initRCloudWithAppId:Player_AppID appKey:Player_AppKey connectResult:anchorStatus];
    
}

#pragma mark - 通知
- (void)addRCloudNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:MsgToolsPlayerReceiveNotification object:nil];

}

- (void)removeRCloudNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MsgToolsPlayerReceiveNotification object:nil];

    if (!_roomId || [_roomId isEqualToString:@""] || ![_roomId isKindOfClass:[NSString class]] || _roomId.length == 0) {
        return;
    }
    
    [[CNLiveMsgManager sharedCNLiveMsgManager] disperse:_roomId success:^(NSString *targetId) {
        
    } error:^(NSInteger errors, NSString *targetId) {
        
    }];
    
}

#pragma mark - 聊天室
- (void)receiveMessage:(NSNotification *)noti {
    
    if (!noti.userInfo[@"message"]) return;
    
    int newValue = [noti.userInfo[@"message"] intValue];
    
    if (_anchorStatus == newValue) return;    //如果新收到的状态与上一次状态一样不作处理
    _anchorStatus = newValue;

    if (newValue == 1) {
        _anchorStatus = CNLiveAnchorStatusLiving;
        [_player play];
        
    } else if (newValue == 2) {
        _anchorStatus = CNLiveAnchorStatusEnd;
        [_player stop];
        
    } else {
        _anchorStatus = CNLiveAnchorStatusLeaving;
        [_player pause];
        
    }

    if (Player_TestEnvironment) {
        NSLog(@"CNLiveMoviePlayerController-->主播直播状态%lu",(unsigned long)_anchorStatus);
    }
    
    //发送通知
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CNLiveAnchorStatusChangedNotification object:nil userInfo:nil];
    });
    
}

@end
