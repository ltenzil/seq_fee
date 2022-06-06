# Fee Calculator

## Instructions:

  * Git Clone repo
  * Dependencies Ruby & Postgres
  * Install gem dependencies with `cd repo_path && bundle install`
  * Setup Database with `rails db:setup`
    this will create database, create records from seeds file.
  * Run the server with `rails s`
  * Run the console with `rails c`


## CodeWalkThrough:

  * This is a  web api application to serve disbursements, orders, and its fee calculation.
  * Once done with bundle install, run `rails db:setup`. this will create database, create records from seeds file.
  * Data is served via Postgres Database. 
  * Query Helpers file is extended to Order, Disbursement model, 
  * Disburse module in lib takes care of generating Report, applying fees for respective order, creates presentable objects which is saved to Disbursement model.

## Assumptions:
  
  * Week range is Monday - Sunday. when a random date is given the system finds the
    start of week (Monday), and end of week (Sunday).
  * Amount to be disbursed to a merchant for an order is:
    pay_merchant = order_amount - fee, which is rounded.
  * Due to time constraint, I went with Merchant id over Merchant name
  * Disburse generates report only for a week, based on any given date. 
    if not given it picks last week's range.
  * Api authenication is not done here. its open.

## Endpoints: 
  
  ## Disbursements - paginated
  * http://localhost:3000/api/v1/sequra/disbursements
  * http://localhost:3000/api/v1/sequra/disbursements?merchant_id=2
  * http://localhost:3000/api/v1/sequra/disbursements?start_date=1/1/2018&merchant_id=2
  * http://localhost:3000/api/v1/sequra/disbursements?start_date=1/1/2018&end_date=30/1/2018&merchant_id=2&page=2
  * http://localhost:3000/api/v1/sequra/disbursements?start_date=1/1/2018&end_date=30/1/2018&page=4

  ## Orders - paginated
  * http://localhost:3000 => root pointed to Order list page
  * http://localhost:3000/api/v1/sequra/orders
  * http://localhost:3000/api/v1/sequra/orders?shopper_id=129&page=1
  * http://localhost:3000/api/v1/sequra/orders?merchant_id=1

  ## Report
  * http://localhost:3000/api/v1/sequra/disburse_report?date=01/01/2018
  * http://localhost:3000/api/v1/sequra/disburse_report?date=01/01/2018&merchant_id=9

  ## Job
  * ReportJob.perform_now
  * ReportJob.perform_now({date: "1/1/2018"})
  * Cron job: runs every monday 6 am, using whenever gem
    bundle exec bin/rails runner -e development 'ReportJob.perform_now' 

## Improvements:
  
  * Create API for merchants and shoppers as well.
  * Refactor if required.
  * Delayed Job can added. With web request to create disbursements on random dates.
