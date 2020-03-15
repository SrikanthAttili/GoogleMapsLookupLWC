public class PlaceFinder {

	public class Matched_substrings {
		public Integer length;
		public Integer offset;
	}

	public List<Predictions> predictions;
	public String status;

	public class Predictions {
		public String description;
		public String id;
		public List<Matched_substrings> matched_substrings;
		public String place_id;
		public String reference;
		public Structured_formatting structured_formatting;
		public List<Terms> terms;
		public List<String> types;
	}

	public class Terms {
		public Integer offset;
		public String value;
	}

	public class Structured_formatting {
		public String main_text;
		public List<Matched_substrings> main_text_matched_substrings;
		public String secondary_text;
	}

    public class Address {
		public String placeId;
		public String description;
    }
    
	
	public static List<Address> parse(String json) {
        
        PlaceFinder j = (PlaceFinder) System.JSON.deserialize(json, PlaceFinder.class);
        List<predictions> pList = j.predictions;
        List<Address> aList = new List<Address>();

        for(predictions p : pList){
            Address a = new Address();
            a.description = p.description;
            a.placeId = p.place_id;
            aList.add(a);
        }
        return aList;
	}
}