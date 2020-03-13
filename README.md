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

This is the list:

```json
{
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
}
```

# Maintainers

- [Radoslav Vitanov](https://github.com/Sh1d0w)

# Resources

- Icon made by [Pixel perfect](https://www.flaticon.com/authors/pixel-perfect) from www.flaticon.com

## License

MIT