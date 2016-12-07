//
//  DataBase.h
//  FmdbTest
//
//  Created by HotYQ on 15/12/11.
//  Copyright (c) 2015年 blog.devtang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYQFMDBDataBase : NSObject
- (void)creatTableWithTableName:(NSString *)table;//创建表
- (void)insterItemWhthTableForName:(NSString *)name tableName:(NSString *)tableName;//插入新字段
- (void)multithreadWithArr:(NSArray *)dataArr tableName:(NSString *)tableName;//安全线程插入内容 数组
- (void)clearTable:(NSString *)tableName;//清除
- (void)clearItem:(NSString *)identification value:(NSString *)value tableName:(NSString *)tableName;//删除一个
- (void)updateTable:(NSDictionary *)propertyDic tableName:(NSString *)tableName;//插入一条数据
- (NSArray *)queryDataWithPropertyDic:(NSDictionary *)propertyDic tableName:(NSString *)TableName;//查询全部
//查询分页
- (NSArray *)queryDataWithPropertyDic:(NSDictionary *)propertyDic tableName:(NSString *)TableName page:(NSInteger)page size:(NSInteger )size;
- (NSArray *)queryDataWithPropertyDic:(NSDictionary *)propertyDic tableName:(NSString *)TableName typeValue:(NSString *)value typeKey:(NSString *)key;


// sqlite文件路径
- (NSString *)dbSqliteFilePath;


@end
