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

@interface ViewController ()<UITableViewDataSource>

@end

@implementation ViewController{
    NSArray *_appList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadData];
}

#pragma mark - dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _appList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"app" forIndexPath:indexPath];
    
    
    cell.model = _appList[indexPath.row];

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
            
//            [appModel cz_objectWithDict:obj];
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
