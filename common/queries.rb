require "json"
require "yaml"

#=======================================================================================================================
class SearchQueries
    attr_accessor :queries

    def initialize
        @queries = Array.new
    end

    #Methods for maintaining the rules array
    def addQuery(value, tag=nil)
        #Gotta have a rule value, but tag is optional.
        rule = Hash.new
        rule[:value] = value
        if not tag.nil? then
            rule[:tag] = tag
        end
        #Add rule to rules array.
        @queries << rule
    end

    def deleteQuery(value)   #No tag passed in, we remove with 'value' match.
                            #Regardless of tag, tour rules Array and remove.
        @queries.each do |r|
            if r[:value] == value then
                @queries.delete(r)
            end
        end
    end

    #Methods for getting the rules in the structure you want ===========================================================
    def getJSON
        queryPayload = Hash.new
        queryPayload[:queries] = @queries
        queryPayload.to_json
    end

    #Methods for reading rules from files ==============================================================================

    def loadQueryYAML(file)
        #Open file and parse, looking for rule/tag pairs
        ruleset = YAML.load_file(file)
        rules = ruleset["rules"]
        rules.each do |rule|
            #p rule
            @queries << rule
        end
    end

    def loadQueryJSON(file)
        #Open file and parse
        contents = File.read(file)
        queryset = JSON.parse(contents)
        queries = queryset["rules"]
        queries.each do |query|
            @queries << query
        end
    end

end
