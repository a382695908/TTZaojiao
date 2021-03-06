//
//  TTWoyiziCaoViewController.m
//  TTzaojiao
//
//  Created by hegf on 15-5-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "TTWoyiziCaoViewController.h"
#import "TTWoyiziCaoTableViewCell.h"
#import "TTWoMuyingCaoTableViewCell.h"
#import "TTLessionMngTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TTWoyiziCaoViewController ()
{
    NSString* _fullPath;
}
@property (strong, nonatomic) NSArray* titlePicList;
@property (strong, nonatomic) NSMutableArray* videoPathList;
@property (weak, nonatomic) IBOutlet UITableView *yiziCaoTableView;

@end

@implementation TTWoyiziCaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars
        = NO;
        self.modalPresentationCapturesStatusBarAppearance
        = NO;
    }
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"yiziCao.plist" ofType:nil];
    _titlePicList = [NSArray arrayWithContentsOfFile:path];
    _videoPathList = [NSMutableArray array];
    _yiziCaoTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(getGYMPath) userInfo:nil repeats:NO];
    [self getGYMPath];
}

-(void)getGYMPath{
    [TTLessionMngTool getGymLessionVideoPath:^(id videoPath) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([videoPath isKindOfClass:[NSMutableArray class]]) {
            _videoPathList = videoPath;
            [_yiziCaoTableView reloadData];
        }else if ([videoPath isKindOfClass:[NSString class]]){
            if ([videoPath isEqualToString:@"neterror"]) {
                [MBProgressHUD TTDelayHudWithMassage:@"网络连接 错误，请检查网络" View:self.view];
            }else{
                [MBProgressHUD TTDelayHudWithMassage:@"健康操获取失败" View:self.view];
            }
        }
    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithFrame:CGRectZero];
    if (_videoPathList != nil && _videoPathList.count >0) {
        if (indexPath.row < _videoPathList.count) {
            TTWoyiziCaoTableViewCell* tmpcell = [TTWoyiziCaoTableViewCell woyiziCaoTableViewCellWithTableView:tableView];
            if (_titlePicList.count > 0) {
                tmpcell.titlePicsDict = _titlePicList[indexPath.row];
            }
            cell = tmpcell;
        }else{
            TTWoMuyingCaoTableViewCell* tmpcell = [TTWoMuyingCaoTableViewCell woMuyingCaoTableViewCellWithTableView:tableView];
            cell = tmpcell;
        }
    }else{
        if (indexPath.row == 0) {
            TTWoMuyingCaoTableViewCell* tmpcell = [TTWoMuyingCaoTableViewCell woMuyingCaoTableViewCellWithTableView:tableView];
            cell = tmpcell;
        }else{
            cell = [[UITableViewCell alloc]initWithFrame:CGRectZero];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoPathList.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_videoPathList != nil && _videoPathList.count >0) {
        if (indexPath.row < _videoPathList.count) {
            return 66.f;
        }else{
            return [TTWoMuyingCaoTableViewCell cellHeight];
        }
    }else{
        if (indexPath.row == 0) {
            return [TTWoMuyingCaoTableViewCell cellHeight];
        }else{
            return 0.f;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _videoPathList.count) {
        
        NSDictionary* dict = _videoPathList[indexPath.row];
        
        NSString* videoPath =  [dict objectForKey:@"i_path"];
        
        NSString* fullPath = [NSString stringWithFormat:@"%@%@", TTBASE_URL, videoPath];
        _fullPath = fullPath;
        if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
            MPMoviePlayerViewController* movieViewPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:_fullPath]];
            [self presentMoviePlayerViewControllerAnimated:movieViewPlayer];
        }else if( [AFNetworkReachabilityManager sharedManager].reachableViaWWAN){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前WIFI未连接 会耗费流量" delegate:self cancelButtonTitle:@"不看了" otherButtonTitles:@"继续看", nil];
            alert.delegate = self;
            alert.tag = 111;
            [alert show];
        }else{
            [MBProgressHUD TTDelayHudWithMassage:@"网络链接错误 请检查网络" View:self.view];
        }

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            //继续观看视频
            if (alertView.tag == 111) {
                MPMoviePlayerViewController* movieViewPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:_fullPath]];
                [self presentMoviePlayerViewControllerAnimated:movieViewPlayer];
            }        }
            break;
        default:
            break;
    }
}

-(void)dealloc{
    _titlePicList = nil;
    _videoPathList = nil;
}

@end
