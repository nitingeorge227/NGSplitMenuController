//
//  NGSplitViewManager.m
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

#import "NGSplitViewManager.h"
#import "NGSplitMenuController.h"

static NGSplitViewManager *_sharedInstance;

@interface NGSplitViewManager()

@property (nonatomic,strong) NGSplitMenuController *ngSplitMenuController;
@end

@implementation NGSplitViewManager

-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NGSplitViewManager *) sharedInstance {
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[NGSplitViewManager alloc] init];
    });
    
    return _sharedInstance;
}

- (NGSplitMenuController *)ngSplitMenuController{
    if (!_ngSplitMenuController) {
        _ngSplitMenuController = [[NGSplitMenuController alloc]init];
    }
    return _ngSplitMenuController;
}

- (void) setRootViewController:(UIViewController*)rootViewController masterViewController:(UIViewController*)masterViewController detailViewController:(UIViewController*)detailViewCOntroller{
   [self.ngSplitMenuController setMasterViewController:masterViewController andDetailController:detailViewCOntroller];
    [rootViewController addChildViewController:self.ngSplitMenuController];
    [rootViewController.view addSubview:self.ngSplitMenuController.view];
    
    self.ngSplitMenuController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [rootViewController.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.ngSplitMenuController.view
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:rootViewController.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:0.0]];
    [rootViewController.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:rootViewController.view
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.ngSplitMenuController.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:0.0]];
    [rootViewController.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.ngSplitMenuController.view
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:rootViewController.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    [rootViewController.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:rootViewController.view
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.ngSplitMenuController.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
}

- (void)toggleMenu{
    [self.ngSplitMenuController toggle];
}

- (void)setMasterViewController:(UIViewController*)masterViewController{
    [self.ngSplitMenuController setMasterView:masterViewController];
}

- (void)setDetailViewController:(UIViewController*)detailViewController{
    [self.ngSplitMenuController setDetailView:detailViewController];
}

- (void)setMenuItems:(NSArray *)menuItems{
    [self.ngSplitMenuController setMenuItems:menuItems];
}

- (void)setDefaultOptions:(NSDictionary*)defaultOptions{
    [self.ngSplitMenuController setDefaults:defaultOptions];
}

@end
