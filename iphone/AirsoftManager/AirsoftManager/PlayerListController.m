//
//  PlayerListController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "PlayerListController.h"
#import "Player.h"

@interface PlayerListController ()

@end

@implementation PlayerListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Joueurs";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.searchDisplayController.searchResultsDelegate = self;
    [self reloadPlayers];

}

-(void)reloadPlayers {
    self.players = [[NSArray alloc] initWithArray:[[Player sharedPlayer] getAllPlayers]];
    self.playersSection = [self playersArrayToSection:self.players];
}


-(NSArray *)playersArrayToSection:(NSArray *)players {
    NSMutableArray *section = [[NSMutableArray alloc] init];
    
    NSEnumerator *e = [players objectEnumerator];
    NSEnumerator *e_section;
    
    Player *player;
    Player *tmp_player;
    NSMutableArray *tmp_section;
    
    while (player = [e nextObject])
    {
        e_section = [section objectEnumerator];
        while (tmp_section = [e_section nextObject])
        {
            tmp_player = [tmp_section objectAtIndex:0];
            if ([tmp_player.team isEqualToString:player.team])
            {
                [tmp_section addObject:player];
                break ;
            }
        }
        if (!tmp_section)
        {
            [section addObject:[[NSMutableArray alloc] initWithObjects:player, nil]];
        }
    }
    return ([[NSArray alloc] initWithArray:section]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.team contains[cd] %@)", searchText, searchText];
    self.searchResults = [self.players filteredArrayUsingPredicate:resultPredicate];
 }


 -(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
     [self
        filterContentForSearchText:searchString
        scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
               objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
     return (YES);
 }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPlayerDetail1"] || [[segue identifier] isEqualToString:@"ShowPlayerDetail2"])
    {
        NSIndexPath *myIndexPath;
        PlayerDetailController *playerDetail = [segue destinationViewController];
        
        if (sender == self.searchDisplayController.searchResultsTableView)
        {
            myIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            playerDetail.playerDetail = [self.searchResults objectAtIndex:[myIndexPath row]];
        }
        else
        {
            myIndexPath = [self.tableView indexPathForCell:sender];
            playerDetail.playerDetail = [[self.playersSection objectAtIndex:myIndexPath.section] objectAtIndex:myIndexPath.row];
        }
        
        playerDetail.playerListController = self;
    }
    else if ([[segue identifier] isEqualToString:@"AddPlayer"])
    {
        PlayerDetailController *playerDetail = [segue destinationViewController];
        
        playerDetail.playerDetail = [Player alloc];
        playerDetail.playerListController = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    else
        return [self.playersSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.searchResults count];
    else
        return [[self.playersSection objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    else
        return [[[self.playersSection objectAtIndex:section] objectAtIndex:0] team];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"Player";
	Player *player;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
        player = [self.searchResults objectAtIndex:indexPath.row];
    else
        player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = player.team;
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *player;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [player delete];
        
        [self reloadPlayers];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
 

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:@"ShowPlayerDetail1" sender:tableView];
    }
}

@end
