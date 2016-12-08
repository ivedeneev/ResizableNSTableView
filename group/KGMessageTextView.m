//
//  KGMessageTextView.m
//  group
//
//  Created by Igor Vedeneev on 21.11.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGMessageTextView.h"

@implementation KGMessageTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textContainerInset = NSSizeFromCGSize(CGSizeMake(0, 0));
    self.textContainer.lineFragmentPadding = 0;
}

- (NSPoint)textContainerOrigin {
    return CGPointZero;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
