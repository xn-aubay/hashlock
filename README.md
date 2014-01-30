HashLock - Secure passwords for Firefox
=======================================

About
-----

HashLock is an add-on for the [Mozilla Firefox](https://www.mozilla.org/firefox/) web browser, allowing you to use a different password on each website.

Security
--------

Having a different password on each website is a strong security recommendation. This way, if a website is hacked, and your password is stolen, it can't be used on every website you've got an account on.

This add-on helps by generating a unique password for you, on each website you visit. The password is generated from 3 components :

* The website main name (for example, if you're visiting `http://www.mozilla.com/en/`, the part `mozilla` will be used)
* A private key (only visible in the options page, you never have to type it)
* A common password you have to type (it can be a trivial word like `banana` without security risk)

The private key is added as en extended layer of security. The only downside of it is you have to keep it in a safe place, and you get to have it if you're not on your usual computer.

Installation
------------

If you're a [Mozilla Firefox](https://www.mozilla.org/firefox/) user, you can directly install this add-on from the [add-ons store](https://addons.mozilla.org/firefox/).

If you're a developer, you can checkout the sources and use the [Firefox Add-on SDK](https://developer.mozilla.org/en-US/Add-ons/SDK) to run it, or build an xpi.

Usage
-----

On the first install, the add-on will generate a unique private key. This key is accessible from the add-on's options page. This key is **very** important and you should keep a copy of it in a safe place. Don't change this key once it has been used to generate a password, or the password will change too.

Now, when you have a password field on a website, all you need to do is type inside the dash sign `#`, followed by a password of your choice (for example, type `#foobar`). You can use the same password on each site (it is even recommended). Once you click outside the password field, a secure password, unique to this website, will replace the typed one. The field should change to a grey color, so that you know it worked.

All you have to remember is the password you typed after the dash sign, and always use it.

Sources
-------

Sources can be found, reviewed, or contributed to, on [GitHub](https://github.com/thunderk/hashlock) or [BitBucket](https://bitbucket.com/thunderk/hashlock).

