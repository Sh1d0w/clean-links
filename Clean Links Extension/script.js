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
 * For the same purpose as above, we need to check if the link that
 * the user has clicked has target="_blank" and if yes, send signal
 * to the extension that new tab will be opened.
 */
function handleExternalLinks(ev) {
    var anchor = null;
    for (var n = ev.target; n.parentNode; n = n.parentNode) {
        if (n.nodeName === 'A') {
            anchor = n;
            break;
        }
    }
    
    if (anchor && anchor.target === '_blank') {
        safari.extension.dispatchMessage("keypress",  { "new-tab": true });
    }
        
    return true;
};

// Bind some event listeners
document.onkeydown = handleKey;
document.onkeyup = handleKey;
document.onclick = handleExternalLinks;
