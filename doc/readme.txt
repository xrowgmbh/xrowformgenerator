xrow form generator 1.0
=====================================================================

The extension is used to create forms dynamicly in a content object
(instead of creating form classes). It uses the standard info collector
system of eZ Publish.

These form fields are available:
---------------------------------------------------------------------
- text line
- text box
- number
- email
- checkbox
- options (1, multiple selections)
- file upload


Install:
---------------------------------------------------------------------
- Install extension
- Activate extension
- run php bin/php/ezpgenerateautoloads.php -e
- Create a class with the new datatype (see package in doc/xrowform-1.0-1.ezpkg) MAKE SURE THE XROWFORM DATATYPE IS A INFORMATION COLLECTOR!
- Modify ini settings


Dependencies:
---------------------------------------------------------------------
The extension Human CAPTCHA is needed for captcha protection
http://ez.no/developer/contribs/applications/ez_human_captcha

eZ Publish 4.x

eZ Components (for creating and sending the email with attachments)

=====================================================================

Required fields of the form class:
----------------------------------
subject - text line - the subject of the form mail
sender - email - the sender of the mail
receiver - text line - the receiver of the mail, multiple receivers can be seperated with a semicolon.
mail_header - text - the mail header
mail_footer - text - the mail footer
thankyou_page - xml - optional (text which should be displayed at the "thank you page")
form - the form datatype - the dynamic form itself.

Known issues:
=====================================================================
There is no security protection at the upload section. People can
upload unsecure files, they will be send to the email receivers
as attachment.