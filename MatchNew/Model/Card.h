//
//  Card.h
//  MatchNew
//
//  Created by Sean Regular on 5/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

// Properties for chosen/matched, we override getter name
// (common for BOOL types)
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

// prototype for the match method, takes array of cards
- (int)match:(NSArray *)othercards;

@end
