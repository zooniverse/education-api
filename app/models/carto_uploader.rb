require 'csv'
require 'json'
require 'uri'
require 'net/http'

class CartoUploader
  attr_reader :output
  
  CARTODB_ACCOUNT = ENV["CARTODB_ACCOUNT"]
  CARTODB_APIKEY = ENV["CARTODB_APIKEY"]
  CARTODB_URI_GET = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql?q=__SQLQUERY__&api_key=#{CARTODB_APIKEY}"
  CARTODB_URI_POST = "https://#{CARTODB_ACCOUNT}.cartodb.com/api/v2/sql"
  CARTODB_TABLE = ENV["CARTODB_TABLE"]
  
  CARTODB_INSERT_MODE_INDIVIDUAL = "ind"
  CARTODB_INSERT_MODE_MASS = "mass"
  cartodbInsertMode = CARTODB_INSERT_MODE_MASS

  ANNOTATION_SPECIES_CHOICES = {
    "RDVRK" => "Aardvark",
    "BBN" => "Baboon",
    "BRDTHR" => "Bird (other)",
    "BFFL" => "Buffalo",
    "BSHBCK" => "Bushbuck",
    "BSHPG" => "Bushpig",
    "CRCL" => "Caracal",
    "CVT" => "Civet",
    "CRN" => "Crane",
    "DKR" => "Duiker",
    "LND" => "Eland",
    "LPHNT" => "Elephant",
    "GNT" => "Genet",
    "GRNDHRNBLL" => "Ground Hornbill",
    "HR" => "Hare",
    "HRTBST" => "Hartebeest",
    "HPPPTMS" => "Hippopotamus",
    "HNBDGR" => "Honey Badger",
    "HN" => "Hyena",
    "MPL" => "Impala",
    "JCKL" => "Jackal",
    "KD" => "Kudu",
    "LPRD" => "Leopard",
    "LNCB" => "Lion (cub)",
    "LNFML" => "Lion (female)",
    "LNML" => "Lion (male)",
    "MNGS" => "Mongoose",
    "NL" => "Nyala",
    "RB" => "Oribi",
    "TTR" => "Otter",
    "PNGLN" => "Pangolin",
    "PRCPN" => "Porcupine",
    "RPTRTHR" => "Raptor (other)",
    "RDBCK" => "Reedbuck",
    "RPTL" => "Reptile",
    "RDNT" => "Rodent",
    "SBLNTLP" => "Sable Antelope",
    "SMNGMNK" => "Samango Monkey",
    "SCRTRBRD" => "Secretary bird",
    "SRVL" => "Serval",
    "VRVTMNK" => "Vervet Monkey",
    "VLTR" => "Vulture",
    "WRTHG" => "Warthog",
    "WTRBCK" => "Waterbuck",
    "WSL" => "Weasel",
    "WLDDG" => "Wild Dog",
    "WLDCT" => "Wildcat",
    "WLDBST" => "Wildebeest",
    "ZBR" => "Zebra",
    "HMN" => "Human",
    "FR" => "Fire",
    "NTHNGHR" => "Nothing here"
  }
  ANNOTATION_SPECIES_CHOICES.default = ""

  ANNOTATION_HOW_MANY = {
    "1" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "10" => "10",
    "1150" => "11-50",
    "51" => "51+"
  }
  ANNOTATION_HOW_MANY.default = nil

  ANNOTATION_HORNS = {
    "S" => true,
    "N" => false
  }
  ANNOTATION_HORNS.default = false

  ANNOTATION_YOUNG = {
    "S" => true,
    "N" => false
  }
  ANNOTATION_YOUNG.default = false
  
  def initialize
    @output = CSV.new(STDOUT, headers: [
      :user_name, :user_group_ids, :zooniverse_subject_id, :gorongosa_id,
      :classified_at, :species, :species_count, :species_young, :species_moving,
      :species_resting, :species_standing, :species_eating, :species_interacting,
      :species_horns
    ], write_headers: true)
  end

  def process(classification)
    
    #Prepare values...
    #--------------------------------
    subject = (classification["subject_data"]) ? JSON.parse(classification["subject_data"]) : { "" => {}}
    subject_id = subject.keys[0]
    subject_data = subject.values[0]
    metadata = (classification["metadata"]) ? JSON.parse(classification["metadata"]) : {}
    #--------------------------------

    #For each annotation answer, we want one line in the output CSV.
    listOfAnnotations = JSON.parse(classification["annotations"])
    listOfAnnotations.each do |annotation|
      if annotation["task"] == "survey" && annotation["value"].is_a?(Hash)

        #Prepare values...
        #--------------------------------
        answers = (annotation["value"]["answers"]) ? annotation["value"]["answers"] : {}
        behaviours = (answers["WHTBHVRSDS"]) ? answers["WHTBHVRSDS"] : []
        #--------------------------------

        #Prepare the output item...
        #--------------------------------
        item = {
          user_name:             classification["user_name"],
          user_group_ids:        metadata["user_group_ids"],
          zooniverse_subject_id: subject_id,
          gorongosa_id:          subject_data["Gorongosa_id"],
          classified_at:         classification["created_at"],
          species:               ANNOTATION_SPECIES_CHOICES[annotation["value"]["choice"]],
          species_count:         ANNOTATION_HOW_MANY[answers["HWMN"]],
          species_young:         ANNOTATION_YOUNG[answers["RTHRNNGPRSNT"]],
          species_moving:        behaviours.include?("MVNG"),
          species_resting:       behaviours.include?("RSTNG"),
          species_standing:      behaviours.include?("STNDNG"),
          species_eating:        behaviours.include?("TNG"),
          species_interacting:   behaviours.include?("NTRCTNG"),
          species_horns:         ANNOTATION_HORNS[annotation["value"]["choice"]]
        }
        #--------------------------------

        #...and record it.
        #--------------------------------
        output << item
        #--------------------------------
      end 
    end
    
  end

  def finalize
    
    allVals = []  #For Mass Insertion mode only.
    keys = []     #Declaration for Mass Insertion mode.
    output.each do |classification|
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
      if cartodbInsertMode != CARTODB_INSERT_MODE_MASS
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
    if cartodbInsertMode == CARTODB_INSERT_MODE_MASS
      sqlQuery = "INSERT INTO #{CARTODB_TABLE} (#{keys}) VALUES #{allVals} "
      uri = URI(CARTODB_URI_POST)
      res = Net::HTTP.post_form(uri, "q" => sqlQuery, "api_key" => CARTODB_APIKEY)
      puts res.body
    end
    #--------------------------------
    
  end
end
