//
//  DataBase.m
//  FmdbTest
//
//  Created by HotYQ on 15/12/11.
//  Copyright (c) 2015年 blog.devtang.com. All rights reserved.
//

#import "HYQFMDBDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "HYQDataToModel.h"

@interface HYQFMDBDataBase ()
@property (nonatomic , strong) NSString * dbPath;


@end
@implementation HYQFMDBDataBase
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dbPath = [self dbSqliteFilePath];
    }
    return self;
}
- (void)creatTableWithTableName:(NSString *)table
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",self.dbPath,table]]) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        
        if ([db open]) {
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL)",table];
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"no error when creating db table");
            } else {
                NSLog(@"***succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
    
}

- (void)insterItemWhthTableForName:(NSString *)name tableName:(NSString *)tableName
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"ALTER TABLE '%@'  ADD  '%@' varchar(30)",tableName,name];
        
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"no error insterItemWhthTable");
        } else {
            NSLog(@"succ to insterItemWhthTable");
        }
        [db close];
    }
}
- (void)updateTable:(NSDictionary *)propertyDic tableName:(NSString *)tableName
{
    NSString *tempStr = @":";
    NSString *keyStr = @"";
    NSArray *properArr = [propertyDic allKeys];
    for (int i = 0 ; i < properArr.count; i ++) {
        
        if (i == properArr.count - 1) {
            tempStr = [tempStr stringByAppendingString:properArr[i]];
            
            keyStr = [keyStr stringByAppendingString:properArr[i]];
        }else{
            tempStr = [[[tempStr stringByAppendingString:properArr[i]]stringByAppendingString:@","]stringByAppendingString:@":"];
            
            keyStr = [[keyStr stringByAppendingString:properArr[i]]stringByAppendingString:@","];
        }
    }
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",tableName,keyStr,tempStr];
        
        BOOL res = [db executeUpdate:sql withParameterDictionary:propertyDic];
        if (!res) {
            NSLog(@"no error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }
}

- (NSArray *)queryDataWithPropertyDic:(NSDictionary *)propertyDic tableName:(NSString *)TableName typeValue:(NSString *)value typeKey:(NSString *)key
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from '%@' where %@ = %@",TableName,key,value];
        return (NSArray *)[self getDataWithSql:sql dbBase:db dic:propertyDic tableName:TableName];
    }
    return nil;
}
- (NSArray *)queryDataWithPropertyDic:(NSDictionary *)propertyDic tableName:(NSString *)TableName
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from '%@'",TableName];
        return (NSArray *)[self getDataWithSql:sql dbBase:db dic:propertyDic tableName:TableName];
    }
    return nil;
}
//LIMIT 2,1
- (NSArray *)queryDataWithPropertyDic:(NSDictionary *)propertyDic tableName:(NSString *)TableName page:(NSInteger)page size:(NSInteger )size
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from '%@' limit %zd,%zd",TableName,page,size];
        return (NSArray *)[self getDataWithSql:sql dbBase:db dic:propertyDic tableName:TableName];
    }
    return nil;
}
- (NSArray *)getDataWithSql:(NSString *)sql dbBase:(FMDatabase *)db dic:(NSDictionary *)propertyDic tableName:(NSString *)tableName
{
    
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet * rs = [db executeQuery:sql];
    while ([rs next]) {
        NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
        
        for (NSString *key in propertyDic.allKeys) {
            [dic setObject:[rs stringForColumn:key] forKey:key];
        }
        
        NSLog(@"dic = %@",dic);
        [arr addObject:[HYQDataToModel getModel:tableName modelDic:dic]];
    }
    
    return arr;
}
- (void)clearTable:(NSString *)tableName
{
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@",tableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"no error clear table");
        } else {
            NSLog(@"***succ to clear table");
        }
        [db close];
    }
}

- (void)clearItem:(NSString *)identification value:(NSString *)value tableName:(NSString *)tableName
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@ = %@",tableName,identification,value];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"no error clear table itme");
        } else {
            NSLog(@"***error clear table item");
        }
        [db close];
    }
    
}
- (void)multithreadWithArr:(NSArray *)dataArr tableName:(NSString *)tableName
{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    //    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < dataArr.count; i ++) {
            [queue inDatabase:^(FMDatabase *db) {
                NSDictionary *dic = dataArr[i];
                
                NSString *tempStr = @":";
                NSString *keyStr = @"";
                NSArray *properArr = [dic allKeys];
                for (int i = 0 ; i < properArr.count; i ++) {
                    
                    if (i == properArr.count - 1) {
                        tempStr = [tempStr stringByAppendingString:properArr[i]];
                        
                        keyStr = [keyStr stringByAppendingString:properArr[i]];
                    }else{
                        tempStr = [[[tempStr stringByAppendingString:properArr[i]]stringByAppendingString:@","]stringByAppendingString:@":"];
                        
                        keyStr = [[keyStr stringByAppendingString:properArr[i]]stringByAppendingString:@","];
                    }
                }
                
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",tableName,keyStr,tempStr];
                
                BOOL res = [db executeUpdate:sql withParameterDictionary:dic];
                if (!res) {
                    NSLog(@"error to add db data: ");
                } else {
                    NSLog(@"succ to add db data: ");
                }
            }];
        }
    });
    
}


- (NSString *)dbSqliteFilePath{
    NSString *docDir =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbfilePath = [NSString stringWithFormat:@"%@/dbServer.sqlite",docDir];
    return dbfilePath;
}



@end
