//
//  CardMatchingGame.m
//  MatchNew
//
//  Created by Sean Regular on 5/22/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int DEFAULT_MATCHES = 2;

static const BOOL DEBUG_IT = YES;

// Have private elements
@interface CardMatchingGame()

// redeclare score are readwrite in the implementation
@property (nonatomic, readwrite) NSInteger score;

// Keep track of the cards, note this could take any object but we'll only put
// cards in it
@property (nonatomic, strong) NSMutableArray *cards;  // of Card
@property (nonatomic, readwrite) BOOL gameStarted;
@property (nonatomic, strong) NSMutableArray *gameLog;  // Has log of game

@end


@implementation CardMatchingGame

@synthesize matchesRequired = _matchesRequired;

- (void) setMatchesRequired:(NSInteger)matchesRequired {
    if ( self.gameStarted == NO ) {
        _matchesRequired = matchesRequired;
    }
}


// Lazy instantiation of the log
- (NSMutableArray *) gameLog {
    if (!_gameLog) _gameLog = [[NSMutableArray alloc] init];
    return _gameLog;
}

// Lazy instantiation of the cards array
- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck {
    
    // should always call super's init in your designated initializer
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
              [self.cards addObject:card];
            }
            else {
                // Didn't get a card couldn't init properly, return nil
                self = nil;
                break;
            }
        }
        self.gameStarted = NO;
        self.matchesRequired = DEFAULT_MATCHES;
        [self.gameLog removeAllObjects ];  // Clear game log array
    }
    return self;
}

// Return card at index within array of cards
- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

// Return the last log entry
- (NSString *)getLastLogEntry {
    return [self.gameLog lastObject];
}

// Bulk of logic for game here
- (void)chooseCardAtIndex:(NSUInteger)index {
    
    NSMutableArray *cardsMatched = [[NSMutableArray alloc] init];
    NSMutableArray *cardsToCheck = [[NSMutableArray alloc] init];
    NSMutableString *cardLog = [@"" mutableCopy];
    
    Card *card = [self cardAtIndex:index];
    
    self.gameStarted = YES;
    if (!card.isMatched) {  // Not matched
        if (card.isChosen) {
            card.chosen = NO;
        }
        else {
            self.score -= COST_TO_CHOOSE;  // Charge here for picking a card
            
            // We build an array that has all the cards to check
            card.chosen = YES;
            for (Card *aCard in self.cards) {
                if (aCard.isChosen && (aCard.isMatched == NO)) {
                    [cardsToCheck addObject:aCard];
                }
            }
            
            if (DEBUG_IT) {
                NSLog(@"---------------------------------");
            }
            // Now check all the cards in array, we use another array to hold the matches
            // that we find, when done with loop we check if that matches the number of
            // cards required to match... that's when we'll mark them as matched.
            if (cardsToCheck.count == self.matchesRequired) {
                int posToAdd, cardScores = 0;
                for (int i = 0; i < [cardsToCheck count] - 1; i++) {
                    Card *firstCard = [cardsToCheck objectAtIndex:i];
                    for (int j = i+1; j < cardsToCheck.count; j++) {
                        Card *secondCard = [cardsToCheck objectAtIndex:j];
                        int currCardScore = [firstCard match:@[secondCard]];
                        
                        if (DEBUG_IT) {
                            NSLog(@"Matching %@ to %@ got score %d",
                                  [firstCard contents],
                                  [secondCard contents],
                                  currCardScore);
                        }
                        
                        
                        if (currCardScore != 0) {
                            // Put cards in the array of matched cards
                            posToAdd = [cardsMatched indexOfObject:firstCard];
                            if (posToAdd == NSNotFound) {
                                [cardsMatched addObject:firstCard];
                            }
                            posToAdd = [cardsMatched indexOfObject:secondCard];
                            if (posToAdd == NSNotFound) {
                                [cardsMatched addObject:secondCard];
                            }
                            cardScores += currCardScore * MATCH_BONUS;
                            
                            [cardLog appendString:[NSString
                                                   stringWithFormat:@", %@ matched %@ score %d",
                                                   firstCard.contents,
                                                   secondCard.contents,
                                                   currCardScore * MATCH_BONUS]];
                        }
                        else {
                            self.score -= MISMATCH_PENALTY;
                        }
                    }
                    
                }  
                
                if (cardsMatched.count >= self.matchesRequired) {
                    for (Card *card2Mark in cardsMatched) {
                        card2Mark.matched = YES;
                    }
                    self.score += cardScores;
                }
                
                [cardLog appendString:[NSString
                                       stringWithFormat:@", Total score: %d",
                                       cardScores]];
                [self.gameLog addObject:[cardLog substringFromIndex:2]];
                
                NSLog([self getLastLogEntry]);
                
                
            }
            else
              if (cardsToCheck.count > self.matchesRequired) {
                  card.chosen = NO;
              }
            NSLog(@"Number of matches is %d",[cardsMatched count]);
        }
        
        
    }
}


/*
- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {  // Not matched
        if (card.isChosen) {
            card.chosen = NO;
        }
        else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    // Other one is chosen but not yet matched, calc score
                    // the match routine takes an array so create a single
                    // element one
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore != 0) {
                        self.score += matchScore * MATCH_BONUS;
                        // Got match, mark both cards chosen
                        otherCard.matched = YES;
                        card.matched = YES;
                    }
                    else {
                        self.score -= MISMATCH_PENALTY;
                        // Since only two card match we'll unchoose other card if no
                        // match.
                        otherCard.chosen = NO;
                    }
                    // Since we found a chosen card to look at we'll stop looking
                    // at more
                    break;
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
        
    }
}
*/

@end
