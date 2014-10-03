//
//  CardGameViewController.m
//  MatchNew
//
//  Created by Sean Regular on 5/6/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameInfoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;

@end

@implementation CardGameViewController
- (IBAction)resetButton:(id)sender {
    _game = nil;
    
    [self initGame];
    [self updateUI];
}

- (IBAction)touchSegmentController:(id)sender {
    [self initStyleForController];
}

- (void) initGame {
    [self initStyleForController];
}

- (void) initStyleForController {
    if (self.segmentController.selectedSegmentIndex == 0) {
        self.game.matchesRequired = 2;
    }
    else
        if (self.segmentController.selectedSegmentIndex == 1) {
            self.game.matchesRequired = 3;
        }
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        // If card is matched then card is disabled
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    }
    
    if (self.game.gameStarted) {
        [self.segmentController setEnabled:NO forSegmentAtIndex:0];
        [self.segmentController setEnabled:NO forSegmentAtIndex:1];
    }
    else {
        [self.segmentController setEnabled:YES forSegmentAtIndex:0];
        [self.segmentController setEnabled:YES forSegmentAtIndex:1];
    }
    
    self.gameInfoLabel.text = [self.game getLastLogEntry];
}

// Helper methods to return card text and background image
- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
