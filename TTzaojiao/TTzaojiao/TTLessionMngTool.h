//
//  TTLessionMngTool.h
//  TTzaojiao
//
//  Created by hegf on 15-5-9.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"
#import "TTUserModelTool.h"
#import "UIAlertView+MoreAttribute.h"

typedef void (^LessionIDBlock)(id lessionID);
typedef void (^WeekLessionBlock)(id lessions);
typedef void (^DetailLessionBlock)(id detailLession);
typedef void (^LessionVideoPathBlock)(NSString* videoPath);
typedef void (^GYMLessionVideoPathBlock)(id videoPath);

@interface TTLessionMngTool : NSObject

+(void)getLessionID:(LessionIDBlock)block;
+(void)getWeekLessions:(NSString*)lessionID Result:(WeekLessionBlock)block;
+(void)getGymLessionVideoPath:(GYMLessionVideoPathBlock)block;
+(void)getDetailLessionInfo:(NSString*)activeID Result:(DetailLessionBlock)block;
+(void)getLessionVideoPath:(NSString*)activeID Result:(LessionVideoPathBlock)block;
@end
