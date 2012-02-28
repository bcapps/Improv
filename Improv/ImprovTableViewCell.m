//
//  ImprovTableViewCell.m
//  Improv
//
//  Created by Andrew Harrison on 2/28/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "ImprovTableViewCell.h"

@implementation ImprovTableViewCell
@synthesize titleLabel, description;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor whiteColor];
        
        description = [[UILabel alloc] init];
        description.textAlignment = UITextAlignmentLeft;
        description.font = [UIFont systemFontOfSize:10];
        description.backgroundColor = [UIColor whiteColor];
        
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:description];
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
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame = CGRectMake(boundsX + 10, 0, 50, 50);
    imageView.frame = frame;
    
    frame = CGRectMake(boundsX + 70, 5, 200, 25);
    titleLabel.frame = frame;
    
    frame = CGRectMake(boundsX + 70, 30, 240, 15);
    description.frame = frame;
}

@end
