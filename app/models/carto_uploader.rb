require 'csv'
require 'uri'
require 'net/http'
require 'json'

class CartoUploader
  CARTODB_ACCOUNT = ENV["CARTODB_ACCOUNT"]
  CARTODB_APIKEY = ENV["CARTODB_APIKEY"]
  CARTODB_URI_GET = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql?q=__SQLQUERY__&api_key=#{CARTODB_APIKEY}"
  CARTODB_URI_POST = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql"
  CARTODB_TABLE = ENV["CARTODB_TABLE"]  
  CLASSIFICATIONS_PER_BATCH = 200

  def initialize()
  end
  
  def upload(data)
    #Determine what's already in the database
    #--------------------------------
    latest_classification_id = get_latest_classification_id()
    expected_insertions = 0
    successful_insertions = 0
    
    #If we can't determine what's already in the database, DELETE AND START ANEW.
    if (latest_classification_id == 0)
      truncateEverything()
    end
    #--------------------------------
    
    arr_vals = []
    keys = []
    data.each do |classification|
      
      #Only insert new Classifications
      #--------------------------------
      if (Integer(classification["classification_id"]) <= latest_classification_id)
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
      arr_vals.push("(#{vals})")
      #--------------------------------
      
      #If we have enough classifications queued up, do a batch Insert.
      #--------------------------------
      if (arr_vals.length >= CLASSIFICATIONS_PER_BATCH)
        expected_insertions += arr_vals.length
        successful_insertions += batchInsert(keys, arr_vals)
        arr_vals = []
        #Sanity check
        puts "Inserted #{successful_insertions} Classifications out of #{expected_insertions}"
        if (expected_insertions != successful_insertions)
          #TODO
        end
      end
      #--------------------------------
    end

    #Do a final batch Insert for any stragglers
    #--------------------------------
    if (arr_vals.length > 0)
      expected_insertions += arr_vals.length
      successful_insertions += batchInsert(keys, arr_vals)
      arr_vals = []
    end
    #--------------------------------
    
    #Final Sanity check
    #--------------------------------
    puts "Inserted #{successful_insertions} Classifications out of #{expected_insertions}"
    if (expected_insertions != successful_insertions)
      #TODO
    end
    #--------------------------------
  end
  
  #Returns latest Classification ID.
  def get_latest_classification_id()
    begin
      sqlQuery = "SELECT classification_id FROM #{CARTODB_TABLE} ORDER BY classification_id DESC LIMIT 1"
      uri = URI(CARTODB_URI_GET.gsub(/__SQLQUERY__/, URI.escape(sqlQuery)))
      res = Net::HTTP.get(uri)
      res = JSON.parse(res)
      if (res["error"])
        raise StandardError, res["error"]
      end
      return (res["rows"] && res["rows"][0] && res["rows"][0] && res["rows"][0]["classification_id"]) ?
        Integer(res["rows"][0]["classification_id"]) : 0
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
      return (res["total_rows"]) ? Integer(res["total_rows"]) : 0
    rescue StandardError => err
      #TODO: Log error?
      puts "ERROR:"
      puts err
      return 0
    end
  end
  
  #Truncates the table. Raises an error if something goes wrong; no safeties. 
  def truncateEverything
    sqlQuery = "TRUNCATE #{CARTODB_TABLE}"
    uri = URI(CARTODB_URI_GET.gsub(/__SQLQUERY__/, URI.escape(sqlQuery)))
    res = Net::HTTP.get(uri)
    res = JSON.parse(res)
    puts "Truncated #{CARTODB_TABLE}"
    if (res["error"])
      raise StandardError, res["error"]
    end
    return
  end
end
