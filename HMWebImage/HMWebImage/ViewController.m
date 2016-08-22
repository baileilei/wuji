//
//  ViewController.m
//  HMWebImage
//
//  Created by GD on 16/8/20.
//  Copyright © 2016年 geduo. All rights reserved.
//

#import "ViewController.h"
#import "HMAppCell.h"
#import "AFNetworking.h"
#import "NSObject+CZAddition.h"
#import "HMAppModel.h"

#import "HMDownloaderOperation.h"
#import "Masonry.h"
//#import "UIImageView+WebCache.h"
#import "HMDownloaderManager.h"

@interface ViewController ()<UITableViewDataSource>

@property (nonatomic,weak) UIImageView *iconImage;

@end

@implementation ViewController{
    NSArray<HMAppModel *> *_appList;
    
    NSOperationQueue *_queue;
    
    NSString *_lastURLStr;
    
    NSMutableDictionary *_opCache;
}



-(void)test{
    
    NSInteger random = arc4random_uniform((u_int32_t)_appList.count);
    HMAppModel *app = _appList[random];
    
    
   
    
//    //操作缓存池
//    if (![app.icon isEqualToString:_lastURLStr] && _lastURLStr != nil) {//不一样,则取消上一次操作
//        
//        [[_opCache objectForKey:_lastURLStr] cancel];
//        
//        [_opCache removeObjectForKey:_lastURLStr];
//
//    }
    
    [[HMDownloaderManager sharedManager]cancelWithLastURLString:_lastURLStr];
    
     _lastURLStr = app.icon;
    
    
    [[HMDownloaderManager sharedManager] downLoadWithImageURL:app.icon finishBlock:^(UIImage *image) {
        self.iconImage.image = image;
    } ];
//    HMDownloaderOperation *op = [HMDownloaderOperation downLoadWithImageURL:app.icon finishBlock:^(UIImage *image) {
//        self.iconImage.image = image;
//        
//        [_opCache removeObjectForKey:app.icon];
//    }];
//    
//    //添加到操作缓存池
//    [_opCache setObject:op forKey:app.icon];
//    
//    [_queue addOperation:op];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _queue = [[NSOperationQueue alloc] init];
    
    _opCache = [NSMutableDictionary dictionary];
    
    [self loadData];
    
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 400)];
    headerV.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = headerV;
    
    UIImageView *img = [self imageView];
    img.frame = CGRectMake(100, 100, 100, 100);
    [headerV addSubview:img];
    self.iconImage = img;
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    add.center = headerV.center;
    [headerV addSubview:add];
    
    [add addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
}

-(UIImageView *)imageView{
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.backgroundColor = [UIColor redColor];
    return imgV;
}

#pragma mark - dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _appList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"app" forIndexPath:indexPath];
    
    HMAppModel *model = _appList[indexPath.row];
    cell.model = model;
    
    HMDownloaderOperation *op = [HMDownloaderOperation downLoadWithImageURL:model.icon finishBlock:^(UIImage *image) {//默认是在主线程刷新的
        cell.iconView.image = image;
    }];
    
    [_queue addOperation:op];
    
    

    return cell;
}

-(void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:@"https://raw.githubusercontent.com/baileilei/server20160820/master/apps.json" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSArray * responseObject) {
        NSLog(@"%@",responseObject);
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HMAppModel *appModel = [[HMAppModel alloc] init];
            
//            [appModel cz_objectWithDict:obj];//为什么不能用分类???
            [appModel setValuesForKeysWithDictionary:obj];
            
            [tempArray addObject:appModel];
        }];
        
        _appList = tempArray.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
