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
@interface PlayerListController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchDisplayDelegate>

@property BOOL isFromGames;
@property (nonatomic, retain) NSArray *players;
@property (nonatomic, retain) NSArray *playersSection;
@property (nonatomic, retain) NSArray *teams;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) NSMutableDictionary *checkedResult;

@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) GameDetailController *parentGameDetailController;

-(void)reloadPlayers;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
