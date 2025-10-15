//
//  CNLivePlayerModel.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/8/19.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//
 
/**
 * 视频信息类
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLivePlayerModel : NSObject
//contentId:rate -> ID
@property (nullable, nonatomic, copy) NSString *ID;
@property (nullable, nonatomic, copy) NSString *url;

- (CNLivePlayerModel *)initWithID:(NSString *)ID url:(NSString *)url;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
