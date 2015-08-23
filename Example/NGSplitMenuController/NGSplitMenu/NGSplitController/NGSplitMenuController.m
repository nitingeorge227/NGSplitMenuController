//
//  NGSplitMenuController.m
//  NGSplitMenuController

//NGSplitMenu is available under the MIT license.
//
//Copyright © 2015 Nitin George.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NGSplitMenuController.h"
#import "MenuTableCell.h"
#import "NGMenuItem.h"
#import "NGMenuConstants.h"

#define kViewWidth [self getScreenWidth]
#define kViewHeight [self getScreenHeight]
#define kMenuWidthPercentage .11
#define kMasterviewWidthPercentage .32

typedef enum
{
    kMenuHide,
    kMenuHideDetail,
    kMenuMinimize,
    kMenuMaximize,
    kMenuNone
}MenuToggleState;


@interface NGSplitMenuController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger menuViewWidth;
    NSInteger masterViewWidth;
    NSInteger kDefaultDetailViewWidth;
    NSInteger kWidthMin;
}

@property (nonatomic,strong) UIViewController *masterViewController;
@property (nonatomic,strong) UIViewController *detailViewController;
@property (nonatomic,strong) UIView *masterViewContainer;
@property (nonatomic,strong) UIView *detailViewContainer;
@property (nonatomic,strong) UIView *menuContainerView;
@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) NSIndexPath *currentMenuIndex;
@property (nonatomic,assign) MenuToggleState menuToggleState;
@property (nonatomic,assign) MenuToggleState currentMenuToggleState;
@property (nonatomic,strong) NSIndexPath *selectedMenuIndexPath;
@property (nonatomic,strong) NSLayoutConstraint *menuLeadingContraint;
@property (nonatomic,strong) NSLayoutConstraint *menuWidthContraint;
@property (nonatomic,strong) NSLayoutConstraint *middleViewLeadingSpaceContraint;
@property (nonatomic,strong) NSLayoutConstraint *rightViewTrailingConstraint;
@property (nonatomic,strong) NSLayoutConstraint *middleViewWidthContraint;
@property (nonatomic,strong) NSDictionary *defaultOptions;
@property (nonatomic,strong) UILabel *seperatorLabel;
@property (nonatomic,strong) UILabel *viewSeperatorLabel;

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

