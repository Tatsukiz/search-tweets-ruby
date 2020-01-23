#Under refactoring
#See below for supported app switches. 

#=======================================================================================================================
if __FILE__ == $0  #This script code is executed when running this file.

    require 'optparse'
    require 'base64'


    #Defines the UI for the user. Albeit a simple command-line interface.
    OptionParser.new do |o|

        #Passing in a config file.... Or you can set a bunch of parameters.
        o.on('-c CONFIG', '--config', 'Configuration file (including path) that provides account and option selections.
                                       Config file specifies which search api, includes credentials, and sets app options.') { |config| $config = config}
        
        #Search rule.  This can be a single rule ""this exact phrase\" OR keyword"
        o.on('-q QUERY', '--query', 'Maps to API "query" parameter.  Either a single query passed in, or a file containing either a
                                   YAML or JSON array of queries/rules.') {|query| $query = query}


        #Period of search.  Defaults to end = Now(), start = Now() - 30.days.
        o.on('-s START', '--start_time', 'UTC timestamp for beginning of Search period (maps to "fromDate").
                                         Specified as YYYYMMDDHHMM, \"YYYY-MM-DD HH:MM\", YYYY-MM-DDTHH:MM:SS.000Z or use ##d, ##h or ##m.') { |start_time| $start_time = start_time}
        o.on('-e END', '--end_time', 'UTC timestamp for ending of Search period (maps to "toDate").
                                      Specified as YYYYMMDDHHMM, \"YYYY-MM-DD HH:MM\", YYYY-MM-DDTHH:MM:SS.000Z or use ##d, ##h or ##m.') { |end_time| $end_time = end_time}

        o.on('-i SINCEID', '--since_id', 'All matching Tweets since this Tweet ID was created (exclusive).') {|since_id| $since_id = since_id}
        o.on('-u UNTILID', '--until_id', 'All matching Tweets up until this ID was created (exclusive).') {|until_id| $until_id = until_id}

        o.on('-m MAXRESULTS', '--max', 'Specify the maximum amount of Tweets results per response (maps to "max_results"). 10 to 100, defaults to 10.') {|max_results| $max_results = max_results}  #... as in look before you leap.

        o.on('-f FORMAT', '--format', 'Specify the format for Tweet JSON, defaults to "default".') {|format| $format = format}

        o.on('-x EXIT', '--exit', 'Specify the maximum amount of requests to make. "Exit app after this many requests."') {|exit_after| $exit_after = exit_after}

        o.on('-w WRITE', '--write',"'files', 'standard-out' (or 'so' or 'standard').") {|write| $write = write}
        o.on('-o OUTBOX', '--outbox', 'Optional. Triggers the generation of files and where to write them.') {|outbox| $outbox = outbox}


        #Tag:  Not in payload, but triggers a "matching_rules" section with query/rule tag values.
        o.on('-t TAG', '--tag', 'Optional. Gets included in the  payload if included. Alternatively, rules files can contain tags.') {|tag| $tag = tag}

        #Help screen.
        o.on( '-h', '--help', 'Display this screen.' ) do
            puts o
            exit
        end

        o.parse!
    end

    #Create a Tweet Search object.
    oSearch = TweetsSearch.new()
  
    tweet_array = oSearch.get_data(query["syntax"], oSearch.start_time, oSearch.end_time, oSearch.since_id, oSearch.until_id)
   
