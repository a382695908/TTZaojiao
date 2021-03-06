//
//  TTLaMaViewController.m
//  TTzaojiao
//
//  Created by Liang Zhang on 15/4/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "TTLaMaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LamaModel.h"
#import "UserModel.h"
#import "TTBaseViewController.h"
#import "LamaTableViewCell.h"
#import "LaMaDetailViewController.h"
#import "TTUserDongtaiViewController.h"
#import "LaMaAddRegCompayViewController.h"
#import "TSLocateView.h"
#import "CustomDatePicker.h"
#import <MapKit/MapKit.h>
#import "TTUserModelTool.h"
#import <MJRefresh.h>

@interface TTLaMaViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic)  NSUInteger pageIndexInt;
@property (assign, nonatomic)  BOOL isGetMore;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *locationCity;
@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *models;
@property (copy, nonatomic) NSString* cityCode; //110000
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) UIButton* rightbtn;

@end

@implementation TTLaMaViewController

#pragma mark
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
    
    UITableView* tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    CGFloat w=ScreenWidth;
    CGFloat h=ScreenHeight-44.f-49.f;
    
    _tableView.frame = CGRectMake(0, 0, w, h);
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _tableView.rowHeight = 120.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _models = [NSMutableArray array];
    
    [self setting];
    
    [self setupRefresh];
    
    _pageIndexInt = 1;
    [self updateLamaList];
    
}

-(void)updateLamaList{
    //定位获得城市码
    __weak TTLaMaViewController* weakself = self;
    [[TTCityMngTool sharedCityMngTool] startLocation:^(CLLocation *location, NSError *error) {
        //NSLog(@"latitude is %f",location.coordinate.latitude);
        if(location!=nil){
            [[TTCityMngTool sharedCityMngTool] getReverseGeocode:location Result:^(NSString *cityCode, NSError *error) {
                weakself.cityCode = cityCode;
                //加载异步网络数据
                [weakself loadData];
            }];
        }else{
            [MBProgressHUD TTDelayHudWithMassage:@"定位失败了" View:weakself.view];
            [weakself loadData];
        }
    }];
}

-(void)setupRefresh{
    __weak TTLaMaViewController* weakself = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakself.tableView.header beginRefreshing];
        weakself.pageIndexInt = 1;
        [weakself updateLamaList];
    }];
    
    [_tableView  addLegendFooterWithRefreshingBlock:^{
        [weakself.tableView.footer beginRefreshing];
        weakself.pageIndexInt++;
        [weakself updateLamaList];
    }];
}

- (void)loadData
{
    NSString* i_uid = [TTUserModelTool sharedUserModelTool].logonUser.ttid;
    NSString* pageIndex = [NSString stringWithFormat:@"%ld", _pageIndexInt];
    
    if (_cityCode == nil || [_cityCode isEqualToString:@""]) {
        _cityCode = @"210200";
    }
    _locationCity.text = [[TTCityMngTool sharedCityMngTool]codetoCity:_cityCode];
    NSDictionary* parameters = @{
                                 @"i_uid":i_uid,
                                 @"p_1":pageIndex,
                                 @"p_2":@"10",
                                 @"i_city":_cityCode
                                 };
    //加载网络数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient]apiGet:GET_LIST_ACTIVE Parameters:parameters  Result:^(id result_data, ApiStatus result_status, NSString *api) {
        [MBProgressHUD hideAllHUDsForView: self.view animated:YES];
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        if (result_status == ApiStatusSuccess) {

            if ([result_data isKindOfClass:[NSMutableArray class]]) {
                
                NSMutableArray *tempArray = result_data;
                if (tempArray != nil && tempArray.count>1) {
                    [tempArray removeObjectAtIndex:0];
                    if ([_pageIndex integerValue] > 1) {
                        [_models addObjectsFromArray:tempArray];
                    }else{
                        _models = tempArray;
                    }
                    [_tableView reloadData];
                    
                }
                
            }
        }else{
            [MBProgressHUD TTDelayHudWithMassage:@"网络连接有问题 请检查网络" View:self.view];
        };
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_rightbtn != nil) {
        [_rightbtn setImage:[self loadWebImage] forState:UIControlStateNormal];
    }
    
}

