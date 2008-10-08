//
//  TRTicketView.m
//  Tractor
//
//  Created by Charlie Morss on 10/7/08.
//  Copyright 2008 AdReady. All rights reserved.
//

#import "TRTicketView.h"


@implementation TRTicketView

@synthesize idField;
@synthesize summaryField;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
  [super drawRect:rect];
}

- (NSString *)foo {
  return @"bar";
}
@end
