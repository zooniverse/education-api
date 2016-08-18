require "csv"
require "json"

class CartoTransformer
  attr_reader :output

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

  def initialize(carto: CartoUploader.new)
    @output = []
    @carto = carto
  end

  def process(stream_event)
    classification = stream_event.fetch("data")
    subject_id     = classification.fetch("links").fetch("subjects").first
    user_id        = classification.fetch("links").fetch("user")
    workflow_id    = classification.fetch("links").fetch("workflow")
    subject_data   = stream_event.fetch("linked").fetch("subjects").find { |subject| subject.fetch("id") == subject_id }
    user_data      = stream_event.fetch("linked").fetch("users").find { |user| user.fetch("id") == user_id }
    metadata       = classification.fetch("metadata")

    # For each annotation answer, we want one line in the output CSV.
    classification["annotations"].each do |annotation|
      next unless ["survey", "T1"].include?(annotation["task"])

      Array.wrap(annotation["value"]).each do |annotation_value|
        next unless annotation_value.is_a?(Hash)

        # Prepare values...
        answers = (annotation_value["answers"]) ? annotation_value["answers"] : {}
        behaviours = (answers["WHTBHVRSDS"]) ? answers["WHTBHVRSDS"] : []

        # Prepare the output item...
        item = {
          user_name:             user_data["login"],
          user_group_ids:        metadata["user_group_ids"],
          classification_id:     classification["id"],
          subject_id:            subject_id,
          gorongosa_id:          subject_data.dig("metadata", "Gorongosa_id"),
          workflow_id:           workflow_id,
          classified_at:         classification["created_at"],
          species:               ANNOTATION_SPECIES_CHOICES[annotation_value["choice"]],
          species_count:         ANNOTATION_HOW_MANY[answers["HWMN"]],
          species_young:         ANNOTATION_YOUNG[answers["RTHRNNGPRSNT"]],
          species_moving:        behaviours.include?("MVNG"),
          species_resting:       behaviours.include?("RSTNG"),
          species_standing:      behaviours.include?("STNDNG"),
          species_eating:        behaviours.include?("TNG"),
          species_interacting:   behaviours.include?("NTRCTNG"),
          species_horns:         ANNOTATION_HORNS[annotation_value["choice"]]
        }

        # ...and record it.
        output << item
      end
    end
  end

  def finalize
    @carto.upload(output)
    @output = []
  end
end
