//
//  GameListController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 25/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameDetailController.h"

@interface GameListController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *gamesSection;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGame;
@property (weak, nonatomic) IBOutlet UITableView *gameTable;

-(void)reloadGames;
-(NSArray *)gamesArrayToSection:(NSArray *)games;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
