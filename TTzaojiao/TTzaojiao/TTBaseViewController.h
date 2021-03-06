//
//  TTBaseViewController.h
//  TTzaojiao
//
//  Created by hegf on 15-4-17.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "TTWebServerAPI.h"
#import "UIAlertView+MoreAttribute.h"
#import <MBProgressHUD.h>
#import "TTUserModelTool.h"
#import "TTCityMngTool.h"
#import <UIImageView+AFNetworking.h>
#import "UIBarButtonItem+MoreAttribute.h"
#import "MBProgressHUD+TTHud.h"
#import "UIView+NKMoreAttribute.h"
#import "TTTabBarController.h"
#import "TTUserModelTool.h"
#import "TTUIChangeTool.h"
#import "UIImage+MoreAttribute.h"

#define kBottomBarHeight 44.f

@interface TTBaseViewController : UIViewController
@property (weak, nonatomic) UIButton* logonRegButton;
@property (weak, nonatomic) UIImageView* rightItemIcon;
@end
