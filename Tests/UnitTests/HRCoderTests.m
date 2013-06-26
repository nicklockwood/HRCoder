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

@end

@implementation Model

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _text2 = [aDecoder decodeObjectForKey:@"text2"];
    _textNew = [aDecoder decodeObjectForKey:@"textNew"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_text2 forKey:@"text2"];
    [aCoder encodeObject:_textNew forKey:@"textNew"];
}

@end


@implementation HRCoderTests

- (void)testChangingModel
{
    //simulate saved model
    NSDictionary *dict = @{HRCoderClassNameKey: @"Model", @"text1": @"Foo", @"text2": @"Bar"};
    
    //load as new model
    Model *model = [HRCoder unarchiveObjectWithPlist:dict];
    
    //check properties
    NSAssert([model.text2 isEqualToString:@"Bar"], @"ChangingModel text failed");
    NSAssert(model.textNew == nil, @"ChangingModel text failed");
}

@end