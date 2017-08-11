//
//  ViewController.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/9.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "ViewController.h"
#import "CHVedioPlayerCtrl.h"
#import "CHTableViewDataSource.h"
#import "CHVedioPlayViewController.h"

@interface ViewController ()<UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)CHTableViewDataSource *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    NSArray *vedioAddress = @[@"https://rc-jc-files.haochang.tv/file/download/98ad4625-c779-4213-aa04-b287fd95e32d.mp4",@"https://rc-jc-files.haochang.tv/file/download/70d00415-0e44-452f-8272-308352983af1.mp4",@"https://rc-jc-files.haochang.tv/file/download/b9b884a8-192c-4a59-8d68-11b69ea48e9a.mp4",@"https://rc-jc-files.haochang.tv/file/download/fd1dd3db-9d3e-4df4-a50c-8dbbc137e2c3.mp4",@"https://rc-jc-files.haochang.tv/file/download/414ff8e2-d46e-4c06-a3c6-7cbc04ed1f53.mp4"];
    
    CHTableViewDataSource *dataSource = [[CHTableViewDataSource alloc] initWithItems:vedioAddress identifier:NSStringFromClass([self class]) configurationCellBlock:^(UITableViewCell *cell, id item) {
        cell.textLabel.text = (NSString *)item;
    }];
    self.dataSource = dataSource;
    UITableView *tableView = [UITableView newAutoLayoutView];
    self.tableView = tableView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    tableView.dataSource = dataSource;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    [tableView autoPinEdgesToSuperviewEdges];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHVedioPlayViewController *vedioViewCtrl = [[CHVedioPlayViewController alloc] init];
    [self.navigationController pushViewController:vedioViewCtrl animated:YES];
}

@end
