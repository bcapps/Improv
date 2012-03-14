//
//  ImprovTableViewCell.m
//  Improv
//
//  Created by Andrew Harrison on 2/28/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

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
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.minimumFontSize = 13.0f;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.highlightedTextColor = [UIColor whiteColor];
        

        descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.textAlignment = UITextAlignmentLeft;
        descriptionLabel.font = [UIFont systemFontOfSize:11.0f];
        descriptionLabel.backgroundColor = [UIColor clearColor];
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