- (void)setMasterViewController:(UIViewController*)masterController andDetailController:(UIViewController*)detailViewController{
    _masterViewController = masterController;
    _detailViewController = detailViewController;
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
    
    masterViewWidth = kViewWidth * kMasterviewWidthPercentage;
    menuViewWidth = kViewWidth * kMenuWidthPercentage;
    kDefaultDetailViewWidth = kViewWidth - (menuViewWidth + masterViewWidth);
    
    _menuContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuViewWidth, self.view.frame.size.height)];
    UIColor *backgroundColor;
    if (_defaultOptions[kNGMenuBackgroundColorKey]) {
        backgroundColor = _defaultOptions[kNGMenuBackgroundColorKey];
    }
    else{
        backgroundColor = kNGMenubackgroundColor;
    }
    _menuContainerView.backgroundColor = backgroundColor;
    
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, menuViewWidth, self.view.frame.size.height)];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.backgroundColor = [UIColor clearColor];
    [_menuContainerView addSubview:_menuTableView];
    [self.view addSubview:_menuContainerView];
    _masterViewContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + menuViewWidth, 0, masterViewWidth, self.view.frame.size.height)];
    
    _masterViewContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_masterViewContainer];
    
    _detailViewContainer = [[UIView alloc]initWithFrame:CGRectMake(_masterViewContainer.frame.origin.x + _masterViewContainer.frame.size.width, 0, masterViewWidth, self.view.frame.size.height)];
    _detailViewContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_detailViewContainer];
    
    //adding layout constrints.
    self.menuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.masterViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _masterViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _detailViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:_masterViewController];
    [self addChildViewController:_detailViewController];
    [self.masterViewContainer addSubview:_masterViewController.view];
    [self.detailViewContainer addSubview:_detailViewController.view];
    
    [self drawSeparators];
    
    _menuWidthContraint = [NSLayoutConstraint
                           constraintWithItem:_menuContainerView
                           attribute:NSLayoutAttributeWidth
                           relatedBy:NSLayoutRelationEqual
                           toItem:nil
                           attribute:NSLayoutAttributeNotAnAttribute
                           multiplier:1.0
                           constant:menuViewWidth];
    
    [self.view addConstraint:_menuWidthContraint];
    
    _menuLeadingContraint = [NSLayoutConstraint
                             constraintWithItem:_menuContainerView
                             attribute:NSLayoutAttributeLeading
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.view
                             attribute:NSLayoutAttributeLeading
                             multiplier:1.0
                             constant:0.0];
    
    [self.view addConstraint:_menuLeadingContraint];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_menuContainerView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.topLayoutGuide
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_menuContainerView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.bottomLayoutGuide
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    
    _middleViewWidthContraint = [NSLayoutConstraint
                                 constraintWithItem:_masterViewContainer
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0
                                 constant:masterViewWidth];
    
    [self.view addConstraint:_middleViewWidthContraint];
    
    _middleViewLeadingSpaceContraint = [NSLayoutConstraint
                                       constraintWithItem:_masterViewContainer
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:_menuContainerView
                                       attribute:NSLayoutAttributeLeading
                                       multiplier:1.0
                                       constant:menuViewWidth];
    
    [self.view addConstraint:_middleViewLeadingSpaceContraint];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewContainer
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:_detailViewContainer
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewContainer
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.topLayoutGuide
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewContainer
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.bottomLayoutGuide
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewContainer
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:_masterViewContainer
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    _rightViewTrailingConstraint = [NSLayoutConstraint
                                    constraintWithItem:_detailViewContainer
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:0.0];
    [self.view addConstraint:_rightViewTrailingConstraint];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewContainer
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.topLayoutGuide
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewContainer
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.bottomLayoutGuide
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    
    //layout menutable inside menu container
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_menuContainerView
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:_menuTableView
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_menuTableView
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:_menuContainerView
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_menuTableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.topLayoutGuide
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_menuTableView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.bottomLayoutGuide
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
    //layout the master and detail viewcontrollers on top of the container views
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewController.view
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.masterViewContainer
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.masterViewContainer
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:_masterViewController.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewController.view
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.masterViewContainer
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.masterViewContainer
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:_masterViewController.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
    ///////////////////////////
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewController.view
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.detailViewContainer
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.detailViewContainer
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:_detailViewController.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewController.view
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.detailViewContainer
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.detailViewContainer
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:_detailViewController.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
    _menuToggleState = kMenuNone;
    _currentMenuToggleState = kMenuHideDetail;
    [self initializeConstraints];
    
    
    
    _menuTableView.dataSource = self;
    _menuTableView.delegate = self;
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _selectedMenuIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_menuTableView selectRowAtIndexPath:_selectedMenuIndexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)initializeConstraints{
    if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)) {
        _menuLeadingContraint.constant = 0;
        _menuWidthContraint.constant = kViewWidth * kMenuWidthPercentage;
        _middleViewLeadingSpaceContraint.constant = kViewWidth * kMenuWidthPercentage;
        _middleViewWidthContraint.constant = kViewWidth - (kViewWidth * kMenuWidthPercentage);
        _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;

    }
    else{
        _menuLeadingContraint.constant = 0;
        _menuWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
        _middleViewLeadingSpaceContraint.constant = kViewWidth * kMasterviewWidthPercentage;
        _middleViewWidthContraint.constant = kViewWidth - (kViewWidth * kMasterviewWidthPercentage);
        _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;
    }
}

#pragma mark

