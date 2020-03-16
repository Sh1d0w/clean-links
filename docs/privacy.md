# Protecting your privacy

*We are actively working on detecting and adding more privacy preserving features. Keep eye on this document.*


By default big tech companies like Facebook or Google do a lot of dirty tricks to track you in background when you are on their platforms, without you even noticing.

This plugin takes the responsibility to protect you as much as possible from this.

Below you can find what we prevent on each platform.

Table of contents
=================

<!--ts-->
   * [Facebook](#facebook)
   * [Google](#google)
<!--te-->

## Facebook

### Click tracking

When you click on an external link while browsing `facebook.com` (let's say some articale linked from a post), several things happen.

- **Facebook** adds `fbclid` query parameter to the url you are about to visit. This allows FB to track that you have clicked the link and allows them to further track your activity when you land on that external page.
- **Facebook** also does an AJAX request to `https://www.facebook.com/si/linkclick/ajax_callback/` with a lot of personal data and again tracks your click, browser etc.
- **Facebook** replaces the original articale link with `l.facebook.com/l.php?u=http://the-real-url.com` just in case you have javascript enabled or you try to copy the link to the article to a friend. This again tracks your click.


### Presence tracking

Periodicly **Facebook** pings `https://www.facebook.com/ajax/bz` with a lot of personal data as well, indicating what you are looking to, time spent etc.

### What *Clean Links* do to prevent all this?

- **Clean Links** removes `fbclid` query parameter from the links you visit.
- **Clean Links** blocks all ajax requests to `https://www.facebook.com/si/linkclick/ajax_callback/`
-  **Clean Links** blocks all ajax requests to `https://www.facebook.com/ajax/bz`
- **Clean Links** prevents opening links from `l.facebook.com` domain and instead will open the real domain you intended to open, without letting **Facebook** to track you.

## Google

### Click tracking

- When you search for something on **Google** and you click on a search result, **Google** silently swapts the real url with `https://google.com/url?u=https://you-real-url&more-tracking-params` and tracks your click.

### What *Clean Links* do to prevent all this?

- **Clean Links** prevents opening links like `https://google.com/url?u=...` and instead opens the real link you've intended yo open, without letting google track you.