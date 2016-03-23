require 'uri'
require 'net/http'

class CartoUploader
  CARTODB_ACCOUNT = ENV["CARTODB_ACCOUNT"]
  CARTODB_APIKEY = ENV["CARTODB_APIKEY"]
  CARTODB_URI_GET = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql?q=__SQLQUERY__&api_key=#{CARTODB_APIKEY}"
  CARTODB_URI_POST = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql"
  CARTODB_TABLE = ENV["CARTODB_TABLE"]
  
  CARTODB_INSERT_MODE_INDIVIDUAL = "ind"
  CARTODB_INSERT_MODE_MASS = "mass"

  def initialize(mode = CARTODB_INSERT_MODE_MASS)
    @mode = mode
  end
  
  def upload(data)
    allVals = []  #For Mass Insertion mode only.
    keys = []     #Declaration for Mass Insertion mode.
    data.each do |classification|
      keys = []  #Will be overwritten with the same data over and over again, but whatcha gonna do?
      vals = []

      #Take every key-val 
      #--------------------------------
      classification.each do |key, val|
        keys.push(key)
        if (val.is_a?(NilClass))
          vals.push("''")
        else
          vals.push("'" + val.gsub(/'/, "''") + "'")
        end
      end
      keys = keys.join(",")
      vals = vals.join(",")
      allVals.push("(#{vals})");  #For Mass Insertion mode only.
      #--------------------------------

      #Option 1: Individual SQL Insertions
      #--------------------------------
      if @mode != CARTODB_INSERT_MODE_MASS
        sqlQuery = "INSERT INTO #{CARTODB_TABLE} (#{keys}) VALUES (#{vals}) "
        uri = URI(CARTODB_URI_GET.gsub(/__SQLQUERY__/, URI.escape(sqlQuery)))
        res = Net::HTTP.get(uri)
        puts res
      end
      #--------------------------------
    end

    #Option 2: Mass SQL Insertions
    #--------------------------------
    allVals = allVals.join(",")
    if @mode == CARTODB_INSERT_MODE_MASS
      sqlQuery = "INSERT INTO #{CARTODB_TABLE} (#{keys}) VALUES #{allVals} "
      uri = URI(CARTODB_URI_POST)
      res = Net::HTTP.post_form(uri, "q" => sqlQuery, "api_key" => CARTODB_APIKEY)
      puts res.body
    end
    #--------------------------------
  end
end