//
//  KGTextMessageCell.m
//  group
//
//  Created by Igor Vedeneev on 20.11.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTextMessageCell.h"

@interface KGTextMessageCell ()
@property (assign) CGFloat maxWidth;

@end

@implementation KGTextMessageCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.backgroundColor = [NSColor lightGrayColor];
    self.textView.superview.superview.layer.backgroundColor = [NSColor redColor].CGColor;
    self.textView.font = [NSFont fontWithName:@"Helvetica Neue" size:16.0];
    
    [self.textView.superview.superview setAutoresizingMask:NSViewNotSizable];
    [self.textView.superview.superview setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (void)configureWithString:(NSString *)string width:(CGFloat)width {
    self.textView.string = string;

}


@end
