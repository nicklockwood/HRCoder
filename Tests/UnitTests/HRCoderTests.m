//
//  HRCoderTests.m
//
//  Created by Nick Lockwood on 12/01/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//

#import "HRCoderTests.h"
#import "HRCoder.h"


@interface Model : NSObject <NSCoding>

@property (nonatomic, strong) NSString *text2;
@property (nonatomic, strong) NSString *textNew;
@property (nonatomic, copy) NSArray *array1;
@property (nonatomic, copy) NSArray *array2;

@end

@implementation Model

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _text2 = [aDecoder decodeObjectForKey:@"text2"];
    _textNew = [aDecoder decodeObjectForKey:@"textNew"];
    _array1 = [aDecoder decodeObjectForKey:@"array1"];
    _array2 = [aDecoder decodeObjectForKey:@"array2"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_text2 forKey:@"text2"];
    [aCoder encodeObject:_textNew forKey:@"textNew"];
    [aCoder encodeObject:_array1 forKey:@"array1"];
    [aCoder encodeObject:_array2 forKey:@"array2"];
}

@end


@implementation HRCoderTests

- (void)testChangingModel
{
    //simulate saved model
    NSDictionary *dict = @{HRCoderClassNameKey: @"Model", @"text1": @"Foo", @"text2": @"Bar"};
    
    //load as new model
    Model *model = [HRCoder unarchiveObjectWithPlistOrJSON:dict];
    
    //check properties
    NSAssert([model.text2 isEqualToString:@"Bar"], @"ChangingModel text failed");
    NSAssert(model.textNew == nil, @"ChangingModel text failed");
}

- (void)testAliasing
{
    Model *model = [[Model alloc] init];
    model.array1 = @[@1, @2];
    model.array2 = model.array1;
    
    //seralialize
    NSData *data = [HRCoder archivedDataWithRootObject:model];
    
    //load as new model
    model = [HRCoder unarchiveObjectWithData:data];
    
    //check properties
    NSAssert([model.array1 isEqualToArray:model.array2], @"Aliasing failed");
    NSAssert(model.array1 == model.array2, @"Aliasing failed");
    
    //now make them different but equal
    model.array2 = @[@1, @2];
    
    //seralialize
    data = [HRCoder archivedDataWithRootObject:model];
    
    //load as new model
    model = [HRCoder unarchiveObjectWithData:data];
    
    //check properties
    NSAssert([model.array1 isEqualToArray:model.array2], @"Aliasing failed");
    NSAssert(model.array1 != model.array2, @"Aliasing failed");
}

- (void)testPlistData
{
    //encode null
    NSArray *array = @[[NSNull null]];
    
    //seralialize
    NSDictionary *plist = [HRCoder archivedPlistWithRootObject:array];
    
    //convert to plist data
    NSError *error = nil;
    NSData *output = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    NSAssert(output && !error, @"Plist encoding failed");
}

- (void)testJSONData
{
    //encode date and data
    NSArray *array = @[[NSDate date], [@"foo" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //seralialize
    NSDictionary *json = [HRCoder archivedJSONWithRootObject:array];
    
    //convert to json data
    NSError *error = nil;
    NSData *output = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    NSAssert(output && !error, @"JSON encoding failed");
    
    //convert back
    NSArray *result = [HRCoder unarchiveObjectWithData:output];
    NSAssert([result isEqualToArray:array], @"JSON decoding failed");
}

@end