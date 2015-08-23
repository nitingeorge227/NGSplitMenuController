//
//  MainViewController.m
//  NGSplitMenuController
//
//  Created by Nitin George on 8/20/15.
//  Copyright (c) 2015 Nitin George. All rights reserved.
//

#import "MainViewController.h"
#import "NGSplitMenu.h"
#import "MasterViewController.h"
#import "MasterViewControllerOne.h"
#import "MasterViewControllerTwo.h"
#import "MasterViewControllerThree.h"

typedef enum{
    kHome,
    kMail,
    kRss,
    kTwitter,
    kNone,
}MenuType;

@interface MainViewController ()

{
    MasterViewController *masterViewController;
    MasterViewControllerOne *masterViewControllerOne;
    MasterViewControllerTwo *masterViewControllerTwo;
    MasterViewControllerThree *masterViewControllerThree;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 19, 19)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuItemSelected:) name:kMenuItemSelectesNotification object:nil];
    masterViewController = [[MasterViewController alloc]initWithNibName:@"MasterViewController" bundle:nil];
    masterViewControllerOne = [[MasterViewControllerOne alloc]initWithNibName:@"MasterViewControllerOne" bundle:nil];
    masterViewControllerTwo = [[MasterViewControllerTwo alloc]initWithNibName:@"MasterViewControllerTwo" bundle:nil];
    masterViewControllerThree = [[MasterViewControllerThree alloc]initWithNibName:@"MasterViewControllerThree" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)toggle{
    [[NGSplitViewManager sharedInstance]toggleMenu];
}

- (void)menuItemSelected:(NSNotification*)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NGMenuItem *menuItem = [userInfo objectForKey:kNGMenuItemKey];
    
    if (menuItem) {
        if (menuItem.menuIndex == kHome) {
            [[NGSplitViewManager sharedInstance]setMasterViewController:masterViewController];
        }
        else if (menuItem.menuIndex == kMail){
            [[NGSplitViewManager sharedInstance]setMasterViewController:masterViewControllerOne];
        }
        else if (menuItem.menuIndex == kRss){
            [[NGSplitViewManager sharedInstance]setMasterViewController:masterViewControllerTwo];
        }
        else if (menuItem.menuIndex == kTwitter){
            [[NGSplitViewManager sharedInstance]setMasterViewController:masterViewControllerThree];
        }
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
