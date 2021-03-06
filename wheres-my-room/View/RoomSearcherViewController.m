//
//  RoomSearcherViewController.m
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/22/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomSearcherViewController.h"
#import "YahooRoomsManager.h"
#import "Room.h"
#import "RoomDetailControllerViewController.h"

@interface RoomSearcherViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;

@property (strong, nonatomic) NSArray *searchedRooms;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation RoomSearcherViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    self.title = @"Search";
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.searchBar.delegate = self;
    
    self.searchResultTable.delegate = self;
    self.searchResultTable.dataSource = self;
    [self.bgImageView setFrame:self.searchResultTable.frame];
    
    [self.searchResultTable setBackgroundView:self.bgImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[YahooRoomsManager sharedInstance] getRooms:searchBar.text complete:^(NSArray *rooms, NSError *error) {
        self.searchedRooms = rooms;
        [self.searchResultTable reloadData];
    }];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchedRooms != nil) {
        return [self.searchedRooms count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"classic"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classic"];
    }
    Room *r = (Room *)[self.searchedRooms objectAtIndex:indexPath.row];
    cell.textLabel.text = r.roomId;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Room *r = (Room *)[self.searchedRooms objectAtIndex:indexPath.row];
    NSString *selectedRoomId = r.roomId;
    RoomDetailControllerViewController *detailViewController = [[RoomDetailControllerViewController alloc] init];
    detailViewController.roomId = selectedRoomId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
