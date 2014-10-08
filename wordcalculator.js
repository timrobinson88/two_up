var wordSubmission = function(){
  var wordsToSubmit = []
  $(".word").each(function(index, word) {
      var wordResult = []
    $(".tile").each(function(tileIndex, tile) {
      if(withinWordBoundary(tile, word)){
        wordResult.push([tile.offsetLeft, $(tile).text()]);
      };
    });
    wordResult.sort(sortFunction)
    wordResult.forEach(function(entry) {
      entry.splice(0,1);
    });
    var mergedWord = mergeWord(wordResult)
    if(mergedWord.length > 0) {
      wordsToSubmit.push(mergedWord);
    };
  });
  return wordsToSubmit
}

var twoUp = function(data){
  $.ajax({
    type: "POST",
    data: data,
    url: "/games/:game_id/words"
  });
}




var mergeWord = function(wordResult){
  var mergedWordResult = []
  mergedWordResult = mergedWordResult.concat.apply(mergedWordResult, wordResult);
  mergedWordResult = mergedWordResult.join("")
  return mergedWordResult
};

var withinLeftBound = function(tile, word){
  return tile.offsetLeft > word.offsetLeft;
};

var withinRightBound = function(tile, word){
  return tile.offsetLeft < (word.offsetLeft + word.offsetWidth - 10);
};

var withinTopBound = function(tile, word){
  return tile.offsetTop > word.offsetTop;
};

var withinBottomBound = function(tile, word){
  return tile.offsetTop < (word.offsetTop + word.offsetHeight);
};

var withinLateralBounds = function(tile, word){
  return withinLeftBound(tile, word) && withinRightBound(tile, word);
};

var withinVerticalBounds = function(tile, word){
  return withinTopBound(tile, word) && withinBottomBound(tile, word);
};

var withinWordBoundary = function(tile, word){
  return withinLateralBounds(tile, word) && withinVerticalBounds(tile,word);
};


 var sortFunction = function(a, b) {
    if (a[0] === b[0]) {
        return 0;
    }
    else {
        return (a[0] < b[0]) ? -1 : 1;
    }
 }
