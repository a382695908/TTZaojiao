//
//  LaMaDetailModel.m
//  TTzaojiao
//
//  Created by dalianembeded on 15/4/28.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "LaMaDetailModel.h"

@implementation LaMaDetailModel
+(instancetype)LaMaDetailModelWithDict:(NSDictionary *)dict{
    LaMaDetailModel* mode = [[LaMaDetailModel alloc]init];
    
    
        NSMutableDictionary* tmpdict = [dict mutableCopy];
  
        [mode setValuesForKeysWithDictionary:tmpdict];
        return mode;
}
@end
