//
//  DBUpdateManager.h
//  FMDB的二次封装
//
//  Created by baoshan on 16/11/9.
//
//


/**
 数据库表格更新类

 通过配置的dbplist 来获配置需要更新的表（只需要将要更新操作写在DBPlist.plist当中）
 当前数据库版本写在info.plist “dbversion"字段
 最好放在是否为用户第一次下载判断中
 */
#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface DBUpdateManager : NSObject

+ (void)updateDatabase;

@end
