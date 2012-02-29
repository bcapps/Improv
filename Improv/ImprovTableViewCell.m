//
//  ImprovTableViewCell.m
//  Improv
//
//  Created by Andrew Harrison on 2/28/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//
//@property(nonatomic,copy)   NSString       *text;            // default is nil
//@property(nonatomic,retain) UIFont         *font;            // default is nil (system font 17 plain)
//@property(nonatomic,retain) UIColor        *textColor;       // default is nil (text draws black)
//@property(nonatomic,retain) UIColor        *shadowColor;     // default is nil (no shadow)
//@property(nonatomic)        CGSize          shadowOffset;    // default is CGSizeMake(0, -1) -- a top shadow
//@property(nonatomic)        UITextAlignment textAlignment;   // default is UITextAlignmentLeft
//@property(nonatomic)        UILineBreakMode lineBreakMode;   // default is UILineBreakModeTailTruncation. used for single and multiple lines of text
//
//// the 'highlight' property is used by subclasses for such things as pressed states. it's useful to make it part of the base class as a user property
//
//@property(nonatomic,retain)               UIColor *highlightedTextColor; // default is nil
//@property(nonatomic,getter=isHighlighted) BOOL     highlighted;          // default is NO
//
//@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is NO
//@property(nonatomic,getter=isEnabled)                BOOL enabled;                 // default is YES. changes how the label is drawn
//
//// this determines the number of lines to draw and what to do when sizeToFit is called. default value is 1 (single line). A value of 0 means no limit
//// if the height of the text reaches the # of lines or the height of the view is less than the # of lines allowed, the text will be
//// truncated using the line break mode.
//
//@property(nonatomic) NSInteger numberOfLines;
//
//// these next 3 property allow the label to be autosized to fit a certain width by shrinking the font size to a minimum font size
//// and to specify how the text baseline moves when it needs to shrink the font. this only affects single line text (lineCount == 1)
//
//@property(nonatomic) BOOL adjustsFontSizeToFitWidth;          // default is NO
//@property(nonatomic) CGFloat minimumFontSize;                 // default is 0.0
//@property(nonatomic) UIBaselineAdjustment baselineAdjustment; // default is 

#import "ImprovTableViewCell.h"

@implementation ImprovTableViewCell
@synthesize titleLabel, descriptionLabel;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.minimumFontSize = 13.0f;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.highlightedTextColor = [UIColor whiteColor];
        

        descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.textAlignment = UITextAlignmentLeft;
        descriptionLabel.font = [UIFont systemFontOfSize:11.0f];
        descriptionLabel.backgroundColor = [UIColor whiteColor];
        descriptionLabel.minimumFontSize = 8.0f;
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
        descriptionLabel.highlightedTextColor = [UIColor whiteColor];
        descriptionLabel.numberOfLines = 2;
        
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:descriptionLabel];
        [self.contentView addSubview:imageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGSize sizeToFit = [self.descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(240, 30) lineBreakMode:descriptionLabel.lineBreakMode];

    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame = CGRectMake(boundsX + 10, 0, 50, 50);
    imageView.frame = frame;
    
    frame = CGRectMake(boundsX + 70, 5, 200, 25);
    titleLabel.frame = frame;
    
    frame.origin.x = boundsX + 70;
    frame.origin.y = 30;
    frame.size = sizeToFit;
    descriptionLabel.frame = frame;
}

@end
