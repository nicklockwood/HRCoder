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

@end