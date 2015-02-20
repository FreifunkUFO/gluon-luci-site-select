# gluon-luci-site-select
This Repository contains a Gluon package to choose between different site.conf files after flashing the image. <br>
This does not apply to the site.mk!

Usage
-----
* Rename your site-files to site_code.conf (E.g. ffki.conf, ffhh.conf)
* copy your renamed site-files to files/lib/gluon/site-select
* Edit the file "siteselect" in files/lib/gluon/site-select and add the entrys for your site-files. It should look like this:
```
config site 'ffhh'
	option path '/lib/gluon/site-select/ffhh.conf'
	option sitename 'Freifunk Hamburg'

config site 'ffki'
        option path '/lib/gluon/site-select/ffki.conf'
        option sitename 'Freifunk Kiel'
```
