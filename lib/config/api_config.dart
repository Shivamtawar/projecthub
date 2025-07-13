class ApiConfig {
  static String baseURL = "https://projecthub.pythonanywhere.com";
  //static String baseURL = "http://192.168.0.110:5000/";

// usesr rougths
  static String addUser = "$baseURL/user/add";
  static String getUserDetailsByID = "$baseURL/user/getUser";
  static String updateUser = "$baseURL/user/update-user";
  static String checkNumber = "$baseURL/user/checkNumber";
  static String checkLogindetails = "$baseURL/checkLogin";

// banck account
  static String addBankAccount = "$baseURL/bank-account/add";
  static String getBankAccount = "$baseURL/bank-account/get";
  static String setPrimaryBankAccount = "$baseURL/bank-account/set-primary";

  // user listed creations
  static String listCreation = "$baseURL/creation/listCreation";
  static String userListedCreations = "$baseURL/creation/userListedCreations";

  // recent creations
  static String getRecentaddedCreationUrl(int pageNo, [int perPage = 10]) {
    return "$baseURL/creation/recentCreations/page/$pageNo/perPage/$perPage/uid";
  }

// trending creations
  static String getTrendingCreations(int pageNo, [int perPage = 10]) {
    return "$baseURL/creation/trendingCreations/page/$pageNo/perPage/$perPage/uid";
  }

  static String addCreationToCard = "$baseURL/creation/card/add";
  static String removeItemFromCard = "$baseURL//creation/card/remove";
  static String incardCreations = "$baseURL/creation/card/get/userid";
  static String placeOrder = "$baseURL/create-order";
  static String categories = "$baseURL/categories";
  static String getReels = "$baseURL/reels";
  static String getLikeInfo = "$baseURL/reel/likes";
  static String addLikeToReel = "$baseURL/reel/addLike";
  static String removeLikeToReel = "$baseURL/reel/removeLike";
  static String getSearchedCreation = "$baseURL/search/creation";

  static String getGeneralCreationsUrl(int pageNo, [int perPage = 10]) {
    return "$baseURL/creations/page/$pageNo/perPage/$perPage/uid";
  }

  static String getRecomandedCreations(int pageNo, [int perPage = 10]) {
    return "$baseURL/recomandedCreations/page/$pageNo/perPage/$perPage/uid";
  }

  static String getPurchedCreations(int pageNo, [int perPage = 10]) {
    return "$baseURL/creation/purchesed";
  }

  static String getFileUrl(String path) {
    return "$baseURL/$path";
  }

  static String getUserTransactions(int userid) {
    return "$baseURL/transactions?user_id=$userid";
  }

  static String getAdvertisements(int userid, String location) {
    return "$baseURL/advertisements?user_id=$userid&location=$location";
  }

  static String getPurchedCreationDetails(int userid, int creationId) {
    return "$baseURL/creation/purchesed-details?user_id=$userid&creation_id=$creationId";
  }
}
