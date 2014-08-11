//
//  PlayingCard.m
//  MatchNew
//
//  Created by Sean Regular on 5/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♣︎",@"♥︎",@"♦︎",@"♠︎"];
}

// Return rank as a string (more user friendly and an int)
+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

// Setter, we implement to ensure that arg is valid
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

// Getter, if suit is nil then question mark is returned
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

// Setter for rank
- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

// Override super's contents
- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank]
            stringByAppendingString:self.suit];
}

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count] -1;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (PlayingCard *otherCard in otherCards) {
        if (self.rank == otherCard.rank) {
            score += 4;
        }
        else if ([self.suit isEqualToString:otherCard.suit]) {
            score += 1;
        }
    }
    return score;
}


@end
