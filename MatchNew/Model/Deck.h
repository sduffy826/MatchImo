//
//  Deck.h
//  MatchNew
//
//  Created by Sean Regular on 5/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

- (BOOL)hasMoreCards;

@end
