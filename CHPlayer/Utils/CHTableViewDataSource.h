//
//  CHTableViewDataSource.h
//  CHPlayer
//
//  Created by chenhang on 2017/8/11.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CHTableViewCellConfigureBlock)(UITableViewCell *cell, id item);

@interface CHTableViewDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items
                   identifier:(NSString *)cellIdentifier
       configurationCellBlock:(CHTableViewCellConfigureBlock)configurationBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
