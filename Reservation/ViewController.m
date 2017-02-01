//
//  ViewController.m
//  Reservation
//
//  Created by Spandana Nayakanti on 1/25/17.
//  Copyright © 2017 spandana. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "IonIcons.h"
#import "SPAServiceViewController.h"
#import "ReservationsTableViewCell.h"

@interface ViewController ()
{
    NSManagedObjectContext *context1;
    AppDelegate *appDelgate1;
    NSMutableArray *arrayForReservedPartyTime;
    NSMutableArray *arrayForReservedPartySize;
    NSMutableArray *arrayForReservedPartyDate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayForReservedPartyTime =[[NSMutableArray alloc]init];
    arrayForReservedPartyDate =[[NSMutableArray alloc]init];
    arrayForReservedPartySize =[[NSMutableArray alloc]init];
    [self navigationBarDetails];
    appDelgate1=[[UIApplication sharedApplication]delegate];
    context1=[appDelgate1 managedObjectContext];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - NavigationBarDetails

-(void)navigationBarDetails{
    self.title=@"My Reservations";
    
    UIBarButtonItem *barButtonItemForAdd = [[UIBarButtonItem alloc]initWithImage: [IonIcons imageWithIcon:ion_ios_plus_empty
                                                                                                       iconColor:[UIColor whiteColor]
                                                                                                        iconSize:40.0f
                                                                                        imageSize:CGSizeMake(40.0f, 40.0f)]style:UIBarButtonItemStylePlain target:self action:@selector(nextView)];
    self.navigationItem.rightBarButtonItem=barButtonItemForAdd;


}
#pragma mark support methods
-(void)nextView{
    SPAServiceViewController *SPAVC=[self.storyboard instantiateViewControllerWithIdentifier:@"spaservice"];
    [self.navigationController pushViewController:SPAVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrayForReservedPartyTime count];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250.0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *tableidentifier=@"reservations";
    
    ReservationsTableViewCell  *cell = [tableViewForMassage dequeueReusableCellWithIdentifier:tableidentifier forIndexPath:indexPath];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];

    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *reqDateString = [dateFormatter stringFromDate:[arrayForReservedPartyDate objectAtIndex:indexPath.row]];
    cell.lableForDate.text=reqDateString;
    cell.lableForTime.text=[arrayForReservedPartyTime objectAtIndex:indexPath.row];
    cell.lableForPartySize.text=[arrayForReservedPartySize objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -Fetch Data from coredata

-(void)fetchRecordFromCoredata
{
    
    [arrayForReservedPartyDate removeAllObjects];
    [arrayForReservedPartySize removeAllObjects];
    [arrayForReservedPartyTime removeAllObjects];
    NSError *error;
    NSArray *fetchedObjects;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Reserve"  inManagedObjectContext: context1];
    [fetch setEntity:entityDescription];
   
    fetchedObjects = [context1 executeFetchRequest:fetch error:&error];
    if (fetchedObjects.count>0)
    {
        
    for (NSManagedObject * obj in fetchedObjects)
    {
        
        [arrayForReservedPartyTime addObject: [obj valueForKey:@"partytime"]];
        if ([obj valueForKey:@"partysize"]!=nil)
        {
            [arrayForReservedPartySize addObject: [obj valueForKey:@"partysize"]];
        }
        
        [arrayForReservedPartyDate addObject: [obj valueForKey:@"partydate"]];
        
    }
    }
    [tableViewForMassage reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self fetchRecordFromCoredata];
}
@end
