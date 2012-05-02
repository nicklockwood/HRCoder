//
//  TodoItem.m
//  TodoList
//
//  Created by Nick Lockwood on 08/04/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

#import "TodoItem.h"


@implementation TodoItem

@synthesize label = _label, checked = _checked;

+ (TodoItem *)itemWithLabel:(NSString *)label
{
	TodoItem *item = [[self alloc] init];
	item.label = label;
	return [item autorelease];
}

#pragma mark -
#pragma mark NSCoding

//note: we've not implemented the NSCoding methods
//because the AutoCoding library takes care of this for us


#pragma mark -
#pragma mark Cleanup

- (void)dealloc
{
	[_label release];
	[super dealloc];
}

@end
