//
//  TTDyanmicUserStautsCell.h
//  TTzaojiao
//
//  Created by hegf on 15-4-27.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBlogFrame.h"
#import "TTDynamicUserStatusTopView.h"
#import "TTDaynamicUserStatusZancountView.h"
#import "TTDynamicPhotosView.h"
#import "TTDynamicCommentsView.h"
#import "TTCommentFrame.h"

@interface TTDyanmicUserStautsCell : UITableViewCell

@property (weak, nonatomic) TTDynamicUserStatusTopView* topView;
@property (weak, nonatomic) TTDynamicPhotosView* photosView;
@property (weak, nonatomic) TTDaynamicUserStatusZancountView* zanCountView;
@property (weak, nonatomic) TTDynamicCommentsView* commentsView;
@property (strong, nonatomic) TTBlogFrame* blogFrame;
@property (strong, nonatomic) NSArray* commentsFrame;

+(instancetype)dyanmicUserStautsCellWithTableView:(UITableView *)tableView;
@end