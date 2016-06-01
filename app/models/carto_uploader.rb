require 'csv'
require 'uri'
require 'net/http'
require 'json'

class CartoUploader
  #--------------------------------
  CARTODB_ACCOUNT = ENV["CARTODB_ACCOUNT"]
  CARTODB_APIKEY = ENV["CARTODB_APIKEY"]
  CARTODB_URI_GET = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql?q=__SQLQUERY__&api_key=#{CARTODB_APIKEY}"
  CARTODB_URI_POST = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql"
  CARTODB_TABLE = ENV["CARTODB_TABLE"]  
  CLASSIFICATIONS_PER_BATCH = 20
  #--------------------------------

  def initialize()
  end
  
  def upload(data)
    #Determine what's already in the database
    #--------------------------------
    latestClassificationID = getLatestClassificationID()
    expectedInsertions = 0
    successfulInsertions = 0
    #--------------------------------
    
    arrVals = []
    keys = []
    data.each do |classification|
      
      #Only insert new Classifications
      #--------------------------------
      if (Integer(classification["classification_id"]) <= latestClassificationID)
        next
      end
      #--------------------------------
      
      #Take every key-val and package it into a single Classification to be Inserted
      #--------------------------------
      keys = []  #Will be overwritten with the same data over and over again, but whatcha gonna do?
      vals = []
      classification.each do |key, val|
        keys.push(key)
        if (val.is_a?(NilClass))
          vals.push("''")
        else
          vals.push("'" + val.to_s.gsub(/'/, "''") + "'")
        end
      end
      keys = keys.join(",")
      vals = vals.join(",")
      arrVals.push("(#{vals})");
      #--------------------------------
      
      #If we have enough classifications, do a batch Insert.
      #--------------------------------
      if (arrVals.length >= CLASSIFICATIONS_PER_BATCH)
        expectedInsertions += arrVals.length
        successfulInsertions += batchInsert(keys, arrVals)
        arrVals = []
      end
      #--------------------------------
    end

    #Do a final batch Insert for any stragglers
    #--------------------------------
    if (arrVals.length > 0)
      expectedInsertions += arrVals.length
      successfulInsertions += batchInsert(keys, arrVals)
      arrVals = []
    end
    #--------------------------------
    
    #Final sanity check?
    #--------------------------------
    puts "Inserted #{successfulInsertions} Classifications out of #{expectedInsertions}"
    if (expectedInsertions != successfulInsertions)
      #TODO
    end
    #--------------------------------
  end
  
  #Returns latest Classification ID.
  def getLatestClassificationID()
    begin
      sqlQuery = "SELECT classification_id FROM #{CARTODB_TABLE} ORDER BY classification_id DESC LIMIT 1"
      uri = URI(CARTODB_URI_GET.gsub(/__SQLQUERY__/, URI.escape(sqlQuery)))
      res = Net::HTTP.get(uri)
      res = JSON.parse(res)
      if (res["error"])
        raise StandardError, res["error"]
      end
      return (res["rows"] && res["rows"][0] && res["rows"][0] && res["rows"][0]["classification_id"]) ?
        Integer(res["rows"][0]["classification_id"]) : 0;
    rescue StandardError => err
      #TODO: Log error?
      puts "ERROR:"
      puts err
      return 0
    end
  end
  
  #Uploads a batch of rows. Returns number of successful uploads.
  def batchInsert(keys, arrValues)
    begin
      allVals = arrValues.join(",")
      sqlQuery = "INSERT INTO #{CARTODB_TABLE} (#{keys}) VALUES #{allVals} "
      uri = URI(CARTODB_URI_POST)
      res = Net::HTTP.post_form(uri, "q" => sqlQuery, "api_key" => CARTODB_APIKEY)
      res = JSON.parse(res.body)
      if (res["error"])
        raise StandardError, res["error"]
      end
      return (res["total_rows"]) ? Integer(res["total_rows"]) : 0;
    rescue StandardError => err
      #TODO: Log error?
      puts "ERROR:"
      puts err
      return 0
    end
  end
end
