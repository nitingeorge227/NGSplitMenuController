//
//  MenuTableCell.m
//  NGSplitMenuController
//

//NGSplitMenu is available under the MIT license.
//
//Copyright © 2015 Nitin George.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MenuTableCell.h"

#define kCellHeight 70
#define kMenuItemWidth 45
#define kMenuItemHeight 45
#define kMenuItemWidthExpanded 55
#define kMenuItemHeightExpanded 55
#define kImageLeadingConstraintConstant 25
#define kImageTrailingConstraintConstant 21
#define kMEnuDescriptionLabelHeight 21
#define kMenuDescriptionLabeltrailingConstraintConstant 23

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MenuTableCell()




- (void)initSubViews;

@end

@implementation MenuTableCell

- (instancetype) initWithMinimumWidth:(CGFloat)minimumWidth maximumWidth:(CGFloat)maximumWidth style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _widthWhenMinimized = minimumWidth;
        _widthWhenMaximized = maximumWidth;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kImageLeadingConstraintConstant, (kCellHeight/2) - (kMenuItemHeight/2), kMenuItemWidth, kMenuItemHeight)];
    [self.contentView addSubview:_typeImageView];
    
    _menuDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(_typeImageView.frame.origin.x+ _typeImageView.frame.size.width + kImageTrailingConstraintConstant, (kCellHeight/2) - (kMEnuDescriptionLabelHeight/2), (_widthWhenMaximized) - (_typeImageView.frame.origin.x + _typeImageView.frame.size.width + kImageTrailingConstraintConstant + kMenuDescriptionLabeltrailingConstraintConstant), kMEnuDescriptionLabelHeight)];
    _menuDescriptionLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_menuDescriptionLabel];
    
}

- (void)awakeFromNib {
    // Initializing image view center X constaint for future use
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = self.selectedBackgroundColor;
    }
    else{
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)switchToMiniView:(BOOL)yes
{
    [self.menuDescriptionLabel setHidden:yes];
    CGRect imageFrame;
    if (yes) {
        imageFrame = CGRectMake((_widthWhenMinimized/2) - (kMenuItemWidthExpanded/2), (kCellHeight/2) - (kMenuItemHeightExpanded/2), kMenuItemWidthExpanded, kMenuItemHeightExpanded);
        
    }
    else{
        imageFrame = CGRectMake(kImageLeadingConstraintConstant, (kCellHeight/2) - (kMenuItemHeight/2), kMenuItemWidth, kMenuItemHeight);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _typeImageView.frame = imageFrame;
    }];

}


@end
