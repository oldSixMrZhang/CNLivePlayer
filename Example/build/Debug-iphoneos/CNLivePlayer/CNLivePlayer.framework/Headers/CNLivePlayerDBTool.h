//
//  CNLivePlayerDBTool.h
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/8/19.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

/**
 * 数据库管理类
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FMDatabase;
@class CNLivePlayerModel;

typedef void(^DBReslutCallback)(int result,FMDatabase *db);

@interface CNLivePlayerDBTool : NSObject

+ (instancetype)shared;

#pragma mark - 根据需要自定义操作
/**
 *  创建具体需要的数据库表
 *
 */
- (void)createTable;

/**
 *  判断数据是否存在表中
 *
 *  @param contentId 数据模型id
 *
 *  @return 返回是否存在
 *
 */
- (BOOL)existInTable:(NSString *)contentId;

/**
 *  查找数据是否存在表中
 *
 *  @param contentId 数据模型id
 *
 *  @return 返回数据模型
 *
 */
- (CNLivePlayerModel *)searchInTable:(NSString *)contentId;

/**
 *  更新数据是否存在表中
 *
 *  @param contentId 数据模型id
 *
 *  @return 返回更新是否成功
 *
 */
- (BOOL)updateInTable:(NSString *)contentId;

/**
 *  插入数据
 *
 *  @param model 数据模型
 *
 *  @return 返回插入是否成功
 *
 */
- (BOOL)insertTable:(CNLivePlayerModel *)model;

/**
 *  删除数据
 *
 *  @param contentId 数据模型id
 *
 *  @return 返回删除是否成功
 *
 */
- (BOOL)deleteTable:(NSString *)contentId;

/**
 *  返回所有数据(字典数组)
 *
 *  @return 返回NSMutableArray对象
 *
 */
- (NSMutableArray *)queryTable;

/**
 *  清除所有数据
 *
 *  @return 返回删除是否成功
 *
 */
- (BOOL)clearTable;

@end

NS_ASSUME_NONNULL_END
