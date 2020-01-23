# Ruby Tweet search client

//Under construction: 

This Ruby client is written to work with the Twitter premium and enterprise versions of Tweet Search. 

+ Works with:
	+ Labs recent search only. 
	+ Master branch is a 'generalist' version that handles enterprise, premium, and Labs search.
	
This client is a command-line app that supports the following features:
	
+ Can manage an array of filters/rules/queries, making requests for each.
+ Returns total count for entire request period, aggregating the total counts across multiple requests.
+ Supports flexible ways to specify search period. E.g., ```-s 7d``` specifies the past week. Other patterns such as ```YYYY-MM-DD HH:mm```, standard Twitter ISO timestamps, and the enterprise ```YYYYMMDDhhmm``` pattern are also supported.
+ Writes to files or standard out. When writing files, one file is written for every API response. File names are based on query syntax, and are serialized. (Writing to a datastore... coming soon?)
+ Can stop making requests after a specified number. If your search query and period match millions of Tweets that would require hundreds of requests, you could have the client stop after four requests by adding the ```-x 4``` argument. 
	
[Premium](https://developer.twitter.com/en/docs/tweets/search/overview/premium) and [enterprise](https://developer.twitter.com/en/docs/tweets/search/overview/enterprise) search APIs are nearly identical but have some important differences. See the linked documents for more information. 

----------------
Jump to:

+ [Getting started](#getting-started)
  + [Selecting API](#selecting-api)
  + [Setting credentials](#credentials)
+ [Example calls](#example-calls)
+ [Fundamental Details](#details)
  + [Configuring the client](#configuring)
  + [Command-line arguments](#arguments)
  + [Specifying search period start and end times](#specifying-times)
  + [Rules files](#rules)
+ [Next steps](#next)
--------------------

## Getting started <a id="getting-started" class="tall">&nbsp;</a>

Four fundamental steps need to be taken to start using this search client: 

1) Establish access to the API(s) of choice.
2) Have your API credentials on hand.
3) Get this Ruby app running in your environment. 
4) Configure client. 
5) Use command-line arguments to start making search requests.

+ Establish access to API:
  + For Labs
  + Obtain credentials for authenticating with the API
  

+ Install client in your environment:
  + Clone respository.
  + Get gems installed with ```bundle install```. See project Gem file. Need some basic gems like 'json', 'yaml'. 
  + Test it out by running ```$ruby search-app.rb -h```. You should see a help menu. 

+ Configure the client.
 + Set application options and crendentials. The Bearer Token is stored in a configuration YAML file. The client deafults to a ```./config/config.yaml``` file, but you can specify any path using the ```-c``` command-line option.


## Example calls <a id="example-calls" class="tall">&nbsp;</a>




## Fundamental details <a id="details" class="tall">&nbsp;</a>

### Configuring the client <a id="configuring" class="tall">&nbsp;</a>

This client relies on a YAML configuration file for some fundamental settings, such as the search API you are working with. This file also contains your credentials for authenticating with your search API of choice.

By default, this file has a path of ```./config/config.yaml```. You can overwrite this default with the ```-c``` command-line option.

Here are the default configuration settings with descriptions of each option:

```yaml
#Client options.
options:
  url: https://api.twitter.com/labs/1/tweets/search
  search_type: labs #premium or enterprise or labs
  archive: recent #fullarchive or 30day or recent
  max_results: 100 #For Labs this max is 100.
  format: compact
  write_mode: so # options: files, so/standard/standard-out --> Store activities in local files or print to system out?
  out_box: ./output # Folder where retrieved data goes.

#Credentials.
auth:
  app_token:

```

### Command-line arguments <a id="arguments" class="tall">&nbsp;</a>

Once you have the configuration file set up, you can start making requests. Search API request parameters (identical across all premium and enterprise APIs) are specified as arguments via the command line. 

For making Tweet requests ('data') see our request parameter documentation [HERE](https://developer.twitter.com/en/docs/tweets/search/api-reference/enterprise-search).
For making *number of Tweets* ('counts') see our request parameter documentation [HERE](https://developer.twitter.com/en/docs/tweets/search/api-reference/enterprise-search).

#### Command-line options:

```
Usage: search-app [options]
    -c, --config CONFIG              Configuration file (including path) that provides account and option selections.
                                       Config file specifies which search api, includes credentials, and sets app options.
    -q, --query QUERY                Maps to API "query" parameter.  Either a single query passed in, or a file containing either a
                                   YAML or JSON array of queries/rules.
    -s, --start_time START           UTC timestamp for beginning of Search period (maps to "start_time").
                                         Specified as YYYYMMDDHHMM, \"YYYY-MM-DD HH:MM\", YYYY-MM-DDTHH:MM:SS.000Z or use ##d, ##h or ##m.
    -e, --end_time END               UTC timestamp for ending of Search period (maps to "end_time").
                                      Specified as YYYYMMDDHHMM, \"YYYY-MM-DD HH:MM\", YYYY-MM-DDTHH:MM:SS.000Z or use ##d, ##h or ##m.
    -i, --since_id SINCEID           All matching Tweets since this Tweet ID was created (exclusive).
    -u, --until_id UNTILID           All matching Tweets up until this ID was created (exclusive).
    -m, --max MAXRESULTS             Specify the maximum amount of Tweets results per response (maps to "max_results"). 10 to 100, defaults to 10.
    -f, --format FORMAT              Specify the format for Tweet JSON, defaults to "default".
    -x, --exit EXIT                  Specify the maximum amount of requests to make. "Exit app after this many requests."
    -w, --write WRITE                'files', 'standard-out' (or 'so' or 'standard').
    -o, --outbox OUTBOX              Optional. Triggers the generation of files and where to write them.
    -t, --tag TAG                    Optional. Gets included in the  payload if included. Alternatively, rules files can contain tags.
    -h, --help                       Display this screen.

```

### Specifying search period start and end times <a id="specifying-times" class="tall">&nbsp;</a>

NOTE: Current code supports search periods longer than 7-days. The Labs recent search endpoint covers the previous 7 days, but longer search periods are likely to be available. 

Start ```-s``` and end ```-e``` parameters can be specified in a variety of ways:

+ A combination of an integer and a character indicating "days" (#d), "hours" (#h) or "minutes" (#m). Some examples:
	+ -s 3d --> Start 3 days (72 hours) ago.
	+ -s 7d -e 5d --> Start 7 days ago and end 5 days ago.
	+ -s 6h --> Start six hours ago (i.e. Tweets from the last six hours).

+ "YYYY-MM-DD HH:mm" (UTC, use double-quotes please).
	+ -s "2020-01-14 07:00" -e "2020-01-16 07:00" --> Tweets from between 2020-01-14 and 2020-01-16 MST.

### Rules files <a id="rules" class="tall">&nbsp;</a>

Search API requests are based on a single rule or filter. When making requests for a single rule, that rule is passed in via the copmmadn-line with the ```-r``` argument. 

However, this client supports making requests with multiple rules, managing the data retrieval for each individual rule. Multiple rules can be specified in JSON or YAML files.  Below is an example of each. 

JSON rules file:

```json
{
  "rules" :
    [
        {
          "value" : "snow colorado",
          "tag" : "ski_biz"
        },
        {
          "value" : "snow utah",
          "tag" : "ski_biz"
        },
        {
          "value" : "rain washington",
          "tag" : "umbrellas"
        }
    ]
}
```

YAML rules file:

```yaml
rules:
  - value  : "snow colorado"
    tag    : ski_biz
  - value  : "snow utah"
    tag    : ski_biz
  - value  : "rain washington"
    tag    : umbrellas
```

For example, you can pass in a JSON rules file located at ./rules/my-snow-rules.json with the following argument:

```$ruby search_app.rb -r "./rules/my-snow-rules.json" -s 7d" -x 1```  


## Next steps <a id="next" class="tall">&nbsp;</a>























