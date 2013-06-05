//
//  PlayerListController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PlayerDetailController.h" 
#import "GameDetailController.h" 

@class GameDetailController;
@interface PlayerListController : UITableViewController <UISearchBarDelegate,UISearchDisplayDelegate>

@property BOOL isFromGames;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (nonatomic, retain) NSArray *players;
@property (nonatomic, retain) NSArray *playersSection;
@property (nonatomic, retain) NSArray *teams;
@property (nonatomic, retain) NSArray *searchResults;

@property (strong, nonatomic) GameDetailController *parentGameDetailController;

-(void)reloadPlayers;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
