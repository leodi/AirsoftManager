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

@synthesize players, searchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Joueurs";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self reloadPlayers];

}

-(void)reloadPlayers {
    self.players = [[NSArray alloc] initWithArray:[[Player sharedPlayer] getAllPlayers]];
}

-(IBAction)addPlayer:(id)sender {
    NSLog(@"Add");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", searchText];
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
            PlayerDetailController *playerDetail = [segue destinationViewController];
            NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
            playerDetail.playerDetail = [self.players objectAtIndex:[myIndexPath row]];
            playerDetail.playerListController = self;
        }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [searchResults count];
    else
        return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"Player";
	Player *player;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        player = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = player.name;
    }
    else
    {
        player = [self.players objectAtIndex:indexPath.row];
        cell.textLabel.text = player.name;        
    }
    
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
        player = [self.players objectAtIndex:indexPath.row];
        
        [player delete];
        
        [self reloadPlayers];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
 */

@end
