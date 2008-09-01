//
//  NWView.h
//  Needle Works
//
//  Copyright 2008 Ryan Lovett <ryan@spacecoaster.org>. All rights reserved.
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//   
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.

#import "NWView.h"
#import "NWStitchBlock.h"
#import "MyDocument.h"

@implementation NWView

- (void) drawRect:(NSRect) rect {
	MyDocument* doc = [self delegate];

	/* Draw the background */
	[[NSColor whiteColor] set];
	NSRectFill (rect);
	
	/* Draw a red box around our view for debugging *
	NSColor* red = [NSColor redColor];
	[red setStroke];
	NSBezierPath* outline = [NSBezierPath bezierPathWithRect:r];
	[outline setLineWidth:3];
	[[NSBezierPath bezierPathWithRect:r] stroke];*/

	/* shrink code - just for playing
	float factor = 0.5f;
	 NSView* clipView = [self superview];
	NSSize clipViewFrameSize = [clipView frame].size;
	[clipView setBoundsSize:NSMakeSize((clipViewFrameSize.width/factor), (clipViewFrameSize.height/factor))];
	 */
	
	/* Get our list of stitch blocks */
	NSArray*		drawList = [doc objects];
	NSEnumerator*	iter = [drawList objectEnumerator];
	NWStitchBlock*	stitchblock;
	 
	/* Draw all of the blocks */
	while(stitchblock = [iter nextObject]) {
		[stitchblock drawWithSelection:FALSE];
	}	
}

/* http://developer.apple.com/documentation/Cocoa/Conceptual/CocoaViewsGuide/Optimizing/chapter_8_section_7.html */
- (void) setFrameSize:(NSSize)newSize {

    [super setFrameSize:newSize];
	
    if ([self inLiveResize]) {
		// A change in size has required the view to be invalidated.
        NSRect rects[4];
        int count;
		
        [self getRectsExposedDuringLiveResize:rects count:&count];
		
        while (count-- > 0) {
            [self setNeedsDisplayInRect:rects[count]];
        }
    } else {
        [self setNeedsDisplay:YES];
    }
}

/*
- (void)printDocument:(id)sender {
	NSPrintInfo* printinfo = [NSPrintInfo sharedPrintInfo];
	[printinfo setHorizontalPagination:NSFitPagination];
	[printinfo setVerticalPagination:NSFitPagination];
	[printinfo setHorizontallyCentered:YES];
	[printinfo setVerticallyCentered:YES];
	
	[printinfo setTopMargin: 0.0f];
	[printinfo setBottomMargin: 0.0f];
	[printinfo setRightMargin: 7.0f];
	[printinfo setLeftMargin: 7.0f];
	if ([self bounds].size.height < [self bounds].size.width) {
		[printinfo setOrientation:NSLandscapeOrientation];
	} else {
		[printinfo setOrientation:NSPortraitOrientation];
	}

	
    // Assume documentView returns the custom view to be printed
    NSPrintOperation *op = [NSPrintOperation
							printOperationWithView:self //[self documentView]
							printInfo:printinfo];//[self printInfo]];
	[op runOperation];

    /*[op runOperationModalForWindow:self //[self documentWindow]
						  delegate:self
					didRunSelector:
	 @selector(printOperationDidRun:success:contextInfo:)
					   contextInfo:NULL];
}*/
/*
- (void)printOperationDidRun:(NSPrintOperation *)printOperation
					 success:(BOOL)success
				 contextInfo:(void *)info {
    if (success) {
        // Can save updated NSPrintInfo, but only if you have
        // a specific reason for doing so
        // [self setPrintInfo: [printOperation printInfo]];
    }
}
*/

/*
- (void) print:(id)sender {
	NSPrintInfo* printinfo = [NSPrintInfo sharedPrintInfo];
	[printinfo setHorizontalPagination:NSFitPagination];
	[printinfo setVerticalPagination:NSFitPagination];
	[printinfo setHorizontallyCentered:YES];
	[printinfo setVerticallyCentered:YES];
	
	[printinfo setTopMargin: 0.0f];
	[printinfo setBottomMargin: 0.0f];
	[printinfo setRightMargin: 7.0f];
	[printinfo setLeftMargin: 7.0f];
	if ([self bounds].size.height < [self bounds].size.width) {
		[printinfo setOrientation:NSLandscapeOrientation];
	} else {
		[printinfo setOrientation:NSPortraitOrientation];
	}

	NSPrintOperation* printOperation = [NSPrintOperation printOperationWithView:self printInfo:printinfo];
		[printOperation runOperationModalForWindow: [self window]
						delegate: nil didRunSelector: nil contextInfo: nil];
		
}*/

/* We want to draw with (0, 0) at the top left */
- (BOOL) isFlipped {
	return YES;
}

- (BOOL) isOpaque {
	return YES;
}

- (void) setDelegate:(id) aDelegate {
	_delegate = aDelegate;
}

- (id) delegate {
	return _delegate;
}
@end