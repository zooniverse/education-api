require "csv"
require "uri"
require "net/http"
require "json"

class CartoUploader
  CARTODB_TABLE = ENV["CARTODB_TABLE"]
  CLASSIFICATIONS_PER_BATCH = 200

  attr_reader :cartodb

  def initialize(cartodb = Cartodb.new)
    @cartodb = cartodb
  end

  def upload(data)
    # Determine what's already in the database
    # --------------------------------
    latest_classification_id = get_latest_classification_id
    expected_insertions = 0
    successful_insertions = 0

    # If we can't determine what's already in the database, DELETE AND START ANEW.
    if latest_classification_id == 0
      truncate_everything
    end
    # --------------------------------

    arr_vals = []
    keys = []
    data.each do |classification|
      # Only insert new Classifications
      # --------------------------------
      if Integer(classification[:classification_id]) <= latest_classification_id
        next
      end
      # --------------------------------

      # Take every key-val and package it into a single Classification to be Inserted
      # --------------------------------
      keys = []  # Will be overwritten with the same data over and over again, but whatcha gonna do?
      vals = []
      classification.each do |key, val|
        keys.push(key)
        if val.is_a?(NilClass)
          vals.push("''")
        else
          vals.push("'" + val.to_s.gsub(/'/, "''") + "'")
        end
      end
      keys = keys.join(",")
      vals = vals.join(",")
      arr_vals.push("(#{vals})")
      # --------------------------------

      # If we have enough classifications queued up, do a batch Insert.
      # --------------------------------
      if arr_vals.length >= CLASSIFICATIONS_PER_BATCH
        expected_insertions += arr_vals.length
        successful_insertions += batch_insert(keys, arr_vals)
        arr_vals = []
        # Sanity check
        puts "Inserted #{successful_insertions} Classifications out of #{expected_insertions}"
        if expected_insertions != successful_insertions
          raise StandardError, "Could not insert Classifications. Aborting attempt."
        end
      end
      # --------------------------------
    end

    # Do a final batch Insert for any stragglers
    # --------------------------------
    unless arr_vals.empty?
      expected_insertions += arr_vals.length
      successful_insertions += batch_insert(keys, arr_vals)
      arr_vals = []
    end
    # --------------------------------

    # Final Sanity check
    # --------------------------------
    puts "Inserted #{successful_insertions} Classifications out of #{expected_insertions}"
    if expected_insertions != successful_insertions
      raise StandardError, "Could not insert Classifications. Aborting attempt."
    end
    # --------------------------------
  end

  # Returns latest Classification ID.
  def get_latest_classification_id
    sql_query = "SELECT classification_id FROM #{CARTODB_TABLE} ORDER BY classification_id DESC LIMIT 1"
    res = cartodb.get(sql_query)
    if res["error"]
      raise StandardError, res["error"]
    end
    if res["rows"] && res["rows"][0] && res["rows"][0] && res["rows"][0]["classification_id"]
      return Integer(res["rows"][0]["classification_id"])
    else
      return 0
    end
  end

  # Uploads a batch of rows. Returns number of successful uploads.
  def batch_insert(keys, arr_values)
    all_vals = arr_values.join(",")
    sql_query = "INSERT INTO #{CARTODB_TABLE} (#{keys}) VALUES #{all_vals} "
    res = cartodb.post(sql_query)
    return (res["total_rows"]) ? Integer(res["total_rows"]) : 0
  end

  # Truncates the table. Raises an error if something goes wrong; no safeties.
  def truncate_everything
    sql_query = "TRUNCATE #{CARTODB_TABLE}"
    cartodb.get(sql_query)
    puts "Truncated #{CARTODB_TABLE}"
  end
end
