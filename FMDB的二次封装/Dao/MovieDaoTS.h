//
//  MovieDaoTS.h
//  FMDB的二次封装
//
//  Created by baoshan on 16/11/23.
//
//

#import <Foundation/Foundation.h>

@class TestModel2;
@interface MovieDaoTS : NSObject
/**
 *  存数据
 *
 *  @param model 需要存的model
 */
+ (void)saveMovie:(TestModel2 *)model;

/**
 *  读数据
 *
 *  @param completion 成功回调model
 */
+ (void)loadMovieCompletion:(void (^)(TestModel2 *))completion;

/**
 *  删除数据
 *
 *  @param complection 事件成功回调
 */
+ (void)deleteMovieComplection:(void(^)(void)) complection;
@end

