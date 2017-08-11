//
//  CHTableViewDataSource.m
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "CHTableViewDataSource.h"

@interface CHTableViewDataSource ()

@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)NSString *identifierStr;
@property(nonatomic,copy)CHTableViewCellConfigureBlock block;

@end

@implementation CHTableViewDataSource

- (instancetype)initWithItems:(NSArray *)items identifier:(NSString *)cellIdentifier configurationCellBlock:(CHTableViewCellConfigureBlock)configurationBlock
{
    self = [super init];
    if ( self ) {
        self.items = items;
        self.identifierStr = cellIdentifier;
        self.block = configurationBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifierStr forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if ( self.block ) {
        self.block(cell,item);
    }
    return cell;
}

@end
