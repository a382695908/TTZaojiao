//
//  TTWoTempTestAnswerCell.h
//  TTzaojiao
//
//  Created by hegf on 15-5-17.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWoTempTestAnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *answerLessButton;
@property (weak, nonatomic) IBOutlet UIButton *answerAlways;
@property (weak, nonatomic) IBOutlet UIButton *answerOffenButton;
- (IBAction)answerClicked:(UIButton *)sender;

@end
