(function(w, d) {
    /**
     * This function catches the press of CMD or CTRL key and notifies the
     * extension. We need this to workaround opening of links while holding
     * CMD or CTRL. Because if we detect blacklisted params, we need to clean
     * up the link and then redirect the current page to the clean link, we
     * can end up with two tabs with same page opened, as the SafariExtensionHandler
     * page handler fires twice for both the parent and the child pages.
     */
    function handleKey(e) {
        e = e || window.event;
        
        if (e) {
            var holdingModifier = e.ctrlKey || e.metaKey;
            safari.extension.dispatchMessage("keypress",  { "new-tab": holdingModifier });
        }
    };

    /**
     * This function checks if the url is the Google's url
     * tracking request, e.g. google.com/url?url=.....
     */
    function isGoogleTrackingUrl(url) {
        if (url.hostname.indexOf("google") != -1 && url.pathname === "/url") {
            return true;
        }
        
        return false;
    }
 
     /**
      * This function checks if the url is the Facebook's url
      * tracking request, e.g. l.facebook.com/l.php?u=....
      */
     function isFacebookTrackingUrl(url) {
         if (url.hostname === "l.facebook.com") {
             return true;
         }
         
         return false;
     }

    /**
     * Google search steals your clicks. Every link in google search,
     * rewrites you clicks to url similar to www.google.com/url?url...&sa=...
     * before redirecting you to the real search result page.
     *
     * We will make sure they can't do that anymore.
     */
    function removeGoogleRedirect(url) {
        if (url.searchParams.has("url")) {
            return url.searchParams.get("url");
        }
 
        return url.searchParams.get("q");
    }
 
     /**
      * Google search steals your clicks. Every link in google search,
      * rewrites you clicks to url similar to www.google.com/url?url...&sa=...
      * before redirecting you to the real search result page.
      *
      * We will make sure they can't do that anymore.
      */
     function removeFacebookRedirect(url) {
         return url.searchParams.get("u");
     }

    /**
     * For the same purpose as above, we need to check if the link that
     * the user has clicked has target="_blank" and if yes, send signal
     * to the extension that new tab will be opened.
     */
    function handleExternalLinks(ev) {
        var anchor = null;
        for (var n = ev.target; n.parentNode; n = n.parentNode) {
            if (n.nodeName === "A") {
                anchor = n;
                break;
            }
        }
        
        var shouldOpenNewTab = anchor && anchor.target === "_blank";
        
        if (shouldOpenNewTab) {
            safari.extension.dispatchMessage("keypress",  { "new-tab": true });
        }
        
        var parsedUrl = new URL(anchor.href);
 
        var isTracker = false;
        var cleanUrl = null;
        
        if (isGoogleTrackingUrl(parsedUrl)) {
            isTracker = true;
            cleanUrl = removeGoogleRedirect(parsedUrl);
        }
 
        if (isFacebookTrackingUrl(parsedUrl)) {
            isTracker = true;
            cleanUrl = removeFacebookRedirect(parsedUrl);
        }
 
        if (isTracker) {
            ev.preventDefault();

            safari.extension.dispatchMessage("prevented-redirect",  {
                "domain": parsedUrl.hostname,
                "url": cleanUrl
            });
 
            w.open(cleanUrl, shouldOpenNewTab ? '_blank' : '_self','noopener,noreferrer');
 
            return false;
        }
            
        return true;
    };

    // Bind some event listeners
    d.onkeydown = handleKey;
    d.onkeyup = handleKey;
    d.onclick = handleExternalLinks;
})(window, document)
