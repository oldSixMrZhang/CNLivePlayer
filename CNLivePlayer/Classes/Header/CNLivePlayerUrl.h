//
//  CNLivePlayerUrl.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/5/25.
//  Copyright © 2016年 CNLive. All rights reserved.
//

/**
 * 播放器URL
 */

#ifndef CNLivePlayerUrl_h
#define CNLivePlayerUrl_h

#define HTTPorHTTPs @"http://"

#pragma mark - 推流
//创建直播活动
#define StreamerURL [NSString stringWithFormat:@"%@/live_epg/createActivity", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

//启动直播活动
#define startStreamerURL [NSString stringWithFormat:@"%@/live_epg/startActivity", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

//停止直播活动
#define stopStreamerURL [NSString stringWithFormat:@"%@/live_epg/stopActivity", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

#pragma mark - 播放
//鉴权
#define authUrl [NSString stringWithFormat:@"%@/platform/valid", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

//查看活动状态
#define liveInfoUrl [NSString stringWithFormat:@"%@/live_epg/live_epg/getLiveActivityPlayInfo4Server", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

//点播
#define vodUrl [NSString stringWithFormat:@"%@/vod_ips/vodplayByAPP", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

//直播
#define liveUrl [NSString stringWithFormat:@"%@/live_ips/liveplayByAPP", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]

#define vodInfoUrl [NSString stringWithFormat:@"%@/vod_epg/getVodInfo4App", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"test.open.cnlive.com/openapi/api2" : HTTPorHTTPs@"api.cnlive.com/open/api2"]


#pragma mark - 探针
#define StatUrl [NSString stringWithFormat:@"%@", [CNLivePlayerManager manager].isTestEnvironment ? HTTPorHTTPs@"app.sta.cnlive.com/app.jpg" : HTTPorHTTPs@"app.sta.cnlive.com/app.jpg"]

#endif /* CNLivePlayerUrl_h */
