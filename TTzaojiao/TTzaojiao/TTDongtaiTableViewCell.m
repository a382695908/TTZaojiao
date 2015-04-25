//
//  TTDongtaiTableViewCell.m
//  TTzaojiao
//
//  Created by hegf on 15-4-23.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "TTDongtaiTableViewCell.h"


@implementation TTDongtaiTableViewCell

+(instancetype)dongtaiTableViewCellWithTableView:(UITableView *)tableView pics:(NSString*)pics{
    NSArray* picsArray = nil;
    if (pics.length != 0) {
        picsArray = [pics componentsSeparatedByString:@"|"];
    }
    
    static NSString* ID = @"dongtainoPic";
    if (picsArray == nil) {
        ID = @"dongtainoPic";
    }else{
        switch (picsArray.count - 1) {
            case DongtaiCellTypePic1To3:
                ID = @"dongtai1to3";
                break;
            case DongtaiCellTypePic4To6:
                ID = @"dongtai4to6";
                break;
            case DongtaiCellTypePic7To9:
                ID = @"dongtai7to9";
                break;
            default:
                break;
        }
    }
    
    TTDongtaiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TTDongtaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.picsNameArray = picsArray;
    [cell setupPicsArray];
    return cell;
}


-(void)setupPicsArray{
    NSMutableArray* picsArray = [NSMutableArray array];
    _picsArray = picsArray;
    if (_icon1 != nil) {
        [_picsArray addObject:_icon1];
    }
    if (_icon2 != nil) {
        [_picsArray addObject:_icon2];
    }
    if (_icon3 != nil) {
        [_picsArray addObject:_icon3];
    }
    if (_icon4 != nil) {
        [_picsArray addObject:_icon4];
    }
    if (_icon5 != nil) {
        [_picsArray addObject:_icon5];
    }
    if (_icon6 != nil) {
        [_picsArray addObject:_icon6];
    }
    if (_icon7 != nil) {
        [_picsArray addObject:_icon7];
    }
    if (_icon8 != nil) {
        [_picsArray addObject:_icon8];
    }
    if (_icon9 != nil) {
        [_picsArray addObject:_icon9];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBlogModel:(BlogModel *)blogModel{
    _dongtai.text = blogModel.i_content;
    _babyName.text = blogModel.baby_name;
    
//    NSString* faceurlStr = [NSString stringWithFormat:@"%@%@",TTBASE_URL,blogModel.face];
//    [_babyIcon setImageWithURL:[NSURL URLWithString:faceurlStr]];
//    
    _blogTime.text = [NSString stringWithFormat:@"%@|%@", blogModel.i_otime, blogModel.i_distance_time];
    
    if (_picsNameArray != nil && _picsNameArray.count > 1) {
        [_picsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView* icon = (UIImageView*)obj;
            if (idx > _picsNameArray.count-2) {
                *stop = YES;
            }else{
                NSString* str = [NSString stringWithFormat:@"%@%@",TTBASE_URL,[_picsNameArray objectAtIndex:idx]];
                [icon setImageWithURL:[NSURL URLWithString:str]];
            }
        }];
    }
    
    _blogModel = blogModel;
}

@end