- (void) drawSeparators
{
    
    UIColor *seperatorColor;
    
    if (_defaultOptions[kNGMenuSeperatorColorKey]) {
        seperatorColor = _defaultOptions[kNGMenuSeperatorColorKey];
    }
    else{
        seperatorColor = kNGMenuSeperatorColor;
    }
    
    BOOL isLineSeperator;
    
    if (_defaultOptions[kNGMenuLineSeperatorKey]) {
        isLineSeperator = [_defaultOptions[kNGMenuLineSeperatorKey] boolValue];
    }
    else{
        isLineSeperator = kNGMenuLineSeparator;
    }
    
    if (isLineSeperator) {
        _seperatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(_menuContainerView.frame.size.width - 1, 0, 1, self.view.frame.size.height)];
        
        
        _seperatorLabel.backgroundColor = seperatorColor;
        
        _seperatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_menuContainerView addSubview:_seperatorLabel];
        
        [_menuContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_seperatorLabel
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:1]];
        
        [_menuContainerView addConstraint:[NSLayoutConstraint
                                           constraintWithItem:_seperatorLabel
                                           attribute:NSLayoutAttributeTrailing
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:_menuContainerView
                                           attribute:NSLayoutAttributeTrailing
                                           multiplier:1.0
                                           constant:0.0]];
        [_menuContainerView addConstraint:[NSLayoutConstraint
                                           constraintWithItem:_menuContainerView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:_seperatorLabel
                                           attribute:NSLayoutAttributeTop
                                           multiplier:1.0
                                           constant:0.0]];
        [_menuContainerView addConstraint:[NSLayoutConstraint
                                           constraintWithItem:_seperatorLabel
                                           attribute:NSLayoutAttributeBottom
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:_menuContainerView
                                           attribute:NSLayoutAttributeBottom
                                           multiplier:1.0
                                           constant:0.0]];
        
        _viewSeperatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(masterViewWidth-1, 0, 1, self.view.frame.size.height)];
        _viewSeperatorLabel.backgroundColor = seperatorColor;
        [_masterViewController.view addSubview:_viewSeperatorLabel];
        
        _viewSeperatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [_masterViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:_viewSeperatorLabel
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.0
                                                                                constant:1]];
        
        [_masterViewController.view addConstraint:[NSLayoutConstraint
                                                   constraintWithItem:_viewSeperatorLabel
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:_masterViewController.view
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:0.0]];
        [_masterViewController.view addConstraint:[NSLayoutConstraint
                                                   constraintWithItem:_masterViewController.view
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:_viewSeperatorLabel
                                                   attribute:NSLayoutAttributeTop
                                                   multiplier:1.0
                                                   constant:0.0]];
        [_masterViewController.view addConstraint:[NSLayoutConstraint
                                                   constraintWithItem:_viewSeperatorLabel
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:_masterViewController.view
                                                   attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0
                                                   constant:0.0]];

    }
    else{
        
        UIBezierPath *masterShadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.masterViewController.view.bounds.origin.x, self.masterViewController.view.bounds.origin.y, self.masterViewController.view.bounds.size.width, kViewHeight) ];
        
        self.masterViewController.view.layer.masksToBounds = NO;
        self.masterViewController.view.layer.shadowColor = seperatorColor.CGColor;
        self.masterViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.masterViewController.view.layer.shadowOpacity = 1.0f;
        self.masterViewController.view.layer.shadowRadius = 3.0f;
        
        self.masterViewController.view.layer.shadowPath = masterShadowPath.CGPath;

        UIBezierPath *detailShadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.detailViewController.view.bounds.origin.x, self.detailViewController.view.bounds.origin.y, self.detailViewController.view.bounds.size.width, kViewHeight)];
        
        self.detailViewController.view.layer.masksToBounds = NO;
        self.detailViewController.view.layer.shadowColor = seperatorColor.CGColor;
        self.detailViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.detailViewController.view.layer.shadowOpacity = 1.0f;
        self.detailViewController.view.layer.shadowRadius = 3.0f;
        
        self.detailViewController.view.layer.shadowPath = detailShadowPath.CGPath;
        
        
    }
    
}

#pragma mark toggle methods

