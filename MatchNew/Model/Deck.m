//
//  Deck.m
//  MatchNew
//
//  Created by Sean Regular on 5/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
    if (atTop) {
        [self.cards insertObject:card atIndex:0]; // Put in first spot
    }
    else {
        [self.cards addObject:card]; // Puts it at the end
    }
}

- (void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

- (BOOL)hasMoreCards {
    return ([self.cards count] > 0);
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count])
    {
        unsigned idx = arc4random() % [self.cards count];
        
        // statement below same as [self.cards objectAtIndex...:idx]
        randomCard = self.cards[idx];
        [self.cards removeObjectAtIndex:idx];
    }
    
    return randomCard;
}

@end
