String extractSlugFromLink(href){
    String slug;
    
    var listSplit = href.split("/");
    var regEx1 = RegExp(r"http[s]?:\/\/www\.demivolee\.com\/[\d]{4}\/\d{2}\/\d{2}\/[\w-]*\/");
    var regEx2 = RegExp(r"http[s]?:\/\/www\.demivolee\.com\/[\d]{4}\/\d{2}\/\d{2}\/[\w-]*\$");
    if (regEx1.hasMatch(href)) {
      slug = listSplit[listSplit.length-2];
    }
    else if (regEx2.hasMatch(href)) {
      slug = listSplit[listSplit.length-1];
    }
    else{
      return null;
    }
    return slug;
    
}