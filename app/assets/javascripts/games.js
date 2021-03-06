
Game = function(gameId, finished, started) {
  // *********** Drag and Drop Functions *****************
  var moveTileWithMouse = function(tile, x, y) {
    $(tile).css({position: "absolute", left: x, top: y, "background-color": "red"})
  };

  var SnapToLine = function(tile) {
    $(".word").each(function(index, word) {
      if (tile.offsetTop > (word.offsetTop - 25) && tile.offsetTop < (word.offsetTop + 50)) {
        $(tile).css({ "top": word.offsetTop + 2 });
      };
    });
  };

  // ********** Page Autoupdating Functions ************
  var autoUpdater = function(data) {
    return $.ajax({
      type: "POST",
      data: data,
      url: "gameId/refresher",
      success: updatePage
    });
  };

  var updatePage = function(data) {
    if (data["actionRequired"] === "addTiles") {
      appendNewTiles(data["tiles"]);
    };

    if (data["actionRequired"] === "reload") {
      location.reload();
    };
  };

  var addTile = function(tileValue) {
    $("<div>").addClass("tile").text(tileValue).appendTo($(".pile"));
  }

  var appendNewTiles = function(tiles) {
    tiles.forEach(function(tileValue) {
      addTile(tileValue);
    });
  };

  // ************* Posting Submissions *************
  var postSubmission = function(data) {
    $.ajax({
      type: "POST",
      data: data,
      url: "/games/" + gameId + "/words",
      success: renderResult 
    });
  };

  var renderResult = function(data) {
    switch (data["submissionResult"]) {
      case "tilesDealt":
        $(".submission-message").html("nailed it boy");
        data["letters"].forEach(function(tileValue) {
          addTile(tileValue);
        });
        break;
      
      case "save failure":
        $(".submission-message").html("save failure occured during submission please try again: " + data["errorMessage"]);
        break;
      
      case "incompleteSubmission":
        $(".submission-message").html("You would make an awful word smith rookie");
        break;
      
      default:
        location.reload();
        break;
    };
  };

  // ************ Generating words for submission ****************
  var collateWords = function () {
    var wordsToSubmit = [];

    $(".word").each(function(index, word) {
      var characterArray = findTilesWithinWord(index, word);

      var wordResult = formatCharacterArray(characterArray);

      if (wordResult.length > 0) {
        wordsToSubmit.push(wordResult);
      };
    });

    return wordsToSubmit;
  };

  var findTilesWithinWord = function(index, word) {
    var wordResult = [];
    
    $(".tile").each(function(tileIndex, tile) {
      if (withinWordBoundary(tile, word)) {
        wordResult.push([tile.offsetLeft, $(tile).text()]);
      };
    });

    return wordResult
  };

  var formatCharacterArray = function(characterArray) {
    characterArray.sort(sortByHorizontalPostion);

    characterArray.forEach(function(entry) {
      entry.splice(0,1);
    });

    return mergeWord(characterArray);
  };

  var mergeWord = function(wordResult) {
    var mergedWordResult = [];
    mergedWordResult = mergedWordResult.concat.apply(mergedWordResult, wordResult);
    mergedWordResult = mergedWordResult.join("");
    return mergedWordResult;
  };

  var sortByHorizontalPostion = function(a, b) {
    if (a[0] === b[0]) {
      return 0;
    }
    
    return a[0] < b[0] ? -1 : 1;
  };

  // ******** Checking Tile Location Relative to Word Div ***********
  var withinLeftBound = function(tile, word) {
    return tile.offsetLeft >= word.offsetLeft;
  };

  var withinRightBound = function(tile, word) {
    return tile.offsetLeft <= (word.offsetLeft + word.offsetWidth - 10);
  };

  var withinTopBound = function(tile, word) {
    return tile.offsetTop >= word.offsetTop;
  };

  var withinBottomBound = function(tile, word) {
    return tile.offsetTop <= (word.offsetTop + word.offsetHeight);
  };

  var withinLateralBounds = function(tile, word) {
    return withinLeftBound(tile, word) && withinRightBound(tile, word);
  };

  var withinVerticalBounds = function(tile, word) {
    return withinTopBound(tile, word) && withinBottomBound(tile, word);
  };

  var withinWordBoundary = function(tile, word) {
    return withinLateralBounds(tile, word) && withinVerticalBounds(tile, word);
  };

  /* run initialisers */
  $("body").attr('unselectable', 'on').css('user-select', 'none').css('-moz-user-select', 'none').on('selectstart', false);

  $('#games-show').on("mousedown", '.tile', function() {
    $tile = $(this);

    $(document).on('mousemove', $tile, function(event) {
      moveTileWithMouse($tile, event.pageX-25, event.pageY-25)
    });

    $(this).css({"margin-left": 0, "margin-top": 0});
  });

  $('#games-show').on('mouseup', '.tile', function() {
    $(document).unbind("mousemove");

    SnapToLine(this);
  });

  $('#games-show').on('click', '.twoupbutton', function() {
    var words = collateWords();
    console.log(words);
    postSubmission({ words: words });
  });

  setInterval(function() {
    autoUpdater({gameId: gameId, started: started, tileCount: $('.tile').length, finished: finished});
  }, 10000);  
};


$(function() {
    var gameId   = $('meta[name=gameid]').attr("content"),
        finished = $('meta[name=finished]').attr("content"),
        started  = $('meta[name=started]').attr("content");

    if (gameId) {
      Game(gameId, finished, started);
    }
});