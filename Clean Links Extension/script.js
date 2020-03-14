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
        safari.extension.dispatchMessage("keypress",  { "holdingModifier": holdingModifier });
    }
};

// Bind some event listeners
document.onkeydown = handleKey;
document.onkeyup = handleKey
