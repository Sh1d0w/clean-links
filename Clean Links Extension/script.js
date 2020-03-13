/**
 * List of query prameters, used for tracking that will be
 * stripped out from the links you click.
 */
var queryParamsToRemove = [
    "fbclid",
    "utm_source",
    "utm_medium",
    "utm_campaign",
    "utm_term",
    "utm_content",
    "gclid",
    "gclsrc",
    "dclid",
    "zanpid"
];

/**
 * Cleans the passed url from tracking query params.
 */
function cleanUrl(url) {
    var parsedUrl = new URL(url);
    
    for(var param of queryParamsToRemove) {
        if (parsedUrl.searchParams.has(param)) {
            parsedUrl.searchParams.delete(param);
        }
    }

    return parsedUrl.href;
}

/**
 * Observe all links in a given node and
 * intercept all child links that are clicked.
 */
function observeLinks (root, cb) {
    root.addEventListener('click', function (ev) {
        var anchor = null;
        for (var n = ev.target; n.parentNode; n = n.parentNode) {
            if (n.nodeName === 'A') {
                anchor = n;
                break;
            }
        }
        if (!anchor) return true;
        
        ev.preventDefault();

        var clean = cleanUrl(anchor.href);
        cb(clean, (ev.metaKey || ev.ctrlKey ));
        return false;
    });
};

/**
 * Register the links observer on dom load event.
 */
document.addEventListener("DOMContentLoaded", function(event) {
    observeLinks(window, function (href, external) {
        window.open(href, external ? '_blank' : '_self','noopener,noreferrer');
    });
});
