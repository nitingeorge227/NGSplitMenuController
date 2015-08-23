//
//  AppDelegate.m
//  NGSplitMenuController
//
//  Created by Nitin George on 8/19/15.
//  Copyright (c) 2015 Nitin George. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MainViewController.h"
//#import "NGSplitViewManager.h"
#import "NGSplitMenu.h"

@interface AppDelegate ()

@property (nonatomic,strong) UIViewController *rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MainViewController *manView = [[MainViewController alloc]init];
    MasterViewController *masterView = [[MasterViewController alloc]init];
    DetailViewController *detailView = [[DetailViewController alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    //[UIColor colorWithRed:0.212f green:0.212f blue:0.212f alpha:1.00f]
    
    [[NGSplitViewManager sharedInstance]setDefaultOptions:@{kNGMenuBackgroundColorKey : [UIColor colorWithRed:0.212f green:0.212f blue:0.212f alpha:1.00f],
                                                            kNGMenuItemFontKey             : [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f],
                                                            kNGMenuItemFontColorKey     :[UIColor whiteColor],
                                                            kNGMenuitemSelectionColorKey        : [UIColor colorWithRed:0.890f green:0.494f blue:0.322f alpha:1.00f],
                                                            kNGMenuSeperatorColorKey  : [UIColor colorWithWhite:0.841 alpha:1.000],
                                                            kNGMenuLineSeperatorKey     : @(NO),
                                                            }];
    
    [[NGSplitViewManager sharedInstance]setRootViewController:manView masterViewController:masterView detailViewController:detailView];
    
    [[NGSplitViewManager sharedInstance]setMenuItems:[self menuItems]];
    
    
    
    
    UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:manView];
    
    self.window.rootViewController = rootNavigationController;
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.090f green:0.349f blue:0.506f alpha:1.00f]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSArray*)menuItems{
    NSMutableArray *menuItem = [NSMutableArray array];
    
    NGMenuItem *menuItem1 = [[NGMenuItem alloc]init];
    menuItem1.itemDescription = @"Home";
    menuItem1.itemImage = [UIImage imageNamed:@"nav-icons-home2x.png"];
    [menuItem addObject:menuItem1];
    
    NGMenuItem *menuItem2 = [[NGMenuItem alloc]init];
    menuItem2.itemDescription = @"Mesages";
    menuItem2.itemImage = [UIImage imageNamed:@"nav-icons-email2x.png"];
    [menuItem addObject:menuItem2];
    
    NGMenuItem *menuItem3 = [[NGMenuItem alloc]init];
    menuItem3.itemDescription = @"RSS Feeds";
    menuItem3.itemImage = [UIImage imageNamed:@"nav-icons-rss2x.png"];
    [menuItem addObject:menuItem3];
    
    NGMenuItem *menuItem4 = [[NGMenuItem alloc]init];
    menuItem4.itemDescription = @"Twitter";
    menuItem4.itemImage = [UIImage imageNamed:@"nav-icons-twitter2x.png"];
    [menuItem addObject:menuItem4];
    
    
    return menuItem;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