- (void)toggle{
    
    [self.view layoutIfNeeded];
    if (_menuToggleState == kMenuHideDetail) {
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)) {
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewWidthContraint.constant = kViewWidth - (kViewWidth * kMenuWidthPercentage);
            _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;
//            _menuToggleState = kMenuNone;//need to recheck
            
        }
        else{
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _middleViewWidthContraint.constant = kViewWidth - _menuWidthContraint.constant;
            _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;
        }
        _menuToggleState = kMenuHide;
    }
    else if (_menuToggleState == kMenuMinimize) {
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) ) {
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = 0;
            _middleViewLeadingSpaceContraint.constant = 0;
            _middleViewWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;
        }
        else{
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _rightViewTrailingConstraint.constant = (kViewWidth * kMasterviewWidthPercentage)-(kViewWidth * kMenuWidthPercentage);
           
        }
         _menuToggleState = kMenuMaximize;
    }
    else if (_menuToggleState == kMenuMaximize){
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) ) {
             _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + ((kViewWidth * kMenuWidthPercentage) + (kViewWidth * kMasterviewWidthPercentage));
            
        }
        else{
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = 0;
            _middleViewLeadingSpaceContraint.constant = 0;
            _rightViewTrailingConstraint.constant = 0;
            
            
        }
        _menuToggleState = kMenuHide;
        
    }
    else{
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) ) {
            
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = 0;
            _middleViewLeadingSpaceContraint.constant = -_middleViewWidthContraint.constant;
            _rightViewTrailingConstraint.constant = 0;
            
        }
        else{
            _menuLeadingContraint.constant = 0;
            _middleViewWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _menuWidthContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMenuWidthPercentage;
            _rightViewTrailingConstraint.constant = 0;
            
        }
        _menuToggleState = kMenuMinimize;
        
        
    }
    _currentMenuToggleState = _menuToggleState;
    [self.menuTableView reloadData];
    [self.menuTableView selectRowAtIndexPath:_selectedMenuIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self animateToggleMenu];
    
}

- (void)adjustContraintsOnOrientationChange{
    [self.view layoutIfNeeded];
    
    if (_currentMenuToggleState == kMenuHideDetail) {
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)) {
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewWidthContraint.constant = kViewWidth - (kViewWidth * kMenuWidthPercentage);
            _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;
            
        }
        else{
            _menuWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _middleViewWidthContraint.constant = kViewWidth - _menuWidthContraint.constant;
            _rightViewTrailingConstraint.constant = _rightViewTrailingConstraint.constant + kViewWidth * kMasterviewWidthPercentage;
        }
        _menuToggleState = kMenuHide;
        
    }
    else{
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)) {
            _menuLeadingContraint.constant = 0;
            _menuWidthContraint.constant = 0;
            _middleViewLeadingSpaceContraint.constant = -_middleViewWidthContraint.constant;
            _rightViewTrailingConstraint.constant = 0;
        }
        else{
            _menuLeadingContraint.constant = 0;
            _middleViewWidthContraint.constant = kViewWidth * kMasterviewWidthPercentage;
            _menuWidthContraint.constant = kViewWidth * kMenuWidthPercentage;
            _middleViewLeadingSpaceContraint.constant = kViewWidth * kMenuWidthPercentage;
            _rightViewTrailingConstraint.constant = 0;
            
        }
        _menuToggleState = kMenuMinimize;
    }
    [self.menuTableView reloadData];
    [self.menuTableView selectRowAtIndexPath:_selectedMenuIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self animateToggleMenu];
    
}

- (void)animateToggleMenu
{
    
    [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark set master/detail

- (void)setMasterView:(UIViewController*)viewController{
    
    [_masterViewController removeFromParentViewController];
    [_masterViewController.view removeFromSuperview];
    
    _masterViewController = nil;
    
    _masterViewController = viewController;
    
    _masterViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self addChildViewController:_masterViewController];
    [self.masterViewContainer addSubview:_masterViewController.view];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewController.view
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.masterViewContainer
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.masterViewContainer
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:_masterViewController.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_masterViewController.view
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.masterViewContainer
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.masterViewContainer
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:_masterViewController.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
        _menuToggleState = kMenuHideDetail;
        [self toggle];
    [self drawSeparators];
}

- (void)setDetailView:(UIViewController*)viewController{
    [_detailViewController removeFromParentViewController];
    [_detailViewController.view removeFromSuperview];
    
    _detailViewController = nil;
    
    _detailViewController = viewController;
    _detailViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:_detailViewController];
    [self.detailViewContainer addSubview:_detailViewController.view];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewController.view
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.detailViewContainer
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.detailViewContainer
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:_detailViewController.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_detailViewController.view
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.detailViewContainer
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.detailViewContainer
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:_detailViewController.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
//    if (!_menuToggleState == kMenuHide) {
//        _menuToggleState = kMenuHide;
//        [self toggle];
//    }
//    else if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) ){
//        _menuToggleState = kMenuHide;
//        [self toggle];
//    }
    
    _menuToggleState = kMenuHide;
    [self toggle];
    [self drawSeparators];
}

