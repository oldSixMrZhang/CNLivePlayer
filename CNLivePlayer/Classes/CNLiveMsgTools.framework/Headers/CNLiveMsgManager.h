//
//  CNLiveMsgManager.h
//  CNLiveMsgTools
//
//  Created by cnliveJunBo on 17/2/23.
//  Copyright © 2017年 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNLiveMsgManager : NSObject

@property (nonatomic, readonly, assign) BOOL isTestEnvironment;


+ (NSString *)getCNLiveMsgVersion;


+ (instancetype)sharedCNLiveMsgManager;


- (void)setToolsInfoWithInfoName:(NSString *)infoName
                         infoUrl:(NSString *)infoUrl;


- (NSDictionary *)getToolsInfo;


- (NSDictionary *)messageWithImage:(id)image;


- (NSDictionary *)messageWithVoice:(NSData *)voiceData duration:(long)duration;


- (void)initCNLiveMsgToolsWithAppKey:(NSString *)appKey appId:(NSString *)appId;


- (void)initCNLiveMsgToolsWithAppKey:(NSString *)appKey appId:(NSString *)appId isTestEnvironment:(BOOL)isTestEnvironment;


- (void)onLineWithMsgToolsInfoId:(NSString *)infoId
                        infoName:(NSString *)infoName
                         infoUrl:(NSString *)infoUrl
                       success:(void (^)(NSString *toolsId))successBlock
                         error:(void (^)(NSInteger errors))errorBlock;


- (void)justOnLineSuccess:(void (^)(NSString *toolsId))successBlock
                    error:(void (^)(NSInteger errors))errorBlock;


- (void)stealthCNLiveMsgTools;


- (void)offLineCNLiveMsgTools:(BOOL)isReceivePush;


- (void)gatherTogether:(NSString *)targetId
          messageCount:(int)messageCount
               success:(void (^)(NSString *targetId))successBlock
                 error:(void (^)(NSInteger errors, NSString *targetId))errorBlock;


- (void)gatherIfNullCreate:(NSString *)targetId
          messageCount:(int)messageCount
               success:(void (^)(NSString *targetId))successBlock
                 error:(void (^)(NSInteger errors, NSString *targetId))errorBlock;


- (void)gatherTogether:(NSString *)targetId
              isCreate:(BOOL)isCreate
          messageCount:(int)messageCount
               success:(void (^)(NSString *targetId))successBlock
                 error:(void (^)(NSInteger errors, NSString *targetId))errorBlock;


- (void)disperse:(NSString *)targetId
         success:(void (^)(NSString *targetId))successBlock
           error:(void (^)(NSInteger errors, NSString *targetId))errorBlock;


- (void)sendCarrier:(NSDictionary *)carrier
               type:(NSInteger)type
           targetId:(NSString *)targetId
            success:(void (^)(NSString *carrier, NSString *messageId, NSString *targetId, NSInteger type, NSString *infoId, NSString *infoName, NSString *infoUrl, long long goTime, long long comeTime))successBlock
              error:(void (^)(NSInteger errors, NSString *messageId, NSString *targetId))errorBlock;


- (void)sendMedia:(NSDictionary *)media type:(NSInteger)type
         targetId:(NSString *)targetId
      pushContent:(NSString *)pushContent
         pushData:(NSString *)pushData
         progress:(void (^)(int progress, NSString *messageId))progressBlock
          success:(void (^)(NSString *messageId, NSString *targetId, NSInteger type, NSString *infoId, NSString *infoName, NSString *infoUrl))successBlock
            error:(void (^)(NSInteger errorCode, NSString *messageId))errorBlock
           cancel:(void (^)(NSString * messageId))cancelBlock;


- (NSInteger)getOnLineStatus;


- (BOOL)judgeLoginStatus;


- (NSArray *)getLatestCarriers:(NSInteger)type targetId:(NSString *)targetId count:(int)count;

- (void)getMeetingPointContent:(NSString *)pointId
                       success:(void (^)(int totalMemberCount))successBlock
                         error:(void (^)(NSInteger errors))errorBlock;

@end
