//
//  LaMaDetailModel.h
//  TTzaojiao
//
//  Created by dalianembeded on 15/4/28.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaMaDetailModel : NSObject
@property (copy, nonatomic) NSString * msg;
@property (copy, nonatomic) NSString * msg_word;
@property (copy, nonatomic) NSString * p_0;
@property (copy, nonatomic) NSString * p_1;
@property (copy, nonatomic) NSString * p_2;

@property (nonatomic, copy) NSString * i_name;
@property (nonatomic, copy) NSString * i_otime_end;


@property (nonatomic, copy) NSString * i_pic;
@property (nonatomic, copy) NSString * i_content;
@property (nonatomic, copy) NSString * i_pic_list;
@property (nonatomic, copy) NSString * i_company;
@property (nonatomic, copy) NSString * i_addresss;
@property (nonatomic, copy) NSString * i_tel;

@property (nonatomic,assign ) int count;

+(instancetype)LaMaDetailModelWithDict:(NSDictionary *)dict;
@end
