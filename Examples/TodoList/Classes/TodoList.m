//
//  TodoList.m
//  TodoList
//
//  Created by Nick Lockwood on 15/04/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

#import "TodoList.h"
#import "TodoItem.h"
#import "HRCoder.h"


@implementation TodoList

@synthesize items = _items;


#pragma mark -
#pragma mark Loading and saving

+ (NSString *)documentsDirectory
{	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (TodoList *)sharedList
{	
    static TodoList *sharedList = nil;
	if (sharedList == nil)
    {
        //attempt to load saved file
        NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:@"TodoList.plist"];
        sharedList = [[HRCoder unarchiveObjectWithFile:path] retain];
        
        //if that fails, load default list from bundle
		if (sharedList == nil)
        {
			path = [[NSBundle mainBundle] pathForResource:@"TodoList" ofType:@"plist"];
            sharedList = [[HRCoder unarchiveObjectWithFile:path] retain];
		}
	}
	return sharedList;
}

- (void)save;
{	
	NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent:@"TodoList.plist"];
	[HRCoder archiveRootObject:self toFile:path];
}


#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        self.items = [aDecoder decodeObjectForKey:@"items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.items forKey:@"items"];
}


#pragma mark -
#pragma mark Cleanup

- (void)dealloc
{
	[_items release];
	[super dealloc];
}

@end
