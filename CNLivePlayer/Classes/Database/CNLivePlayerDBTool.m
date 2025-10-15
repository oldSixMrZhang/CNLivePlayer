//
//  CNLivePlayerDBTool.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/8/19.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLivePlayerDBTool.h"
#import <fmdb/FMDB.h>
#import "CNLivePlayerModel.h"

//数据库名字
//#define CNLivePlayer_DBNAME @"CNLivePlayer.sqlite"

//数据库路径
//#define CNLivePlayer_DBPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:CNLivePlayer_DBNAME]


@interface CNLivePlayerDBTool()
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation CNLivePlayerDBTool
// 数据库名字
static NSString *const CNLivePlayerDBName = @"CNLivePlayer.sqlite";

// 数据库视频表的名字
static NSString *const CNLivePlayerTableName = @"videos";

+ (instancetype)shared{
    static CNLivePlayerDBTool *dbTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbTool = [[CNLivePlayerDBTool alloc]init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:CNLivePlayerDBName];
        dbTool.queue = [FMDatabaseQueue databaseQueueWithPath:path];//没有自动创建
    });
    return dbTool;
}

- (BOOL)checkDB{
    if (!self.queue) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:CNLivePlayerDBName];
        self.queue = [FMDatabaseQueue databaseQueueWithPath:path];//没有自动创建
    }
    return YES;
}

- (BOOL)closeDB{
    //关闭数据库
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db close];
    }];
    return result;
}

- (void)openDB:(DBReslutCallback)callback{
    if (!self.queue) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:CNLivePlayerDBName];
        self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    [self.queue inDatabase:^(FMDatabase *db) {
        callback(YES, db);
    }];
}

#pragma mark - 自定义操作
- (void)createTable{
    [self openDB:^(int result, FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (ID varchar, url varchar)",CNLivePlayerTableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"建表失败");
        } else {
            NSLog(@"建表成功");
        }
        [db close];

    }];
    
}

- (BOOL)existInTable:(NSString *)ID {
    __block BOOL isResult = NO;
    [self openDB:^(int result, FMDatabase *db) {
        NSString * check = [NSString stringWithFormat:@"SELECT * FROM %@ where ID = '%@'",CNLivePlayerTableName,ID];
        FMResultSet * re = [db executeQuery:check];
        while ([re next])  {
            isResult = YES;
        }
        [db close];

    }];
    return isResult;
    
}

- (CNLivePlayerModel *)searchInTable:(NSString *)ID{
    __block CNLivePlayerModel *model = [[CNLivePlayerModel alloc] init];
    [self openDB:^(int result, FMDatabase *db) {
        NSString * check = [NSString stringWithFormat:@"SELECT * FROM %@ where ID = '%@'",CNLivePlayerTableName,ID];
        FMResultSet * rs = [db executeQuery:check];
        while ([rs next]) {
            model = [[CNLivePlayerModel alloc] initWithID:[rs stringForColumn:@"ID"] url:[rs stringForColumn:@"url"]];
        }
        [db close];

    }];
    return model;

}

/**
 *  更新数据是否存在表中
 *
 *  @param contentId 数据模型id
 *
 *  @return 返回更新是否成功
 *
 */
- (BOOL)updateInTable:(NSString *)contentId{
    __block BOOL isResult = NO;
    [self openDB:^(int result, FMDatabase *db) {
        NSString * check = [NSString stringWithFormat:@"UPDATE %@ SET finish = 1  where contentId = '%@'", CNLivePlayerTableName, contentId];
        isResult = [db executeUpdate:check];
        [db close];
        
    }];
    return isResult;
    
}

- (BOOL)insertTable:(CNLivePlayerModel *)model{
    __block BOOL isResult = NO;
    [self openDB:^(int result, FMDatabase *db) {
        NSString * check = [NSString stringWithFormat:@"SELECT * FROM %@ where ID = '%@'", CNLivePlayerTableName, model.ID];
        FMResultSet * re = [db executeQuery:check];
        if (![re next]) {
            NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@ (ID, url) values('%@', '%@')", CNLivePlayerTableName, model.ID, model.url];
            BOOL res = [db executeUpdate:sql];
            if (res) {
                isResult = YES;
            }
        }
        [db close];
        
    }];
    return isResult;
    
}

- (BOOL)deleteTable:(NSString *)ID{
    __block BOOL isResult = NO;
    [self openDB:^(int result, FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ where ID = '%@';", CNLivePlayerTableName, ID];
        BOOL res = [db executeUpdate:sql];
        if (res) {
            isResult =  YES;
        }
        [db close];
        
    }];
    return isResult;
    
}

- (NSMutableArray *)queryTable{
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    [self openDB:^(int result, FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@;", CNLivePlayerTableName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            CNLivePlayerModel *model = [[CNLivePlayerModel alloc] init];
            model.ID = [rs stringForColumn:@"ID"];
            model.url = [rs stringForColumn:@"url"];
            [list addObject:model];
        }
        [db close];

    }];
    return list;
}

/**
 *  清除所有数据
 *
 *  @return 返回删除是否成功
 *
 */
- (BOOL)clearTable {
    __block BOOL isResult = NO;
    [self openDB:^(int result, FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@;", CNLivePlayerTableName];
        BOOL res = [db executeUpdate:sql];
        if (res) {
            isResult =  YES;
        }
        [db close];

    }];
    return isResult;
    
}

@end
