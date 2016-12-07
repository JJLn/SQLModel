//
//  DataToModel.h
//  FmdbTest
//
//  Created by HotYQ on 15/12/14.
//  Copyright (c) 2015年 blog.devtang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYQDataToModel : NSObject
+ (id)getModel:(NSString *)modelName modelDic:(NSDictionary *)dic;
+ (NSDictionary *)getDicWithModel:(id)model;
@end
