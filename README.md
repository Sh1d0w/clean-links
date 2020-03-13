<div align="center">
	<img src="assets/fingerprint.png" width="200" height="200">
	<h1>Clean Links</h1>
	<p>
		<b>What happens in your browser, stays in your browser.</b>
	</p>
	<br>
	<br>
	<br>
</div>

This is a Safari App Extension, which strips all popular tracking query parameters off the links you click. No more `fbclid` or `gclid`!

# Installation

To install *Clean Links* you can either download the latest prebuild extension from the [releases](https://github.com/Sh1d0w/clean-links/releases) tab, or you can clone the repository and build it yourself.

After that double click on the extension to install it. Navigate to `Safari -> Preferences -> Extensions` and make sure *Clean Links* is enabled.

You should see the extension icon next to the url bar, indicating that the extension has been successfully activated.

<img src="assets/toolbar.png" />

# FAQ

### What tracking parameters does the plugin currently strips?

Tracking tokens from the following services are stripped:

- [UTM parameters](https://en.wikipedia.org/wiki/UTM_parameters) used by Google Analytics
- [DoubleClick Click Identifier](https://en.wikipedia.org/wiki/DoubleClick_Click_Identifier) (dclid), used by DoubleClick, now Google
- [Facebook Click Identifier](https://en.wikipedia.org/wiki/Facebook_Click_Identifier) (fbclid) used by Facebook in social media analytics
- [Google Click Identifier](https://en.wikipedia.org/wiki/Google_Click_Identifier) (gclid and gclsrc), used by Google Ads
- [Microsoft Click Identifier](https://en.wikipedia.org/wiki/Microsoft_Click_Identifier) (mscklid), used by Bing Ads
- [Zanox click identifier](https://en.wikipedia.org/wiki/Zanox_click_identifier) (zanpid), used by Awin
- Mailchimp (mc_eid)
- Yandex (_openstat)
- HubSpot (_hsenc, _hsmi)

The extension also prevents event bubling, when clicking on a link, so it avoids services like `Facebook` to track the links you click even when you are on facebook website itself. Links now will be opened directly, instead of re-routed through `l.facebook.com/l.php`.

# Maintainers

- [Radoslav Vitanov](https://github.com/Sh1d0w)

# Resources

- Icon made by [Pixel perfect](https://www.flaticon.com/authors/pixel-perfect) from www.flaticon.com

## License

MIT