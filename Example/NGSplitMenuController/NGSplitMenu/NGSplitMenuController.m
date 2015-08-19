//
//  NGSplitMenuController.m
//  NGSplitMenuController
//
//  Created by Nitin George on 8/19/15.
//  Copyright (c) 2015 Nitin George. All rights reserved.
//

#import "NGSplitMenuController.h"


@interface NGSplitMenuController ()
{
    NSInteger kMenuViewWidth;
    NSInteger kDefaultMasterViewWidth;
    NSInteger kDefaultDetailViewWidth;
    NSInteger kWidthMin;
}

@property (nonatomic,strong) UIViewController *masterViewController;
@property (nonatomic,strong) UIViewController *detailViewController;
@property (nonatomic,strong) UIView *masterViewContainer;
@property (nonatomic,strong) UIView *detailViewContainer;
@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,assign) CGFloat masterViewWidth;
@property (nonatomic,assign) CGFloat detailViewWidth;
@property (nonatomic,strong) NSIndexPath *currentMenuIndex;

@end

@implementation NGSplitMenuController

- (instancetype)initWithMasterViewController:(UIViewController*)masterController andDetailController:(UIViewController*)detailViewController{
    self = [super init];
    
    if (self) {
        _masterViewController = masterController;
        _detailViewController = detailViewController;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup master and child views

- (void)setUpViews{
    
    kDefaultMasterViewWidth = self.view.frame.size.width*.32;
    kMenuViewWidth = self.view.frame.size.width*.11;
    kDefaultDetailViewWidth = self.view.frame.size.width - (kMenuViewWidth + kDefaultMasterViewWidth);
    _masterViewWidth = kDefaultMasterViewWidth;
    _detailViewWidth = kDefaultDetailViewWidth;
    
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMenuViewWidth, self.view.frame.size.height)];
    _menuTableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_menuTableView];
    
    _masterViewContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + kMenuViewWidth, 0, _masterViewWidth, self.view.frame.size.height)];
    
    _masterViewContainer.backgroundColor = [UIColor redColor];
    [self.view addSubview:_masterViewContainer];
    
    _detailViewContainer = [[UIView alloc]initWithFrame:CGRectMake(_masterViewContainer.frame.origin.x + _masterViewContainer.frame.size.width, 0, _detailViewWidth, self.view.frame.size.height)];
    _detailViewContainer.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_detailViewContainer];
    
    //adding layout constrints.
    
    self.masterViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark width setter methods

- (void)setMasterListWidth:(CGFloat)width{
    
    if (width && width > kWidthMin) {
        _masterViewWidth = width;
    }
    else{
        _masterViewWidth = kDefaultMasterViewWidth;
    }
    
}

- (void)setDetailListWidth:(CGFloat)width{
    if (width && width > kWidthMin) {
        _detailViewWidth = width;
    }
    else{
        _masterViewWidth = kDefaultDetailViewWidth;
    }
    
}

@end
