//
//  Card.m
//  MatchNew
//
//  Created by Sean Regular on 5/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@implementation Card

// Define implementation for match
-(int)match:(NSArray *) othercards {
    int score = 0;
    for (Card *card in othercards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
