//
//  TRTicketView.h
//  Tractor
//
//  Created by Charlie Morss on 10/7/08.
//  Copyright 2008 AdReady. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TRTicketView : NSView {
   IBOutlet NSTextField *idField;
   IBOutlet NSTextField *summaryField;
}

@property (readonly, nonatomic) NSTextField *idField;
@property (readonly, nonatomic) NSTextField *summaryField;

-(NSString *)foo;
@end
