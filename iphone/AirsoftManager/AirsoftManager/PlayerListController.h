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

@interface PlayerListController : UITableViewController


@property (nonatomic, retain) NSArray *players;
@property (nonatomic, retain) NSArray *searchResults;

-(void)reloadPlayers;
- (IBAction)addPlayer:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
