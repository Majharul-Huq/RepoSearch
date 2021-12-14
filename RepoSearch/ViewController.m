//
//  ViewController.m
//  RepoSearch
//
//  Created by Majharul Huq on 2021/12/13.
//

#import "ViewController.h"
#import "Repository.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong) NSArray* arrRepositories;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

#define BASE_URL            @"https://api.github.com/search/repositories?"
#define SORT_STRING         @"&page=1&per_page=100&order=desc"
#define TIMEOUT_INTERVAL    1000

@implementation ViewController

@synthesize arrRepositories;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Search Repo";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [_activityIndicator startAnimating];
    
    // Create the URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@q=%@%@",BASE_URL,searchBar.text,SORT_STRING]];
    NSLog(@"url %@", url);
    
    if (url == nil) {
        return;
    }
    // Create the Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setTimeoutInterval:TIMEOUT_INTERVAL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (jsonError == nil) {
            self.arrRepositories = [jsonObject valueForKey:@"items"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                [self.tableView reloadData];
            });
        }
     }];
    
    [dataTask resume];
}

#pragma mark TableView delegate method
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld Results",arrRepositories.count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrRepositories.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString* identifier = @"TableCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: identifier forIndexPath:indexPath];
    NSDictionary *dict = [self.arrRepositories objectAtIndex:indexPath.row];
    Repository *model = [[Repository alloc] initWithModelDictionary:dict];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.htmlUrl;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

@end