#pragma mark
//ADD_REG_COMPAY
-(void) leftBtnClick
{
    [self performSegueWithIdentifier:@"TOADDREGLAMA" sender:nil];
}

#pragma mark 显示个人信息
- (void) rightBtnClick:(UIBarButtonItem*)btn
{
    
    UIStoryboard *storyBoardDongTai=[UIStoryboard storyboardWithName:@"DongTaiStoryboard" bundle:nil];
    TTUserDongtaiViewController *userViewController = (TTUserDongtaiViewController *)[storyBoardDongTai instantiateViewControllerWithIdentifier:@"UserUIM"];
    [userViewController setI_uid:[[[TTUserModelTool sharedUserModelTool] logonUser] ttid]];
    [self.navigationController pushViewController:userViewController animated:YES];
    //导航
}

- (UIImage *) loadWebImage
{
    UIImage* image=nil;
    NSString *url = [NSString stringWithFormat:@"%@%@",TTBASE_URL,[[[TTUserModelTool sharedUserModelTool] logonUser] icon]];
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];//获取网咯图片数据
    if(data!=nil)
    {
        image = [[UIImage alloc] initWithData:data];//根据图片数据流构造image
    }
    return image;
}

#pragma mark 导航条布局
- (void) setting
{
    
    //left
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setImage:[UIImage imageWithName:@"icon_apply_join.png"]  forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(leftBtnClick)
         forControlEvents:UIControlEventTouchUpInside];
    leftbutton.frame = CGRectMake(50, 5, 100, 30);
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem= left;
    
    
    //right
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbtn = button;
    [button setImage:[self loadWebImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem= right;
    
}


#pragma mark
//懒加载模型
- (NSMutableArray *)models
{
    return _models;
}


#pragma tableview 数据源以及代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //create cell
    
    LamaTableViewCell *cell = [LamaTableViewCell lamaCellWithTabelView:tableView];
    if (_models.count > 0) {
        //data
        LamaModel * model=
        _models[indexPath.row];
        //set cell
        cell.lamaModel = model;
    }
 
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect headerFrame = CGRectMake(0, 0, tableView.frame.size.width, 44.f);
    _headerView.frame = headerFrame;
    _headerView.backgroundColor = TTBlogBackgroundColor;
    return _headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_models.count > 0) {
        LamaModel *model = _models[indexPath.row];
        LaMaDetailViewController *detailController = [[LaMaDetailViewController alloc]init];
        detailController.ttid = model.ttid;
        
        self.navigationController.title = @"详情";
        [self.navigationController pushViewController:detailController animated:YES];
    }
}


#pragma mark 更改位置
- (IBAction)changLocation:(UIButton *)sender {
    //[_babyName resignFirstResponder];
    [[self rdv_tabBarController]setTabBarHidden:YES];
    TSLocateView *locateView = [TSLocateView sharedcityPicker:@"请选择城市" delegate:self];
    [locateView showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isKindOfClass:[TSLocateView class]]) {
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        TSLocation *location = locateView.locate;

        //You can uses location to your application.
        if(buttonIndex == 0) {
            _cityCode = @"210200";
        }else {
            NSString* cityName = [NSString stringWithFormat:@"%@市", location.city];
            _locationCity.text = cityName;
            _cityCode = [[TTCityMngTool sharedCityMngTool]citytoCode:cityName];
            NSString* cityString = [NSString stringWithFormat:@"%@ %@",location.state, location.city];
            [_location setText:cityString];
        }
        [[self rdv_tabBarController]setTabBarHidden:NO];
        _pageIndexInt = 1;
        [self loadData];
    }
}

-(void)dealloc{
    _locationManager = nil;
    [_headerView removeFromSuperview];
    [_location removeFromSuperview];
    _headerView = nil;
    [_locationCity removeFromSuperview];
    _locationCity = nil;
}

@end
