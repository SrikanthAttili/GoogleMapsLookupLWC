public with sharing class AddressSearchController {

  @AuraEnabled(cacheable=true)
  public static List<LookupSearchResult> placeSearch(String searchPhrase) {
    System.debug('#### Called! ' + searchPhrase);
    String url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?' +
      'input=' +
      EncodingUtil.urlEncode(searchPhrase, 'UTF-8') +
      '&types=geocode' +
      getKey();
    list<LookupSearchResult> results = new List<LookupSearchResult>();

    List<PlaceFinder.Address> sugg = getPlaceId(url);
    for (PlaceFinder.Address s : sugg) {
      results.add(
        new LookupSearchResult(
          s.placeId,
          '',
          'custom:custom106',
          s.description,
          ''
        )
      );
    }
    return results;
  }

  public static List<PlaceFinder.Address> getPlaceId(string strURL) {
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    req.setMethod('GET');
    req.setEndpoint(strURL);
    req.setTimeout(120000);
    res = h.send(req);
    String responseBody = res.getBody();
    List<PlaceFinder.Address> aList = PlaceFinder.parse(responseBody);
    for (PlaceFinder.Address a : aList) {
      System.debug('@@@' + a);
    }
    return aList;
  }

  public static string getKey() {
    string key = 'PLEASE_PASTE_YOUR_API_KEY_FROM_GOOGLE_PLACE_API_WEBSITE';
    string output = '&key=' + key;
    return output;
  }
}
