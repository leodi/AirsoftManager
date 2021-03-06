//
//  GameDetailController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 01/06/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Player.h"
#import "GameListController.h"
#import "PlayerListController.h"

@class GameListController;
@interface GameDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) GameListController *gameListController;
@property (strong, nonatomic) Game    *game;
@property (nonatomic, retain) NSArray *playersSection;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *nbPlayers;
@property (weak, nonatomic) IBOutlet UITableView *playerTable;
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;


@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) UIToolbar *dateToolbar;

- (IBAction)saveGame:(id)sender;
- (IBAction)nameEdited:(id)sender;

-(void)addPlayer:(Player *)player;
-(void)setChronyStateFor:(Player *)player state:(BOOL)state;
-(void)setPaymentStateFor:(Player *)player state:(BOOL)state;
-(void)reloadPlayers;

@end
