//
//  DataToModel.m
//  FmdbTest
//
//  Created by HotYQ on 15/12/14.
//  Copyright (c) 2015年 blog.devtang.com. All rights reserved.
//

#import "HYQDataToModel.h"
//#import "DemoModel.h"
#import <objc/runtime.h>
@implementation HYQDataToModel

+ (id)getModel:(NSString *)modelName modelDic:(NSDictionary *)dic
{
    NSString *class = modelName;
    Class newClass = NSClassFromString(class);
    id instance = [[newClass alloc] init];
    
    // 对该对象赋值属性
    for (NSString *key in [dic allKeys]) {
            [instance setValue:[dic objectForKey:key] forKey:key];
    }
//    DemoModel *mode = (DemoModel *)instance;
    return instance;
}
+ (NSDictionary *)getDicWithModel:(id)model
{
    id _id = model;
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([_id class], &propertyCount);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);//获取属性名字
        NSString *key = [NSString stringWithFormat:@"%s",name];
        NSString *value =   [model valueForKey:key];
        NSLog(@"pro = %@ ,value = %@",key,value);
        NSLog(@"%@",[_id class]);
        if (!value) {
            value = @"";
        }
        [dic setObject:value forKey:key];
    }
    NSString *class_Name = [NSString stringWithFormat:@"%@",[_id class]];
    NSDictionary *dict = @{@"className":class_Name,@"propertyDic":dic};
    return dict;

}
@end
