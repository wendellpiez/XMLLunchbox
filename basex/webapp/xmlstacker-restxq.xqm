(:~
 : This module contains some basic examples for RESTXQ annotations.
 : @author wendellpiez
 :)
module namespace page = 'http://basex.org/modules/web-page';

(:~
 : XML Stacker page.
 : @return HTML page
 :)
declare
  %rest:path("XMLStacker")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("-//W3C//DTD XHTML 1.0 Transitional//EN")
  %output:doctype-system("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd")
function page:start_stacker(
) as element(Q{http://www.w3.org/1999/xhtml}html) {
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>XMLStacker serving over RestXQ from BaseX</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
      <div class="right"><a href='/'><img src="static/basex.svg"/></a></div>
      <h2>XML Stacker</h2>
      <h3>Running { xslt:processor() }</h3>
      <h4>Or return to <a href="/">BaseX HTTP Services on this host</a>.</h4>
      {
      let $greeting := 'hello-world.xml'
      let $xslt     := 'hello-world.xsl'
      return
        try { xslt:transform($greeting, $xslt, () ) }
        catch * { document {
           <EXCEPTION>
            { 'EXCEPTION [' ||  $err:code || '] XSLT failed: ' || $xslt || ': ' || normalize-space($err:description) }
           </EXCEPTION> } }
      }
      {
let $yarrow := (let $prob := (6,7,7,7,7,7,7,7,8,8,8,8,8,9,9,9)
                for $n in (1 to 6)
                let $p := random:integer(16) + 1
                return $prob[$p])
let $xslt     := 'iching/cast-yarrow-sticks.xsl'
      return
        try { xslt:transform($xslt, $xslt, ( map { 'yarrow-sequence': string-join($yarrow,' ') }) ) }
        catch * { document {
           <EXCEPTION>
            { 'EXCEPTION [' ||  $err:code || '] XSLT failed: ' || $xslt || ': ' || normalize-space($err:description) }
           </EXCEPTION> } }

                 
                 }
    </body>
  </html>
};

(: (1 to 6) ! (6,7,7,7,7,7,7,7,8,8,8,8,8,9,9,9)[position() eq random:integer(16)] :)