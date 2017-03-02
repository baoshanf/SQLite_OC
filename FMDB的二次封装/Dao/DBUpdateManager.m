//
//  DBUpdateManager.m
//  FMDB的二次封装
//
//  Created by baoshan on 16/11/9.
//
//

#import "DBUpdateManager.h"
#import "DbManager.h"

static NSString *const DBVERSION_TABLE_NAME = @"db_version";

@implementation DBUpdateManager

/**
 更新操作
 */
+ (void)updateDatabase{

    [self getDbVersion:^(NSString *version) {
        if (!version) {
            [self saveDbVersion:[self getCurrentVersion]];
            return;
        }
        if ([[self getCurrentVersion] compare:version options:NSNumericSearch] == NSOrderedDescending) {
            // 读取DB plist文件
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DBInfo" ofType:@"plist"];
            NSArray *plist = [NSArray arrayWithContentsOfFile:plistPath];
            if (version) {
                for (NSDictionary *dic in plist) {
                    
                    NSArray *sqls = [dic objectForKey:@"sql"];
                    [[DbManager getInstance].dbQueue inDatabase:^(FMDatabase *db) {
                        for (id sqlObj in sqls) {
                            if ([sqlObj isKindOfClass:[NSString class]]) {
                                [db executeUpdate:sqlObj];
                            }
                        }
                        [db close];
                    }];
                }
            }
        }
    }];
}


/**
 当前版本号
 */
+ (NSString *)getCurrentVersion{

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"DBVersion"];
    return majorVersion;
}

/**
 获取旧版本号
 */
+ (void)getDbVersion:(void(^)(NSString *version)) completion{

    [[DbManager getInstance].dbQueue inDatabase:^(FMDatabase *db) {
        [self createTable:db];
        
        NSString *sql = [NSString stringWithFormat:@"select * from %@",DBVERSION_TABLE_NAME];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            if (completion) {
                completion([rs stringForColumn:@"version"]);
            }
        }
        [rs close];
    }];
}


/**
 保存版本号
 */
+ (void)saveDbVersion:(NSString *)version{

    [[DbManager getInstance].dbQueue inDatabase:^(FMDatabase *db) {
        [self createTable:db];
        //先清空
        [db executeUpdate:[NSString stringWithFormat:@"delete from %@",DBVERSION_TABLE_NAME]];
        
        //保存数据库版本
        [db executeInsertOrReplaceInTable:DBVERSION_TABLE_NAME withParameterDictionary:@{@"version":version}];
        
    }];
}

/**
 创建表
 */
+ (void)createTable:(FMDatabase *)db{
    if ([db tableExists:DBVERSION_TABLE_NAME]) {
        return;
    }
    NSDictionary *table = @{@"version":@"TEXT NOT NULL UNIQUE"};
    [db createTable:DBVERSION_TABLE_NAME columns:table];
}
@end
