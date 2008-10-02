//
//  Color.m
//  Tractor
//
//  Created by Charlie Morss on 10/1/08.
//  Copyright 2008 AdReady. All rights reserved.
//

#import "Color.h"


@implementation Color

+ (NSColor *) colorFromHexRGB:(NSString *) inColorString
{
	NSColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor
		colorWithCalibratedRed:		(float)redByte	/ 0xff
							green:	(float)greenByte/ 0xff
							blue:	(float)blueByte	/ 0xff
							alpha:1.0];
	return result;
}

@end
