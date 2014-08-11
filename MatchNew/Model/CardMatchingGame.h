//
//  CardMatchingGame.h
//  MatchNew
//
//  Created by Sean Regular on 5/22/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSString *)getLastLogEntry;

// Need score, no getter so make readonly, it'll be
// only updated within implementation (privately)
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSInteger matchesRequired;
@property (nonatomic, readonly) BOOL gameStarted;


@end
