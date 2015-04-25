//
//  BlogReplayModel.h
//  TTzaojiao
//
//  Created by hegf on 15-4-25.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogReplayModel : NSObject
@property (copy, nonatomic) NSString * Birthday;
@property (copy, nonatomic) NSString * baby_name;
@property (copy, nonatomic) NSString * face;
@property (copy, nonatomic) NSString * i_content;
@property (copy, nonatomic) NSString * i_distance_time;
@property (copy, nonatomic) NSString * i_otime;
@property (copy, nonatomic) NSString * i_uid;
@property (copy, nonatomic) NSString * i_x;
@property (copy, nonatomic) NSString * i_y;
@property (copy, nonatomic) NSString * id;

+(instancetype)blogReplayModelWithDict:(NSDictionary*)dict;
@end
