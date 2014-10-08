$("#games-show").ready(function() {
   TwoUp.start();
});


TwoUp = (function () {

  var mergeWord = function(wordResult) {
    var mergedWordResult = [];
    mergedWordResult = mergedWordResult.concat.apply(mergedWordResult, wordResult);
    mergedWordResult = mergedWordResult.join("");
    return mergedWordResult;
  };

  var withinLeftBound = function(tile, word) {
    return tile.offsetLeft > word.offsetLeft;
  };

  var withinRightBound = function(tile, word) {
    return tile.offsetLeft < (word.offsetLeft + word.offsetWidth - 10);
  };

  var withinTopBound = function(tile, word) {
    return tile.offsetTop > word.offsetTop;
  };

  var withinBottomBound = function(tile, word) {
    return tile.offsetTop < (word.offsetTop + word.offsetHeight);
  };

  var withinLateralBounds = function(tile, word) {
    return withinLeftBound(tile, word) && withinRightBound(tile, word);
  };

  var withinVerticalBounds = function(tile, word) {
    return withinTopBound(tile, word) && withinBottomBound(tile, word);
  };

  var withinWordBoundary = function(tile, word) {
    return withinLateralBounds(tile, word) && withinVerticalBounds(tile,word);
  };

  var sortFunction = function(a, b) {
    if (a[0] === b[0]) {
      return 0;
    }
    else {
      return a[0] < b[0] ? -1 : 1;
    }
  };

  var updatePage = function(data) {
    if (data["refreshRequired"] === "true") {
      location.reload();
    };
  };

  var updateGame = function(data) {
    return $.ajax({
      type: "POST",
      data: data,
      url: "gameId/refresh",
      success: updatePage
    });
  };

  var renderResult = function(data) {
    if(data["submissionResult"] === "tilesDealt") {
      $(".submission-message").html(data["message"]);
      data["letters"].forEach(function(word){
        $(".pile").append('<div class="tile">'+ word +'</div>')
      });
    }
    else if(data["submissionResult"] === "incompleteSubmission") {
      $(".submission-message").html(data["message"]);
    }
    else {
      location.reload();
    };
  };

  var moveDiv = function(event){
    $(this).css({"position":"absolute", "left": (event.pageX-25) , "top": (event.pageY-25), "background-color": "red"})
  };

  var gameId = $('meta[name=gameid]').attr("content");
  var tileCount = $('meta[name=tileCount]').attr("content");
  var finished = $('meta[name=finished]').attr("content");

  publicAttrs = {};
  myButton = {};

  publicAttrs.postSubmission = function(data) {
    $.ajax({
      type: "POST",
      data: data,
      url: "/games/"+gameId+"/words",
      success: renderResult 
    })
  };

  publicAttrs.wordCollation = function () {
    var wordsToSubmit = [];
    $(".word").each(function(index, word) {
      var wordResult = [];
      $(".tile").each(function(tileIndex, tile) {
        if(withinWordBoundary(tile, word)){
          wordResult.push([tile.offsetLeft, $(tile).text()]);
        };
      });
      wordResult.sort(sortFunction)
      wordResult.forEach(function(entry) {
        entry.splice(0,1);
      });

      var mergedWord = mergeWord(wordResult);

      if(mergedWord.length > 0) {
        wordsToSubmit.push(mergedWord);
      };
    });

    return wordsToSubmit;
  };

  publicAttrs.start = function() {
    $('#games-show').on("mousedown", '.tile', function() {
      $(this).bind("mousemove", moveDiv);
      $("body").attr('unselectable', 'on').css('user-select', 'none').css('-moz-user-select', 'none').on('selectstart', false);
    });

    $('#games-show').on('mouseup', '.tile', function() {
      $(this).unbind("mousemove", moveDiv);
    });

   
    $('#games-show').on('click', '.twoupbutton', function(){
      var words = publicAttrs.wordCollation();
      console.log(words);
      publicAttrs.postSubmission({ words: words });
    });

    setInterval(function() {
      updateGame({gameId: gameId, tileCount: tileCount, finished: finished});
    }, 50000);
  };

  return publicAttrs;
}());


    