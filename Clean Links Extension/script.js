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

function catchLinks (root, cb) {
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

function cleanUrl(url) {
    var parsedUrl = new URL(url);
    
    for(var param of queryParamsToRemove) {
        if (parsedUrl.searchParams.has(param)) {
            parsedUrl.searchParams.delete(param);
        }
    }

    return parsedUrl.href;
}

document.addEventListener("DOMContentLoaded", function(event) {
    catchLinks(window, function (href, external) {
        window.open(href, external ? '_blank' : '_self','noopener,noreferrer');
    });
});
