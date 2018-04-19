//
//  BuyCreditViewController.m
//  Wink
//
//  Created by Apple on 13/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "BuyCreditViewController.h"

#define wCredit30 @"WinkCredit30"
#define wCredit70 @"WinkCredit70"
#define wCredit120 @"WinkCredit120"

@interface BuyCreditViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblCredits;

@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong,nonatomic)  NSArray *validProducts;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UITableView *tblvPurchases;
@property (strong, nonatomic) SKProduct *selectedProduct;
@end

@implementation BuyCreditViewController
@synthesize lblCredits,creditBalance,productsRequest,validProducts,activityIndicatorView,tblvPurchases,selectedProduct;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    lblCredits.text = [NSString stringWithFormat:@"Credits (%d)",creditBalance];
    [self GetInAppPurchase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}
-(void)GetInAppPurchase
{
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:wCredit30,wCredit70,wCredit120,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    [SVProgressHUD show];
}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addFunds
{
    if([WinkUtil reachable])
    {
        int credit = 0;
        
        if([selectedProduct.productIdentifier isEqualToString:wCredit30])
        {
            credit = 30;
        }
        else if ([selectedProduct.productIdentifier isEqualToString:wCredit70])
        {
            credit = 70;
        }
        else if ([selectedProduct.productIdentifier isEqualToString:wCredit120])
        {
            credit = 120;
        }
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"funds" : [NSNumber numberWithInt:credit]
                               };
        [WinkWebServiceAPI addCredits:dict completionHandler:^(WinkAPIResponse *response, int balance)
        {
            if(response.code == RCodeSuccess)
            {
               lblCredits.text = [NSString stringWithFormat:@"Credits (%d)",balance];
                WinkGlobalObject.user.balance = balance;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else if(response.message)
            {
                [self showAlertWithMessage:response.message];
            }
            else
            {
                [self showAlertWithMessage:response.error.localizedDescription];
            }
            
        }];
    }
    else
    {
        
    }
}
#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:selectedProduct.productIdentifier])
                {
                    [SVProgressHUD dismiss];
                    [self addFunds];
                    
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [SVProgressHUD dismiss];
                NSLog(@"Purchase failed ");
                break;
            default:
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    //SKProduct *validProduct = nil;
    
    [SVProgressHUD dismiss];
    int count = (int)[response.products count];
    if (count > 0)
    {
        validProducts = response.products;
        [tblvPurchases reloadData];
        
        /*if ([validProduct.productIdentifier
             isEqualToString:kTutorialPointProductID]) {
            [productTitleLabel setText:[NSString stringWithFormat:
                                        @"Product Title: %@",validProduct.localizedTitle]];
            [productDescriptionLabel setText:[NSString stringWithFormat:
                                              @"Product Desc: %@",validProduct.localizedDescription]];
            [productPriceLabel setText:[NSString stringWithFormat:
                                        @"Product Price: %@",validProduct.price]];
        }*/
        
    } else
    {
        [self showAlertWithMessage:@"No products to purchase"];
    }    
    [activityIndicatorView stopAnimating];
   
}
#pragma mark -UITableView Delegate & DataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return validProducts.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditCell"];
    SKProduct *validProduct = validProducts[indexPath.row];
    
    cell.lblPrice.text = [NSString stringWithFormat:@"Product Price : %@" ,validProduct.price];
    cell.lblPurchaseName.text = [NSString stringWithFormat:
                                 @"Product Title : %@",validProduct.localizedTitle];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self canMakePurchases])
    {
        selectedProduct = validProducts[indexPath.row];
        
        SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [SVProgressHUD show];
    }
    else
    {
        [self showAlertWithMessage:@"Purchase are disabled"];
        
    }
}
@end
