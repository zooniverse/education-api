require "csv"
require "uri"
require "net/http"
require "json"

class CartoUploader
  CARTODB_TABLE = ENV["CARTODB_TABLE"] || "classifications"
  CLASSIFICATIONS_PER_BATCH = 200

  attr_reader :cartodb

  def initialize(cartodb = Cartodb.new)
    @cartodb = cartodb
  end

  def upload(data)
    if cannot_determine_latest_classification_in_cartodb
      truncate_everything
    end
    # --------------------------------

    return if data.empty?
    keys = data.first.keys.join(",")

    data.in_groups_of(CLASSIFICATIONS_PER_BATCH, false).each do |classification_batch|
      arr_vals = classification_batch
        .lazy
        .reject { |classification| already_in_carto?(classification) }
        .map { |classification| insert_statement_values(classification) }
        .to_a

      inserted = batch_insert(keys, arr_vals)
      verify_insertion_amounts(arr_vals.length, inserted)
    end
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

  def already_in_carto?(classification)
    Integer(classification[:classification_id]) <= latest_classification_id
  end

  def latest_classification_id
    @latest_classification_id ||= get_latest_classification_id
  end

  def cannot_determine_latest_classification_in_cartodb
    latest_classification_id == 0
  end

  def insert_statement_values(classification)
    vals = classification.values.map do |val|
      ActiveRecord::Base.connection.quote(val.to_s)
    end

    "(#{vals.join(",")})"
  end

  def verify_insertion_amounts(expected_insertions, successful_insertions)
    # Sanity check
    Rails.logger.info "Inserted #{successful_insertions} Classifications out of #{expected_insertions}"
    if expected_insertions != successful_insertions
      raise StandardError, "Could not insert Classifications. Aborting attempt."
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
    Rails.logger.info "Truncated #{CARTODB_TABLE}"
  end
end