- (void)setMenuItems:(NSArray *)menuItems{
    _menuItems = menuItems;
    [_menuTableView reloadData];
}

#pragma mark menu table delegate/datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MenuTableCellReuseIdentifier";
    
    MenuTableCell *sideMenuTableViewCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (sideMenuTableViewCell == nil) {
        sideMenuTableViewCell = [[MenuTableCell alloc]initWithMinimumWidth:kViewWidth * kMenuWidthPercentage maximumWidth:kViewWidth * kMasterviewWidthPercentage style:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    else{
        [sideMenuTableViewCell setWidthWhenMaximized:kViewWidth * kMasterviewWidthPercentage];
        [sideMenuTableViewCell setWidthWhenMinimized:kViewWidth * kMenuWidthPercentage];
    }
    
    UIColor *backgroundColor;
    
    if (_defaultOptions[kNGMenuBackgroundColorKey]) {
        backgroundColor = _defaultOptions[kNGMenuBackgroundColorKey];
    }
    else{
        backgroundColor = kNGMenubackgroundColor;
    }

    sideMenuTableViewCell.backgroundColor = backgroundColor;
    
    sideMenuTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NGMenuItem *menuItem;
    
    menuItem = _menuItems[indexPath.row];
    
    if (menuItem) {
        sideMenuTableViewCell.menuDescriptionLabel.text = menuItem.itemDescription;
        sideMenuTableViewCell.typeImageView.image = menuItem.itemImage;
    }
    
    if (_menuToggleState == kMenuMinimize ) {
        [sideMenuTableViewCell switchToMiniView:YES];
    }
    else{
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) ){
            [sideMenuTableViewCell switchToMiniView:YES];
        }
        else{
            [sideMenuTableViewCell switchToMiniView:NO];
        }
        
    }
    
    UIFont *menuFont;
    UIColor *textColor;
    UIColor *selectionColor;
    if (_defaultOptions[kNGMenuItemFontColorKey]) {
        textColor = _defaultOptions[kNGMenuItemFontColorKey];
    }
    else{
        textColor = kNGFontColor;
    }
    sideMenuTableViewCell.menuDescriptionLabel.textColor = textColor;
    
    if (_defaultOptions[kNGMenuItemFontKey]) {
        menuFont = _defaultOptions[kNGMenuItemFontKey];
    }
    else{
        menuFont = kNGMenuItemFont;
    }
    sideMenuTableViewCell.menuDescriptionLabel.font = menuFont;
    
    if (_defaultOptions[kNGMenuitemSelectionColorKey]) {
        selectionColor = _defaultOptions[kNGMenuitemSelectionColorKey];
    }
    else{
        selectionColor = kNGMenuItemSelectionColor;
    }
    
    sideMenuTableViewCell.selectedBackgroundColor = selectionColor;
    
    return sideMenuTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedMenuIndexPath.row == indexPath.row) {
        return;
    }
    _selectedMenuIndexPath = indexPath;
    
    NGMenuItem *menuItem = _menuItems[indexPath.row];
    menuItem.menuIndex  = indexPath.row;
    
    NSDictionary *userInfoDict;
    
    if (menuItem) {
        userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:menuItem,kNGMenuItemKey, nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kMenuItemSelectesNotification object:nil userInfo:userInfoDict];
    }
    
    
}

- (CGFloat)getScreenWidth{
    
    CGFloat width;
    if ([self respondsToSelector:@selector(extensionContext)]) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    else{
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
        {
            width = [UIScreen mainScreen].bounds.size.height;
        }
        else{
            width = [UIScreen mainScreen].bounds.size.width;
        }
    }
    return width;
}

- (CGFloat)getScreenHeight{
    
    CGFloat width;
    if ([self respondsToSelector:@selector(extensionContext)]) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    else{
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
        {
            width = [UIScreen mainScreen].bounds.size.width;
        }
        else{
            width = [UIScreen mainScreen].bounds.size.height;
        }
    }
    return width;
}

- (void)setDefaults:(NSDictionary *)defaults{
    _defaultOptions = [defaults copy];
}

#pragma orientation

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    [self adjustContraintsOnOrientationChange];
}

@end
