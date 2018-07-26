# stock_market_chart_iOS

## Demo

![Alt Text](https://github.com/snehakasetty224/stock_market_chart_iOS/raw/master/ViewGlassGif.gif)

## API’s Used to get stock symbols and details

1. I have used the IEX API for getting the stocks symbols and details (name,price,change percent,chart and news).Referred the following API documentation https://iextrading.com/developer/docs/#getting-started
2. API to get symbols https://api.iextrading.com/1.0/ref-data/symbols
3. API to get stock details of a particular stock "https://api.iextrading.com/1.0/stock/aapl/batch?types=quote&range=1m&last=10"
4. API to get chart details of a particular stock https://api.iextrading.com/1.0/stock/aapl/chart/1d
5. API to get news details for a particular stock https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,&types=quote,news
6. The stock app has persistence enabled using NSKeyedArchiver to store the symbols. We can perform fetch(decode), save(encode) and delete on the my favorite symbol list.
7. By default if my favourite list is empty, I am initializing the symbols with 5 symbols.
8. My stocks table displays My favourite symbols details such as Name, price and change percent.
9. All the symbols are fetched from the REST API and displayed in the picker view.
10. You can select symbols from picker view add to the My favourite list, which fetches details of the stock symbol and adds to  Stocks table. 
11. You can delete a stock detail from the My stocks table which , deletes the symbols from My favourite symbols list and the file .
12. On Clicking the stock item from the table, navigates to a different view which shows the day chart of the stock in a graph along with the news table.
13. You can select different time data and click on update button which shows the updated graph.
14. The news table shows the news title along with the date of the news of a particular stock. On clicking a news item it opens the link in the safari browser.

## Pods used 
- SwiftyJSON - for parsing the JSON data
- Alamofire - for Swift networking 
- SwiftChart - for displaying the stock details in the form of a chart

## Additional Features to Improve the UI 
The symbol list gets All symbols from the API and is displayed in Picker View Controller. Instead of picker View to display symbols a text field search bar would be useful to search the symbols easily and add to the Stocks Table.


