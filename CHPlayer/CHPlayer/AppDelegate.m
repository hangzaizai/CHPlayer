//
//  AppDelegate.m
//  CHPlayer
//
//  Created by 陈行 on 17/8/9.
//  Copyright © 2017年 陈行. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [self test];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)test
{
    NSString *str = @"abcdefghijklmnopqrstuvwxyz";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *subDataOne = [data subdataWithRange:NSMakeRange(0, 0)];
    NSString *subStringOne = [[NSString alloc] initWithData:subDataOne encoding:NSUTF8StringEncoding];
    
    
    NSData *subDataTwo = [data subdataWithRange:NSMakeRange(0, 5)];
    NSString *subStringTwo = [[NSString alloc] initWithData:subDataTwo encoding:NSUTF8StringEncoding];
    
    NSData *subDataThree = [data subdataWithRange:NSMakeRange(5, 5)];
    NSString *subStringThree = [[NSString alloc] initWithData:subDataThree encoding:NSUTF8StringEncoding];
    
    NSRange unionOne = NSUnionRange(NSMakeRange(0, 5), NSMakeRange(9, 5));
    
    NSRange sectionOne = NSIntersectionRange(NSMakeRange(0, 5), NSMakeRange(5, 5));
    
    NSLog(@"");
    
}

@end
