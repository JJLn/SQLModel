//
//  DateBaseModel.h
//  FmdbTest
//
//  Created by HotYQ on 15/12/11.
//  Copyright (c) 2015年 blog.devtang.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HYQDataBase : NSObject

/*
            用model 类名做表名
 */
//根据model  创建 表 和 字段  创建表和字段！！！
-  (void)creatTableWitchMode:(id)model;

///通过这个model 插入数据  是插入！！！
- (void)insertObjForTableWithModel:(id)model;

///清除这个表的内容
- (void)cleanAllInTableWhthModel:(id)model;

///安全线程创建 数据  比如 把一个数组插入进去
- (void)multithreadWithArr:(NSArray *)dataArr;

///单个删除
- (void)clearItem:(NSString *)identification
            value:(NSString *)value
        tableName:(NSString *)tableName;

///查询全部
- (NSArray *)queryDataWithModel:(id)model;

/// 查询分页
- (NSArray *)queryWithModel:(id)model
                  page:(NSInteger )page
                  size:(NSInteger)size;

///查出某一个 key:model中的一个属性 目的是和table 中的字段关联 value :model key属性的值
- (NSArray *)queryOnesDataWithModel:(id)model
                 withTypeValue:(NSString *)value
                       typeKey:(NSString *)key;





/*
                自己创建表名
 */
///创建一个空的表
- (void)creatEmptyTable:(NSString *)name;

///给表添加字段
- (void)addTextForTable:(id)model;

///插入内容
- (void)insertObjForTableWithModel:(id)model withTable:(NSString *)table;

///安全线程创建 数据  比如 把一个数组插入进去
- (void)multithreadWithArr:(NSArray *)dataArr withTable:(NSString *)table;

///查询全部
- (NSArray *)queryWithModel:(id)model withTable:(NSString *)table;

///根据条件查询
- (NSArray *)queryWithModel:(id)model modelValue:(NSString *)value modelKey:(NSString *)key withTable:(NSString *)table;

///删除一个
- (void)deleteModel:(id)model modelValue:(NSString *)value modelKey:(NSString *)key withTable:(NSString *)table;

///删除全部
- (void)deleteModel:(id)model withTable:(NSString *)table;

///分页查询
- (NSArray *)queryWithModel:(id)model
                       page:(NSInteger )page
                       size:(NSInteger)size
                  tableName:(NSString *)table;











@end
