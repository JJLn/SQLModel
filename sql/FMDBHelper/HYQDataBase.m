//
//  DateBaseModel.m
//  FmdbTest
//
//  Created by HotYQ on 15/12/11.
//  Copyright (c) 2015年 blog.devtang.com. All rights reserved.
//

#import "HYQDataBase.h"
#import "HYQFMDBDataBase.h"
#import "HYQDataToModel.h"
#define className @"className"
#define propertyDic @"propertyDic"
@interface HYQDataBase ()
@property (nonatomic , strong) HYQFMDBDataBase * dataBase;

@property (nonatomic , assign) NSInteger page;

@property (nonatomic , assign) NSInteger size;

@end
@implementation HYQDataBase


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataBase = [[HYQFMDBDataBase alloc]init];
    }return self;
}
///通过model 转换成字典
- (NSDictionary *)modelDataBase:(id)model
{
    return [HYQDataToModel getDicWithModel:model];
}


#pragma 创建表 和加字段
//根据model  创建 表 和 字段  创建表和字段！！！
-  (void)creatTableWitchMode:(id)model
{
    NSDictionary *dic = [self modelDataBase:model];
    NSString *tableName = dic[className];
    NSDictionary *Pdic = dic[propertyDic];
    [self.dataBase creatTableWithTableName:tableName];
    for (NSString *str in Pdic.allKeys) {
        [self.dataBase insterItemWhthTableForName:str tableName:tableName];
    }
}
/**********************************************************************/
///创建一个空的表
- (void)creatEmptyTable:(NSString *)name{
    [self.dataBase creatTableWithTableName:name];
}

///给表添加字段
- (void)addTextForTable:(id)model{
    NSDictionary *dic = [self modelDataBase:model];
    NSString *tableName = dic[className];
    NSDictionary *Pdic = dic[propertyDic];
    for (NSString *str in Pdic.allKeys) {
        [self.dataBase insterItemWhthTableForName:str tableName:tableName];
    }
}
#pragma 添加

///通过这个model 插入数据  是插入！！！
- (void)insertObjForTableWithModel:(id)model
{
    NSDictionary *dic = [self modelDataBase:model];
    [self.dataBase updateTable:dic[propertyDic] tableName:dic[className]];
}


///安全线程创建 数据  比如 把一个数组插入进去
- (void)multithreadWithArr:(NSArray *)dataArr
{
    NSMutableArray *dicArr = [NSMutableArray array];
    NSString *name ;
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        id model = dataArr[i];
        NSDictionary *dic =  [self modelDataBase:model];
        [dicArr addObject:dic[propertyDic]];
        name = dic[className];
    }
    [self.dataBase multithreadWithArr:dicArr tableName:name];
}

/**********************************************************************/
///插入内容
- (void)insertObjForTableWithModel:(id)model withTable:(NSString *)table
{
    NSDictionary *dic = [self modelDataBase:model];
    [self.dataBase updateTable:dic[propertyDic] tableName:table];
}
- (void)multithreadWithArr:(NSArray *)dataArr withTable:(NSString *)table
{
    NSMutableArray *dicArr = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        id model = dataArr[i];
        NSDictionary *dic =  [self modelDataBase:model];
        [dicArr addObject:dic[propertyDic]];
    }
    [self.dataBase multithreadWithArr:dicArr tableName:table];
}




#pragma 查询

///查询
- (NSArray *)queryDataWithModel:(id)model
{
    NSDictionary * dic =  [self modelDataBase:model];
    NSArray *arr =   [self.dataBase queryDataWithPropertyDic:dic[propertyDic] tableName:dic[className]];
    NSLog(@"data arr is %@",arr);
    return arr;
}
- (NSArray *)queryWithModel:(id)model page:(NSInteger )page size:(NSInteger)size
{
    self.size = size;
    self.page = size*page;
    NSDictionary * dic =  [self modelDataBase:model];
    NSArray *arr =  [self.dataBase queryDataWithPropertyDic:dic[propertyDic] tableName:dic[className] page:page size:size];
    NSLog(@"data arr is %@",arr);
    return arr;
}
- (NSArray *)queryOnesDataWithModel:(id)model withTypeValue:(NSString *)value typeKey:(NSString *)key
{
    NSDictionary * dic =  [self modelDataBase:model];
    NSArray *arr =  [self.dataBase queryDataWithPropertyDic:dic[propertyDic] tableName:dic[className] typeValue:value typeKey:key];
    NSLog(@"data arr is %@",arr);
    return arr;
}



/**********************************************************************/
///查询全部
- (NSArray *)queryWithModel:(id)model withTable:(NSString *)table
{
    NSDictionary * dic =  [self modelDataBase:model];
    NSArray *arr =   [self.dataBase queryDataWithPropertyDic:dic[propertyDic] tableName:table];
    NSLog(@"data arr is %@",arr);
    return arr;
}
///根据条件查询
- (NSArray *)queryWithModel:(id)model modelValue:(NSString *)value modelKey:(NSString *)key withTable:(NSString *)table{
    NSDictionary * dic =  [self modelDataBase:model];
    NSArray *arr =  [self.dataBase queryDataWithPropertyDic:dic[propertyDic] tableName:table typeValue:value typeKey:key];
    NSLog(@"data arr is %@",arr);
    return arr;
}
- (NSArray *)queryWithModel:(id)model
                       page:(NSInteger )page
                       size:(NSInteger)size
                  tableName:(NSString *)table
{
    self.size = size;
    self.page = size*page;
    NSDictionary * dic =  [self modelDataBase:model];
    NSArray *arr =  [self.dataBase queryDataWithPropertyDic:dic[propertyDic] tableName:table page:page size:size];
    NSLog(@"data arr is %@",arr);
    return arr;
}

#pragma 删除

///清除这个表的内容
- (void)cleanAllInTableWhthModel:(id)model
{
    NSDictionary *dic = [self modelDataBase:model];
    [self.dataBase clearTable:dic[className]];
}
///清除某一项
- (void)clearItem:(NSString *)identification value:(NSString *)value tableName:(NSString *)tableName
{
    [self.dataBase clearItem:identification value:value tableName:tableName];
}
/**********************************************************************/
///删除一个
- (void)deleteModel:(id)model modelValue:(NSString *)value modelKey:(NSString *)key withTable:(NSString *)table
{
   [self.dataBase clearItem:key value:value tableName:table];
}
///删除全部
- (void)deleteModel:(id)model withTable:(NSString *)table
{
     [self.dataBase creatTableWithTableName:table];
}





#pragma mark ------



















@end
