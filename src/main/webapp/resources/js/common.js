function loadScript(url, callback)
  {
  // Adding the script tag to the head as suggested before
  var head = document.head;
  var script = document.createElement('script');
  script.type = 'text/javascript';
      script.src = url;
  
  // Then bind the event to the callback function.
  // There are several events for cross browser compatibility.
      script.onreadystatechange = callback;
      script.onload = callback;
  
  // Fire the loading
      head.appendChild(script);
  }

Promise.all([
    loadScript('/resources/js/index.js'),
    loadScript('/resources/js/joinValidChecker.js')
])